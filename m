Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045412;
	b=YjSGphVa8IymDjok3SelpJDYi63lcrng6BpBQF/MqTt5Q8nvv1PZge25wh3rA5CgeEs3
	 p9VF273rMvLRtL/yeyABcyGlLfSi7QGXo3M36lma5FccQczNIn9thpD3+zgTJyS2N6w7K
	 ZvsdSQ8vNXNrCFy3rVmUBP75QpY8nwJApSV4mbXogT3KIVgNP8nEXU0j7iBYROF3Tujv3
	 46jdlgc1BJB5lpE4Utflqg1a8QVyiPf4qXpeAV7OqgpvlbheVtVKoiqMPVFWz0adO6wPY
	 Cst/scPTPxEo01dWqUQFBGRMycJWE4whc9uVrCgn161F10Wro/o3PbTfQphbKfECr5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KaHmPN32WK2eFkqjjgSLo/a4hbY9LmpVJAKh0mCKi0s=;
	b=V9IMTsBlGCWeBKbHzx/mHaVql0IUAI77Bu0N4/p3jzZ3tmS7ie6MpfQh8PZe+d5Qtl0t
	 eaWHTRG//XwJFa+iGhL9u72McnDVS1B3aDO1tVSeJ+PWZ2SjJw3jqDrgcGILjBMJzcAyw
	 gS9f/wbjpKYB3iAKtcUD2rwzylepkLioYulWAl0ZLRvRbh+gzHkIaDMlmT/sANFL8LkFj
	 svh2bvIO+1Zf/QH2dJi4Pp+ZrF92bCGT/uqIps3Ij/llapYN+k5hE/JwoLtgtaiZdhMDS
	 HWRJeZmcXqyFiiMMtllNfJvWuyeiOockWoxJpwedKrfNZZJ3UvtTJAE65dvs1bL6kng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9KifYbX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BF0606A31C;
	Wed, 18 Nov 2026 23:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9KifYbX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4621F000C4;
	Wed, 18 Nov 2026 23:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045412;
	bh=KaHmPN32WK2eFkqjjgSLo/a4hbY9LmpVJAKh0mCKi0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9KifYbX4AIGogeM3lNcJIWcWYAc9igFDH8hFdjPjyo280BcY0SIk70P0oQalJxr0
	 dUtPUPxCukJXaiaTQ0eysKLEW9nyWsrmazIAghX3oIwuDprBOtx1iVxSQy80eP1dii
	 XmB7xofTnl7nULkZaNDLbaO68ej0tGJqoqbChHGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wyraz <michael@wyraz.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0914/2857] USB: serial: option: add support for ASR 1286:4e3c modem
Date: Wed, 18 Nov 2026 15:32:28 +0100
Message-ID: <20261118150234.490508633@linuxfoundation.org>
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

From: Michael Wyraz <michael@wyraz.de>

[ Upstream commit 87c56085bcdfec305f5c350fe1c58a62a7f65843 ]

The ASR modem used in the Tuoshi LT22M exposes an RNDIS function on
interfaces 0 and 1, a diagnostic port on interface 2, and AT ports on
interfaces 3 and 4. Match only the vendor-specific serial interfaces
so option does not bind to the RNDIS function.

Link: https://lore.kernel.org/all/d12635f9-9706-4dbd-8adb-d673c6a77202@wyraz.de/
Signed-off-by: Michael Wyraz <michael@wyraz.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/option.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index ea418fbd7149c..6663b352d7a63 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2444,6 +2444,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x30) },	/* Compal EXM-G1x */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x60) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1286, 0x4e3c, 0xff) },			/* ASR modem */
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */
-- 
2.53.0



