Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC07223DE1;
	Mon, 23 Jun 2025 21:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715140; cv=none; b=OyHMywKXADJ8vdgL7ozrXzaKL+G093EiXpiNcmsWJJNbIMqisFuc/rI4H0Rpl/MzSSeC+jmhlkiZW3627QjwfWtUFjlrWMFgmAfS7AmPELb2RtN0UVsj0FK3vvjtqE1dUL52bsxv8ozM2WaHciUxDLuVrv4lyDJ+rpJ5232v2jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715140; c=relaxed/simple;
	bh=axdPMSmhPDtRkxOxUKleyiJfe0gSalpg7n/kJ4HfP5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAM657G/ialRIhQDSmwVle6XXbl69JmLN/g0BP7jxthCnpKaFrphQtDIBXKG2yVhY7Mwx6Fcq6aDr1P4b4i8sclz0YnOkUPeeLrLgld/JrNhPsdWdf8cETBkFcC4WMH6k5Flp0UYgns1AtizQh3SD2aB64Nk6v5QJ8xzOG0OTAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6TIrfF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6TIrfF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A505C4CEEA;
	Mon, 23 Jun 2025 21:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715139;
	bh=axdPMSmhPDtRkxOxUKleyiJfe0gSalpg7n/kJ4HfP5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6TIrfF89If6KyjEeL4XR6xvXMc0gV877J8YlENlXn2XVpwnPpo565aM4na8t35Sd
	 +divSDIgJ1cmsPboD46+daXdKkJZgCqpr6oNm2C/yKd/WmgFe+cYInKauj7o75PCa4
	 azk+zXAldSoHgx/SUWY2zC7w9gaufO1gfuXze94g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/414] ASoC: tegra210_ahub: Add check to of_device_get_match_data()
Date: Mon, 23 Jun 2025 15:05:22 +0200
Message-ID: <20250623130646.646634784@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 04cb269c204398763a620d426cbee43064854000 ]

In tegra_ahub_probe(), check the result of function
of_device_get_match_data(), return an error code in case it fails.

Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://patch.msgid.link/20250513123744.3041724-1-ruc_gongyuanjun@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_ahub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/tegra/tegra210_ahub.c b/sound/soc/tegra/tegra210_ahub.c
index 1920b996e9aad..51043e556b3e9 100644
--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -1359,6 +1359,8 @@ static int tegra_ahub_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ahub->soc_data = of_device_get_match_data(&pdev->dev);
+	if (!ahub->soc_data)
+		return -ENODEV;
 
 	platform_set_drvdata(pdev, ahub);
 
-- 
2.39.5



