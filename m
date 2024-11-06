Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE9F1DF26B;
	Wed,  6 Nov 2024 12:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895624; cv=none; b=CmWX0nquScbO+pSeH2rlT3BFHR8YfTBU8fIG0uq3GlTEWZ0VJ69liL03KXKgC8eC+QjQmwmdgKjkOZx1fiJcnFVHaFeoYGDTFdMXlydGsE5qHjIcqTqXnIiUp7eDdzfawXlHZOZ3PxFB0hg+EBxpvItVmyfNL64bLa5BJ3/nDNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895624; c=relaxed/simple;
	bh=uNgoudwHQ5cakiMOGIvFqvaOIX7UEsbLPw9xG3HDhCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXhQ+AjdSx7vFAqVdLjvmoeLz8kVzQ+Z0QESh9/7ncA1xTFW/WjjRPjMnC+S8acoOULlST8QLTkoAhJ2EzfkLQhBgR/pTdaWoOHqlAByLyJAZDBCyLknAGTOKBCsSdck8kZ57b74BFezvHdv+ITcMj0TD00KQWLuNRnvk74iIO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAFtHFmo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAFtHFmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646AFC4CECD;
	Wed,  6 Nov 2024 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895623;
	bh=uNgoudwHQ5cakiMOGIvFqvaOIX7UEsbLPw9xG3HDhCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAFtHFmosAkapEQFEht4f2G79j/EIZslh9TXT2K5+hW+ZbDrC/eePRYfLC56T1dCP
	 ekvXNzw7QWzCg2UBJN1CRV62ckiZZjY4JZtPHwcXCDG5zKShoJehUmXmlEHEDV5bWV
	 qpeOen/Pvyi4s5naGOGEfF8ZoyhaifxML6Kn6Ryg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 279/350] iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig
Date: Wed,  6 Nov 2024 13:03:27 +0100
Message-ID: <20241106120327.753474825@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,6 +335,7 @@ config STM32_DAC
 
 config STM32_DAC_CORE
 	tristate
+	select REGMAP_MMIO
 
 config TI_DAC082S085
 	tristate "Texas Instruments 8/10/12-bit 2/4-channel DAC driver"


