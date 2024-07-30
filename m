Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B65C1FBA;
	Tue, 30 Jul 2024 17:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358895; cv=none; b=mLXKp56nnD7ZOGq8nzO/0sAxOis65+yncgkaUeoBgSk5OT78I8naVWuLS3OuF33+LQO9ale928WVB1lm+9DD3yoej5Z58NTyBR6xMJxVBGQ1h0vlbX2v/j0Ow0WyN6TlmdO904vZ1+XKQZ17mroXQvCJOdaoftkAloh7RAbrACo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358895; c=relaxed/simple;
	bh=vqSfzYhpPWoR0OBz4dHtmJsL/f6yxSavefuFcx5EM1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHG1WJB/xn4EBT1sahOuxuAPleCpcie0i4iK5Jc9pHrx0wvgBIcyKI5TJKg2HN0PTJOcV5yXYD7ukPQEEdYTScznOYfsFk1F2v8aanEM2iE3xJOCfHyZX82LnfhifpyDckVYyZCAjHaqFY9Q1PY1Y7+zFVP88k18quNuUT7qaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btWLi9kl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btWLi9kl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F6FC4AF0A;
	Tue, 30 Jul 2024 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358895;
	bh=vqSfzYhpPWoR0OBz4dHtmJsL/f6yxSavefuFcx5EM1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btWLi9klLyfanN5opby0ntx3S9RWhfiUvHJ/sOOKMZ8wNPgObSRhOV6IieZuIVaiJ
	 Dm+E9TAcGoTNq4hHP/XfDUcv7jJW/3O4Z1w4jxUay0F5In34HoOtB7DeuJUXm4n5xG
	 4AdxLv2Q8e41k07R7+7DB4wzcFrcvaiMj105mX9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Maxime Ripard <mripard@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 431/440] spi: spidev: add correct compatible for Rohm BH2228FV
Date: Tue, 30 Jul 2024 17:51:04 +0200
Message-ID: <20240730151632.611325680@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5241785266153..00612efc2277f 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -725,6 +725,7 @@ static const struct of_device_id spidev_dt_ids[] = {
 	{ .compatible = "lwn,bk4", .data = &spidev_of_check },
 	{ .compatible = "menlo,m53cpld", .data = &spidev_of_check },
 	{ .compatible = "micron,spi-authenta", .data = &spidev_of_check },
+	{ .compatible = "rohm,bh2228fv", .data = &spidev_of_check },
 	{ .compatible = "rohm,dh2228fv", .data = &spidev_of_check },
 	{ .compatible = "semtech,sx1301", .data = &spidev_of_check },
 	{ .compatible = "silabs,em3581", .data = &spidev_of_check },
-- 
2.43.0



