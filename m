Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17FA4611C5;
	Sat, 28 Feb 2026 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301294; cv=none; b=svblPvLEmWLIRG6P8yE4Lkvd7FMNns4jVBILsy948s5oyerb1wJMJXqTtYJG4/KS9qmCfrF9cKoPStC5JKoMIuG8hBy+Yjf158Hlb4PcnCdbFVjYJypk5iT3tR1Q8mdMy77pjJ3DQ3BLHWjfzgSaXiJNqV/llY/CJyDe+WphBGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301294; c=relaxed/simple;
	bh=lcawo1snmYO4JkAn7IB+DhZ12UD686+CTTT4COmR6yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7Z/AWNorSP0eRSeCWrSZoSxbXQiE9VPEd/HYrWuIcgwznyugyJgcU00hDQXrINe9FVnu9Autvyat9dghp/OB6sARwfW7t2SqzVaO4x4wERRHRCZyfYWs5R6cn5lvP/KovMMI/KzFmcubJd+DuiGU9Ro6xKpixXIhTqUS54zu0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1EhJ7XR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1EhJ7XR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15031C19425;
	Sat, 28 Feb 2026 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301294;
	bh=lcawo1snmYO4JkAn7IB+DhZ12UD686+CTTT4COmR6yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1EhJ7XRqTYE+inAOIjsJosYKMfM1jHpnTzmog3HPW6zkuV6zjkOrZuzGzDh0ZT8k
	 X3EE5BnUZZywtGgHHvMxG4Z77lmgK+3pAEiymYZeM0NPRQ5sCsp1nemYT4cLT1Wy1y
	 frY6tepjZtrRqrfgCOsNi0ZiIw4J9OgPcP7u07QgXsGY8eb/A0+DVOztBRX6GcTjc7
	 ziy5KFF0OxLOXI8GzRArHNFQncOK+ZzCWG8KJMf737JUjL8jUX6G8ZC3HPzbZ6qE8Q
	 XrSzb+RHjJnpyHb+6xHs1OkSNPqcRWG8Xu1kfyt1rRyc+bUcuqFmwdJx33S2bwOl8Q
	 Qgir8epLfHOQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexey Minnekhanov <alexeymin@postmarketos.org>,
	stable@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 479/752] arm64: dts: qcom: sdm630: Add missing MDSS reset
Date: Sat, 28 Feb 2026 12:43:10 -0500
Message-ID: <20260228174750.1542406-479-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexey Minnekhanov <alexeymin@postmarketos.org>

[ Upstream commit 0c1d1591f898d54eaa4c8f2a1535ab21bf4e42e4 ]

If the OS does not support recovering the state left by the
bootloader it needs a way to reset display hardware, so that it can
start from a clean state. Add a reference to the relevant reset.

It fixes display init issue appeared in Linux v6.17: without reset
device boots into black screen and you need to turn display off/on
to "fix" it. Also sometimes it can boot into solid blue color
with these messages in kernel log:

  hw recovery is not complete for ctl:2
  [drm:dpu_encoder_phys_vid_prepare_for_kickoff:569] [dpu error]enc33
      intf1 ctl 2 reset failure: -22
  [drm:dpu_encoder_frame_done_timeout:2727] [dpu error]enc33 frame
      done timeout

Fixes: 0e789b491ba0 ("pmdomain: core: Leave powered-on genpds on until sync_state")
Cc: stable@vger.kernel.org # 6.17
Signed-off-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251116-sdm660-mdss-reset-v2-3-6219bec0a97f@postmarketos.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index b383e480a394d..876a6871745cf 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -1563,6 +1563,7 @@ mdss: display-subsystem@c900000 {
 			reg-names = "mdss_phys", "vbif_phys";
 
 			power-domains = <&mmcc MDSS_GDSC>;
+			resets = <&mmcc MDSS_BCR>;
 
 			clocks = <&mmcc MDSS_AHB_CLK>,
 				 <&mmcc MDSS_AXI_CLK>,
-- 
2.51.0

