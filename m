Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AED15684;
	Thu, 13 Feb 2025 15:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459641; cv=none; b=dPF+VSkTXcgcTz2uyCmq7aYJoycY1m3uFOGLzluVeBrUpaGFemgcymy52ynb2BdKlmjSHQEWohpgmsda55Vzc/SZLu6asMQ3qIdFbVYJqz1l8n7CyGtGBSBTE+9CIoYJ5DNxWT54lhDM0Mcp3nIaeM8uzFDfWo/4gnjs7Yyt55o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459641; c=relaxed/simple;
	bh=sy40xPdaBNsSlsY45CJ4djc/VYDM5rqfj5c/GD7h2+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBQmTUi6G3ncjlTzsLDJRHLMq1SdtSohoTBXBWhVoACQjIMfiXzHUUmZcLSNJC5FhrrciNcu6JHH3+jHKHABve22G782VsDd7eB4zJQLp+2IODH1djEzilpe/tUQXlCfk790BCCKhWuoAiP757is8gp7ID/wEtpuX4n/G0gK1F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bvix5wic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bvix5wic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9D6C4CED1;
	Thu, 13 Feb 2025 15:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459641;
	bh=sy40xPdaBNsSlsY45CJ4djc/VYDM5rqfj5c/GD7h2+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bvix5wicrMVmhsD0VJwHDt7oh5Q7PeA+lHgEhKbcWYRLVdpkWqY5yfXSz+6qE5Aba
	 aJ7kD1SViSrDoBESEoJcn9wFtBQNDvsxs69+eKQQ+Pl3JQLURETgKxY2NoiAQz0HtC
	 VEPjIpp0oVd50yD10IDb45jfp6K/o6/DQFvl6szE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 322/443] arm64: dts: qcom: sm8550: correct MDSS interconnects
Date: Thu, 13 Feb 2025 15:28:07 +0100
Message-ID: <20250213142453.046029165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit b8591df49cde459e3b84cdc0517d7bf92053d244 upstream.

SM8550 lists two interconnects for the display subsystem, mdp0-mem
(between MDP and LLCC) and mdp1-mem (between LLCC and EBI, memory).
The second interconnect is a misuse. mdpN-mem paths should be used for
several outboud MDP interconnects rather than the path between LLCC and
memory. This kind of misuse can result in bandwidth underflows, possibly
degrading picture quality as the required memory bandwidth is divided
between all mdpN-mem paths (and LLCC-EBI should not be a part of such
division).

Drop the second path and use direct MDP-EBI path for mdp0-mem until we
support separate MDP-LLCC and LLCC-EBI paths.

Fixes: d7da51db5b81 ("arm64: dts: qcom: sm8550: add display hardware devices")
Cc: stable@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241026-fix-sm8x50-mdp-icc-v2-1-fd8ddf755acc@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -3003,9 +3003,8 @@
 
 			power-domains = <&dispcc MDSS_GDSC>;
 
-			interconnects = <&mmss_noc MASTER_MDP 0 &gem_noc SLAVE_LLCC 0>,
-					<&mc_virt MASTER_LLCC 0 &mc_virt SLAVE_EBI1 0>;
-			interconnect-names = "mdp0-mem", "mdp1-mem";
+			interconnects = <&mmss_noc MASTER_MDP 0 &mc_virt SLAVE_EBI1 0>;
+			interconnect-names = "mdp0-mem";
 
 			iommus = <&apps_smmu 0x1c00 0x2>;
 


