Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6D927733;
	Tue, 16 Jul 2024 15:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145197; cv=none; b=BwkX0MXmQ3qVtJUKITs+AzyCL0r3JKrMesyhsw74JK/yhilIAm/o7ql+Lz2pyvLfHVUKbRVQn7UjWv+siSVwcCOMYkp5ZlJv+VBX8s32MTGjPmfl1l9+VCO1rxzfnNrHrRNFZRbEHnHd7Pu6lkxOx6KqdsgviI1HzLS3BznsigA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145197; c=relaxed/simple;
	bh=1GCyO49mTsCTPDrBfnddHFkyYKpDSn3RYzEbywqr6i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/yDtZXfGrGzFfRpgSovq+si1zVkp9cjCLG6NzXyqduCx+rj459qDPfIIMW6j0Xnu8LwNrPDmmdDv+lRYeLbXp+CI//qAOFbvS/8X+j11tidRwFd5hzroDteUH4MsmKYeLLJY4jLN+pyRl5pxkJ0L2m+X0L2dMCrPuyyghXViqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYyPF5DN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYyPF5DN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E016BC4AF0E;
	Tue, 16 Jul 2024 15:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145197;
	bh=1GCyO49mTsCTPDrBfnddHFkyYKpDSn3RYzEbywqr6i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYyPF5DNR8OvXfKGUDc6828uuLfTgmdLTXzx6gSY9qxAozQnJpGigLwUro635Y5mu
	 TqhLy+VWQjCmkhF7cEFn9j6w82IHf5Pn8gWx1HUWxN8RqA3ggJC16bCJJMVDz2Bc0x
	 fyMaPfYucQWJqNRUsUD32UHxUym5u+Nlu0XULStM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 098/143] arm64: dts: qcom: x1e80100-crd: fix DAI used for headset recording
Date: Tue, 16 Jul 2024 17:31:34 +0200
Message-ID: <20240716152759.748627242@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 74de2ecf1c418c96d2bffa7770953b8991425dd2 upstream.

The SWR2 Soundwire instance has 1 output and 4 input ports, so for the
headset recording (via the WCD9385 codec and the TX macro codec) we want
to use the next DAI, not the first one (see qcom,dout-ports and
qcom,din-ports for soundwire@6d30000 node).

Original code was copied from other devices like SM8450 and SM8550.  On
the SM8450 this was a correct setting, however on the SM8550 this worked
probably only by coincidence, because the DTS defined no output ports on
SWR2 Soundwire.

This is a necessary fix for proper audio recording via analogue
microphones connected to WCD9385 codec (e.g. headset AMIC2).

Fixes: 4442a67eedc1 ("arm64: dts: qcom: x1e80100-crd: add sound card")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240611142555.994675-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -101,7 +101,7 @@
 			};
 
 			codec {
-				sound-dai = <&wcd938x 1>, <&swr2 0>, <&lpass_txmacro 0>;
+				sound-dai = <&wcd938x 1>, <&swr2 1>, <&lpass_txmacro 0>;
 			};
 
 			platform {


