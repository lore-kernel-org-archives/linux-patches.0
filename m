Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D879E1DA4D;
	Tue, 16 Jul 2024 15:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144815; cv=none; b=FyZpnLrYmDuNoyUW3nKfcdJInB+FLr1GYUY4RQ6pQU2zXLIpycqYxvNd9Eh50j3XsmU3lE56Mfqt2PBhXJaHAG7aDcCfxaP0iqGbvgbNvSQPvvNX61WWnpRSllKgBvl7hpdBPkPIeGcID9q27JN1vOewzi7NMbLq068w2uiw31w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144815; c=relaxed/simple;
	bh=RfGGBb/FfRi0KYWoEziHF09famHM2M5jzkznIsHNzM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcZlyOiV6ztQ2UM0i4wRrF8vgzm0qjcdoNNpGlT/VJmUb2Q4L9/RM4LJwJa7wORzc62UcmTiPeuelrZRmMm/5VZSGpZBExwLyFDOb6H//HQapE+U0nwZr0cq5ERblErXTq+DeAWpPWzUJm0UXxrpKbNn3wrbseC2a3uEL05USi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfH4PMEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfH4PMEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E54DC4AF11;
	Tue, 16 Jul 2024 15:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144815;
	bh=RfGGBb/FfRi0KYWoEziHF09famHM2M5jzkznIsHNzM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfH4PMEboA3s+srIthKvtIAUcv9grtNgBDMt/bLHpSQA/f8yKou+6I7IB7EOgXC/1
	 wU05rdqQsOLFV/eEvJ5Xmp9HttgGod3X1XwyDU67YTQbTIJv/ulgtA1F7rZTj6lxND
	 P5SCKEVB2HxozeKHFvY5WwxeI6BOBMCSn9EEoX4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/108] i2c: rcar: Add R-Car Gen4 support
Date: Tue, 16 Jul 2024 17:31:58 +0200
Message-ID: <20240716152749.951070578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ea01b71b07993d5c518496692f476a3c6b5d9786 ]

Add support for the I2C Bus Interface on R-Car Gen4 SoCs (e.g. R-Car
S4-8) by matching on a family-specific compatible value.

While I2C on R-Car Gen4 does support some extra features (Slave Clock
Stretch Select), for now it is treated the same as I2C on R-Car Gen3.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
[wsa: removed incorrect "FM+" from commit message]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: ea5ea84c9d35 ("i2c: rcar: ensure Gen3+ reset does not disturb local targets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 029d999708261..720c3fd757ef2 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -950,6 +950,7 @@ static const struct of_device_id rcar_i2c_dt_ids[] = {
 	{ .compatible = "renesas,rcar-gen1-i2c", .data = (void *)I2C_RCAR_GEN1 },
 	{ .compatible = "renesas,rcar-gen2-i2c", .data = (void *)I2C_RCAR_GEN2 },
 	{ .compatible = "renesas,rcar-gen3-i2c", .data = (void *)I2C_RCAR_GEN3 },
+	{ .compatible = "renesas,rcar-gen4-i2c", .data = (void *)I2C_RCAR_GEN3 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, rcar_i2c_dt_ids);
-- 
2.43.0



