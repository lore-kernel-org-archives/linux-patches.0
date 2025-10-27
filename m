Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5391BC4E;
	Mon, 27 Oct 2025 19:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592703; cv=none; b=Am3SVV0I19Se1uYUDJy2IU9hblcVirsDfokCgX1VdoeUwiNG0DMs68HuqiM6gHtkjhdhpIbY5jKHUKk9X7/HIvU1GfnoCJjhdrrBUiXOi0cIj5p/U9iOfxOxQeKHTsOwvZQY6kmWGvy/1DMpGHpoEPvBdUeCCti/L9/Bj/CdyvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592703; c=relaxed/simple;
	bh=buf0CwQ/yvwp1bjnipL2wH9NaL1Fgrf346NqbKjJBow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Za0DV9ou8+MIR8qrdGPZ32VEIA4oSM5ktViwEtKUZA0QnVaijmk8MbpvOWr4p/2yTufI00+9JXe52KPFUyT3F/AI32Il3x91jrpA9CCyhvGsbycutiNhHIVcu0dN55qaYoFR+/0yNgNOfXCUOKo81Lg0Rbe6ArGSzsnBjwOIKZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndvH0nQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndvH0nQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708A4C4CEF1;
	Mon, 27 Oct 2025 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592701;
	bh=buf0CwQ/yvwp1bjnipL2wH9NaL1Fgrf346NqbKjJBow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndvH0nQrkZ55FNBOLEukloC2DzrnwgGaAbt7EWG31umXc3LfWivFK3D1T6rZbTzM/
	 i4QG2UDNkdIqci8izOrQZk0KeNRhD11xosYzjhhJOwJJXNauKCiyPw9nQkkp/zA7LV
	 yQSQeF+YIllNHu8s4l0jFUsdxAoG5Dl4NnX+JP70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 34/84] gpio: pci-idio-16: Define maximum valid register address offset
Date: Mon, 27 Oct 2025 19:36:23 +0100
Message-ID: <20251027183439.729511669@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <wbg@kernel.org>

commit d37623132a6347b4ab9e2179eb3f2fa77863c364 upstream.

Attempting to load the pci-idio-16 module fails during regmap
initialization with a return error -EINVAL. This is a result of the
regmap cache failing initialization. Set the idio_16_regmap_config
max_register member to fix this failure.

Fixes: 73d8f3efc5c2 ("gpio: pci-idio-16: Migrate to the regmap API")
Reported-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Closes: https://lore.kernel.org/r/9b0375fd-235f-4ee1-a7fa-daca296ef6bf@nutanix.com
Suggested-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20251020-fix-gpio-idio-16-regmap-v2-2-ebeb50e93c33@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pci-idio-16.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-pci-idio-16.c b/drivers/gpio/gpio-pci-idio-16.c
index 476cea1b5ed7..9d28ca8e1d6f 100644
--- a/drivers/gpio/gpio-pci-idio-16.c
+++ b/drivers/gpio/gpio-pci-idio-16.c
@@ -41,6 +41,7 @@ static const struct regmap_config idio_16_regmap_config = {
 	.reg_stride = 1,
 	.val_bits = 8,
 	.io_port = true,
+	.max_register = 0x7,
 	.wr_table = &idio_16_wr_table,
 	.rd_table = &idio_16_rd_table,
 	.volatile_table = &idio_16_rd_table,
-- 
2.51.1



