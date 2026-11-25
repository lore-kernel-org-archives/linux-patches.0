Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625993;
	b=F7z/afu3nZb46TOGmedJ1fJgizDwPLFZCdMoKoIBRzUAz3zLznNpxqEZb0N9WXAiekt9
	 ay3Z5SSJfCji4CUKZgULILlM1qK+G/4esZeQEfr8GWjhY5bKtwzW8Iq3EXgD433iJzSQd
	 Z/onh68bxcY6s7Qfvk2JdoIBL8OnW9tUrQt3qC30t+Z4esbB6o+hwC0Y0T2o19G8Y+TK3
	 fQBUWce48ZKYlm7+Qx4fjHyt9xsqy+dkvLxXWSgO6tkKQJ9E+V4aJxscYTOj5Flg9bHJ9
	 8k+ZC2uYuMvqn4tY9Qety/vMZM/nVt/MJcLIhvoBnkUb5qnGct44VdVxBvuMMbPuBhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Vs5Ifh3CyBT9ddZMSy4IMupd9fnkt2dUXMn1hk00mB0=;
	b=inm6jVxZ1yTz6Q+mX2lm30oQYr0g/dzMOHT6kja4Ybtt4prWaBVZMgO5QHeLwkmIDRm3
	 GbOtDitPtzCYm45D8aSrbI0nh0gAobc8HciHEVxX4UBBjAFyRg8kPt2f16aHE9vpme8x3
	 PCVf6fxbDYPOhbI6u43NUtEh2d5S55h5riiJQoAZLimNKQ+3D1HxZ+g2wFTbWfgelzrw+
	 VLxnGKJbhnUTMzqqcd1tyKMZkUe8UN77yHpAMvmq3N6RsZZLjrjG65Trosofd5lJJM3Pi
	 9aBMqxfYSGqn1z0keobgqqO+FJg/PtQEqGfGZEozZO3r7Hs9XpYSlP6V4ZRpnyW9Ycg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pE82X5r2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318D4606A32C;
	Wed, 25 Nov 2026 16:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pE82X5r2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B41C1F000C6;
	Wed, 25 Nov 2026 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625993;
	bh=Vs5Ifh3CyBT9ddZMSy4IMupd9fnkt2dUXMn1hk00mB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pE82X5r2rtfQWmY6Cki/UNyQ0dtVS1Hd6IK5f7BPWvgMWT21RZR8+U5JQktOdwOtv
	 koVhdtLeyec+Pg5lTybHGz3/2IKCiNdEkeIn5GusFFNnykVgNwMRS7WC7hCKLp/+2K
	 TAtRlPTHOckbCH4hGHDPs6sGk1fzzVsYCoalkNOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.12 659/816] wifi: ath9k_htc: do not start ANI before the first channel is set
Date: Wed, 25 Nov 2026 15:36:47 +0100
Message-ID: <20261125143904.433474139@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

commit dda63dd136ba2bc3b297079b190ac81a0aea40ae upstream.

ath9k_htc_add_interface() starts ANI for the first AP interface, before
any channel is configured. The per-channel calibration data only gets
attached by the first ath9k_htc_set_channel() that is not a fast
channel change, and that same call cancels the ANI work a few
milliseconds after add_interface, so normally the work never runs.

When the bring-up stalls for more than the 100 ms ANI poll interval in
between, it does run, and ar9002_hw_per_calibration() records the IQ
calibration result in the calibration data that does not exist yet:

  Unable to handle kernel NULL pointer dereference at virtual address
  00000008
  PC is at ar9002_hw_calibrate+0x1f8/0x570 [ath9k_hw]
  Workqueue: phy0 ath9k_htc_ani_work [ath9k_htc]

Seen about once per thousand AP starts with an AR9271 on a Cortex-A5
board that starts hostapd while still booting; a 500 ms delay after
add_interface reproduces it on every start. The crashed work never
completes, so the next cancel_delayed_work_sync() blocks for good.

Drop the start; it has nothing to calibrate against and is cancelled
anyway. The TSF adjust bit that shared its condition is now set for
every AP interface, which is harmless: the next reset applies it. The
next patch starts ANI once the interface beacons.

Fixes: a236254c35f0 ("ath9k_htc: Add ANI for AP mode")
Cc: stable@vger.kernel.org
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20261005072209.4101009-2-mehmet.fide@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1098,11 +1098,8 @@ static int ath9k_htc_add_interface(struc
 
 	ath9k_htc_set_opmode(priv);
 
-	if ((priv->ah->opmode == NL80211_IFTYPE_AP) &&
-	    !test_bit(ATH_OP_ANI_RUN, &common->op_flags)) {
+	if (priv->ah->opmode == NL80211_IFTYPE_AP)
 		ath9k_hw_set_tsfadjust(priv->ah, true);
-		ath9k_htc_start_ani(priv);
-	}
 
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d at idx: %d\n",
 		vif->type, avp->index);


