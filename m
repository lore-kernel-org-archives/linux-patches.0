Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590348;
	b=LRdYye8zu3fy8jOzYYtzrGpazqLLrp/mcUDTMxsVmmBYUNdMkgnabX8e1/2YVdsp/GIY
	 P3bQcirY/00G9/68f0rccIs4BQqZ2QFykOWKtEAfn8Yv12hy1sJAwJYwQE0wpe45aGoED
	 x9bTGZNGWq4WOCkxcffN12C2741pEBBai/VmXACWOn3jm8zuNSCR4cEA4G+whh+Ot/Fch
	 MZuViCUpdzu7b8zgKB/6R1z82gx6cq2CCE9eHT2egCcXy043cCo+IQtzgh0TDQzAIbzUZ
	 evWenNdIpUSRRLyCPPg2HMADtE4AQ/I9mtkA7Nz/QqUo+0inuOxok+T+pDssE6TPinA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DM7QvS4EuM5U5loqB/ELfFfdHPSKSmzIse14bcF+rlQ=;
	b=1emvhc0n1oMrGoRRFZsRZ+TaR1onWowmlo/rrB3Zsh4twjA6ChVtZCrzMSW/v0xyUtcc
	 KtE7u+amPaL3SLN6nAKupeHR0kKz8KJBkU4aLNsXyroU7M9ls43zv9G48fBmUkvgnPvp9
	 DvFccOwurtMTAsQsfr9lUD+L4L8fHGM5TJG0wIloD4mv4nCW21GomOmqNqrREh2GGCSkV
	 3livEA14cuea1NcgvzlteqGnrcERcJY/eLKTiQrMKCltBuNnT3qcaXBGGSxZj/A1GYsFi
	 qlBZIIqEuEA6wHxesNi1Ky4BlwEidhj2nAE6bGxOIA0C4+Iz0aLAtsqdBdPJFFx04nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wve3ss3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068DA6083163;
	Fri, 13 Nov 2026 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wve3ss3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85EE1F000C4;
	Fri, 13 Nov 2026 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590347;
	bh=DM7QvS4EuM5U5loqB/ELfFfdHPSKSmzIse14bcF+rlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wve3ss3Iaqx0l5Zh45z3Zs+qT0Z5jtRAA3IqucjKJrzfHTEIdmY9MebCZd49OTxvW
	 EJ9Ug+Zmqrd37oecy8YE6zOsg7gr60YC9ZWY6g3nzeAoRaHzZXlV8nARzbWg6rpHHJ
	 IBGeTcAEJ4wAVTBHDZpi9cV0ApALqv7YRfQNLzHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 272/686] hwmon: chipcap2: fix command error diagnostics
Date: Fri, 13 Nov 2026 10:46:45 -0500
Message-ID: <20261113153830.224444380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d0a03e1a2d9bd53b94fe6dff7a1a8058d25be82d ]

The command response field only contains bits 1:0, while the
error flags are stored in bits 2:5. The existing diagnostic
checks test the extracted response field, so they can never report
an error flag.

Test the full status byte for the error flags, and check the
configuration-load flag instead of RAM parity for the last diagnostic.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-1-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 0e182454779e0..b3d944852e73a 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -165,13 +165,13 @@ static int cc2_cmd_response_diagnostic(struct device *dev, u8 status)
 	case CC2_RESPONSE_BUSY:
 		return -EBUSY;
 	case CC2_RESPONSE_NACK:
-		if (resp & CC2_ERR_CORR_EEPROM)
+		if (status & CC2_ERR_CORR_EEPROM)
 			dev_dbg(dev, "Command failed: corrected EEPROM\n");
-		if (resp & CC2_ERR_UNCORR_EEPROM)
+		if (status & CC2_ERR_UNCORR_EEPROM)
 			dev_dbg(dev, "Command failed: uncorrected EEPROM\n");
-		if (resp & CC2_ERR_RAM_PARITY)
+		if (status & CC2_ERR_RAM_PARITY)
 			dev_dbg(dev, "Command failed: RAM parity\n");
-		if (resp & CC2_ERR_RAM_PARITY)
+		if (status & CC2_ERR_CONFIG_LOAD)
 			dev_dbg(dev, "Command failed: configuration error\n");
 		return -ENODATA;
 	default:
-- 
2.53.0



