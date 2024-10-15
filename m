Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7E71C07E0;
	Tue, 15 Oct 2024 13:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997468; cv=none; b=TA6AszaENp4saZgA2rDApYGsC2brDrqrVYCWJFgIN61sGoYtUsIDh7amgvMZIQT8J/eZMJU46FgiaNYcwvhx3c1UR5OtBbZKUb7MaqIgO7Om6903zAGdgK+zeXVJE+FB/t+MjBDJSPQ5KpGwhcJlUjzTsJtyYWe4uThzgJDXRPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997468; c=relaxed/simple;
	bh=61qZcjByTSP3cXYFqZ86BN6/kbk8NiLMsJ3V/6piwpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/ERW8Nm32uPldE3y6EQQQmYf0OQk+PGE1RmUQByH/9l8J0jH4jdxkf5PE2wcm7iiZvylUHkU9vymfpGuY17oduhDjSseXAhc2GTF1Umahx1FIU/k2YIGo48tmokgxtE1wsASRbqTbCJQ852drS8qEbkoSD+hhgI7PkXWRsfNrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRaa3FVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRaa3FVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7EAC4CEC6;
	Tue, 15 Oct 2024 13:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997468;
	bh=61qZcjByTSP3cXYFqZ86BN6/kbk8NiLMsJ3V/6piwpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRaa3FVIsVq6HM3CfOjdtW3gqMupJWj4cdrsVNyw0Jbfu7HR0jloyrtfhvYeyZtoz
	 7F58o6McE7kOpt1HiFwhClNpZAC9/meeNjroX5DjZ9EX4Hcr5E1w+WIfkT17jdSo76
	 3R97b0JXF2VbQANEx82oaj5FXuqyNaE1MQiBZ3Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/518] spi: lpspi: Silence error message upon deferred probe
Date: Tue, 15 Oct 2024 14:41:35 +0200
Message-ID: <20241015123924.355017977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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



