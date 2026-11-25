Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620162;
	b=bziohOoP+epeBksyPTVdlB6vPHYKgnPGYb2dJWOFs3QF0khg+yo4qb2ZPR0CRR7yitHs
	 R8Zqy6ctOOqNQ2An9IhD5bISsRPryNxyjAiztZqcpLs0gy6CqpsxjXPlRiOJemT0BMfYL
	 mR12JxKjGokmYkRSF0Uz/ZMhuAhZSYLzM+ewEy0P1u5diDTYC24ubpF4j0bW2NfJ9G4am
	 mjupWczhoETRpBb8xaGjDqGCRSI3Xr2B1ye3Al/N+/FOKGtNXSyvgA+X7l1bqxUect/JP
	 wAt19fKklTBkXlxgdW3Nf0KE//lBKM+1yBR2mdwlBqyhk9NyTVnoUPXE91t3d6RlmBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IwQMTAbKC5+6MCUc5i4aoBi1hFSpPhflPbUdxjIk2iA=;
	b=PVQTrb9ou6RfCvAyBw9LBniwowSp4pHD6JipabjyL26TeVLIl2NiMK3BDve9r/sEvoLb
	 h17jCPG6sKsvZeYdPX4akVMKfBA/UwdS5H+sbW4KkQ5uspn2SAIUIY6jlV5Ek12JyizUs
	 1HvlZ43qbnGiLvpeS0Hc2dMqeQltEJIIVqeGtVzFIYJu+RfHu78CPaATpPAWE5QSUk88V
	 rozzSh/tWj6guKYXwhpXaeuDwxONOM5b40qjgIpY2UuHKlc06znuO5IhN/f8a8e02csxG
	 C7fv15Dlq/krTpBoeZQT6JoADBurtnMv0FlwsfSoYhtnaksKghOj5fat39+x1O3uduQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f4dC/Qck";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F88606A33B;
	Wed, 25 Nov 2026 15:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4dC/Qck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1105C1F000C4;
	Wed, 25 Nov 2026 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620161;
	bh=IwQMTAbKC5+6MCUc5i4aoBi1hFSpPhflPbUdxjIk2iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4dC/QckoODiTJ8DwfNQTV5NMJLpg4a2S0uwB9ckyN3WM21qxe3gD+gFiGFkzWygc
	 zRSdXYKMX/U3YNsilNfnTs+CIj+QdTQBUOrEWc3pjSExdYZetyQFszgrMc4LGMN6ho
	 4HOd5egOwpc+ZXGDNqXgO9ewg/YK/iou+GsYVzvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 7.3 0792/1005] wifi: ath9k_htc: do not start ANI before the first channel is set
Date: Wed, 25 Nov 2026 15:35:30 +0100
Message-ID: <20261125143840.292121446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


