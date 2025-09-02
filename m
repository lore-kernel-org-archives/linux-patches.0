Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9BD30505A;
	Tue,  2 Sep 2025 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819589; cv=none; b=RDACay93FkAZrwCYaYm5sG4wWqLN2y4PSCfiPMaWgirAB0++/aL6O6ePlbSoxx2zMXrdkofWNbnpednj7e4vVHiE8zjA8OrrPWV+ZD+mxGK1UVLDmS+xw6i/r6NQvuQGPkHV81qeKngqDaYaiXLPp4866HhyBd/e3j20tNJ7aPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819589; c=relaxed/simple;
	bh=NwC+gCz3LG1ES0X6rGEdTm/GGpKHXx0pR91kkZYY/uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/bzaALneuJhUvn10jt/9bBTAJkleJPNzK5jCKXeakXXedakALxCVkaXBtdawJAUBPzEGySuMWtFJPqj4RP3938zJSVBLnRaW/sFaEPxlzRpUVegStFFWCliy6+TNF7TojW/MfpWvE2/PKyzqX4HaMe2p0LtQ4O+za9U3XrbU/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvlstoTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvlstoTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21463C4CEED;
	Tue,  2 Sep 2025 13:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819589;
	bh=NwC+gCz3LG1ES0X6rGEdTm/GGpKHXx0pR91kkZYY/uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvlstoTGosLpRUjsNXAPN7UsyhTveiLdsi+GtK6xQ3KwAgfVHujChxmR/cwevDdDm
	 MsH4rMrkFh0CdPRzuJLrZrXDu+ET91f/TvrPDigmMH4gaAnXNV/hnhvOvbz2DwpoNF
	 gZUqCz4mog31GFgc9T1jZ4Ei1V9yquGyV40XDvlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 062/142] dt-bindings: display/msm: qcom,mdp5: drop lut clock
Date: Tue,  2 Sep 2025 15:19:24 +0200
Message-ID: <20250902131950.628912086@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 7ab3b7579a6d2660a3425b9ea93b9a140b07f49c ]

None of MDP5 platforms have a LUT clock on the display-controller, it
was added by the mistake. Drop it, fixing DT warnings on MSM8976 /
MSM8956 platforms. Technically it's an ABI break, but no other platforms
are affected.

Fixes: 385c8ac763b3 ("dt-bindings: display/msm: convert MDP5 schema to YAML format")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Patchwork: https://patchwork.freedesktop.org/patch/667822/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml b/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml
index e153f8d26e7aa..2735c78b0b67a 100644
--- a/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml
+++ b/Documentation/devicetree/bindings/display/msm/qcom,mdp5.yaml
@@ -60,7 +60,6 @@ properties:
           - const: bus
           - const: core
           - const: vsync
-          - const: lut
           - const: tbu
           - const: tbu_rt
         # MSM8996 has additional iommu clock
-- 
2.50.1



