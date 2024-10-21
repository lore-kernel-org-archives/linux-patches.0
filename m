Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B211E47B4;
	Mon, 21 Oct 2024 10:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506734; cv=none; b=JAwEo/B3TbTk1qnkI0fWHmSsSbjEj5oHcCY0liThhQVPoos10KpGizDEhv9fitzo7yHs2eMEtlCMJo380+YMscawx57H5Lv1ubkDpc7zn/OLicO6QQDQOkeBdU+kE8NAKujbrAul3XNH67itH9cN506w/xcY72YFPELdsIbv+MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506734; c=relaxed/simple;
	bh=zt5jgZJZDdzevMJ7Yw9m7/dtO3NmHPAbvavXOJvgBnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR5Ll+6BUw/RgWloP8lw7f5257zVem0W40aa7NdJSLS9ZygUSZixBrqUfenZY9br65BksAUo+pGHk5omErWC9bYxVKVdanrADH77b9CFyy/1wVNvZh++doDq6msWnXJTgc1ohFi3NZcNasxiLryslFOdaxP/JvmwXLVJDl80wmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0s7dmEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0s7dmEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C195AC4CEC3;
	Mon, 21 Oct 2024 10:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506734;
	bh=zt5jgZJZDdzevMJ7Yw9m7/dtO3NmHPAbvavXOJvgBnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0s7dmEMcRojnjPQ4erO4dr+XXl0YWlC4U/p6dMf3H7HXGmCTbgtBXB23VZeVubXu
	 40P7cbYPDoDMayvM3CTTVEWjNDUA4JtKaMQxR/lqvdSP5NK/WL0sLbeRJjU9rUAa6g
	 mYHsGTsEvMKq6lgAfMEuPyBgxUy3SIa5gJLGn6Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 072/135] iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig
Date: Mon, 21 Oct 2024 12:23:48 +0200
Message-ID: <20241021102302.147903346@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -474,6 +474,7 @@ config STM32_DAC
 
 config STM32_DAC_CORE
 	tristate
+	select REGMAP_MMIO
 
 config TI_DAC082S085
 	tristate "Texas Instruments 8/10/12-bit 2/4-channel DAC driver"


