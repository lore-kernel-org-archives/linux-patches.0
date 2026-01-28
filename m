Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B55F2FF178;
	Wed, 28 Jan 2026 15:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615499; cv=none; b=gnrCW4HTte4ag6FAOTBBgxQabsC0VUU2QARkuWwe/lqSaCCtABHo1JEWKmWoU3CiMGUxLEREcvKcusySfXqaQ5UG9EzRMATdW8uOT1NFKYosMmQ2dbn4u2QL9z44BiuX86BiNedacMsRUuU18bcgH4mPyh/c1lktk0k9nsLIqOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615499; c=relaxed/simple;
	bh=EAsxDL75wU/bbOfqjmVYPbYSmbF+uszJjFMcK0SkJFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f90KDgCSkGvJJZiXAcZypgSbU0EnjpcZ3Anc6HdSGBzOlKFATXAhj9HgOiuw7gVYLfw/jsbSkFGXcUXc8pXtI3yZL/mrybAjJa+5UVjkG0gynZqLBF2BwsHqNoy2t6sDDoBdxScR2tIpV9ls6o2bNbaCpVjAQaWQowhEjpntmtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlnQx9x4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlnQx9x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15572C4CEF7;
	Wed, 28 Jan 2026 15:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615499;
	bh=EAsxDL75wU/bbOfqjmVYPbYSmbF+uszJjFMcK0SkJFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlnQx9x4nXZrTh2JLSs/U5nnVEjg5EBFkM4yPMM9FaXQkQAv+4EUXDXT7nmYvek6I
	 BOLDGXzylMXQr2kAxyI1qiDDVGjkOffpx1NuK+XKxDjJa39bffFPCFlo9gUGFXUx0b
	 qmOJwlCArTmC2tf2thVIubaLDPG/G6qsj9s2Mw0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/227] arm64: dts: qcom: sm8650: Fix compile warnings in USB controller node
Date: Wed, 28 Jan 2026 16:20:48 +0100
Message-ID: <20260128145344.460705023@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 1f6ca557088eb96c8c554f853eb7c60862f8a0a8 ]

With W=1, the following error comes up:

Warning (avoid_unnecessary_addr_size): /soc@0/usb@a600000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

This is because the child node being removed during flattening and moving
to latest bindings.

Fixes: 77e1f16b9302 ("arm64: dts: qcom: sm8650: Flatten the USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251203144856.2711440-3-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 3b03c13539386..d22a26a416ccc 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -5115,9 +5115,6 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			dma-coherent;
 
-			#address-cells = <1>;
-			#size-cells = <0>;
-
 			status = "disabled";
 
 			ports {
-- 
2.51.0



