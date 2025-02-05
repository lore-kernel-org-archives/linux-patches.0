Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0EB1FECAA;
	Wed,  5 Feb 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767020; cv=none; b=iKmIkisiCXCC0qawySULglPjQmsew9/EuSZCDbOFsc9PqOSGRebR//GxukSTiG6a7VPx+dhKssKzb33gmfdmzoiizJ6gs1dAHGH6iNDzyn9IWUVUAqms5MieTG8vTg3KvoXy3p09aTnixsLcUoeyVkaNjKYHPAdJ/WXcAG7xQOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767020; c=relaxed/simple;
	bh=fffpDjZzk70PfmOgx4Kc4RDeLIcylJJz6bNaCJN/VSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM4HAzh+BBJY3GzqaT9qbjSoBJWXlukU7GZjDGDT3AxQFa021wa3QFjBtNtxuJcHgppYtLhtUQTMTTxWfIiPWzhuog1uRvJCPU1JbU3YcVumDSZIcUJKa1erePwfMXvRhkIL9oMZXMqVNvcLIcNw8ukCaksJ4QvWI++ZnkZrjqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuCbKycx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuCbKycx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18366C4CED1;
	Wed,  5 Feb 2025 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767020;
	bh=fffpDjZzk70PfmOgx4Kc4RDeLIcylJJz6bNaCJN/VSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuCbKycxywBrWkE87Sb2KlAoUMG1gLcsvTz7F6dkEKIV4/BycDaOXb/lpqHRG0quO
	 7gyTTQ/9f3DcSYKFCpSZpQr3vQ/gbjprqX/HjAMt+rdxH2wh8YvtJNipPshc+lwmO/
	 Y5dmMggtwExBsMe9xTrk5wKSgoEeHpm+++DJKdh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/590] arm64: dts: qcom: qcm6490-shift-otter: remove invalid orientation-switch
Date: Wed,  5 Feb 2025 14:42:06 +0100
Message-ID: <20250205134509.464162704@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit abb00f0fbf31d71b9f725e58d6a29634175f28a8 ]

The orientation-switch property is not documented in the PHY bindings,
remove it.

This fixes:
qcm6490-shift-otter.dts: phy@88e3000: 'orientation-switch' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/phy/qcom,usb-snps-femto-v2.yaml#

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241230-topic-misc-dt-fixes-v4-1-1e6880e9dda3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
index 4667e47a74bc5..75930f9576966 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
@@ -942,8 +942,6 @@
 
 	qcom,squelch-detector-bp = <(-2090)>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
-- 
2.39.5



