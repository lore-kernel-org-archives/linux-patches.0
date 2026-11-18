Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024221;
	b=rzGZucY8kmUPgj5bAswSBesVuZLYbcoFOyqWJDeB3cTIEOMDEzNJ2V8FnDVLpTlNb7NV
	 ebVVkpPF8EhPHBTtp9DYLu/JQeramHbQ8eQQJ4fwvXVIBaFXPKhmD2N5QCeu8yGMlflMi
	 EHkUZgfJFiNA65SsnMus0h43D+tR9ZIphF7So+yWfTA7R7/Lh+zSQWwXGDXUOK/ssvYqV
	 dAmitc82vmvk6FRdBhbjDbZ5dYTKNaU85340wW7eAV7RI6fEVw+6AwxNpqN1dwjooW0Dv
	 skAxTKKpL/J3UWpMMKOF3mmFLuwOrL6wBt/CalTiEyZKNnAW4UlkJwMmfaUt6FP8H8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJUSIeenBWBuCkT0tfn44EgkfSEwjpgk9Pw3iA0akTg=;
	b=hJIszf4ABWHVKyYbhsFRRJF/3XprNI2Ugg5ttq9YQLyXJt69zo8xei1sztbzUMnpuk3r
	 3pRWUQBhxNvUu0o2+N+ovCGljQfBwrW22X48mlZL5Yxpw6llAUSld9Vb2UY/aP6lawDLJ
	 6CJPCBs202WrzozUWlJ4xohFxhNbJs6EpbaDMuPKgUTTp9KIu6JwapOSLmOg+kUwQIaWU
	 2YK6E7aa5NZ52Yz/DyokCgYR2jwnTBxyrpYxVr+EBr7KFPR7txXpTFcJ4CyQUSBPHizB2
	 C1On189Lt3K2QzGItBTN/EYwHlQVjtP2MF4uhjXKm45hPWTK9e4SdgCVrSjr0yxdxCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rTBBsuFD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD43606A31C;
	Wed, 18 Nov 2026 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rTBBsuFD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47FC1F000C5;
	Wed, 18 Nov 2026 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024221;
	bh=uJUSIeenBWBuCkT0tfn44EgkfSEwjpgk9Pw3iA0akTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rTBBsuFD1UeHwzscqGFjVKkfo791JDJndFwrYg3HG/0K+FzerFYlHwhA+lEz/OxNJ
	 KHW4UUjoEXjSa8cyRJQvwcSR2mMXKauppBVd7Tq44jYRJud19HLitCu/KrGu6uPz2f
	 q78WIj0PtGR/zmruWp8kEWGnXQ1YfqgvXOtEBeJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kerenl.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0607/2151] ASoC: amd: acp-es8336: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:39:02 +0100
Message-ID: <20261118150144.050200306@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 6f50ab7ab1f93e874fa75d18bf98bbca4ce0204f ]

Replace acpi_get_first_physical_node() that is slated for removal
with acpi_bus_get_primary_device() that takes a reference to the
device it is about to return.

This addresses a potential use-after-free that may occur if the
device returned by acpi_get_first_physical_node() is removed right
after dropping its ACPI companion's physical_node_lock in that
function.

It also fixes a device reference counting issue that may lead to
a premature device release if gpiod_get_optional() fails in
st_es8336_late_probe().

Fixes: 02527c3f2300 ("ASoC: amd: add Machine driver for Jadeite platform")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Mark Brown <broonie@kerenl.org>
Link: https://patch.msgid.link/2063881.yKVeVyVuyW@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-es8336.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp-es8336.c b/sound/soc/amd/acp-es8336.c
index b16dde0e29871..7593eaef5859a 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -199,7 +199,7 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (!adev)
 		return -ENODEV;
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev) {
 		dev_err(card->dev, "can not find codec dev\n");
-- 
2.53.0



