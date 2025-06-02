Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3598F222560;
	Mon,  2 Jun 2025 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872898; cv=none; b=jlSV5f3fD88I6aqM3+in3AFXZwinPU9ywZApxS2z+l+3T4l6fUKfEqfapjCylQ2k9Lrw/y3qcALhnOJKns8gl72+iPlHCOZ35omVuFZcjY1P6zZRrt1ZE6ptq7VnshQGR1QBkFXTqmhBO02VryFtL+qg5wqxhH+FcDTVOSmO7EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872898; c=relaxed/simple;
	bh=sa0tL9IBkfzMvsfeYwrUNP+iOUtJS0TethNqmp9JnIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIO16tp7KKWovMqJKN9sGA4XK9DhqLuVR07Pl5fmKqwJivfSgrwkeuz+NuM9yiMMEMCuSynJh0a28N64OCzfQjl/qVIqAZRmhNepYNuLI9NyInlIiZRV0wDjtuLvE3JwhCidMOio0XRfuXcttzfeXsaRCjKjC6jxkQSN/OaqzYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMT81AQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMT81AQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4143C4CEEE;
	Mon,  2 Jun 2025 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872898;
	bh=sa0tL9IBkfzMvsfeYwrUNP+iOUtJS0TethNqmp9JnIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMT81AQYmNlo1RSZxJGKCrmn+18FzRn5LKVrTHL99yYjxHlAWocim5c0gExN03Fn6
	 T6uojr23D+PT6mjw+fm06X6Jeqf0EdQrS0RsAwgS4Oz/+jrOKTri6X/klXvvtH2Dgn
	 3LDHHRwqeLI7F+VHINQnIgMa0RjSCQfG3cBFTX0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 08/55] arm64: dts: qcom: sm8650: Add missing properties for cryptobam
Date: Mon,  2 Jun 2025 15:47:25 +0200
Message-ID: <20250602134238.596804249@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 38b88722bce07b6a5927f45fbf7a9a85e834572c upstream.

num-channels and qcom,num-ees are required for BAM nodes without clock,
because the driver cannot ensure the hardware is powered on when trying to
obtain the information from the hardware registers. Specifying the node
without these properties is unsafe and has caused early boot crashes for
other SoCs before [1, 2].

Add the missing information from the hardware registers to ensure the
driver can probe successfully without causing crashes.

[1]: https://lore.kernel.org/r/CY01EKQVWE36.B9X5TDXAREPF@fairphone.com/
[2]: https://lore.kernel.org/r/20230626145959.646747-1-krzysztof.kozlowski@linaro.org/

Cc: stable@vger.kernel.org
Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Link: https://lore.kernel.org/r/20250212-bam-dma-fixes-v1-4-f560889e65d8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -2495,6 +2495,8 @@
 				 <&apps_smmu 0x481 0>;
 
 			qcom,ee = <0>;
+			qcom,num-ees = <4>;
+			num-channels = <20>;
 			qcom,controlled-remotely;
 		};
 


