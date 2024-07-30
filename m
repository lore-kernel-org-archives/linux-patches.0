Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9C2188019;
	Tue, 30 Jul 2024 16:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355422; cv=none; b=KJgMuAEx9h3bB3Huma7FU4rYKpC39rnW9ItP7YCvhhOj7YMiPu0tojxNgWlaMtB+xjy2AIqW++xby6c5Zgps4mJtyvFypOKCQ43cJRbecom1bq5U8NKXA9JAvvrvCCq7VNbtswQZF1h2U3Hi64mIsD5wfyNx1eWTm0IflLouy8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355422; c=relaxed/simple;
	bh=mPDHn4Fln7+Dj+hISxwV+hpRHbGpV0+EG4NAAKPoS30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OipfCy+05z0rzbrxObPCiCWruvNEstpGe3a4kfDkGLN9lTe1EpQYArApp7txLM23TbHZDNmIXVRWrv2O/0+HXhraDZwNgD4NabVXz5I425Fqzxh1BrjW3zWybOvWuu/Av6u0xwWYxzTzSEhF/fVPir1GIiOyfhSL4CLg+2CLsBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHKhY8GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHKhY8GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35C1C32782;
	Tue, 30 Jul 2024 16:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355422;
	bh=mPDHn4Fln7+Dj+hISxwV+hpRHbGpV0+EG4NAAKPoS30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHKhY8GEK1avUNmyLDpAU01b5W7AeHoWynuc0SpcOgderDQ86ZUb0vNz/9t7fQKn4
	 yV1FgsqrCM6IXxHgg4LXHJ1p8fnYF2t9w+xucaAV2JtcVzoFf5M7OvpeIZQ9hX/dnu
	 xwjlZU6dYj3fCihqOvBBwlIcXlwPnGq5P+rUTiiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/568] arm64: dts: qcom: sdm850-lenovo-yoga-c630: fix IPA firmware path
Date: Tue, 30 Jul 2024 17:42:26 +0200
Message-ID: <20240730151641.366947645@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit cae4c862d8b2d7debb07e6d831e079520163ac4f ]

Specify firmware path for the IPA network controller on the Lenovo Yoga
C630 laptop. Without this property IPA tries to load firmware from the
default location, which likely will fail.

Fixes: 2e01e0c21459 ("arm64: dts: qcom: sdm850-yoga: Enable IPA")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240527-yoga-ipa-fw-v1-1-99ac1f5db283@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 92a812b5f4238..fe5c12da666e4 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -488,6 +488,7 @@ ecsh: hid@5c {
 &ipa {
 	qcom,gsi-loader = "self";
 	memory-region = <&ipa_fw_mem>;
+	firmware-name = "qcom/sdm850/LENOVO/81JL/ipa_fws.elf";
 	status = "okay";
 };
 
-- 
2.43.0



