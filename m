Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025494;
	b=Xz/ap2K5DL0Cqy2wmA0LNMH8BnkFtn2nQYa+aAkEr38rvVEBgyhU1ktpJZBbcwpt9paA
	 i5tDfbiYTd1mCIy8NaS8jOWF/dVJ2qYGsEORm4q+2oPkt4pURD2mzx8KlR0J3saoTl+PD
	 ED8IuYopG/HseKnCS50XuRPwVN0UxJiYdRiVAX4gwYELEJOWXt7BrN+/U1CeIJjgPGCtv
	 tIJlBzdLG7whpDLW09jH3AJCdVxJa/H3MMbPu7qKXpp2KrNlw4hhT3wSPhgln3XrmpVV6
	 N9zXjmYKMllxD+DztIvF/FaMSycFfUJp1NlZ6UR32tO6iV1MMvaCfdWf8SKMp+UT0hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEpJH5g7CkxxpEneaKmBqG33qV4fhdp3DXhewzjahzE=;
	b=KtyV7mAyA8k5Rmyc2wF0O244bJmA7wltXXvzdDTztnNtwr1p6xlKXAAJo3doRgTHJxH1
	 yajtVqxcH91qis2pRm91BMX4O4VAds9a0cpL+sng5lIMBEYmx3+Kpym+XI700o0qjiXA2
	 +tc9DLG9M6BrfZKgOjwVDzEW4I4iXj1EWe2f/oyMie+OmnHxJYKhEl9B9XbukFmR1qr8S
	 onen3EnV0rD3k88u8IBjVolU7l00wS1QhkXhd05jLdtjr1fosMMorkpslY2EaRiz22+hJ
	 61USp/lEnvYt+k7L8qgP6v5gk7kVrqiugGpECsIjdLJbG60pUkt55XAo3XI29hk2B7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNud8IMU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0F606A320;
	Wed, 18 Nov 2026 18:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fNud8IMU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB4E1F000C4;
	Wed, 18 Nov 2026 18:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025494;
	bh=mEpJH5g7CkxxpEneaKmBqG33qV4fhdp3DXhewzjahzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNud8IMUZwd832XpO5PUaPGJvFvR9QvzeyVq4VqvJOSwt3bXqIu1RokPRab4mdwF3
	 +R2LqDQYynYaaadaqF3u+02W7Rt6fKndjw0EJDp/wKVRYCs5bV4jFJtLPcuhRAt6ho
	 P5m5oXwTkrxkylk/niNxasTDC4EGi65oYGhMZICA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1098/2151] wifi: carl9170: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:47:13 +0100
Message-ID: <20261118150202.267781338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2d734567000a4..a816e04014acf 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -119,7 +119,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!count)
 		return 0;
 
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 
 	ar = file->private_data;
@@ -131,7 +131,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 	if (!dfops->write)
 		return -ENOSYS;
 
-	buf = vmalloc(count);
+	buf = vmalloc(count + 1);
 	if (!buf)
 		return -ENOMEM;
 
@@ -139,6 +139,7 @@ static ssize_t carl9170_debugfs_write(struct file *file,
 		err = -EFAULT;
 		goto out_free;
 	}
+	buf[count] = '\0';
 
 	if (mutex_trylock(&ar->mutex) == 0) {
 		err = -EAGAIN;
-- 
2.53.0



