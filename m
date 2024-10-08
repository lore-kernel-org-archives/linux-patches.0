Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24E81DE4CD;
	Tue,  8 Oct 2024 13:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393652; cv=none; b=ZvMKj+SmjYNmkkHzQd1pMw6rpKp4LwShkXzPOVHCuxQ34ye5podTULfb+eLi3eXn2rZIFHDjp/4GY9qk0NegUkapM9MwqXi4UVq7xiEVcfVEPtpixM6Ts+ZDbitr3hgc28nAUoT3SqyE15KspLf5nLmgn3qLG2lnD7lSlnSIHkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393652; c=relaxed/simple;
	bh=y/9Azo9Cy2bUjJ3DCGtC28SFlHhb8TEX0O57kVB343o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeaP2+aLvqN3mQx3+unMjpBqvsMZ4NZ0DjFGyZJ330tjEYOJn0c8C+QNZQULsTBg9pBs6gJb7ilOnPUB9zvF1j5ZcX6FTuImn052DwkT6ft5l+FuZlWqkII4b0BCjtvDyppxSP5nYAltIlszJubz21qPaNJsx8n0BlB38kRJLjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnma9FJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnma9FJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED94DC4CECF;
	Tue,  8 Oct 2024 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393652;
	bh=y/9Azo9Cy2bUjJ3DCGtC28SFlHhb8TEX0O57kVB343o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnma9FJ8igid6q92iMAWeeHblCf0OIQPCvQA9eeeiQ3VKNHpPb0Kp2n0LRrkkD1Ex
	 XG5APuUqL582yLRD77yELuw+SV82/50YZKLRfdUy00y1U489EsERLW+B3zMDvVnxi5
	 o7T1jYWjqaThIawDAzJFon3Y2NnJrJ27PcDkh/1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 215/386] memory: tegra186-emc: drop unused to_tegra186_emc()
Date: Tue,  8 Oct 2024 14:07:40 +0200
Message-ID: <20241008115637.868218061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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


