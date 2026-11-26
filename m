Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705527;
	b=eCRnny5jyAn8CVLgl740CXEQHAQl8cBB//eyS5/KErklJkwuCiEAGIynVXgn0DixGNsI
	 Ou1vNM/RXlFhf7/Sf62BqyFe+eGeBVn9z5ZY/up2mHAq3CE2zOhgTsA0H8f/VSuOFMEvW
	 cHEZDoA3czbe+gKVo2rQdKHskl+pUXF06K3Mhg2LDyvXHM/Wx68iuJBJPgG22kq/RQcSU
	 WSIyzRcAQtsdKjdMfbkPk+RxNa+aiLHGyOsZQpjVaEIzLtQgwQ55mQqpICUpGjW6WUfTv
	 EXq/QRzQtV2RZypWxwLRbTd4GrcCtFDXXdMq3KHleDVkiDTdv0147Rn/Cqj2tMS0sng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=8JMb0U0B5aI2ESnDflwruXS6gQ/vwMCYJaWVcd0GCw0=;
	b=lzDDbn2gm+bHn9MeCTOK4sHxpgImY1KakBT1bNb5PFW3CE+6f/GhNK++SM6InEj3+0VH
	 fdVhwtg4hb+IDivj+nqbpzSRU28oP23WJ3N9MMTqTliZU4nxsamlWNCrOWPqAF2l+AEM9
	 GJXMTTyhkg6s53AuHMfFKMxzLvzzpjm23WkmdLQdhp/X1+RC1j3Ev4STQv/J2c2245v4F
	 V34cvpIkiNL+Z4A8Wi8VQWiDbXO7E6Kw2RMGUVyqb6kDa/O8e0tYmwrLiI5moZ8lV2aJs
	 f2GOu1z6MKV5ynDfqrZflE7iKBJjsMB8b27uUnPGLH1py6uj49pIXowklBLJn+CQS8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzwNwA6p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC42606A329;
	Thu, 26 Nov 2026 15:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzwNwA6p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5D41F000C0;
	Thu, 26 Nov 2026 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705527;
	bh=8JMb0U0B5aI2ESnDflwruXS6gQ/vwMCYJaWVcd0GCw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzwNwA6pOmUn7XO0ocqVJfDLcSrGFaA0HSHAYBcq8dwwhlI1zGMCQ87zWXCstR4dj
	 amTFwkzWaDtOtqRCmBQz7vKFuTcQzgLgbLBhqWAICTDM3hHakWHVD8kn+yIHPcjubG
	 QumcdwobTIyCprZ49uFZXKgZP9CO0iDY1sBXKXTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.15 229/319] wifi: ath9k_htc: do not start ANI before the first channel is set
Date: Thu, 26 Nov 2026 15:39:57 +0100
Message-ID: <20261126144011.917130842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


