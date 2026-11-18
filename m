Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039987;
	b=v/PUJDXA9tLYY5FjQ/vnymuSCdp2CpbcmqR431/std+Pt3wEjkq2jyy2FpylB5rCVBWs
	 raT9AZen+IRc7WKyURWt06Pd1FxnqH/5Z+uxqKCKGajEpyALXjQxZqdPJ1Kl0I7cmkZMZ
	 Z8t3jdKWux/FW54OaDCTwYQFKgoRiCAgHTjGC7CX1tnoOQ+WEPkjHXJBpYpbu0jUyvZzX
	 olUI5BXuGjq5f1WImI//7eQJI7DocdLlAoff3N5lwnHTCEGGBwN2X1z0/sz+PjyrcCnvo
	 bikhVmQaqB636Dnhv5XuPjBwF4FO3eooIWvnaV8iA+0fmb4bXh6pB5g4U5UR4fRiHig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+hxf3SgFw34cCQtgHxm8zJqqqaXS4ea7cAnzxu0o9I=;
	b=tlfV/uWCfNV6sBOu0ij3R865Ii+UZ0k8jWNY+d3ddEbQKONjr51rIY7B3OgTYV+Ugxao
	 zp2C/bVv1S/1GoSijeXrNlALHeMbOm7LiZp+zWtmsxUHSP5UsvkeFK3P/DFGPVs9wmK/z
	 37Q2wZyVp0+7jjjRcl9xQJYJcRFKU6RYlUI0C+wGDUR+SOtnP7SO6SGvXbB0ItmPZrKSw
	 GQSoWhY394LU6AAWJaTGm+ZhjT5yNsmANbvNaoAqXeDTJI1oeZb2nFFIQqIy4xTVSI+0o
	 jqgSq3mQ7pXedHaF4QTx/Jca+dZI1eJPxTNEpSoINSpGQOZYWncg6ycd/pv/b8IfV6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd436VMN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198FC606A320;
	Wed, 18 Nov 2026 22:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wd436VMN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701FD1F000C4;
	Wed, 18 Nov 2026 22:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039987;
	bh=v+hxf3SgFw34cCQtgHxm8zJqqqaXS4ea7cAnzxu0o9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wd436VMNSY1rMBokuvCRtox5huJQe+eOwb1eRlkaBarEGgQmcfP4HyXlSpUOlWrxY
	 /9YW+z9BlUXsepk7v+6FfBBwv+ugIoOC1UkRZw3vYqJYS65xbOdax0UVk8ZQD88YbN
	 F1Q1O2RiCMWr6Dc61Z/M491RyOeCMcXWn6jjWgOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mark Brown <broonie@kerenl.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2296/3318] ASoC: amd: acp-es8336: Switch to use acpi_bus_get_primary_device()
Date: Wed, 18 Nov 2026 15:48:38 +0100
Message-ID: <20261118150430.608202748@linuxfoundation.org>
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
index 49bffc567e68d..0800c50bc9df3 100644
--- a/sound/soc/amd/acp-es8336.c
+++ b/sound/soc/amd/acp-es8336.c
@@ -201,7 +201,7 @@ static int st_es8336_late_probe(struct snd_soc_card *card)
 	if (!adev)
 		return -ENODEV;
 
-	codec_dev = acpi_get_first_physical_node(adev);
+	codec_dev = acpi_bus_get_primary_device(adev);
 	acpi_dev_put(adev);
 	if (!codec_dev) {
 		dev_err(card->dev, "can not find codec dev\n");
-- 
2.53.0



