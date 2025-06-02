Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C4221DA8;
	Mon,  2 Jun 2025 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872845; cv=none; b=gsy+khTmyU9IN9LbtZ4UAXfnlJh3fYkpuZyZDj/KsbuWIKEVPG467wivOP9dMrvd+kruVIgOoOsWbRvCTiX4l/MEsu0d4ZNrfpIyKTgD+RSokF5mNOdGgdnTwDqKAPegQ6rhHwaR1yY0SU3jZSqYU1s/HJprMm7YkqH+w4E/M9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872845; c=relaxed/simple;
	bh=o2KCyplHZIW5JWL248OgzrvlWvdV03CzrQIZmj0b6hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KH3RQeugpOUAmgtdxHyQLVRGX3MOyDhN4S8Y+EKwHvfH+lROcoFjsCua0t48VgZ+0pT1dxITl1xAGVPvyrOwOL1JVJgk8mIY9isFJe156z/tWeXioOP3wFI5SRN+uGEPNMi6aNJvvaf9P8FDT44ZyFUVN8m5igB3MDMbdDUOwdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBIpLjUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBIpLjUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E89DC4CEEB;
	Mon,  2 Jun 2025 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872845;
	bh=o2KCyplHZIW5JWL248OgzrvlWvdV03CzrQIZmj0b6hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBIpLjUfaL49beMA8zsxlNXaXfmrLsmwo6D3Wr1f6lm/D96kgV/jtWVi7eWbT2Gl6
	 ydb2NjH24qY0/bEjKTrRo3AFT/Ox4uk8pwvp5L56Pj/juy0dXt70CZ9fNq/xk3TBd+
	 s0fLNa2rA1kFPjd3xUOV77Vs+tLqeJlhj023u930=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 14/55] arm64: dts: qcom: x1e80100: Fix video thermal zone
Date: Mon,  2 Jun 2025 15:47:31 +0200
Message-ID: <20250602134238.845478175@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6682,15 +6682,19 @@
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


