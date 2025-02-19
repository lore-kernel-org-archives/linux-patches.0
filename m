Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BC11DDC11;
	Wed, 19 Feb 2025 09:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956377; cv=none; b=bVBvXg/3wkJxIgI3weDTVwJYTNYuGs4kMjqjw8l9FtpaKXWKrQD/5Jv9tm6HGItzmJQEfo8N1URFZmbYALp4zf8S5S/tFbnXygy5T5nSVhmtPO5YaAIIPqwEpIKrzlrHw1uJ4DlQ9xhj2wFD6r9zKrTZDtMHfF6/qfXvzjAwvEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956377; c=relaxed/simple;
	bh=NxKldDOrG6lfmhN8Fz3BsOc1aKkX8iFLmvX5ZyhxjOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heU/TOJw88WJZTYQyIpXCWk0x8Zh3OzKcMVFwArWOzsQlWl/iTyyjrWFawOL8H5+91PzZie4ZfAmKHVvIZ/1FcGZryFxuoVgwkDqneo+NX9g1lcRIvjTyHz1qMr1zkH0HIFmd7RGiikEOHqbueFVlMhQgyTQKP3v8Y1bzxLmzyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eV7siRUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eV7siRUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4D3C4CED1;
	Wed, 19 Feb 2025 09:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956377;
	bh=NxKldDOrG6lfmhN8Fz3BsOc1aKkX8iFLmvX5ZyhxjOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eV7siRUqDTUnzKgTmbuTuDEGnHINffiXnBrzxCET1zoanl+1FAYRauOMYJBOz3drg
	 klcRaW+5TDxMblHi6i0C91rlsIQu+z7vbtqfoc1GEoAYSUVweJtf5yHdb0TUW69lfG
	 gQeL9eqWsyxCIefm7GeCgptcYVbX1MagUf/POPrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/578] arm64: dts: qcom: sc7280: correct sleep clock frequency
Date: Wed, 19 Feb 2025 09:22:43 +0100
Message-ID: <20250219082659.227069886@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f6ccdca14eac545320ab03d6ca91ca343e7372e5 ]

The SC7280 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 7a1f4e7f740d ("arm64: dts: qcom: sc7280: Add basic dts/dtsi files for sc7280 soc")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-8-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index b5cd24d59ad9a..b778728390e53 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -79,7 +79,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



