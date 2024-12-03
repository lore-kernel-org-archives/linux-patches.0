Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D61C1F890E;
	Tue,  3 Dec 2024 16:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242285; cv=none; b=npzKYQrbfUGtQTAAPPQbqJj/Fjc3kYcZXAqinLKUy+iE9nwkCPolH44bMajEXUqm4+A09MaFIUnCrXk14wv3RR1eDktageOv2ICmrcldZlPchPkU2hxaLHlxPMqFnseJleQAMNrFg0N6Li4qJrVufvKcYIZpokpMNZL8g6yjBa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242285; c=relaxed/simple;
	bh=YSOeYXS0WAb1vmOUZyjCJMyjRuan8mOtJpfWC/vAlzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL1mjVGZuJd/4vOb9CYc7xBL6fFKWyPl0SeKmVAHj0ISfwkqH2R0+XXlVlVEhMB17l6zbIJJ7UmlOm/UnZUfzuW8k6RUFDaG6ymEshPvuiVUHPmuRiU9Ie9Rt0lQbpbuNPXNYk2xJ462gaPKl+If85+kavk79t4YYaUYoOiz4os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HorPaeVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HorPaeVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5DBC4CECF;
	Tue,  3 Dec 2024 16:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242285;
	bh=YSOeYXS0WAb1vmOUZyjCJMyjRuan8mOtJpfWC/vAlzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HorPaeVSf1eWyoTUiOcJDVH4rETQIsFW8c1EQgZa78hrEjfjmZ8WZRCJG6CfjyY00
	 vfZ9WSspELLFgTyKFIHi858Ysklh2Zv6ynO0tVULH3bWgWvCwagANmgpmn8kAX+zvr
	 VP2q0EiU/21I/MVIHTD6Fzl362g37Vtxn3bbTu04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 662/826] iio: dac: adi-axi-dac: fix wrong register bitfield
Date: Tue,  3 Dec 2024 15:46:29 +0100
Message-ID: <20241203144809.579068475@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

commit 70602f529e4d76798c95aeed5ce2a8d36263abe5 upstream.

Fix ADI_DAC_R1_MODE of AXI_DAC_REG_CNTRL_2.

Both generic DAC and ad3552r DAC IPs docs are reporting
bit 5 for it.

Link: https://wiki.analog.com/resources/fpga/docs/axi_dac_ip
Fixes: 4e3949a192e4 ("iio: dac: add support for AXI DAC IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20241008-wip-bl-ad3552r-axi-v0-iio-testing-v5-1-3d410944a63d@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/adi-axi-dac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/adi-axi-dac.c
+++ b/drivers/iio/dac/adi-axi-dac.c
@@ -46,7 +46,7 @@
 #define AXI_DAC_REG_CNTRL_1		0x0044
 #define   AXI_DAC_SYNC			BIT(0)
 #define AXI_DAC_REG_CNTRL_2		0x0048
-#define	  ADI_DAC_R1_MODE		BIT(4)
+#define	  ADI_DAC_R1_MODE		BIT(5)
 #define AXI_DAC_DRP_STATUS		0x0074
 #define   AXI_DAC_DRP_LOCKED		BIT(17)
 /* DAC Channel controls */


