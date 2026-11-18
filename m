Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015519;
	b=ROEXjuJzcV6TRiIZzOYNFJCn3FPfuPHaNlfKzDLpvDKpogHSorIuTHgD05QNOceVw4EY
	 jTlwTQLh3R9nW1wDTYquStfkHE1XFFYjhDWGWXXZlNGV8A/P3J37J7Pb6CvVIO+9/5GZI
	 f7LtKiVuFEgWRzpgZu1+2nmJgR23ktlIG0/VAnlD5rw8dugkdTeDFkkVZ++bmiTt5AKH4
	 UW4Ostv3fElcsFLUhDj0nHqvYBlxv3EeefetJgy0sMFu0v49zERwyIR2G0suNFuL4V4Xd
	 VvoE5qhHZOyvBtqDWZbeaoj5HSyYGRZoRQzeXM+0W8Vo9JHIlKjZIvGt5n+xaCLh0CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jc7AOZ+ypSK7ZofquQHfNw9HQZALiN0TPkynsQll1Ms=;
	b=h+iiYNO0QitotqlIKAJ97zmZMP0gx9a14D7L9DdmE1qTu//eREQ8JAXVCiklW7RhelHO
	 VaJ5/XVnxth1AEcVhkJop9cnQayQbgVv1Gf+k6NsPV9CNJT6IBkMYpqitaGuhCRZx0tZ6
	 5SZYslPMjl5zlkQE64Jz4pw83+MvBNElCiq10gfVOwLOUq6KE7yY1NFJ/u2mKWFkvDeTB
	 F8yOQquJRQGyVyDlQr7e9k+M7B9lLWFHlFwZF3iVK86BoRi21V/DR9+jIiVgS/T2ZttlK
	 2czf91D/POufBmqA0ALk1ns6IfUVoUbZ472QArWb5LxgsDfAkHnuso3ed4edhjRaCaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuxTXtyB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08368606A335;
	Wed, 18 Nov 2026 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuxTXtyB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5839F1F000C9;
	Wed, 18 Nov 2026 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015518;
	bh=jc7AOZ+ypSK7ZofquQHfNw9HQZALiN0TPkynsQll1Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuxTXtyBibnIyjbQ0bbUTmQYs9qFdBbI2RfwPWxQd1j1IB668oiat+GRBr+1P4JaP
	 5kNaOeEaIY5NjryyAsvLXFnKfagJzLbDUW89eACuIYi7VBGTbz+mAoQefIZxHS/AmF
	 W2cfPgycAk1zWptngv4hxqmJi3ndqZqptjSk7bm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0200/2651] wifi: ath11k: unregister PM notifier on QMI init failure path
Date: Wed, 18 Nov 2026 15:24:00 +0100
Message-ID: <20261118150255.064906681@linuxfoundation.org>
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

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 1d8e73163ef933624341075f576e2f36ef9133f7 ]

ath11k_core_init() registers a PM notifier before the QMI server
becomes available. If the QMI server never arrives, the device remove()
path can take the early-exit path introduced for QMI initialization
failures, skipping ath11k_core_deinit().

As a result, the PM notifier remains registered after the ath11k base
object has been freed. A subsequent suspend or resume event may invoke
the stale notifier and trigger a use-after-free.

Fix this by explicitly unregistering the PM notifier in the QMI failure
cleanup path before releasing ath11k resources.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.2.0.c2-00204-QCAMSLSWPLZ-1

Fixes: 32d93b51bc7e ("wifi: ath11k: choose default PM policy for hibernation")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260806101331.484063-4-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index c3ce5ea36e3c3..ee3f493d2e445 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1302,6 +1302,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 		ath11k_ahb_power_down(ab, false);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
+		ath11k_core_pm_notifier_unregister(ab);
 		goto qmi_fail;
 	}
 
-- 
2.53.0



