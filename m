Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B045A2D9EDB;
	Wed, 28 Jan 2026 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614873; cv=none; b=X7GPnrSLKcRvy3isMBbUpZnVAa2UNswof9SJb9JgJ6YjoNqiUR5J6QjQLMdkM3jIcjAbEMWRXMq1SK0NKwYMkSfkwzukO+0nKSC+hR2sVFXdLYy1BUsyRnsWz+mBssgN7lG6q1HtMrdZ/Q7kLNciNubV70sdh9z0+LqrEzPochc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614873; c=relaxed/simple;
	bh=BGPrXTYJ2kk2MHtgj6v/2HiCg8vikPmT2PWi4S03Dt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvmCzmgPLFDpc2Hbh9a5zpPy8UQ7ZqFFZq5m1LdFnLqZM1mTliMHyOoagrCtefhcEXVdnPepSJ7PY9zzpOv+brpEOlfGN9Pi4Ay34RO9phNdMfBhgbzvNmhRYESOlHLuzzpgUotv2bskXR59DU1xTIvhyHNeeVyEGE9nEELjulE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWb8LJaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWb8LJaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB2FC4CEF1;
	Wed, 28 Jan 2026 15:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614873;
	bh=BGPrXTYJ2kk2MHtgj6v/2HiCg8vikPmT2PWi4S03Dt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWb8LJaR+XQoo95CjcNKZy++2HWVGmNVkR6E6+FBedXzBTQLaQgAkkTj9ew9aILe6
	 ffX5GEeQmRWlYe70hZM3KTh2iNIMhJPIj6ofYWY/RGH1G1HynsELccDhBptcI6edEc
	 XjFE1uHZlqvjvJZEG6DoD/NfNAiM6zB+4rCA4AKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Jishnu Prakash <quic_jprakash@quicinc.com>,
	Melody Olvera <quic_molvera@quicinc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/169] dt-bindings: power: qcom,rpmpd: document the SM8750 RPMh Power Domains
Date: Wed, 28 Jan 2026 16:21:28 +0100
Message-ID: <20260128145334.206644122@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 134e9d035d830aabd1121bcda89f7ee9a476d3a3 ]

Document the RPMh Power Domains on the SM8750 Platform.

Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Jishnu Prakash <quic_jprakash@quicinc.com>
Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
Message-ID: <20241112002444.2802092-2-quic_molvera@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 5bc3e720e725 ("pmdomain: qcom: rpmhpd: Add MXC to SC8280XP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 1 +
 include/dt-bindings/power/qcom-rpmpd.h                  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 929b7ef9c1bcd..d55758a759717 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -58,6 +58,7 @@ properties:
           - qcom,sm8450-rpmhpd
           - qcom,sm8550-rpmhpd
           - qcom,sm8650-rpmhpd
+          - qcom,sm8750-rpmhpd
           - qcom,x1e80100-rpmhpd
       - items:
           - enum:
diff --git a/include/dt-bindings/power/qcom-rpmpd.h b/include/dt-bindings/power/qcom-rpmpd.h
index 608087fb9a3d9..df599bf462207 100644
--- a/include/dt-bindings/power/qcom-rpmpd.h
+++ b/include/dt-bindings/power/qcom-rpmpd.h
@@ -218,6 +218,7 @@
 /* SDM845 Power Domain performance levels */
 #define RPMH_REGULATOR_LEVEL_RETENTION		16
 #define RPMH_REGULATOR_LEVEL_MIN_SVS		48
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_D3		50
 #define RPMH_REGULATOR_LEVEL_LOW_SVS_D2		52
 #define RPMH_REGULATOR_LEVEL_LOW_SVS_D1		56
 #define RPMH_REGULATOR_LEVEL_LOW_SVS_D0		60
@@ -238,6 +239,7 @@
 #define RPMH_REGULATOR_LEVEL_TURBO_L1		416
 #define RPMH_REGULATOR_LEVEL_TURBO_L2		432
 #define RPMH_REGULATOR_LEVEL_TURBO_L3		448
+#define RPMH_REGULATOR_LEVEL_TURBO_L4		452
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO 	464
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO_NO_CPR	480
 
-- 
2.51.0



