Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704629;
	b=tR2scPuTUMv1Shf87jWe00J2YUi/WNth/zI25OAaDhNdZXPrHjanihy3DrXuzMaAt9Rt
	 rki1S44GXfmPaji9WuhVQm4zoTWEVMWRxnIOHJ6trU3FRU9exBvPbF75G13/35RahRiou
	 kSYvCkoOoHItpY1K27tS05N4huR28PYSZL76IJI24rfHjgU/y8iYAYH5KoMgFcnI3tIXm
	 IwPRsRETAcIoK0IxUs1f6qcLz7Bua8/aiBojQfF1b4Z6XQPtftFMxqKT1PbVoYifLVu63
	 7eU5z/EuR8xNyM2c6gmkJvtzpAtKzISKoA62W0nRwhd2ipQ6Jt6MmvDc/cuVXCRy+Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Eo8lktpJLNEtaijuue8pPGJMtRtzVNP8Xk+Nb+N6Uy4=;
	b=W5GV4lNgbS8v8ryF/EAXazGT0+iGgAf5hlj1laiJ65IB7Crktc6tafsCzu3ZQsqTqTOR
	 KieO47yX3VlgRYa6NcJ4PIJhHaaKfIDx+FSPYNnirEoQ5Tbo8G/hrfWaVm2ah9YQwkRYG
	 jNNJk//7AfrkaBa0AeOLec5jm7JU5O/DHJc3Kz7yd86a+kOeilQOUJDgkBM8rOlZFGbkp
	 6dGBQP7jSQXPNgBZxzPzzlOyk01cOUPE8g8gUzt0BwUUrUohcKq1DtqaDhhPBgLappxz3
	 hPut6BcQPNEpHaPxDUliXAtmqc8maNzDAPQVd0LRk9mJepeePrKPEJYhdMoz9RqkfQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+vhszNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54109606A329;
	Thu, 26 Nov 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+vhszNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63E71F000E0;
	Thu, 26 Nov 2026 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704629;
	bh=Eo8lktpJLNEtaijuue8pPGJMtRtzVNP8Xk+Nb+N6Uy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+vhszNgNRLurFaeQkjr9NiSJnvOKDkFZJvV4919tHpPZsUVeZ4UFKffc2LujXZiX
	 Wy89tDNJjFC65HNSgYtIeriqh+Fm09lU23xyUIzAf0s1WK9vkYyzyHNjQ/Oxby42if
	 nja2MBFWsw1yvu/zLgFrEX9+8OVwEYGvz62dE8sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.10 188/265] wifi: ath9k_htc: do not start ANI before the first channel is set
Date: Thu, 26 Nov 2026 15:38:38 +0100
Message-ID: <20261126143618.345549801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


