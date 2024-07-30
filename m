Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043BC1A76A5;
	Tue, 30 Jul 2024 17:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360729; cv=none; b=i7tIfsDb+EB4A4dIA2MucME9xb9mVB4K0s8/gwcD7lpb3+QBGFxh7xmelurfuuVJoxymJ8Hr1lkugxAk0FO69d2qMy55xoWWmZx2gBMHdNCltBELTg3KrAnGImjTnIJhjJoAgq62eAeJaD9XsytbJGXHnTDXHTacsCW0hzmXNio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360729; c=relaxed/simple;
	bh=1J7T12y/X5A8g5pOYaL5B5kXaEJKClGQw7R48KT7MDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4u93UFGHwtRxCQzDHUMRDc0OzYq6v6SzK+Z7hFoS+XrOVpDXkez5JxGPJ6/zYnn5tEBc8BcMrDAZ58ycmlL74q1FNf2Yp8PxX5+YUWMDfLUbHCXmBUgJAixa9PnyCj7nTQMtQfekLfpROTPOamDNiHfunnaBThd8Okvdax4RY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpyDbUiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpyDbUiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6595CC32782;
	Tue, 30 Jul 2024 17:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360728;
	bh=1J7T12y/X5A8g5pOYaL5B5kXaEJKClGQw7R48KT7MDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpyDbUiAekxn6HgeG9FHicZSzDWYiB0dxJGa6NKPbannrb+lzM2PnagMOGmLLL5uC
	 UUR6+qq1HXs0HzMq1wORSvxj0X4ckh+/fp+YR5PNRAaj9ijP/CWDRvTG7UP3DNuvcS
	 cpHHUgyz2BvhcnaaBKtMU334MEpQWkcRSr1MgF1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Maxime Ripard <mripard@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 788/809] spi: spidev: add correct compatible for Rohm BH2228FV
Date: Tue, 30 Jul 2024 17:51:04 +0200
Message-ID: <20240730151756.091105441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit fc28d1c1fe3b3e2fbc50834c8f73dda72f6af9fc ]

When Maxime originally added the BH2228FV to the spidev driver, he spelt
it incorrectly - the d should have been a b. Add the correctly spelt
compatible to the driver. Although the majority of users of this
compatible are abusers, there is at least one board that validly uses
the incorrect spelt compatible, so keep it in the driver to avoid
breaking the few real users it has.

Fixes: 8fad805bdc52 ("spi: spidev: Add Rohm DH2228FV DAC compatible string")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20240717-ventricle-strewn-a7678c509e85@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 95fb5f1c91c17..05e6d007f9a7f 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -734,6 +734,7 @@ static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
 	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
+	{ .compatible = "rohm,bh2228fv", .data = &spidev_of_check },
 	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
 	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
 	{ .compatible = "silabs,em3581", .data = &spidev_of_check },
-- 
2.43.0



