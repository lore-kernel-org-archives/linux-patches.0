Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0C0264FA8;
	Thu, 17 Apr 2025 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914116; cv=none; b=E/4DqvSj5e1ZKPTV6WZBUxeltrMnOWqts9DeGBnz4lg6eaQPMCVTFhZpxKslQnoBsP3sLtIkG8dI7O2ARdB6dT8zDTjWhprajzojf0Wc96tKqnZgzPDYOPim6KjQ2G/N911yXz7F3AHVuIwdA6zW9QAe1ikj8/2jtP/HFvdAHCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914116; c=relaxed/simple;
	bh=eYq8PhevX6Kl1qE3Z7ZsE8L9L5YaQj+ecQ17Nr5zt/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7nEXuJWdxAHgfkA3xIoDMh36NZaizH/diJiiSXvUW1HvxtQJdXBnawjZdSDjNuDeTtNFWyUQOdluNHdXYWYtXG+Uj3fAw/E6xMLTU6D75YgdXBUvkIzzxCjaA/HqVi4S8YOIwEzmGEMFGXXGRqnDcqlrN2dr26xKWnNNTvEAys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM8czYkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM8czYkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FB1C4CEE7;
	Thu, 17 Apr 2025 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914116;
	bh=eYq8PhevX6Kl1qE3Z7ZsE8L9L5YaQj+ecQ17Nr5zt/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QM8czYkZKZ5PhlTsX9XhxCFHfKSTWduBKJjQ+Us2cvxFOHydcDgSljAmS25RRzZ97
	 ayAG1NLAd+/56WN3hu76Dr7ohhA5y4Zd4/JnmMWl2bXNgI0RnP5HRenHdWbf33tSWL
	 W2Fi4ham6/ZwcPoSCcLkrVD2SgenCnv1+yrRH4+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 082/414] platform/x86: x86-android-tablets: Add select POWER_SUPPLY to Kconfig
Date: Thu, 17 Apr 2025 19:47:20 +0200
Message-ID: <20250417175114.742919510@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2c30357e755b087217c7643fda2b8aea6d6deda4 ]

Commit c78dd25138d1 ("platform/x86: x86-android-tablets: Add Vexia EDU
ATLA 10 EC battery driver"), adds power_supply class registering to
the x86-android-tablets code.

Add "select POWER_SUPPLY" to the Kconfig entry to avoid these errors:

ERROR: modpost: "power_supply_get_drvdata" [drivers/platform/x86/x86-android-tablets/vexia_atla10_ec.ko] undefined!
ERROR: modpost: "power_supply_changed" [drivers/platform/x86/x86-android-tablets/vexia_atla10_ec.ko] undefined!
ERROR: modpost: "devm_power_supply_register" [drivers/platform/x86/x86-android-tablets/vexia_atla10_ec.ko] undefined!

When POWER_SUPPLY support is not enabled.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503231159.ga9eWMVO-lkp@intel.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250324125052.374369-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/x86-android-tablets/Kconfig b/drivers/platform/x86/x86-android-tablets/Kconfig
index a67bddc430075..193da15ee01ca 100644
--- a/drivers/platform/x86/x86-android-tablets/Kconfig
+++ b/drivers/platform/x86/x86-android-tablets/Kconfig
@@ -10,6 +10,7 @@ config X86_ANDROID_TABLETS
 	depends on ACPI && EFI && PCI
 	select NEW_LEDS
 	select LEDS_CLASS
+	select POWER_SUPPLY
 	help
 	  X86 tablets which ship with Android as (part of) the factory image
 	  typically have various problems with their DSDTs. The factory kernels
-- 
2.39.5



