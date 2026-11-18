Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028039;
	b=QShog9n8ym9NQ372KbmqWHtOa5voh4ibLNkhvDKk5ZgOKtuq8kG82sXrUZLFLmAkxKf2
	 tYadfx3e9+gXEUMzkhV5XNuChOLj2adgED6CIQE6bQhYIWSBtjPexATni3v07z+PnLhaC
	 uAFvQTVIpnmkmczaewvHC08DRNrdYHTmqfHoTQ9/WFzRmO132GsoJnvAftPm38Pxp5/X4
	 kfFHgx3Yl6TkUqVIEXYDRFjQRD+JsXGnvdBjKvK30HSZt1EnhL8O3WmvOtjrFU4A1lUIx
	 +BOPBJWyi7PscH2XT1R+MPJIlbX9Fp0dm5r2SOHzOxZSlmktwTearlBi/hjRgxpgkaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6hfCQgzu88nqZ64+lgOX2Vpt5dMi8uT8aA/MtTvhL94=;
	b=yu0V0HReMEtasPEQdR8Amqf/g1Q2GYOheZh3ZzOw8Hm0ajr0hY+Y3W2RGdcd6NwsgnE7
	 11VQDdPgBW1DLO5RiQOo2jxbaAzG5k6McOc9hIWpTnd9Y/TU5qf9YvJag8Rq9Wuv08rIu
	 pNCu3aji2hbU21s7nWzBzimrqJloY1t6wNQUNoIHDNXJKvGtAYT5mFojksh6SJoXHIjwA
	 tQ4g3FjQslOHqv0bRA6SA9/ceAsDjsY5t/jOZr8B5us7YW4ikr8Y8hANJfv7fx2/7vG3h
	 1M57CwDwtgNg4b/J8Rcm01QkNROUc1XY2HBbZZwEGrplg+5g/1dyW3Mf/RaIc48m/Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4jsCweu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE21B606A31C;
	Wed, 18 Nov 2026 18:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4jsCweu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C53C1F000C4;
	Wed, 18 Nov 2026 18:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028039;
	bh=6hfCQgzu88nqZ64+lgOX2Vpt5dMi8uT8aA/MtTvhL94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4jsCweuQTeQxpI5zIevU8ppefmZ+yjMd0jgHN1ViCKijSjxk/dLfg3RaeRqwcHTk
	 t3718edjYYSb+RcFkEgb8bSi/bNEso830+Sqm7rUK+4XKVTKnSwO1AKeFJ3L/1Vsg0
	 nqWSbkmj37A4R+ZWcGW/FL2vnNDjt0+k82UUYIM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9mie=20Rodon?= <jeremie.rodon@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1962/2151] spi: cs42l43: Add speaker ID quirk for Dell XPS 13 DX13260 SKU 0E54
Date: Wed, 18 Nov 2026 16:01:37 +0100
Message-ID: <20261118150233.226530035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémie Rodon <jeremie.rodon@gmail.com>

[ Upstream commit 7da2aca123754c0e06092bbe179d58078b58d8d4 ]

The Dell XPS 13 DX13260 is also sold with SKU 0E54, which has the same
ACPI speaker ID layout as SKU 0E53: two pins in one GpioIo() while the
spk-id-gpios _DSD property references only the first. Without the quirk
the speaker ID is wrong (0), so there is no speaker audio and no amp
firmware is loaded.

Add a DMI entry for SKU 0E54 using the same handler.

Fixes: cad16d850e37 ("spi: cs42l43: Workaround for wrong speaker ID on Dell XPS 13 DX13260")
Signed-off-by: Jérémie Rodon <jeremie.rodon@gmail.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20261025095037.18891-1-jeremie.rodon@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cs42l43.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index 4d153f58f2462..ca3db3e604a49 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -316,6 +316,14 @@ static const struct dmi_system_id cs42l43_spk_id_quirks[] = {
 		},
 		.driver_data = cs42l43_get_2bit_speaker_id_from_one_gpioio,
 	},
+	{
+		.ident = "Dell XPS 13 DX13260",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0E54"),
+		},
+		.driver_data = cs42l43_get_2bit_speaker_id_from_one_gpioio,
+	},
 	{ }
 };
 
-- 
2.53.0



