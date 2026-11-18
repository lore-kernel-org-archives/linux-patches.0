Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023015;
	b=0VxiBFfjMY4fdxk6NRGSF43yf6UCJzIU8T56uIIdjmEDEN2nmWbpZgJuKvF6jlwtyTYX
	 a7q0RdX4ZFlLfdsFTSDTtTWNAgWmGNm4gEsWtatoMdth5Y+HU6x2JDLfzoCnU7U2J0ZrL
	 Zs1oF85FDULT5vdTRWsuCtWpDyC3kKs0RPzQd1vjtw9UieUqnAaWIF0IoV61ccuoivEmX
	 yeR5HUo74C0dVC3TxeQYXt4y5RkZuwIWguAbqPEmH/lO0XBAkF4HEZVEq7XmoMsYDcqTx
	 EODKqXNavyQQYWmtBQRZ0/AhzjgAB/9Im4V2nSpA6vugbJB+UiEe8koMz2SCUji/WRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTYFlsdCKzDK81DBdWvZX34uIcYRwn3L+/Ke0eNyW3Y=;
	b=kg4hT5XDph7Ajwqt+3OjZDpSmmmk/FiRGhjH6EB7j33b1QL6/KUARwk4lZl2j7BteMo4
	 juwA/9wjujRddKsfXTKYxKTgo/R8Ak0GY6OBfbopKohIHrj7pEcsPpQR6M7YMTb0n+VoP
	 aYj28jwpK+yi0663IS/GlHOMJscrdnLALgi4enTpxOn2hm4zlXE7DKEghHj656FN6LfCY
	 RKOEY+lJMSllR5KHeAamsR+ahvgXp06xow5uP5PlMbowYSosqXI3hLwpmJdMQOPpNi+tx
	 bQFAxUQO9nrF1J9FphBXn7zyr0f9IgDT3b8wJBzlcP7Ss6/XuB+mxMk7HIxX5CI2M3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nn+gLCa3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDA3606A31C;
	Wed, 18 Nov 2026 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nn+gLCa3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C70E1F000C4;
	Wed, 18 Nov 2026 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023014;
	bh=KTYFlsdCKzDK81DBdWvZX34uIcYRwn3L+/Ke0eNyW3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nn+gLCa3MgGvFOp9SD1kfJUZcbEPyitLzq12mzYdGPKPu52euSF/YWuz0eqf5Js8p
	 LqJG192x1d59R3M2jp+rIW+j4UNOSzSHoJUo+HrbaTibEL8i6ZKBCIwoOUZ78rFS5C
	 rLwgsScTswH43tplSu35yuhxWbzWxsAa42dbj8h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0217/2151] wifi: ath11k: unregister PM notifier on QMI init failure path
Date: Wed, 18 Nov 2026 15:32:32 +0100
Message-ID: <20261118150129.687378231@linuxfoundation.org>
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
index db7a762dcf62b..e7dcd3eff4a4f 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1306,6 +1306,7 @@ static void ath11k_ahb_remove(struct platform_device *pdev)
 		ath11k_ahb_power_down(ab, false);
 		ath11k_debugfs_soc_destroy(ab);
 		ath11k_qmi_deinit_service(ab);
+		ath11k_core_pm_notifier_unregister(ab);
 		goto qmi_fail;
 	}
 
-- 
2.53.0



