Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8D21DED60;
	Tue,  8 Oct 2024 12:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392251; cv=none; b=ckadxj0dekCKrhpoO8gJpccErg/OfczPxYt6OM39FgrLaQDxlABC2rB/tLFWUDpG9w8uOkg0vygPMl5PcA6GfagZ25Q+qsEZ4XtI03yiY+jjoh9qauFXNj/GSeIPGE2ghUQnoZYUlI9RxVCjkqsAQ/7aThmbrCX0O3ZP9zBVyjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392251; c=relaxed/simple;
	bh=PEQWUyKnNFQQc53ArWv9UPRQQNDsDYktXq+LB7Tm/94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXCpzgwrW2XVwwyZW99Lk9Mz1FoGziphAQxbMxqBZQxyuprSF+JSXjpL31imOuNtqhUPodXEF12EVETW9DdyetN0ScHHcnXdUhqULbMz2uiQUMPxiWNc6fLILTduD2G0c5RemUYtD/R5AGv0aDR6CrE0/d1O55TebdnM4fi/kME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd2+zBQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd2+zBQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E156DC4CEC7;
	Tue,  8 Oct 2024 12:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392251;
	bh=PEQWUyKnNFQQc53ArWv9UPRQQNDsDYktXq+LB7Tm/94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zd2+zBQ22axkAlul5gPIhJwXapDmM2HVMMk6MKTvhxqAybQ21cpvIepvN22+IZA0n
	 JpsxYJklnBpwdDhbuvo8xspIWFEOWmH5G8AapyCEePl19Q3Q9sYo/AfvvdAWMrgwu3
	 rzwupcvYAaV7BqkGaIrVduuV9EHcr+7BeatoAF9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.11 360/558] memory: tegra186-emc: drop unused to_tegra186_emc()
Date: Tue,  8 Oct 2024 14:06:30 +0200
Message-ID: <20241008115716.466007968@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 67dd9e861add38755a7c5d29e25dd0f6cb4116ab upstream.

to_tegra186_emc() is not used, W=1 builds:

  tegra186-emc.c:38:36: error: unused function 'to_tegra186_emc' [-Werror,-Wunused-function]

Fixes: 9a38cb27668e ("memory: tegra: Add interconnect support for DRAM scaling in Tegra234")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240812123055.124123-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/tegra/tegra186-emc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/memory/tegra/tegra186-emc.c
+++ b/drivers/memory/tegra/tegra186-emc.c
@@ -35,11 +35,6 @@ struct tegra186_emc {
 	struct icc_provider provider;
 };
 
-static inline struct tegra186_emc *to_tegra186_emc(struct icc_provider *provider)
-{
-	return container_of(provider, struct tegra186_emc, provider);
-}
-
 /*
  * debugfs interface
  *


