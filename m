Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF2221D9E;
	Mon,  2 Jun 2025 13:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872121; cv=none; b=jfsFW7kbj0nKOnLValCBSI799G+LO8j7oq433F8MUHS7LXG2uiXPO8wvENDSWxBJPT5UCWgHQQozc4HfE3GVdreDIdKVGam86r5KZH0SZmEHOc7LgczIK05Mbg4MFnZ+iqDN7fiODhUbH5DsF/CYRLG2JN9e7jTK54Foe2Oh5JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872121; c=relaxed/simple;
	bh=/BpGPX4awaAJZyJ2towMdRULLX33vWpxuHFygjKpEBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EuWk1OQ9JvxCZuhMwRRWXxEu+RDDBXqpQ3HL2+jnFA4OeTbbbt1G2RIKSjzHNrBOh0wUvFysFLL/+4042O2tT4jZ0dXFfDI+MDQpO72cC80LaqX5R7flf3gIYlq9MynHLHZvQr9m6Hr8Lgi/8LW0w3iR8cO2ZxGvNbNRE8iQP+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDw1IbFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDw1IbFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BB7C4CEF2;
	Mon,  2 Jun 2025 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872120;
	bh=/BpGPX4awaAJZyJ2towMdRULLX33vWpxuHFygjKpEBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDw1IbFgsT+rKzINTNKu9RfLFahUAas/rBQDCUbkgGoHUyNIQlQ20dwuwqXcdwqiW
	 qjQFdMxThvQBfSBHcavxVkJQJ8nfTo1IP7zuNuPHDx7WE3soIyVuOSlVViUiAl4Rez
	 8N/r6YVjdvXOi/nYh0dCRucFgYVaB1sUM1iBc3EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.15 24/49] arm64: dts: qcom: x1e80100: Apply consistent critical thermal shutdown
Date: Mon,  2 Jun 2025 15:47:16 +0200
Message-ID: <20250602134238.894392006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 03f2b8eed73418269a158ccebad5d8d8f2f6daa1 upstream.

The firmware configures the TSENS controller with a maximum temperature of
120°C. When reaching that temperature, the hardware automatically triggers
a reset of the entire platform. Some of the thermal zones in x1e80100.dtsi
use a critical trip point of 125°C. It's impossible to reach those.

It's preferable to shut down the system cleanly before reaching the
hardware trip point. Make the critical temperature trip points consistent
by setting all of them to 115°C and apply a consistent hysteresis.
The ACPI tables also specify 115°C as critical shutdown temperature.

Cc: stable@vger.kernel.org
Fixes: 4e915987ff5b ("arm64: dts: qcom: x1e80100: Enable tsens and thermal zone nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250219-x1e80100-thermal-fixes-v1-2-d110e44ac3f9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |  128 ++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 64 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -8457,8 +8457,8 @@
 				};
 
 				aoss0-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -8483,7 +8483,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8509,7 +8509,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8535,7 +8535,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8561,7 +8561,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8587,7 +8587,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8613,7 +8613,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8639,7 +8639,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8665,7 +8665,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8683,8 +8683,8 @@
 				};
 
 				cpuss2-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -8701,8 +8701,8 @@
 				};
 
 				cpuss2-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -8719,7 +8719,7 @@
 				};
 
 				mem-critical {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <0>;
 					type = "critical";
 				};
@@ -8737,7 +8737,7 @@
 				};
 
 				video-critical {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8755,8 +8755,8 @@
 				};
 
 				aoss0-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -8781,7 +8781,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8807,7 +8807,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8833,7 +8833,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8859,7 +8859,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8885,7 +8885,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8911,7 +8911,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8937,7 +8937,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8963,7 +8963,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -8981,8 +8981,8 @@
 				};
 
 				cpuss2-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -8999,8 +8999,8 @@
 				};
 
 				cpuss2-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9017,8 +9017,8 @@
 				};
 
 				aoss0-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9043,7 +9043,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9069,7 +9069,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9095,7 +9095,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9121,7 +9121,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9147,7 +9147,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9173,7 +9173,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9199,7 +9199,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9225,7 +9225,7 @@
 				};
 
 				cpu-critical {
-					temperature = <110000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9243,8 +9243,8 @@
 				};
 
 				cpuss2-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9261,8 +9261,8 @@
 				};
 
 				cpuss2-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9279,8 +9279,8 @@
 				};
 
 				aoss0-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9297,8 +9297,8 @@
 				};
 
 				nsp0-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9315,8 +9315,8 @@
 				};
 
 				nsp1-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9333,8 +9333,8 @@
 				};
 
 				nsp2-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9351,8 +9351,8 @@
 				};
 
 				nsp3-critical {
-					temperature = <125000>;
-					hysteresis = <0>;
+					temperature = <115000>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9377,7 +9377,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9403,7 +9403,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9429,7 +9429,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9455,7 +9455,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9481,7 +9481,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9507,7 +9507,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9533,7 +9533,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9559,7 +9559,7 @@
 				};
 
 				trip-point2 {
-					temperature = <125000>;
+					temperature = <115000>;
 					hysteresis = <1000>;
 					type = "critical";
 				};
@@ -9578,7 +9578,7 @@
 
 				camera0-critical {
 					temperature = <115000>;
-					hysteresis = <0>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};
@@ -9596,7 +9596,7 @@
 
 				camera0-critical {
 					temperature = <115000>;
-					hysteresis = <0>;
+					hysteresis = <1000>;
 					type = "critical";
 				};
 			};


