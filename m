Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9EF183CD5;
	Tue, 30 Jul 2024 16:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355439; cv=none; b=fnBOHp3OJfdyOfSRJRO8msbGv2iujYtSUlC1gSCPcUUjQPQ9A/XztVBams1MNBGZHDZqVhLsiq+GxHR5ZiJUi6vU4iqj61F7XGV+40r3dsVYjzH4TIhEj/dBnNRGH2CmtZqm/8F+NX2GUQqeupphNeRK198qOTM2UpjYHcLyGp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355439; c=relaxed/simple;
	bh=i6e9CGiXEeoDMWjoBlzCb8SOnw3yjthSZLqjfLWUJ/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eu0CvvK0I848lu4MqhZdg6ckVGOJoYJLKviL96qpEfzHL7zkav+mqkgDarMuUcolvly/kVPCntwdnV6FfZXmx7UtBUktiasXLWdfIhpTGre91GI9n9/LP9gA1XNfnNud54L4/YaWMLCXY2e3jVLqv9xyN6u8v+wXF7DoTYKuZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4WkahI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4WkahI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9A3C32782;
	Tue, 30 Jul 2024 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355438;
	bh=i6e9CGiXEeoDMWjoBlzCb8SOnw3yjthSZLqjfLWUJ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4WkahI4mpPaB5YJUtZXwRn8T88HtMfOKLqNMgANkTjYoQRfDfeWBhrRjLnpxHoyi
	 J36T16p+614X2C8g+hf23XdXazAc5E+0jBPg1p2X+5mbVHCeyFtLL3FaqxuQeG5j1N
	 D+Nczttj0Ae5ja+n0cvdIpr4ZFZGk4JHGcXQ3FTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/440] arm64: dts: qcom: sm6350: Add missing qcom,non-secure-domain property
Date: Tue, 30 Jul 2024 17:45:08 +0200
Message-ID: <20240730151618.690867625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 81008068ee4f2c4c26e97a0404405bb4b450241b ]

By default the DSP domains are secure, add the missing
qcom,non-secure-domain property to mark them as non-secure.

Fixes: efc33c969f23 ("arm64: dts: qcom: sm6350: Add ADSP nodes")
Fixes: 8eb5287e8a42 ("arm64: dts: qcom: sm6350: Add CDSP nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20240705-sm6350-fastrpc-fix-v2-1-89a43166c9bb@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 66998df053d52..ba078099b8054 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -895,6 +895,7 @@ fastrpc {
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "adsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
@@ -1002,6 +1003,7 @@ fastrpc {
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "cdsp";
+					qcom,non-secure-domain;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-- 
2.43.0



