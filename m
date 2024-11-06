Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BC51EABD7;
	Wed,  6 Nov 2024 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897062; cv=none; b=gZ5VYTXhAvn4KzeLe2j5ry8Xy9ADRF9IS5gXBgltbAvfsp1I20/YKXUCn1qqHX12cxYhIkYmh1Ad56zdEYWyfH8D7tQUufosrLN99/0leIutazgNCy+SHQvwPlfV3NRHM5NCMhl57moJ8RIDRxot1wRpNheIOnVgECq+UazRW4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897062; c=relaxed/simple;
	bh=n8yKDnTFjeIvyjquPGfMElJ4w6QJZQbVH04Q10EcCb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/63bcqkrGaxPYdMvMgavzp3p9w7pdC1MtYMglHUe/zo+ZzzQ/BgwnWSsEUoT2W7vX7cvGjggDoqA5l+anzQCeGfn8xVM/AoQ/aGgoXjINCzoKjsemgrMdbeD1udttRxq+Im3Vi+wlC2F8Ga+Jhiky/ic/trlWxC/Hg1w92Bnqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLYMU1Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLYMU1Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B927C4CECD;
	Wed,  6 Nov 2024 12:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897061;
	bh=n8yKDnTFjeIvyjquPGfMElJ4w6QJZQbVH04Q10EcCb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLYMU1Bq3yTLgg2SUJAYAaJTDkXBh2tf9JhH/zpil7aDIdpPOFhGQAg6OqpWuHk6a
	 8Y7uQcD+46gA4ruMpgW6vnB819T7HDI3zne2/Zq59LBhHq9vS8TlQ8ysWWBkaGDIL9
	 SFKa8GDMN6u4dMMwscbOVN5pHUpf4xK59xCj/aJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	syzbot+c2ada45c23d98d646118@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/126] fs/ntfs3: Fix warning possible deadlock in ntfs_set_state
Date: Wed,  6 Nov 2024 13:04:14 +0100
Message-ID: <20241106120307.531931380@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 5b2db723455a89dc96743d34d8bdaa23a402db2f ]

Use non-zero subkey to skip analyzer warnings.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Reported-by: syzbot+c2ada45c23d98d646118@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index a88f6879fcaaa..26dbe1b46fdd1 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -328,7 +328,7 @@ struct mft_inode {
 
 /* Nested class for ntfs_inode::ni_lock. */
 enum ntfs_inode_mutex_lock_class {
-	NTFS_INODE_MUTEX_DIRTY,
+	NTFS_INODE_MUTEX_DIRTY = 1,
 	NTFS_INODE_MUTEX_SECURITY,
 	NTFS_INODE_MUTEX_OBJID,
 	NTFS_INODE_MUTEX_REPARSE,
-- 
2.43.0



