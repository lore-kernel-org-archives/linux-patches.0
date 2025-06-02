Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4FE1401B;
	Mon,  2 Jun 2025 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872634; cv=none; b=DsIsWdGjWMAioeWroek41nFvFSkszU3i9IAPjoxVuiDtkUYqZ8k+2oEXg+R45KZrXZ2JKjdCFc79ZiJ8PwG/PmW2h8RrgRjmhTGkvjzb8DE1oys8ZD2wTkg+o5vlvfFJEDpt4oFFfi8DwVa4dQrNe8eXJFm0TjLoOPJHwik1GP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872634; c=relaxed/simple;
	bh=T/dI8eA99jBF+qfBUrg9W2fxf3bqZu9jb4uMPQwAM1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W7716g5wmmIs1CkD6qnJMDX6v/rAZcxPPoXgrjaUDq8ID+9oZRpdS7BMFuObloC/j6vQkaLiBuAO5wDAzpAw3zcKLa2GHkm8Xfyx3TRpSqy0TreKT3vu7DHJ5Z/6KlnpoZPTsnV5XoKqOgBgfublNuu/Iku+mF54qrsPnslU2zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQTPJAJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQTPJAJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803C3C4CEEB;
	Mon,  2 Jun 2025 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872634;
	bh=T/dI8eA99jBF+qfBUrg9W2fxf3bqZu9jb4uMPQwAM1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQTPJAJ209OX7Y5ct6wAz21JoYdsIa1eUoZJpitjDAHTjSfabbmERDhg36DG94KDG
	 l5zCCE/sXJ/ifKJIDAl9Ldba5WlDeDMjtf+7zmcpND9tflyihrFiLIDhQqwnfUxhrm
	 j2eEcqcR0N66cQsPcDDqQrz84opTkY4f0zZqOuOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 23/73] arm64: dts: qcom: x1e80100: Fix video thermal zone
Date: Mon,  2 Jun 2025 15:47:09 +0200
Message-ID: <20250602134242.613632004@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 801befff4c827aa72e3698367c5afc18987a6a3f upstream.

A passive trip point at 125°C is pretty high, this is usually the
temperature for the critical shutdown trip point. Also, we don't have any
passive cooling devices attached to the video thermal zone.

Change this to be a critical trip point, and add a "hot" trip point at
90°C for consistency with the other thermal zones.

Cc: stable@vger.kernel.org
Fixes: 4e915987ff5b ("arm64: dts: qcom: x1e80100: Enable tsens and thermal zone nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250219-x1e80100-thermal-fixes-v1-1-d110e44ac3f9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -8727,15 +8727,19 @@
 		};
 
 		video-thermal {
-			polling-delay-passive = <250>;
-
 			thermal-sensors = <&tsens0 12>;
 
 			trips {
 				trip-point0 {
+					temperature = <90000>;
+					hysteresis = <2000>;
+					type = "hot";
+				};
+
+				video-critical {
 					temperature = <125000>;
 					hysteresis = <1000>;
-					type = "passive";
+					type = "critical";
 				};
 			};
 		};


