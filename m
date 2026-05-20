Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDE83164C3;
	Wed, 20 May 2026 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296272; cv=none; b=JVhXhOwWivDum/ByB9j4imzx63h84BcqU3+5cAhJDFB/nNJMsCKY/AKewE5seX2KB8WJSVv5OIkc46xiYCXOFXMYDPlKO8SSldrlEFpJP+LrKTg3sVZXd8lqCtQ2I575KrbAoMvnV2Ud3MSsvLUACaZuVxgK65HxCqXjMmb4wwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296272; c=relaxed/simple;
	bh=orcHeOkPGxlY3CMjmgqlLts/bUO2bhfvcAUdfmNx+nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFkl9te3WDBwVLhYqFlXfzL+bSooamtQtwzjJ6mYxNKG4Y4HOAvJFt043f+Ldm95DRG8nGWtBaUcWWaEWyDTFJifRlbUGSJB9LjRbfhsCttJDWpYOXbrgZTUsHm5DwkT+MQf27n+VApvepewwabGhNd08yF7srC6fa/7VDRe230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZDjfFi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZDjfFi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823DD1F000E9;
	Wed, 20 May 2026 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296271;
	bh=d3xj52gff6DGD+sAyPWC8YtAbL8KaWYS6Syl9kGXqtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZDjfFi7ERho/tPfmiRNmeIDGcu+XTxsQe6dvIs54LDX1RttJgDdQogUTrG3xfCYQ
	 BKRbafpqeScmdrh+2ZGCoT7ikc0vN+NaNDeWfbfLI5FaNMIMgcU8HTsQShGF/EyM+3
	 x551cDQRxoIA/uhd94TmwBYCNCGG/I9glelSd8Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0695/1146] dt-bindings: clock: qcom: Add GCC video axi reset clock for Glymur
Date: Wed, 20 May 2026 18:15:45 +0200
Message-ID: <20260520162203.917558507@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 7c3260327fc874b7c89d7bb230cd569d2e78aff7 ]

The global clock controller video axi reset clocks are required by
the video SW driver to assert and deassert the clock resets.

Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260202-glymur_videocc-v2-1-8f7d8b4d8edd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 1c8ce43e1e07 ("clk: qcom: gcc-glymur: Add video axi clock resets for glymur")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,glymur-gcc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/qcom,glymur-gcc.h b/include/dt-bindings/clock/qcom,glymur-gcc.h
index 10c12b8c51c34..6907653c79927 100644
--- a/include/dt-bindings/clock/qcom,glymur-gcc.h
+++ b/include/dt-bindings/clock/qcom,glymur-gcc.h
@@ -574,5 +574,6 @@
 #define GCC_VIDEO_AXI0_CLK_ARES					89
 #define GCC_VIDEO_AXI1_CLK_ARES					90
 #define GCC_VIDEO_BCR						91
+#define GCC_VIDEO_AXI0C_CLK_ARES				92
 
 #endif
-- 
2.53.0



