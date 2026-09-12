Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381AA37F313;
	Sat, 12 Sep 2026 11:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213511; cv=none; b=XXKnJ99as9JR7rRjiKpUr51EWWiKvQrQpJ+GV0zYm21m9M83GwFGmytLJMAVlMJ6NsVyGPQeH31fjbLxyVOVYhu0BceAOkQJQLoKDnvn0qzMNm6lu/1l0X0SUzny+xKl/vmWJVanLeBA0yAQmap86Fehd8YPW2foc7glccg3zxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213511; c=relaxed/simple;
	bh=PIH2/AfyT+tzO7QIdYibmNcFBadbPTdjonVQXnINRF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8tDkJWedPuEMpalxpZOHTIEAEg/Xp8c3LAuek+VbWGsuCdJ5EBoQ4/2HRgeEMr3BelhHAkgTEnHOt1wDo145SBHokqI5hzqds1fBM2FWRrKvv+XjnrPQYIdPy4metTMLIwDMQNDbzkKpeRuZoFQB+Fcscnep3WFXse9gD6NUs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gp96XAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gp96XAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E471F000FF;
	Sat, 12 Sep 2026 11:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213507;
	bh=ki3hkOZvdOEdVgvNFq7aFiur/NLeO124H2nnWFoyXj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Gp96XAVV9hYMol0cdNQuS2n54ICLqOfI7DbqXJJNx+Tmd14XJE24KJ0NUrxctAXT
	 phEFCe26fT9UovjsqKqRtuDwSCIbechj/bDMhFDZ0uXTvHFXBRlaoZqzYVw04afK37
	 ducUVyHO2uVF82SxN+ieNo70GM/FgwJYdiVdvEcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0134/1376] iio: adc: max34408: add missing select REGMAP_I2C to Kconfig
Date: Sat, 12 Sep 2026 08:42:40 +0200
Message-ID: <20260912065610.541108164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit 947f1079074a260ba200419d5cba6b8549d5ac0c upstream.

The Kconfig entry for the MAX34408 is missing a 'select REGMAP_I2C',
causing build failures.

Fixes: cf27775838c5 ("iio: adc: Add driver support for MAX34408/9")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -841,6 +841,7 @@ config MAX1363
 config MAX34408
 	tristate "Maxim max34408/max344089 ADC driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say yes here to build support for Maxim max34408/max34409 current sense
 	  monitor with 8-bits ADC interface with overcurrent delay/threshold and


