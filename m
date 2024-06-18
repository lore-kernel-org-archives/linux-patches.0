Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2929C1BF312;
	Tue, 18 Jun 2024 12:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714616; cv=none; b=tAstRqZovk5AiLGlmTjqUtIutaERXzi3oY95L4obYGgDmhUtMB4biDEDrpWEDKE9lf97Rz7RXvyrtZw6y2wNKqPm7wmxqVN0rTf0qRMpzIjx56u736JhjAqu8LsvgZ2vbV9JQGxrz27uXe2AjhrFmVVOnlY7OPK1BDHKG7joUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714616; c=relaxed/simple;
	bh=U4VbE8fkIvxvB1C283jjfdulrqrHcyVadgQuUI6z1VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEGXV3Q3i89FjniNbjjwnbw1tdu5yNOuXBukpieMKvwB6GakyZdh95b/M2173IlbgdOTahqYAmwslHACWJ0WUR23JsPMiovSCZrxe/+y7VKafbADssbbqy71eqftvsPv1guBKta9MjseeFGhJlqnUAs0eh6JRNDHwXnircfdyR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QOtL6Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QOtL6Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E5EC4AF48;
	Tue, 18 Jun 2024 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714616;
	bh=U4VbE8fkIvxvB1C283jjfdulrqrHcyVadgQuUI6z1VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QOtL6ZpNWZUJiezOlzfR4mi00lowFQwARR7rhP6RnYrg8VUx0KAKJEag56MJicZv
	 8x4OnUIXZz9N/5elTJdIs1bkr/bOQk8JaHQ/oToofImQDz5sEgU/cU5cETVO+JyJw7
	 OPIUwcYcJ9ro0fKPBCW6BmotAsj9zOGfanTyiGL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/770] NFSD: Replace READ* macros in nfsd4_decode_getattr()
Date: Tue, 18 Jun 2024 14:28:03 +0200
Message-ID: <20240618123408.458060443@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f759eff260f1f0b0f56531517762f27ee3233506 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 234d500961230..70ce48340c1b7 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -772,7 +772,8 @@ nfsd4_decode_delegreturn(struct nfsd4_compoundargs *argp, struct nfsd4_delegretu
 static inline __be32
 nfsd4_decode_getattr(struct nfsd4_compoundargs *argp, struct nfsd4_getattr *getattr)
 {
-	return nfsd4_decode_bitmap(argp, getattr->ga_bmval);
+	return nfsd4_decode_bitmap4(argp, getattr->ga_bmval,
+				    ARRAY_SIZE(getattr->ga_bmval));
 }
 
 static __be32
-- 
2.43.0



