Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063242;
	b=z227WkIK289uaGfwle6YnJEhc7nu2phsdVAd8XT4H8djBq7z6tOtA9N0sSQ9QgYwsSz8
	 NN8s37/mtrHtHqsTAwjtlMSkhvzSEa8iaUqYoeqerrUTHIljFUWGLLTTK1tgJDpl4GcMg
	 X9NO/YUCjFHfZ5KEBybp9kFrbrGWlMuPorDEcuIr8PS/tKOizzRdCw+t5Y67MOjkBRxYD
	 3hF+hLM3ZO8mcGLGwpVO/dT3PM1Hq39s5lC4Skh6JRdEjytfiyi+5Lkj1LuKB+Tk97/Za
	 jT0AiKSDq1Kq5eQHDJeOphLeR12q7u+IaeUih7NSZS4HpVvrT40onKS/v3PWCidIJtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQjqn9TSs27EANKbicWG2/WwiH9YHUqixNQsYlZ6ZbQ=;
	b=Wf6Zf50HDvSqxRI9K7R9dvrwQIMfDN3HZrhsZ3IFVyVfE3FOe5cwyubc7elZA2ioY3+m
	 hGwdSZu50Hcwu+/8crXKtLmms0e25r9mRNutgGKi8ZbER1ugQ4ngbKFIs/JOWmthWyaQ3
	 BIm1NdypHwFM0Z0eKDk5DvYPIEWeoLEoVD2ZbGSP0lNwiJAV5JDuY7GKcx9GWCgwH+JSH
	 WrN/f/ajUKO+/S6EHR3C6MscyXbxdskfepuAYzGOR+O/8ohXJZIuRAL5wD/BAWpRDwL9+
	 y6Zqk35ASHT57UUAIAL3BOehg81TX6pMPJ0KewQFJLc994eNGqCWuYVMW4ou1wum5cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhENbBQd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4719C606A33F;
	Sat,  7 Nov 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vhENbBQd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052CD1F0089F;
	Sat,  7 Nov 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063242;
	bh=bQjqn9TSs27EANKbicWG2/WwiH9YHUqixNQsYlZ6ZbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhENbBQdS+KuoEBvfn/hYRpxwrgzQpss9peS0IRNIw4ayoiF7Rs0Tp1YGfu4fl3KO
	 pKZucoKF7Y4NkwpM3RjcY1nHmLLmopSqd67uK8kW0wGlDV+6TUpz08RZaSf9aH+/Lw
	 GvY4hBNzJBMsWCm3aQ3E/p7GUjoqYjGybt4Eaufk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wyraz <michael@wyraz.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 447/869] USB: serial: option: add support for ASR 1286:4e3c modem
Date: Sat,  7 Nov 2026 08:52:09 -0500
Message-ID: <20261107134908.892359755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 416ec012b0ace..2f83e7b866f60 100644
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



