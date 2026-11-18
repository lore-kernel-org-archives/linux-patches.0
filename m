Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015522;
	b=HSVTZLSLFv0pITiH7KwW/yRDn7+4wnvwlhFqB8B3WXoVEEt52Q4gplzxKfZtBTW0yGXI
	 +aNFL2Rr2xJEwQReyJAFBXhfFAZ6fi0kp7Oss1KRjfrpDgfxSrb+z2o1WS79vhuQ0uF1v
	 49SGmWhHheZoeRgsnW49TCn77NJQAPHtmKebJmwv+vJhnYCIZwkEjQtG4K0FXXY8mMmcy
	 1//4zXwY9aEeyvWd3T3r40i3pRvxj7DM4UsU4b6mDmeyWK/SE1aWGYZUuiTWjvX0A1Mlu
	 bMXiHgL/BqIVLhShS3kOySrGG9GNABIkLr2Syh6shyYIgbO3+NnqT1PY0S//d90qesA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iXZ8O7mxs5pQodADdEyn8tKMaHgTYk2AxJNdR5OKeK0=;
	b=LPnQkfRNuVLZd3z0iJ0MUIMHOYlaXsEkD/erBwBaAoIIMngbe5+w3QYmqb9lraB60Mr7
	 CxKZ3sF6NrHN1WoVbyEqvuSW8XXJIzXkWBYxyU2c4XrDQss9fwkD3O5pMdgM+I/Y2gCdQ
	 TLfBbQYWsU8vZbA9JhSmOuvXBkkCwwT84UkF9tENzp7zvVRv2PZUFlqdCaWUiOUb03fKU
	 sNAccBq7pp6/sG345djAcnd+I9zrbTVyjEqYfchAdI3dcLFgUObdS+k23Cfwx7F/9QgPE
	 W1J31cOXIUGH06twIa1Ef2M/dXDUStWcKjd1jq77mP45IZQ6ezhE1osaScNlgQeHiFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2wMB0qh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB4060A260E;
	Wed, 18 Nov 2026 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2wMB0qh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226A61F000C6;
	Wed, 18 Nov 2026 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015521;
	bh=iXZ8O7mxs5pQodADdEyn8tKMaHgTYk2AxJNdR5OKeK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2wMB0qhMv07qZkF4GdYB0VqLMmwIettRaVP48iI3/UPzimgl5qNCjkyCdnBSGZ6C
	 JEzfB9mGlkVVI+MxReFJ89cz6WB+fAIjCCflkrr4NlxvRaZDF+pFMmyujmyUd8REA1
	 Wx9FtlWNa4KILY3h2B/S5rgXwENydIQq1hx90FjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0201/2651] PCI/pwrctrl: tc9563: Allow RESX reset assertion to sleep
Date: Wed, 18 Nov 2026 15:24:01 +0100
Message-ID: <20261118150255.100990431@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 028f86457e822ab9de5b0d6d23efddc1b8b54ae1 ]

The RESX GPIO may be provided by a sleeping GPIO controller, such as an I2C
or SPI I/O expander. Calling gpiod_set_value() for such a GPIO triggers the
following warning:

  WARNING: ... drivers/gpio/gpiolib.c:4030 at gpiod_set_value()

The TC9563 power-on and power-off callbacks already sleep while enabling or
disabling regulators and while waiting for oscillator stabilization.  Use
gpiod_set_value_cansleep() for RESX so it can be driven without triggering
the warning.

Fixes: 4c9c7be47310 ("PCI: pwrctrl: Add power control driver for TC9563")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260825-pci-pwrctl-tc9563-use-cansleep-for-resx-v1-1-0dbe7cfd8200@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c b/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
index fd53a7db9875d..1b7718d07d15d 100644
--- a/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
+++ b/drivers/pci/pwrctrl/pci-pwrctrl-tc9563.c
@@ -481,7 +481,7 @@ static int tc9563_pwrctrl_power_off(struct pci_pwrctrl *pwrctrl)
 	struct tc9563_pwrctrl *tc9563 = container_of(pwrctrl,
 					    struct tc9563_pwrctrl, pwrctrl);
 
-	gpiod_set_value(tc9563->reset_gpio, 1);
+	gpiod_set_value_cansleep(tc9563->reset_gpio, 1);
 
 	regulator_bulk_disable(ARRAY_SIZE(tc9563->supplies), tc9563->supplies);
 
@@ -501,7 +501,7 @@ static int tc9563_pwrctrl_power_on(struct pci_pwrctrl *pwrctrl)
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "cannot enable regulators\n");
 
-	gpiod_set_value(tc9563->reset_gpio, 0);
+	gpiod_set_value_cansleep(tc9563->reset_gpio, 0);
 
 	fsleep(TC9563_OSC_STAB_DELAY_US);
 
-- 
2.53.0



