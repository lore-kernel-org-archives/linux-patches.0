Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABB21DF738;
	Wed,  6 Nov 2024 13:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898825; cv=none; b=RrJ0DAGWZJ2EBMsx9tXdhfTTWLuxMebp5ujAQVya3WIUlpBi7tXnZl4XdKcJwfhuIRbyD68vrVy3VcWWq3o+uE2zvIQe3zrmmj1scTksa5a/FsiOObVs5K/QxgQo183bQgrjaSttMZwcsWcRDwccSb+6QsIbvKu7EJiO2syl0aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898825; c=relaxed/simple;
	bh=mzjM6ncQfLAXermoQ49XUrH2CKgoAneot0c3eHJkTr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSwS19v625ABVQ9DjqSXRox5437OMu/FBaxxUJK0kdRKgjpEoxAFNCR2TDi8FG6gAw0og5ylT9j6v6Nnu2ApGVEQsT7jq2EfWEWWpQV4Mtlu9dspvIGiU1ed15Qr21HNH4ONUjsSE9bTQlSYD/HqAK1fE8qtvtmQyiHEo4LVpBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOdyvTMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOdyvTMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57E1C4CECD;
	Wed,  6 Nov 2024 13:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898825;
	bh=mzjM6ncQfLAXermoQ49XUrH2CKgoAneot0c3eHJkTr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOdyvTMBS1p6/f39hVKviC1szm7xJrKZ1Mtl5WsJfB5pmY/5TPY+Zo4AN04oJZL9z
	 vG2jxIqg4NGfG3g7i4TMsBYQ+dxERTQ8sCxDSW0SH4mZF1d9TCQ5dchQ4d1nekcyWs
	 s1GJFoxnHHWzW4JNtdkRJK4+ir35V+t3Ee6x8+X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 368/462] iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig
Date: Wed,  6 Nov 2024 13:04:21 +0100
Message-ID: <20241106120340.618638442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -347,6 +347,7 @@ config STM32_DAC
 
 config STM32_DAC_CORE
 	tristate
+	select REGMAP_MMIO
 
 config TI_DAC082S085
 	tristate "Texas Instruments 8/10/12-bit 2/4-channel DAC driver"


