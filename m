Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264731C68C;
	Sun,  1 Sep 2024 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208785; cv=none; b=Yz/NtqKG+ncN+xirzGsfC1f8IZeH4Q4C3Sp9VXA0505NUMnGcauZc72z0CYPjUgitdhu9Pf2IIpblXm4AU99D1Pl27W7nwY+l+xnFlT82KF+y8T0ewhIWG79UFo5wUE61P+g8pVoIvpoXmCAbepCcmAOBJHdQ1Gf405X49nuM9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208785; c=relaxed/simple;
	bh=KHGLogeJaMubrSo6A9PK9pqIxItqhErOE7j1iz+HTRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6pS/aNlETEYyum5CERdriXBQmCX4gBZB13ndfXJDvD77/j+2GYIQQXLHyr/HRk2sDjzVx8TbsqfeDpX0RXhLB8glDEtOYJeMQlYga9V/pxPmYhxM+/jn9TGJ/RHMnJIdbUDzc1BU/0dFtxrLKyQUvKbLwJ/fDqkjEIw2JU5hEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIGTn1hM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIGTn1hM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F436C4CEC3;
	Sun,  1 Sep 2024 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208785;
	bh=KHGLogeJaMubrSo6A9PK9pqIxItqhErOE7j1iz+HTRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIGTn1hM5f9JGbsEo01Z2ibVG+R+6Sh2DRXBPvOkdluAyyTcZ8hY6PfDWfG93JWi0
	 ByS+JJr74KNkOwiA84EJdsW74eYQzS02qU4M6FjhXfaFIlO/SSIJRW+hqklOKyDUFt
	 pndqV6t+L6ux7rde1inJOy1s2+Mmj6cSUEbigluw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/134] gfs2: setattr_chown: Add missing initialization
Date: Sun,  1 Sep 2024 18:16:24 +0200
Message-ID: <20240901160811.543703986@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 988bb7b17ed8f..4e0c933e08002 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1869,7 +1869,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	kuid_t ouid, nuid;
 	kgid_t ogid, ngid;
 	int error;
-	struct gfs2_alloc_parms ap;
+	struct gfs2_alloc_parms ap = {};
 
 	ouid = inode->i_uid;
 	ogid = inode->i_gid;
-- 
2.43.0



