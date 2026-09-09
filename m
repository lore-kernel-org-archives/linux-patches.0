Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA23D59B688;
	Wed,  9 Sep 2026 14:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963807; cv=none; b=eFsMeeD9yntLO2oiYA+6nw/0yZwTVPQPtJgUxei0BP8DEUY7fU93ismQhjWN2dEWdtpz5uPfZhMmJ9YOM+vzJaCyYQ1rNd9lUctafXC+rG/8II0MHcI84P1MpfkEDA8jiimD1zwxKoJ0MnFNLlwhaWKD/Gj4Dn0tKZP+VwzItXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963807; c=relaxed/simple;
	bh=HCZbRMXntBaSSoqqHa68TVXQO0/sttRDk6qe0tk9A6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRMeLTPqasKiKQfDqN9HKGjJblXPg9tAGB6LlUelYxFeNf5JKt1zMR3GKq2NS2+t2mhYihVt0T74O5HQ/dlKWjKScAJ0YGaQubgRuovkf88xXkwDEL9VDpjW3Or4ua62CMJI3Edvr/TZgrd24do8p4pYPWvz36+VvVMDY/Xr4Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BL5/KBjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BL5/KBjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D683B1F00A3A;
	Wed,  9 Sep 2026 14:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963805;
	bh=rvKXXHO6lFLwhd4Xqt9ge7fGsWqMjAO1SKEfIZ/kvNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BL5/KBjd8cdW0Xvt/+XSHBiJkvJ1aQDlhHH5j4aGoZIGVfKn0VyxIP9x/pQhEHRXt
	 mVYoC4nJIWs3LX+WpypGL1Na/umB07g8qXARzOjwgvmXMu1G5vmyT43CyHgo9GOFW2
	 0hS0o92Gh8OPIZWPGCilyKv5Y+gqasQDo2WP0Heo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 204/583] iio: adc: max34408: add missing select REGMAP_I2C to Kconfig
Date: Wed,  9 Sep 2026 15:38:09 +0200
Message-ID: <20260909134245.214195849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1026,6 +1026,7 @@ config MAX1363
 config MAX34408
 	tristate "Maxim max34408/max344089 ADC driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say yes here to build support for Maxim max34408/max34409 current sense
 	  monitor with 8-bits ADC interface with overcurrent delay/threshold and


