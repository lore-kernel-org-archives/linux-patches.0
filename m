Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021791;
	b=fAp/uUokOxTHqx1XfOwPB8A/ekznTM93uu6TicpEldfKIw/J1G0WM0WFUlYp42TiCeuP
	 kqoKwiZBul3xvM9FzO8OnHx4I9wV2DlLxkIjeXPMUXptQCJFaQqn1jdPulhrccOE+4jTR
	 iOxI8/Bc8dz+an/iVREDpUXcI0kA5RZ6Mh++2G46otpzps+p4fb3eJufUSn9MipYpybLJ
	 ucZfi0CFJJsZ3QHNVsxo5KwLYOiFXHG9D1ED+l2npjh7X8NmW7A7Z5EKp4CXGzo6YZyMd
	 XLw9jObhX/f/QgFS+9vwMkjOFkjtAXj+cQ3UzsK5yvCNh6x7nYcAWn7RuAh86jtgSJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=92rjo9alVJ/iBxoC7wcho9NYp8gjgCaQre+/z5BBBSE=;
	b=iHypg6AvGcpNkrKZTCJl2sPCeZGPx7LPdf4V0JyFflhy1CnPvm7BK2zLV6sZ6d18Bo9F
	 aZawwTSwSXm51GEGd/4K5XUu+/+0+hQvvaG0DaGrE0W5zoYRbdOPO/prDLFmPbjIJt1FK
	 /o3URT3hhTyCHXr71hqioBVAYERFOegJRuG2YEpcym4uts8+AIPNI7hApQRN5Nca+FS9M
	 EBMBNvecstQSwnxBj6cm5Dv85ZZGpS4bRxFkbfWL9O2WxhiceuuKmdX/JmtZijaLZseZU
	 05L3/VztuYl2zt/rHxwp5Y/wlz9d2WaLUFjH0nVSQzv/GTe6Ag9qZulDOAt1JffNz5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tKiiydLg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44799606A325;
	Wed, 18 Nov 2026 17:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tKiiydLg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969AF1F000C5;
	Wed, 18 Nov 2026 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021791;
	bh=92rjo9alVJ/iBxoC7wcho9NYp8gjgCaQre+/z5BBBSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKiiydLgidMV17eKpapzkTLvpmr9DubFz7ae9HRHEVtDRJqH1w0/rVhbAcArrzZ2z
	 xkfvQUzEz/H4zn3LtW+L8INyWXie55b9BaXLgnTcQIdJNS3kTThE8FoJWsqle4s7Bo
	 1cJpie5aKochQcvJQ2+s6zNRl89mT7HMLnEUj+Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9mie=20Rodon?= <jeremie.rodon@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2432/2651] spi: cs42l43: Add speaker ID quirk for Dell XPS 13 DX13260 SKU 0E54
Date: Wed, 18 Nov 2026 16:01:12 +0100
Message-ID: <20261118150412.755182261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 6772abb483dd3..46eeb44130dd5 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -301,6 +301,14 @@ static const struct dmi_system_id cs42l43_spk_id_quirks[] = {
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



