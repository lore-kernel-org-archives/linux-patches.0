Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A341319924F;
	Thu,  5 Sep 2024 09:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529920; cv=none; b=YYzQtQY1vx4UEgTzgShaIFEUJqhfsXEHkTI1K+GHPSU+xElJz+GB+XpLT+wBQxeLP0GPv12uXi23dw6M94NM0EttUY4+KUC8aTGyTt8aUONS9hmHn4BeAfkTdDVj7rHJivZ7ybstWItNLNY0Y3CRIMGk+7BiLWbtF6+kDEkwqts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529920; c=relaxed/simple;
	bh=9mp4/VhyGcRTE023V6BU7HIcahVgsLbubyd56seoOuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCOhCeYwWPQ+Su0uEx1XrPF1i+GxIq221Ba8j74rctOoH1X1Bg9vprnYTSQoAzaypgkTGUt60RArbr8JYnLH8ryqOFmuQeGKuKz1W1AYfd6ppxdr0lYqqnRPHqlg+BLpNV+JkwetYX35KselBJPli8L/zpCA7OwzhBygbLBAx4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmQrIrLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmQrIrLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2998BC4CEC6;
	Thu,  5 Sep 2024 09:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529920;
	bh=9mp4/VhyGcRTE023V6BU7HIcahVgsLbubyd56seoOuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmQrIrLrTjt6vuGElgLlTClLIyg3rN2IwO7NSew1cbf8ox8MgleQO4LuYrAnTWIrV
	 fgJSbqu+uJuFZ2zYOaKyhldkUUJUA81gwQY/48SEJ+IT5gTKJ9N7qjqGi5mA/RtUfd
	 Of1hVmGx+ovc+kK6oMvFH5NCsOVRGotRBlOVg2+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 6.10 183/184] i2c: Use IS_REACHABLE() for substituting empty ACPI functions
Date: Thu,  5 Sep 2024 11:41:36 +0200
Message-ID: <20240905093739.472243237@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit 71833e79a42178d8a50b5081c98c78ace9325628 upstream.

Replace IS_ENABLED() with IS_REACHABLE() to substitute empty stubs for:
    i2c_acpi_get_i2c_resource()
    i2c_acpi_client_count()
    i2c_acpi_find_bus_speed()
    i2c_acpi_new_device_by_fwnode()
    i2c_adapter *i2c_acpi_find_adapter_by_handle()
    i2c_acpi_waive_d0_probe()

commit f17c06c6608a ("i2c: Fix conditional for substituting empty ACPI
functions") partially fixed this conditional to depend on CONFIG_I2C,
but used IS_ENABLED(), which is wrong since CONFIG_I2C is tristate.

CONFIG_ACPI is boolean but let's also change it to use IS_REACHABLE()
to future-proof it against becoming tristate.

Somehow despite testing various combinations of CONFIG_I2C and CONFIG_ACPI
we missed the combination CONFIG_I2C=m, CONFIG_ACPI=y.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f17c06c6608a ("i2c: Fix conditional for substituting empty ACPI functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408141333.gYnaitcV-lkp@intel.com/
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/i2c.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -1053,7 +1053,7 @@ static inline int of_i2c_get_board_info(
 struct acpi_resource;
 struct acpi_resource_i2c_serialbus;
 
-#if IS_ENABLED(CONFIG_ACPI) && IS_ENABLED(CONFIG_I2C)
+#if IS_REACHABLE(CONFIG_ACPI) && IS_REACHABLE(CONFIG_I2C)
 bool i2c_acpi_get_i2c_resource(struct acpi_resource *ares,
 			       struct acpi_resource_i2c_serialbus **i2c);
 int i2c_acpi_client_count(struct acpi_device *adev);


