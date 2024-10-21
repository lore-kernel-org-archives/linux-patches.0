Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4571E47B8;
	Mon, 21 Oct 2024 10:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507894; cv=none; b=D4es57tm8sWz7jz1gwBWQMqnKSICqRGRKa25faWVxU+ZjwY0TKqVCWwMoK7k8Xsv0GMkMCBv/QbdZymKwDaWrRykMsl7YYsOzOoUyfnnrjsjANhSlBkzcmBR3VYBk9j97u4aN5EMWpHdi6mKNw9SUgTfQccrcPNCiIP+OhljGD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507894; c=relaxed/simple;
	bh=Bbg6Yi6oNdPxZlc7Mq1iz1CMqd0WsZjIlvug5WKqLtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=St05OzyrWl3jB/Qnp8CJGN1DC/1eIp8ei7kU8VFuQYdpHdBdlc5OOJAb4wk/v2fygPDqhx6qMuyLFrmL3USQ/A9Q+IdhyEtS6IP0CvXP/AuGoeFP4gVGoxihGC2eVok5yLEvi7RvxlvWaCePrD4Ma0FDgMOo/pYiJj8/jFcitKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StYBplij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StYBplij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83269C4CEC3;
	Mon, 21 Oct 2024 10:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507893;
	bh=Bbg6Yi6oNdPxZlc7Mq1iz1CMqd0WsZjIlvug5WKqLtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StYBplijPaadNyITEsWvRPOb6K0FtuQOZMSQ4k2Sdq2JNEa6Mgfvs4Eib7uvrr5Od
	 zLU2ANt/peoHNaC5bhhkc0tBU0+eO1i6PY4rNkot4MWe/KTHFXchkHHruBAtuKBu5Y
	 9UZnGlNeB6P3BfdHriFdD3psCcnatzGU3C4hP/Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 28/52] iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig
Date: Mon, 21 Oct 2024 12:25:49 +0200
Message-ID: <20241021102242.727640585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 27b6aa68a68105086aef9f0cb541cd688e5edea8 upstream.

This driver makes use of regmap_mmio, but does not select the required
module.
Add the missing 'select REGMAP_MMIO'.

Fixes: 4d4b30526eb8 ("iio: dac: add support for stm32 DAC")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241003-ad2s1210-select-v1-8-4019453f8c33@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/dac/Kconfig
+++ b/drivers/iio/dac/Kconfig
@@ -359,6 +359,7 @@ config STM32_DAC
 
 config STM32_DAC_CORE
 	tristate
+	select REGMAP_MMIO
 
 config TI_DAC082S085
 	tristate "Texas Instruments 8/10/12-bit 2/4-channel DAC driver"


