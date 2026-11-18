Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054981;
	b=FR5stUsjPhmYKK8KrWh3cforDYYpNrOwLm3a1M4vW7LFsXh5jq4MQEqkhsixfpbZBa5O
	 GjLJS3NaNziwxiaTJos8uXMW+InTBKYWbw+Cj7o9uGkc4p/xONpbbzBPLYGvuNPYGOLaU
	 2q/itG3w60Tg5ixsg8Ef257OISOZpwj9dBvN3IaDQ49zAPZ0gsUBfITJqZ80RkMzIxktu
	 y5L34hHxyw2EzvAnlH4Ih/FMA4iMV2p3epDiWDYcEPIyzIh4NQs4B31Z6f49+HfjAniXN
	 dv32sHLeocEorpX97oPJsR0Dtw5IgeglSzxsla+2hXjEYq9+IPP0ZgMS+SbgdLSq+Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=azow6vCMAeMxjEUTXdTSZW3+9Si4mE7qAqSbuD2+w8g=;
	b=zPxAfptzk+KIDHQjkq7/3vtWbAkK9TVed7XCjRXk9wvv8yEWT3tf8XNtsa6jJb0fRCgF
	 99O3IBxguYTnuM0pXgKmYZDjIOB62yTiFVrRbtymJikRe0ajqbiUQANnQ8SAMdxFE0xGx
	 Jdn+mziK9H7KAPvObYick9P7csrbXs8+s2he0/MKuHf4hA7/wFD8R17y+7+pk1Dp5TpHf
	 QwwBKXGA4iPNTAeMCm2EL4JYwR/iPKEXZutSzUxdO8Kzk3SOCzPN2gF3GHzXcn2kZxqY7
	 Q87KV6jWHEFyD65CDJ09O0y/2NYxEagy74qLwqUn8kuv3QIaT6L83Tnx1q8B3plMDDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvIieW5m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C531606A31C;
	Thu, 19 Nov 2026 02:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvIieW5m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B748A1F000C4;
	Thu, 19 Nov 2026 02:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054981;
	bh=azow6vCMAeMxjEUTXdTSZW3+9Si4mE7qAqSbuD2+w8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvIieW5m3WPD9ELX4ba/ycCy5mjOQa1a61k8Xb5yvRcbFWLjvJlYdhbDUauCoVNFw
	 idBK4uDcZZUahpag/aaXuC6R04iDnSCB3Nxru/B1nB/ZzCl4YL+fwT/8wh7A2k96fA
	 tmBI9dbG56qmeDSN+51rBAEDSegK/plHszhaMhBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Gallagher <cdine@cdine.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1418/2214] ACPI: button: Add lid_init_state quirk for Razer Blade Stealth 13 (Early 2020) RZ09-0310
Date: Wed, 18 Nov 2026 15:51:34 +0100
Message-ID: <20261118150107.948157947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Gallagher <cdine@cdine.org>

[ Upstream commit f16c512a07b954aa3b0b3c580e7abb5dd4f5e703 ]

This patch adds a quirk mapping for the "Blade Stealth 13 (Early 2020) -
RZ09-0310" laptop, which exhibits the same issue as the following two
related products already accounted for in this file.

 - Razer Blade Stealth 13 Late 2019
 - Blade Pro 17 (Early 2020) - RZ09-0329

Summary of the issue this fixes:
The firmware's _LID method still returns "closed" after resume when the
lid was opened during S3, causing systemd-logind to suspend the system
again within several seconds (15-40) after waking.

Signed-off-by: Ian Gallagher <cdine@cdine.org>

Link: https://patch.msgid.link/90ab9b58-da8b-4ffc-bd4b-adf7590545a9@app.fastmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index c2d19a2e73d8f..d996c0354922c 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -141,6 +141,18 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Stealth 13 early 2020, when the lid is opened
+		 * while suspended the open notification is lost and _LID keeps
+		 * returning closed after resume, causing spurious re-suspends.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Stealth 13 (Early 2020) - RZ09-0310"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0



