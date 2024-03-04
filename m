Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC85F2C689;
	Mon,  4 Mar 2024 21:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587839; cv=none; b=MsuUUnZdk3ntZsQf8MBRa2FjlCHPjikpuaUlsflSWaJXT8PZm54D7uNvNFe2+Ux6vCWdwwhP1JuCF+gdC7YLvabs3tSL9uu5I0OcwHHMP3KTm2J0W5LEJWQAlKYry8DvDcXMzldYxIMbz1u9qGRtLWcwhjJHsJIC9FTmNc+ILG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587839; c=relaxed/simple;
	bh=zRUMo5C7fchhZFf1xO/PLjgNqp57B4x2r3EI3li0imM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTkkHGy81KXKhsbYViXNz6zLg1o0TnG+TYwvGlcFZUJ275Qn3KtRgLBy/2zMREp6sWFyTWcUwc6XMymSpNJZB1tq6tMu+JlKEzfjImhDvIXVFJpomLovyhNOg63mjoDWT0Fwv4ajt1890T9bGU5vWOGrjpIr5dggr1iXhubx2uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHNH5BqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHNH5BqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD18C433C7;
	Mon,  4 Mar 2024 21:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587839;
	bh=zRUMo5C7fchhZFf1xO/PLjgNqp57B4x2r3EI3li0imM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHNH5BqLxAdsORkyJ7621JJpOvMXB1wdZA+K92gJoAflqpjmRqCUuCc7veHoNq9W6
	 XhaXL+tGAshQb6ruPVXIBo1m71Wuk+AFEhN8wxITb/Z5SgdwrnKYCUIesKKKkNJm5O
	 Zt9quc/ThaYGfuCXu1eRlBcPbPaUKsFRjZaikEkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.7 109/162] power: supply: mm8013: select REGMAP_I2C
Date: Mon,  4 Mar 2024 21:22:54 +0000
Message-ID: <20240304211555.274413640@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 30d5297862410418bb8f8b4c0a87fa55c3063dd7 upstream.

The driver uses regmap APIs so it should make sure they are available.

Fixes: c75f4bf6800b ("power: supply: Introduce MM8013 fuel gauge driver")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240204-mm8013-regmap-v1-1-7cc6b619b7d3@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index f21cb05815ec..3e31375491d5 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -978,6 +978,7 @@ config CHARGER_QCOM_SMB2
 config FUEL_GAUGE_MM8013
 	tristate "Mitsumi MM8013 fuel gauge driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  Say Y here to enable the Mitsumi MM8013 fuel gauge driver.
 	  It enables the monitoring of many battery parameters, including
-- 
2.44.0



