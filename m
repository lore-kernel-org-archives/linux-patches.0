Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8911A01D0;
	Tue, 27 Aug 2024 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770201; cv=none; b=WpQC1S9FZT+tjYQ7+E4V384n4Mevku0ZFMj3fau63Zjwj/ZPgwikZqRGW2Ri1quTwpn+MMyKiAY3YMR7Vfahj1y6dvjgKSu0SANKHEmvefjVviL+wyMa+XEZuDFphlwfkLVyQ08c3VoKOOQGx2YjnaGb70iNhvzj0qtHKeuicQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770201; c=relaxed/simple;
	bh=yloia8llL2goUJ9gW1UCvKGvqZbkFkJxGW8RXsLOhKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9pOrdL+HR1wFaSQUnLwPRbZ6mvY+EcUcjhMWsSW7gEH+2ajLVBGe5yOJ11jfi54IhD7upHJ5bWLnUSokYGtMRamBJgR46HGLDHULkunoCTUBzkdNVHB6k5HANH5Uj4yAvfOpY8nJDp31PTgvqqrcT9ppwx5J28eUJT2Kop2LCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqapO737; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqapO737"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72AFC4DDEA;
	Tue, 27 Aug 2024 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770201;
	bh=yloia8llL2goUJ9gW1UCvKGvqZbkFkJxGW8RXsLOhKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqapO737zc/DjXNID+P8KWpFMjSb9MyhD04aLHmH2wSs44+9J/G27qxsaHuoS2PeI
	 8NCab194z5rIkggMBddiqG0EQf1EYrkNyiL6DnJYQhIMVqbU+S/xcaOEYK91z1jYkQ
	 v5ftFGah5v26J+jXm0NxBJP4FU5sgUDhepA53eRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/341] gfs2: setattr_chown: Add missing initialization
Date: Tue, 27 Aug 2024 16:35:57 +0200
Message-ID: <20240827143848.210209381@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2d8d7990619878a848b1d916c2f936d3012ee17d ]

Add a missing initialization of variable ap in setattr_chown().
Without, chown() may be able to bypass quotas.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3de0d8ab42eaf..29085643ad104 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1929,7 +1929,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	kuid_t ouid, nuid;
 	kgid_t ogid, ngid;
 	int error;
-	struct gfs2_alloc_parms ap;
+	struct gfs2_alloc_parms ap = {};
 
 	ouid = inode->i_uid;
 	ogid = inode->i_gid;
-- 
2.43.0



