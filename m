Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018751;
	b=1rLzY35ElpoE5B39qttFb1VRznkx4YuHfH88tTcs4x6UkxGGHZmNbe/doYnowMrc59Al
	 FEovT+wtLd7pWclVnIUitUx/txIhd1Td21WW1iblcMEB473p+MYLzFg979btPUrKGw4Q0
	 v0OWozrjBr+XrZQK2wZGdSaKios47TnLRcFUn0W1vbONEXI05Tm7GAFkaeeM20MBe6isk
	 /Aq55MNNiK0zxNZfT6ifSjPPkXHqFnOBW4Ev7v1FGw+INLGPiM2FfPWdy8ET9dWxXjUqj
	 C4XBNJEmmtaCHbzUxtGwkiaaK76s64Y46WOdYpSZj+/0qmsMGinW5Kegw+goVpjqWQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5w7h7qtZo9NfYVlteNshyzd7xWXrKioImy7bEbg3mq0=;
	b=q6s6fM3x9xaNykOL6t7T4c1EYq5cCde+7BwOMhzwIbZEUilFc/lWJnXSAZexQMtK8qYe
	 FZ2FH2vGSP3c0qsg5xBMUZgNd5RhFBSo5XWcMMCWsmcq7CgvymdJyDTjJBx9emd1BQwbi
	 imwikvrKLK9zQcCpbxMtcDZtvA6h1sejsQmPUAjTZ9fgdiyEb2JgADR/8ln3+VJ/2o3aE
	 zaCS4F9CiI6bIzbZ9CMIVGnYtjw6Zyf4DzkC7V/0UAsGQzKiTxOtqh4EdfGexgdS2jfIZ
	 xd4jrHvlv4eXMIo8HRKcm7Hz3XedtPMOSmmEd0zaCKnZVkvD8uuYAhzHX7WmY2kf5VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2D9UqhxB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B67E606A320;
	Wed, 18 Nov 2026 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2D9UqhxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CB91F000C4;
	Wed, 18 Nov 2026 16:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018751;
	bh=5w7h7qtZo9NfYVlteNshyzd7xWXrKioImy7bEbg3mq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2D9UqhxB/wWqncV3+ebuldpbG4A1rUEiD+aFRr+8tmCfRQJQh6eJs6gS8cA6YpodD
	 yUEJe+/qpWuGio7nYnoOhv7GUwLfnmNNnWKie+wZH8ajfNUC9q5o+deNdjWTpmqtgM
	 BpBLsJwcqEvkGT3vrqsxB+ybL8kaA2smug0sG36E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1310/2651] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:42:30 +0100
Message-ID: <20261118150335.135717744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f94595252b318a9ae3c01d78b3bcd33b01b1c082 ]

The "buf" buffer is PAGE_SIZE and allocated with kzalloc().  We store a
string from the user in it and then pass it to sscanf() in the write
functions such as tsf_write_file().  The buffer is only used to store a
number so we never come close to filling up the whole PAGE_SIZE.  Reserve
the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/909ea7a88658b5e7c183bf0fda31687a91d73818.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index a04d90d7307cf..7ce8bcf12f0a9 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -259,7 +259,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



