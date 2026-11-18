Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025599;
	b=pRJrs0niajP4ifzC1gf3q2OP7ld0zr0+GpU5I1B4cg+VVoPiHHZdqSfghSv0xq8VUUmU
	 S/Ugy1rAc4/F2okOyMqNjGQWzLGQbFc6WIkELp88AD4hbW8Ud5QCw28PxqViNkrzM4VYj
	 FqHadxoghzdTStWi27Hm7mdlxxA5ZGDBjOgwQtj41+YtyyH/gvP2lZ4G97AkQc1nQaK1A
	 rLohNC4T/NjL5HMi4VGin3La6ewB7whkqOj965s8I26bmivW3dnP/e189ou94NeZAAyr6
	 JyVrk5vHkW3DZZilBI9GKaCr/DJOhfXcIh5UmeqivhD0/JCI2ssdSUkEyKs6bEWzGmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eSucJTDjha3sJElsbWXMlJb/xqycTx57BFnvNGLOW1g=;
	b=4Rf9gZjLlAEcucY7HfBJcW/nE08+TO9eNxgKB610d+JA9zHKam7chIDYVAeDltGMs1eD
	 0VbaRTgs3s2D5ZuyV0JL9m1DcmRBUANdbFbfMX/EirqQejvhaMxXvLEKZkjfoAaFC7VwR
	 iWx3RA5m6rUMHmSBR5rkIHY3bGlWYtw6igrLa0SdjDmgiy3JKY/PLzI0v0RVFH66S8hl1
	 9SSX7yxfdJiK6AhG2p1so5A/BgWMrWuXcC0mEPCmbXNF+seJcVU32d+LbX78SKJ5hSYNR
	 MRY9fcMBNlpY8YDbbOEjkyOHafULLMWLoxKH4cilWBM9zz0eviFNhZeFgLcdnSHPWow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKl4kCWg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5945C606A31C;
	Wed, 18 Nov 2026 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sKl4kCWg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADA31F000C4;
	Wed, 18 Nov 2026 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025598;
	bh=eSucJTDjha3sJElsbWXMlJb/xqycTx57BFnvNGLOW1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKl4kCWgZDxtjjsXeNR2/guhWh8TM193wAZrYOtjCRAqgR6pvUMFxR29lO/GRlpfL
	 P6x5Jp5Yn5sFrXh+/VjMNAO5gonIn/cxfCsA712r0PbchiHe3ksCX2czSiyWgGYacu
	 Gmv162+LJdZjXPddh0fTgquPPJKZjQU3sZ1T6ty8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jiale Yao <yaojiale02@163.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1109/2151] wifi: ath12k: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:47:24 +0100
Message-ID: <20261118150202.640138324@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 13b15eabe2c541b80406166964cdc8ccb5e9c32a ]

ath12k_write_htt_stats_type() accepts count == size, which fills the
zero-initialized buffer without a terminating NUL. sscanf() then reads
beyond the buffer.

Reject input that leaves no room for the trailing NUL.

Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
Reviewed-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20261003095913.575108-1-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
index 4f749d473d0e1..e120a0e2f9be6 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -5929,7 +5929,7 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
 	const int size = 32;
 	int num_args;
 
-	if (count > size)
+	if (count >= size)
 		return -EINVAL;
 
 	char *buf __free(kfree) = kzalloc(size, GFP_KERNEL);
-- 
2.53.0



