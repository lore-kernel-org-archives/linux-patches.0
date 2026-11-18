Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055759;
	b=VLtptai9pSB7jH7ojYgMfO7k1BY0F9BeNNsP3i16ohrY8kFCEhBjubJHfM8RAU1eLNUi
	 jv8NBQ+QdTKlM+nFbBxdcLIkWgPL6G/Z5/usv/cbGVLJnJAEFkZ/5y47S+6VxgkVWEFkT
	 wQ36GX5MwHDIb1qnobA17426TlXDLB6H99ipcMyuy3GHjEzkSi/5sfyTktUG8rN5xkfci
	 VB17LHVdKEBGlNEX9XbCb2HIEMZmuRrcwpGypRHUUWbjLi4z88dOQbmuJOy7SPwBJLmum
	 o1Z6yMkR3M4npzL6CIPnS20sUi0SdhfO02rrYrsS3vWblof6HQgq4j2ARJyjeBM+n8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jzRj7d/RdqchZZEORvUr2xX8TkxZ7SStrlFqsJj2JUc=;
	b=UDQKGSYVYCxKTjCArQbvxhUS8FQJMjh4ha+V/Ke2Vb/w+KyLKAnEXavJHf2buvBVLJah
	 sHbAJArmtRt2fClCmaAzjwkDX6JrC1wUvrxHMXIxSq9xLej8JjfISV47ssQ9o/7dZoP4U
	 HUjQ0VJ3TO1Qr/wUTgSdbU3yC4c9qXsHXn5ZUtDbUnIDzew9YbK8OeQrtjfIYjACosmE1
	 kKAmmJNaShnaKNLTm+7EYWCkPiAyl0PQ/pUdJ47zC1CD4a6esQ/WLjATTioZd/GrsG51+
	 9md5ALjPoPorAoFnoL5w+WFn5d6bSQGU+kZFiEIS8hCHguxd9/JlkEhgoq79Zp2EtsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oU2NFobj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8424606A332;
	Thu, 19 Nov 2026 02:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oU2NFobj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C9B1F000C5;
	Thu, 19 Nov 2026 02:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055759;
	bh=jzRj7d/RdqchZZEORvUr2xX8TkxZ7SStrlFqsJj2JUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oU2NFobjMp6oBBFwtNws4WT7YA8k0AIWwk7uP6Ig799kAUIxqyJLmX3QUaq1BjNr9
	 gqUc4WuALcRen3/QheAaN7vILsJQKJ5YJdU1NXT2A5vfu/JIn0wZyPLzBqGTLbmwkv
	 +sus2CfMNzSy0wsrmbOmCF9/fwKvBfGCPRg+mjbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1746/2214] wifi: carl9170: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:57:02 +0100
Message-ID: <20261118150121.462557701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit ece30e1daf6a9c95d6f9d0518534a0b9c8c7fd42 ]

The "buf" buffer comes from the user.  We use it to store a number or
two so it doesn't need to be large.  It gets passed to sscanf() in the
write functions such as carl9170_debugfs_erp_write().  Ensure that
buffer is NUL terminated.

This is debugfs so it's root only.

Fixes: 00c4da27a421 ("carl9170: firmware parser and debugfs code")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Acked-by: Jeff Johnson <jjohnson@kernel.org>
Link: https://patch.msgid.link/674270ab4aeefa1982362c0ea4132427e14f15eb.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/carl9170/debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index bb40889d7c720..6bbcca46358cf 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -121,7 +121,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!count)
 		return 0;
 
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 
 	ar = file->private_data;
@@ -134,7 +134,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!dfops->write)
 		return -ENOSYS;
 
-	buf = vmalloc(count);
+	buf = vmalloc(count + 1);
 	if (!buf)
 		return -ENOMEM;
 
@@ -142,6 +142,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 		err = -EFAULT;
 		goto out_free;
 	}
+	buf[count] = '\0';
 
 	if (mutex_trylock(&ar->mutex) == 0) {
 		err = -EAGAIN;
-- 
2.53.0



