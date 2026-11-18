Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039843;
	b=1V/Am8UMjEShb2UlWY7Ua6MiYeXUW6Bh4w6QU81Bi1pJBfEYEyJIV/ObQ/e92Z2R7dE5
	 aMF9z2CkuxuN8BskY+G4vrRZOKg7sZDlwt3ViNMG6vwpgfqR+vQ2JjuZDLxeKxv3m8vxL
	 oS2CPR8Mqe8TNxLuigUbuNYCah7lkkXO8khzUT4c1EUrICASfH55yjqUrJhnWxGLuU0Mx
	 IEZ2VFN8gTCC7Ng9wbwo0qf4bLA8hOnWdInVoJDuoJvJh2edwGM32OWYBjKXeL3r0qM9V
	 PoYlabeCskQCQ2c5v0Vn50PfjE0i+fmqCMFYzzxmtrfU6rHaL2+PVLT7k74jwZmBT/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xTMzg63Jt/dvs99L278dwFpX3V0n24N4BmsG+9iLVBU=;
	b=ISBex2H8nMbaD9sKbQl3xe+vReMvNMOZsc/iC6PmDEo2+uuaCeEGvOmIq7NbbXJ040Z7
	 SoCaTNXfBH1Y/ZOWMtyy9yAvLI60GIE/zc35C+7o+09yqgSxnrEajjrYwyT5xT41ugEim
	 iUfL6AfYEkAV7EjC+dsee+uRsQnBjVPeeNRBs+CzcKS8bIz4VLS7s4VcWg4aabPoCsTme
	 NkHpeSCdViPEbhx6fJ3TTDH2WxM+WmB42r3LvW4Fwyq6cE2oSVcZr3RBe37NJgQUcKQiY
	 M9Os70f5SdyIIe5LsK+I+ETMi7FIMybBvRxfnWpe2xwq1oV6iTq1uML/khpHpSl725g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ph8tGhRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD01606A330;
	Wed, 18 Nov 2026 22:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ph8tGhRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AD71F000C4;
	Wed, 18 Nov 2026 22:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039843;
	bh=xTMzg63Jt/dvs99L278dwFpX3V0n24N4BmsG+9iLVBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ph8tGhRFijyEW8pZFxIctdmHgGYCiYWbintscoyZs0we9F1Lnkjz2cjg46K97mEE/
	 jkDjCfFlKkRlnNDNy0XS+WnmsOUEVmlGai+/BlVBmDusdVaLYF6uIaXgBH+QRjy5gg
	 pTdOO2/fDCOoLKOdVvZRIC4VSR175muuPq+xidHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2228/3318] wifi: rtw88: sdio: zero the padding added to a TX transfer
Date: Wed, 18 Nov 2026 15:47:30 +0100
Message-ID: <20261118150428.719859680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit b81ead28aeb1fd9bc3b0de4e20342b6b538ac658 ]

rtw_sdio_write_port() rounds the transfer up with sdio_align_size() and
then hands that length to sdio_memcpy_toio() while the skb still only
holds skb->len bytes. The difference, between one and 511 bytes, is read
from beyond the end of the frame and transmitted. Whether it stays
inside the skb's allocation depends on how much tailroom the skb happens
to have, so this is at best sending uninitialised memory over the air.

Pad the skb up to the transfer size first. __skb_pad() zeroes the added
bytes, reallocates a cloned skb rather than writing into a buffer a
clone still shares, and leaves skb->len alone, so nothing else in the
transmit path has to change.

It must not free the skb on failure: rtw_sdio_write_data() frees the skb
itself and rtw_sdio_process_tx_queue() requeues it, so both callers
still own it and would double free.

Found while reworking this path for the RTL8723BS. Measured on RTL8723BS
hardware, padding the transfer costs about 2% observable over transfer:
uplink is 19.5 to 19.8 Mbit/s padded against 20.9 to 21.1 Mbit/s unpadded
in an interleaved A/B, with scans, reconnection and a UDP flood clean in
both. The other SDIO parts sharing this path are untested; I have only the
RTL8723BS.

Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets")
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260909074556.55709-5-luka.gejak@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 025a975265511..e9593c7b7b91f 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -635,6 +635,7 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 			       enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	size_t pad_size;
 	bool bus_claim;
 	size_t txsize;
 	u32 txaddr;
@@ -645,6 +646,17 @@ static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
 		return -EINVAL;
 
 	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+	pad_size = txsize - skb->len;
+
+	if (pad_size > 0) {
+		/*
+		 * __skb_pad() must not free the skb on failure: both callers
+		 * still own it, one requeues it and the other frees it.
+		 */
+		ret = __skb_pad(skb, pad_size, false);
+		if (ret)
+			return ret;
+	}
 
 	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
 	if (ret)
-- 
2.53.0



