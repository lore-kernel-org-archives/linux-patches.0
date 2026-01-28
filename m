Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E4123EA92;
	Wed, 28 Jan 2026 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614877; cv=none; b=DKBCckNxxCzXsrCNew5wjQmW8EpXp8icPGVmTfmPpba0Se8g+qS8e0ZgLIOWhG2O1Thnw/EZDE21ND2pnw/SgkpK37Isf+eOMJM2rGBHfTckeBN/ZhM0mDdhcB+/7mNCuq/iVno7sRfSytej3aoEmMtfHgZgq0KS8Rr5DI2v3IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614877; c=relaxed/simple;
	bh=+GC4k6c9FRKHLCzhQoGFfNLlPRhePnUzHHVPc0oQ2uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECjm/HEzeUqeQ+I0DYa2/0g7YCtko/yuuJbxPNSf7SeL7WTI8wNqNLj8AG3ZK1iD+WiluymqNBSjCsutkEcHzwcKsQDz6qFYqtgvZ7sSJVtVTqJR6LCG26zDzZDh8mBJpT7IbKYDXuEzdkz7EySHkhJGiG965DstCtzt2yL6aok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waUrxV2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waUrxV2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EF2C4CEF1;
	Wed, 28 Jan 2026 15:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614877;
	bh=+GC4k6c9FRKHLCzhQoGFfNLlPRhePnUzHHVPc0oQ2uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waUrxV2AZ6f7memm5hdyP179Gl4yDdOgCrdQLEL89SzVGHMfvhcspyycfoMaMRHaP
	 dKtvVm8NnYzF9EVAYHjxV7jdXxzN/J7yh7U7lGRUNL9FLSWY19EPAEKVclQV0SNiSy
	 3zRNt3DXuxD0o4w4HZ5uKksavG/rpM9cbizukvYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/169] dt-bindings: power: qcom,rpmpd: add Turbo L5 corner
Date: Wed, 28 Jan 2026 16:21:29 +0100
Message-ID: <20260128145334.242705093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 1c402295c10891988fb2a6fc658e6e95d4852a20 ]

Update the RPMH level definitions to include TURBO_L5 corner.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/661840/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Stable-dep-of: 5bc3e720e725 ("pmdomain: qcom: rpmhpd: Add MXC to SC8280XP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/power/qcom-rpmpd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/qcom-rpmpd.h b/include/dt-bindings/power/qcom-rpmpd.h
index df599bf462207..5bc4735fb3e6e 100644
--- a/include/dt-bindings/power/qcom-rpmpd.h
+++ b/include/dt-bindings/power/qcom-rpmpd.h
@@ -240,6 +240,7 @@
 #define RPMH_REGULATOR_LEVEL_TURBO_L2		432
 #define RPMH_REGULATOR_LEVEL_TURBO_L3		448
 #define RPMH_REGULATOR_LEVEL_TURBO_L4		452
+#define RPMH_REGULATOR_LEVEL_TURBO_L5		456
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO 	464
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO_NO_CPR	480
 
-- 
2.51.0



