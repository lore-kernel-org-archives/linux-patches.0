Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058083;
	b=LvMPofi8GyfC6vpftFIBr9TrLZ2YLbQ2D+H9z8w0iv8EQom2tUluY3MILMNB7rPHukQo
	 R8JR6RhhNBBOJVY7n+NrXyfcKBYmnGGiL0tG4bLvLjjrWPdq9QYGqILF99KxmSErlUJHd
	 U/V22C6bdfXKuURHv3QLWZTGDC+YSYfEcR4C7n9I2zjBJyy0Ie/Jwt6dAl7NFtJU+s8QT
	 9jq7CYW+FK93W5iq5mREB0ZlUieG7kNeWfLBL6xJPuD4IvuI8hcRrx4eX+1mjju5VyIXO
	 Oo6MeZdu8ahkKo39H9vAGxvW9KA8N+k0CBsIIk0Fd6ogPjPhppg/wpCgdAhyjfdMfqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XhyXfAMHWi+I156UdJonm9canzZr5aGBMMLpU6UtMJI=;
	b=G1aCp5a6BlsGi2Mo/gYajHIqkJokN9Cm+EjRp2A07+M9TmuNagravihtF4csazfLeD89
	 nHvQns9bPNND/0zy/dGBtGXdhtwLAWmgsU4Y7OOcs9BP/4U1AIRZlBeR620cl+9A3VrOM
	 AgyO8/DjSyeTYtCzTM057ZzOW1s/MlLF8143kQgJGmsHmskL4uLSD2IJCz0Ost8yLZZki
	 qaNC0LOoXZF1/6uxSktlHmWMWjSK/O+sJogulGNZYXKCCnLUUMfk7LWt4Sk7CT8shZigT
	 cZL2MI1WlQptmpVBtux8531k7ejNQ1p1ws9G7aJiMFw9jWhhiMnIjmUkUHG052AvMOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0UZr3Io;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32132606A31C;
	Thu, 19 Nov 2026 03:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0UZr3Io
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880B11F000C5;
	Thu, 19 Nov 2026 03:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058083;
	bh=XhyXfAMHWi+I156UdJonm9canzZr5aGBMMLpU6UtMJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0UZr3IoALNQMudlrGJ8gt5rSW3OS8MmmGeB4kME2RBn95lQkxjzt1td9i7Jv7OjJ
	 VRUjMsm758eMecFkIiVxr1ogFGPVejkfRe32m+2nwqGuxVWw/RmP92+QWlzBOncKiJ
	 Zowj4aj32rW90dvdbY+lqkF+sgH5yNKZzcNqK6Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0360/1848] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Wed, 18 Nov 2026 15:39:58 +0100
Message-ID: <20261118145928.185708055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 6132d70d0890c03546f6970893fd71938efb2a2f ]

In ath11k_dp_srng_setup(), the memory allocated for
ring->vaddr_unaligned is not freed in the error paths that follow.
Fix that by calling ath11k_dp_srng_cleanup() in those error paths.

Compile tested only. Issue found using a prototype static analysis tool
built on the LLVM compiler infrastructure.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260801114911.91483-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index 62dba9fc3ff59..598b7177ad546 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -288,12 +288,14 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 	case HAL_RXDMA_DIR_BUF:
 		break;
 	default:
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "Not a valid ring type in dp :%d\n", type);
 		return -EINVAL;
 	}
 
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
 			    ret, ring_num);
 		return ret;
-- 
2.53.0



