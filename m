Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036431;
	b=osjiEo4MbsalEwBhXCgYF9kQvRrPfF4YdVJcE8PjzJDytqHKoWWYGlrnTvGl/Xvy7B14
	 nI7EbISu74UaChuLC6eT5E6c+FRe0M0MWiSHQPMm090WrDcl3hyLKu8afXVi5aycOO3Yd
	 etgTKa8bxSsgVgBYsCPCU9od51gVcYnPIe8KI4UVAkhPF9SOoDzL6SGjZNgbRhtxdNa+5
	 dqbIxoVvY2R8TL0ZBpsHQnic1OY4/wr9YLn/Vyn2fvvJRM3r1N6QUFsQ8v1+mN5d/rAa1
	 cgFY9daK3/dXdVbihUy8Nfw4h7bqYo/lYMJ2vL2RgTJpUymWjD6HS6TuuDjY/Rwld7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ytMf0/xLwuneqjUE5Rjs9O06A6437eO2iw+kulOyI0E=;
	b=UcC1wjLmwbsuQsYmAOSk1t/hGh7JgCIaARbi511FiQHbWiy422BvHCgH3mosexLuLw3v
	 0geVyO390oz7TDc2VpQUhXUSj7yEDhYjZKyuAtejfacadQk3jWsLuobKujipP165f57rm
	 wd6ZffSv9Wz4fYPtaq1hxHgG6PujiwV78C26ENY+Zh3JXqelJtDAzb20A1uXt04OaQoSM
	 zuHkQCiYIP/anvGL2SPuJWoWEZQ0P7kKJdcIk+iq7GKIEBJ1ljot3ur37Au6o63OWyasR
	 UMAHAZwW+K7Sga9wNQX2vvCHKnA5xDLOgntzcFFIf6J64UGVj8V4Es+X/h62rjoKwig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHNZ5Vhj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAEA606A320;
	Wed, 18 Nov 2026 21:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHNZ5Vhj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789121F000C4;
	Wed, 18 Nov 2026 21:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036431;
	bh=ytMf0/xLwuneqjUE5Rjs9O06A6437eO2iw+kulOyI0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHNZ5VhjfiAhZZ2IFztaDcId03+zwfW4RaAS5HNUiVnO2OTuaQNBTfmirNtkxKA5n
	 2+KbtNNBz+TNmTtQenVWPX23P8NrGZxI/pu9NMCe+3ShAOzRKyZkt2mt6wjqW2zrTs
	 5YReR31IChk6CNc3XJ55DhR332qIeuS5q3IN9KOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wyraz <michael@wyraz.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1055/3318] USB: serial: option: add support for ASR 1286:4e3c modem
Date: Wed, 18 Nov 2026 15:27:57 +0100
Message-ID: <20261118150351.588494667@linuxfoundation.org>
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
index e00c967bedc89..19f51ace4ed80 100644
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



