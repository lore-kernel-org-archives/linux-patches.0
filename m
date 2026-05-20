Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03A630BF68;
	Wed, 20 May 2026 17:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298508; cv=none; b=s/kbYp1/MqP0hzc2PM/JOVu9+aN9FKZddJV1DaSKOFnMgyTb253MniaPDzeSovSi7GIxOyEEEjAKt2RITSavaROMeP/kVGGpuTPiBAwO4DxKK9K1yYkJgdQ96HtBR21LWIawPqOsE91n2lV2eLQt3pL02bMdUMm538v0PpgCnA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298508; c=relaxed/simple;
	bh=J++k1AVzFPOmdefCGubGKu6ZjOd4HJf3hhxllwWRZEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+Abj2Zzj/lxJBW0U/j5P3F8mGVqRL2kIXR4qDJpHvh/rmhdgv3A4qksG1Z4B1U2P8f9K7JtnmdasfKdY3EtbvvxN3ZbwQ1Fa2ULz9XpXMI5oW/a8s7Q6e5tzisinXv1Ns+TjrHK76xufrNxcE7Y0aOPQTKOFkfejF4bSC9ZnDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abBY0CLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abBY0CLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1074D1F000E9;
	Wed, 20 May 2026 17:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298507;
	bh=XqqJWfuNzVHlQGotqpl32aFOdHIDy8W7IPxjVg95mJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abBY0CLwQEy4MutdqiTePTH2BBzSnGqhaA8JEA7AomS14SCr+C9/tzfJ9azeEawsg
	 rMkt7NrRgBQi2XtupBJkq8D0riQqWPgpFcQGrQMFm18dP3Tv3x50gxqASmWR3NFiQq
	 LLpB/EPcg/zqQwoHi2ht95rEmN8uKWe9vYgsBCNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Koskovich <akoskovich@pm.me>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/957] arm64: dts: qcom: sm8250: Add missing CPU7 3.09GHz OPP
Date: Wed, 20 May 2026 18:15:18 +0200
Message-ID: <20260520162143.955116568@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Alexander Koskovich <AKoskovich@pm.me>

[ Upstream commit b683730e27ba4f91986c4c92f5cb7297f1e01a6d ]

This resolves the following error seen on the ASUS ROG Phone 3:

cpu cpu7: Voltage update failed freq=3091200
cpu cpu7: failed to update OPP for freq=3091200

Fixes: 8e0e8016cb79 ("arm64: dts: qcom: sm8250: Add CPU opp tables")
Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260307-sm8250-cpu7-opp-v1-1-435f5f6628a1@pm.me
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 50dd11432bb2e..adf6b49b52c48 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -665,6 +665,11 @@ cpu7_opp20: opp-2841600000 {
 			opp-hz = /bits/ 64 <2841600000>;
 			opp-peak-kBps = <8368000 51609600>;
 		};
+
+		cpu7_opp21: opp-3091200000 {
+			opp-hz = /bits/ 64 <3091200000>;
+			opp-peak-kBps = <8368000 51609600>;
+		};
 	};
 
 	firmware {
-- 
2.53.0



