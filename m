Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4227262A;
	Tue, 11 Nov 2025 01:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823033; cv=none; b=J8HsIQBlEm88+JQq+5XUIENgY+1rkjupuCadxxWwShaC/Ludf7gN2HUcj61/yPKqpSkUPP50DLJIsVyo3To3NkYEbcfl+2l8sjW+dFcNMmCL+K1iupaERqSHGl+QlLKaVUyG7L9+eYrlaXLWoQBx6vHjX59l6tg9SQSkFzrsVDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823033; c=relaxed/simple;
	bh=OavhtcT7UlMg1hmqp5ZxI2nTAr/iBBYP4xYMQD2paUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KA1XBazPwWrEdeigpYBjmW2s+hZbNbTZXWqBMrDwaeA+cVELFnz1oz1wptbWxSUEHEZ+3cx0zmxzOe2YuN+iXW4zutoh304hgaZMRzHcZq8CcxQcJ/hkIbw1frfACrsImtQpLG5TPnNo/MYMiTMvJAPSqGrr4VB4LNAzfjxNFx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Is6NUQ+x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Is6NUQ+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C10C4CEF5;
	Tue, 11 Nov 2025 01:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823032;
	bh=OavhtcT7UlMg1hmqp5ZxI2nTAr/iBBYP4xYMQD2paUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Is6NUQ+x+dqbtzBoXiJ1PVpwcetSryIpnpc1bO2+C5fpeRrj8KdJTIacqNBqEoif6
	 N6zU6Ha3eRp7Lm0Px33cLjqeh4QFfHxSoiGY+57cW1qcdQf6zq29FiyvmRhDA54dX9
	 8vkIoWiqQXnSXYrLaVZOBvSldZuz9fHG5ze7QkfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 218/849] mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA
Date: Tue, 11 Nov 2025 09:36:28 +0900
Message-ID: <20251111004541.710167645@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 81a2c31257411296862487aaade98b7d9e25dc72 ]

The QIXIS FPGA found on Layerscape boards such as LX2160AQDS, LS1028AQDS
etc deals with power-on-reset timing, muxing etc. Use the simple-mfd-i2c
as its core driver by adding its compatible string (already found in
some dt files). By using the simple-mfd-i2c driver, any child device
will have access to the i2c regmap created by it.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250707153120.1371719-1-ioana.ciornei@nxp.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/simple-mfd-i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 22159913bea03..f7798bd922224 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -99,6 +99,8 @@ static const struct of_device_id simple_mfd_i2c_of_match[] = {
 	{ .compatible = "maxim,max5970", .data = &maxim_max5970},
 	{ .compatible = "maxim,max5978", .data = &maxim_max5970},
 	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
+	{ .compatible = "fsl,lx2160aqds-fpga" },
+	{ .compatible = "fsl,ls1028aqds-fpga" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, simple_mfd_i2c_of_match);
-- 
2.51.0



