Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064587;
	b=O0w9scoUknsQqN1NvuSc8IoCmsQvlAUW/y4mVO8ilzNjfHDxhn6c7VO3PDbtPK7iCrH/
	 sZciLyWDgZL6M7T1g0BkscqkP4zpMcFvuyIPVTyjfA8svSRzZWJaR7E5/QYSRRgbihcgY
	 XawXG2L6LZjMeKktE7l4SMNHKdPx43mHB6FXFKnqFe98MktEO1gj52md3xDjsltlzvQJL
	 kGcIGkGfmRt5PHVAOA+Pdt2mdLYtXrQDNGQ41noD/en9MoTr+HQ/poTyMlg3r2ExwjLZK
	 D/kTiMU3SdJHhZllRtq/hYiTVvAE/0WzaU4RCFqmRCDi6upBQiFktcOmrVp6KkK1xTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uc2vA8pFvjR8NsROWDp3HoBdLzMXuZdP70Rij56tWFU=;
	b=trKnAFa3eEyc1bD137wB49kcPZV4yFRnJRxl3ErP74M1b6wg4Rut12xqpo9LQssGj+xj
	 /7m3iHPvRlK78nvA/ZTdHGtC3U4jzqw1hM98LU93iGgX1SwPwQPc+1lCe99XaVeE2R1yX
	 Imv7VXtQFq8OlSIBz3hBtKb5vIKJLyMC2HfFL4QcN5bwb/xOMsvkxaIp4iUnkloqXkkOH
	 cOock0pQrbm0YVMuY0wFrVFnLhH7gnizHCpckUOvM/xevx3QmUZN/islzigggQpDVUoWh
	 VndVULU+YmL6aPpuTuoTj3KJaKHYSp+kUr1nebkk9hMr7uxC19+tdKtodG6A6rTCNqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vO6LlhcP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7B9606D821;
	Sat,  7 Nov 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vO6LlhcP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D6F1F0089F;
	Sat,  7 Nov 2026 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064586;
	bh=uc2vA8pFvjR8NsROWDp3HoBdLzMXuZdP70Rij56tWFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vO6LlhcP5/4lJu+vyhDzG105OElSxld1l1/ko5eT6VxBB/IHe3ayEBFeO2z+71HP/
	 bUivWxSEqWDAnFnhFP2xnnDeBUtdK6GFROn2tkgx3ZiEsRW6GJn7O1NIRIZ40lUYEH
	 aVucJ9Cpw9PG5tYMb86kFdLfA8fvZCxJAN9VLegA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wyraz <michael@wyraz.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0603/1257] USB: serial: option: add support for ASR 1286:4e3c modem
Date: Sat,  7 Nov 2026 08:48:19 -0500
Message-ID: <20261107134955.969311124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index dc8f459ca3995..65506f6e1502e 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2443,6 +2443,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x30) },	/* Compal EXM-G1x */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x60) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1286, 0x4e3c, 0xff) },			/* ASR modem */
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */
-- 
2.53.0



