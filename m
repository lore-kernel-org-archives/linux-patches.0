Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A0A1CFEA9;
	Tue, 15 Oct 2024 11:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992967; cv=none; b=rA1/b5VV8RnDPwgUvGP/qh3EO9cwoSIRQafRUgxNxn3NbP2k+khLN/YjgZXHvibuhdp7/dREiH+eYmFaEPnh6exDFXPqjgO5tG1PELKft2nGh+wHxlk6C9884NZpYl8Kc9Mw5ot5dVSdmP81hGPWjCfvpQePdHn59cL5lDez0oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992967; c=relaxed/simple;
	bh=BlxF1XJN4FHTUM+9ZzzPWObZmplIGGZEJC4CIFRBMOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK45gNhtjsaQVGbnh9yNlQSjyydq5suQSaUKp8vYk5OsETYVd95v8wSnx/ttBxUqtAYaZGGZUGp6Ryl1escovGIcW9AsEbmO+57Kg9V7l+q8eINTev0571uZ36+v2oCqEnUw2Ne4T04NlbiVumM9p0w66ynj86niCbRZqtUCvZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REN1tiSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REN1tiSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B2EC4CEC6;
	Tue, 15 Oct 2024 11:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992966;
	bh=BlxF1XJN4FHTUM+9ZzzPWObZmplIGGZEJC4CIFRBMOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REN1tiSrIxKl7PWB+BugmwKkRVgu47A6mpSA7g9MoGo1l4l8mgwqROkObWh8B8SnS
	 lXYDgMGnq5uWwioqVDi4G5RPpiw6T8A9UsThxG/PFtHrdNvI6t7XHeVjCKoJqjQOaL
	 OyYoH3zpoeOcU4xlbKOPJ4i56lbNqvtUDSMBCrMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/691] spi: lpspi: Silence error message upon deferred probe
Date: Tue, 15 Oct 2024 13:23:39 +0200
Message-ID: <20241015112451.103116915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 12f62a857c83b2efcbf8d9961aacd352bf81ad3d ]

Do not print error messages with error code -517. Silences the following
errors upon on imx8qm:
fsl_lpspi 5a000000.spi: spi_register_controller error: -517
fsl_lpspi 5a010000.spi: spi_register_controller error: -517
fsl_lpspi 5a020000.spi: spi_register_controller error: -517

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20211108145523.1797609-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3b577de206d5 ("spi: spi-fsl-lpspi: Undo runtime PM changes at driver exit time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index c21d7959dcd23..bc3e434ba2986 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -919,7 +919,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 
 	ret = devm_spi_register_controller(&pdev->dev, controller);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "spi_register_controller error.\n");
+		dev_err_probe(&pdev->dev, ret, "spi_register_controller error: %i\n", ret);
 		goto out_pm_get;
 	}
 
-- 
2.43.0



