Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086BF3054DD;
	Tue,  2 Sep 2025 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819927; cv=none; b=fUXkHnqS/sBCHBplO3EIKGtHLHKlK0CndyL8QyWjHnJsUx88JbCToeJOWMZdEAdPEpZRilR8LMM4J9n1UoPZzVRFHxCNtapNtwv0lF7Z/3tzeu3OXurixFyJopAh4+a8DPaFPFxB73lb4XMAJ0GN4ONsRu+Ck28cTvZpl28DnZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819927; c=relaxed/simple;
	bh=r5TOZVjpy5Unca1DIB9ukvXWDig83DmrnFV3185i4+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNicsg459wytndTMFTLZ/iKZ3AL26ubADdb0zRkc61763xEVcTwF8Un3i5f4azk5TMsaJ91/qsqnoQszF/16unLAxzGZTkqxKJbhMGcDB7A85lBmOo/xiSr8lMl+CHaNQmBlswUc2QGi7RIjj1t9aQivaRzdMN2lNn8lhrAwFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6qW8Z2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6qW8Z2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E782C4CEED;
	Tue,  2 Sep 2025 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819926;
	bh=r5TOZVjpy5Unca1DIB9ukvXWDig83DmrnFV3185i4+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6qW8Z2MblYdqY0J92UEuVB6wEnb0ckPN0POoM3bLmJzr6Zu5eM9oTO8UAQQVrbYS
	 0UlJlAtB+LGO+Bc/tp8jInrBkZIteVAkBK5qkCm7rAroYzy+QUentgpyaO1ZO7z+Vh
	 Nmb1PAkZQDVyAcrEAnbIHHyPZJ0z89no24Mg1Z5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 39/95] dt-bindings: display/msm: qcom,mdp5: drop lut clock
Date: Tue,  2 Sep 2025 15:20:15 +0200
Message-ID: <20250902131941.109504657@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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



