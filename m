Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAFC1C32EB;
	Tue,  8 Oct 2024 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392978; cv=none; b=ZdYZMOMirLVEzINNrXnojOWHe06PBIz3SRfUIwhNsBXc6tCJSGtPFjupeXVrI74Q82ZdW4ddQK5TZIR7+qrBaYTz7hylh4lWEsXgn9IFPl+R6pipVyYYq6z3onc/lDDBSDB8CigS8SrMf/xh+b8MaEFS6Vr+HX22Ir0F3S3JnfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392978; c=relaxed/simple;
	bh=oMWchAMYeOVjJvwPnu3Cu3nJXH+yBRgAI6QmfM7q2xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOMxWxK0JmZE3YYaSOXejtZK/KYCsXsmHV/ZlHtP0kKRpD792vbvisdr7B0l7CRTE7XvA1hdu4joXb0zJRNmaXerIc6l1RqKcGJaIpr0917LvSSVELWy4OAJjvqQIAKBd/sHarMVOSFCx/iCb5t8MShIlBUzD8cz4U+qhGFmQ9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+in/3Vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+in/3Vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC9FC4CECC;
	Tue,  8 Oct 2024 13:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392978;
	bh=oMWchAMYeOVjJvwPnu3Cu3nJXH+yBRgAI6QmfM7q2xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+in/3Vdy2rhTc/YEUZXZI77D2lE4rvUTajB1mme1saW7Wdjp1A7nbGQIB5V9zSuv
	 vEVESNxkfq6l7lR1EF0m3x4tJr624mCZj3nExzRver74glh/4k553SzOLPhZuAkDTm
	 L0iXtfYpXxrsj8zwI6dnDeM3XKwQiAAgk4jKag7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/386] netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
Date: Tue,  8 Oct 2024 14:04:22 +0200
Message-ID: <20241008115630.001664765@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 76f1ed087b562a469f2153076f179854b749c09a ]

Fix the comment which incorrectly defines it as NLA_U32.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 621e3035145eb..9c29015d09c10 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1690,7 +1690,7 @@ enum nft_flowtable_flags {
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
- * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
+ * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
-- 
2.43.0



