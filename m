Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BED195FEC;
	Mon, 21 Oct 2024 10:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507639; cv=none; b=qaeDBaBL6PZEHQPo0YeQu0rYzdLwUX80Afr7ceyZ4r+HNbRWIiUmo6lLczRxdleZuGggqYwLrXqkc+hjwqHHG2uk69UBdwgCgnEpZE36L/cMEhpEW+orqVq2Vi49AlKHxzkacy7rFmtPST1anJdT0qA6nXNMH0uL1vT4ysH/qTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507639; c=relaxed/simple;
	bh=F3KDtz+TOLOmMmOym6z0ySrAt3XjtDd6vd4lNs4fmg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBDn7chWw/+2lH7qHBTHCxPiYPureOYjCke6AO5WdIcYAu6kyW8v5cp5eGqfATvZHAd6lLzVwYpZPlaQyc262YPx1znzBJNJPRR5UQeEKQjRqPpUHmr6Qy5PFtfcm2k7FxrHqefKh8Y1nqRwNlpMKaD3V6kdd6Z+J+NMCUBqPyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTiWHC49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTiWHC49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C09C4CEC3;
	Mon, 21 Oct 2024 10:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507639;
	bh=F3KDtz+TOLOmMmOym6z0ySrAt3XjtDd6vd4lNs4fmg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTiWHC492TfZ9H8ONhNaWhR0DPbb/Cxnlv4JkKRGpxX5KCNqvYoHIn6Eu3MebMMRU
	 n2FRQDatCNjQNQ9LhlvwhSy4sEyh3YMsJbCfsyj+6ltdf7cEo9OI7bfyrl93vEpTGC
	 Kr+8c/kCyHujP4WM4lzB8lw2rd96UzhAWpYvkwW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 53/82] iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig
Date: Mon, 21 Oct 2024 12:25:34 +0200
Message-ID: <20241021102249.332172967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,6 +371,7 @@ config STM32_DAC
 
 config STM32_DAC_CORE
 	tristate
+	select REGMAP_MMIO
 
 config TI_DAC082S085
 	tristate "Texas Instruments 8/10/12-bit 2/4-channel DAC driver"


