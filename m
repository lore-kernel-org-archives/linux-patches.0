Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018754;
	b=gOs0lf2exPtPonWnXcN/CJ+0PWIYAbV3z8mnILc7G82G6tAtq/aXk3xsYOYLQia1Nu0Z
	 njpVwpcLZi9BI358flsfWZC4Wz74DGMHJbNXcaUIpsIcovtUZp7uwoGUAjjlZIip4WLGQ
	 BLtQdrcSNSokPjt/LaW4ZtUPX3Kq2qjMnwJTLUCY27owGB5inx27jXDJCnKIvycfa3AP8
	 SCWdKIYqUU0G6HknZXkAJvd2n8LkoBIc3ZIahlSIITrsYnyVRNGvEwYR1XuvlOmkiQBZA
	 FQfnNrBiWoRXXgPwICoQtQnKjr3yhHFcYlQytfyCWpxE9XvqTE1bmkoRylyw+VEmlvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tV3ccrhxKSyaMQYW7pEVe4GCRCXyMXMTHgY2/GRQEUs=;
	b=rlTbN458KR4F45yj4hpqWUr+f/ktO2PUt/m/tY2RjleOCJTAgTmwPaD6eaR4yegulctN
	 0Q2GW+JP1ykeFY8QlHiLkK+Unrher//q9DlJ1G/UlcsWvMNoPiPjyuiiAnSE71MrT2YR5
	 +0AHEh+GV3UYaGUw4kkpGGlukWNSigmZozz2YCZAXhQteL78qTsW0FsguWXPNUTnYkZ9d
	 QmCxKbjWockJtkhe0CjZbL2H/XgsYCbvP+5LoizY7T/0gkt0GHjiFGY1wW4urErLRhjgq
	 QRCVWdbWLsDegxyIKz1A3+DaiKJsY8rSRTNJEDJ9kuCxOfLutpzxuQ1CmxuQTwYQ87Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmrIFjWr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F021606A32C;
	Wed, 18 Nov 2026 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmrIFjWr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DC91F000C4;
	Wed, 18 Nov 2026 16:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018753;
	bh=tV3ccrhxKSyaMQYW7pEVe4GCRCXyMXMTHgY2/GRQEUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmrIFjWrVvz+ovaCjOdGaeHQL+DZWfLMWdkUKJLLhHw+rUX6eGJd0aRkzK3q1/Nsp
	 +537HVt+snNnBHy+F/xy2VP+k8jAj4ul8CjBJLJNTph8bsJp+fSEw2KbhkUtXbLfhl
	 eOHfesNeB4xFsp7UYXxFQfNh3zKJp2Ew4wTM4PY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1311/2651] wifi: carl9170: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:42:31 +0100
Message-ID: <20261118150335.169694411@linuxfoundation.org>
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
index 0498df2a21608..bc6c8e0b1d161 100644
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



