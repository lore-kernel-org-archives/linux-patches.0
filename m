Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586091E86C;
	Mon,  1 Apr 2024 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989571; cv=none; b=pLhI8HRgaw1KE/d+uk7jk8wbRq9gTCK8BXjNDb6HycvrgFA9QD/bwZZT9u8bPqH6RzmupRaxaWJhYBgD5HV7VSWna8RKXYlN//nzWgmy+VfuInESlYpciieXt1gx2DzALyRfSZu1v48Kb6fZqEvRgzo0Mc/EAi1uYSfMVbDNz3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989571; c=relaxed/simple;
	bh=/NIhdgEzIfpuHCFm8tiw/y6Yv7bwNdpHv0nC9L04/A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQt3MlNjWwfItusD/XLWEeIRZQKRFTmQeT3tZ+nESHdGPj21pBcdwunCgR9dt3DlfYtMn7b+vjEJ0JefwBcIPBWUXui2XtnqaHjd0QAw32pqMCMPos8TgDOP2dJfbw1Ge9AfRx4Pfd0hEl3o8hYWJaRa+5mcUedVBzmPM+Lp1W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fwmjj4/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fwmjj4/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98E3C433F1;
	Mon,  1 Apr 2024 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989571;
	bh=/NIhdgEzIfpuHCFm8tiw/y6Yv7bwNdpHv0nC9L04/A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fwmjj4/l2XwKkNnq+noWtudh/eXjLa6Gyw/deMn4Y3Uow7YERFQQXRFffi9IxNJiF
	 04GOhcHCd4iqnhAlM7TQkkfktQNazRIUbn++3csHBuu2k0zhilYQQGSib/vbowzg3o
	 6jJG4YiMI0YsYd2LPrpfk6+zMNWT91jbdV83chus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/396] iio: adc: rockchip_saradc: fix bitmask for channels on SARADCv2
Date: Mon,  1 Apr 2024 17:41:49 +0200
Message-ID: <20240401152549.713807181@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit b0a4546df24a4f8c59b2d05ae141bd70ceccc386 ]

The SARADCv2 on RK3588 (the only SoC currently supported that has an
SARADCv2) selects the channel through the channel_sel bitfield which is
the 4 lowest bits, therefore the mask should be GENMASK(3, 0) and not
GENMASK(15, 0).

Fixes: 757953f8ec69 ("iio: adc: rockchip_saradc: Add support for RK3588")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20240223-saradcv2-chan-mask-v1-1-84b06a0f623a@theobroma-systems.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/rockchip_saradc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/rockchip_saradc.c b/drivers/iio/adc/rockchip_saradc.c
index dd94667a623bd..2da8d6f3241a1 100644
--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -52,7 +52,7 @@
 #define SARADC2_START			BIT(4)
 #define SARADC2_SINGLE_MODE		BIT(5)
 
-#define SARADC2_CONV_CHANNELS GENMASK(15, 0)
+#define SARADC2_CONV_CHANNELS GENMASK(3, 0)
 
 struct rockchip_saradc;
 
-- 
2.43.0



