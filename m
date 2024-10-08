Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C7C1DE2AD;
	Tue,  8 Oct 2024 12:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390482; cv=none; b=taaHbrO/xY+fV2RNg5LEy56T5o158oCWFO8WFULdm3fyjNICRRyu13+0nWXG/W49NW69OWPjJub6opmJhbhjwvLcsrEbmAMNsivRlflgnm3XcWyyl1GCQSRDEmn9STiDSCTnqj5O20+PRBJciBIF/MBnHOPH9GjvxsW60PDKJfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390482; c=relaxed/simple;
	bh=zK8be5urcgrCUZcGMJYH6J+h+GCDbSn/AuCgHJaR2w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUpPwz//3pCdfp4sFv2Rk9QiF7UJO1kVJx3gbH4+jBruhQ2iCfQ6YwFWcel7At7EtttJkW4tpVLXs6e2nL1hfjcutS2xoNWq/a1K7rd6yW0C9uh0IRRot2Hcy0JgWpdajGPD3aia20hszuQX+125LomvL5m8h6Q/2MU20RPA3Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XT+K82Kv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XT+K82Kv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B2DC4CECE;
	Tue,  8 Oct 2024 12:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390482;
	bh=zK8be5urcgrCUZcGMJYH6J+h+GCDbSn/AuCgHJaR2w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XT+K82KvQaCGIQG1G5639DjBVcFHDwgpK6QvNr96Mwtv03vHIW+Q8UkN0egB/YLC5
	 Y9zSopipbPaKfYZ+edGKAx3uCMU7jv1sRBYxA4V+6H6mdm4di5lVVCBK5vt87WMVGl
	 exxkfzCYfIDP1RgdWmpr1FhsVizSz8XmzztRP6Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.10 303/482] memory: tegra186-emc: drop unused to_tegra186_emc()
Date: Tue,  8 Oct 2024 14:06:06 +0200
Message-ID: <20241008115700.361174486@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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


