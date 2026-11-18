Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049117;
	b=LdSmjbQHoX/LEPRZYMajLPTz15RlZ+/mwHHtnJmAAbKiQis3fqmIAiDZuF/WMfvXU6cz
	 IgKqs008OqCtMQ556eN+JTWK6meqGCLZNg7PPGzP0PltFLpDDayS7YetKd3rP6BlC3Qwk
	 NXl7+mj25DhCU+bH7Fd7abriW9IHB2WAm3uovz88xt3Lhf0GNGol8TMW+dec8uaU3BV8y
	 te8mNMLq0Gmqf91aqHi7f1KmEPv3BS9Y+6WmP7D2daNzzHYALpzlrugCu2AWNPn+PMpx+
	 ug1rgvht7GXznNxW4PVfdYbXuMQ11BAfID8Y8gwTf/Id60AKuEaCXWwfVsRA9nYTa+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+8KtHnMmBURICrCaYe1cewbCquBZnDdnJ7XeXO5DNec=;
	b=VkP3gRNvxF8txHv4UUDAXvKPCgrAFwPM17im4nF+ZHFHRP1iw0a8Wy6ZjL9r6dfOecuP
	 cRr3HvaRcdjX6/LATJjvmioVUgaMa6qCbHs0yco+yMi+RiHF2Qjqjf6nYagQyuCfMHAVF
	 c3hScAOXTi+m6CLk8Xe0v0jE2f9j+/jMWqAwHld0uRm1udArG4A0bdpspcGvknr9D2qES
	 9lMppaeCljYYUfKpMFqgkgQyAU7DN45Rk2UuazlTwXYsdrpBdwrT48+8D672ssMteAJfL
	 VV1L0OoqgcbfvTxU0ymn55RmEhXgrrIMi9L7hLkIDgmxzpsDaJRzsJ0+gxsb6CvnlRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEpy8W3c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25711606A320;
	Thu, 19 Nov 2026 00:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEpy8W3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3311F000C4;
	Thu, 19 Nov 2026 00:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049117;
	bh=+8KtHnMmBURICrCaYe1cewbCquBZnDdnJ7XeXO5DNec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEpy8W3cdPT+5+NixghO3BsKhYcJfIdf+Xj9gKAN8yISr11lZn+1mjP2xkSFsQgpG
	 RjCSPGZdVs3z52rdKTMoIU1zWnXPcEkRJq3im6EsFHl8LHDi8xaypkor7AhnGIbJ+k
	 CrFJdcnA4sqt2lCD84nkJGcH28Hq+DZGBXvxpfEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2238/2857] wifi: carl9170: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:54:32 +0100
Message-ID: <20261118150322.016545919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



