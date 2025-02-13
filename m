Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A781547E3;
	Thu, 13 Feb 2025 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460674; cv=none; b=os7wfIrjwoc3YeSUiM6tz0Z0LPetC1VqfrwcU6k2D9n6jv5vynI21VZCZG81OApWJrQ2LkpqsPclt8E82mzShIL5huqYM5aQkTlwIjrP6X/504BsR126gpLX7qHxUhhCCUXwQ/ioXqEBUtfuRUqRo9NYlM7sX5PFcfmCg/78Ne0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460674; c=relaxed/simple;
	bh=PcNi2dn5L7XFvUiVASryvSO/BJH5tHuE6zn1+2S6Rws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCD6UB65PVvuRVX7A0FLBKujyNkdYqDIGw7jNE6Tm+hMPhBSF8e58s9OSDI0Br2JQk/uLfZTC8f1736gWp7RKVYq2q9aYAGy6Mqdj/b0x6HzPGLOnjq9pH6lIje2lOAcscl3NIyIYE7y1PwfEF+YjEfFSGuKvktI7pL6Xt6w4H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYU3mPSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYU3mPSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFF6C4CED1;
	Thu, 13 Feb 2025 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460674;
	bh=PcNi2dn5L7XFvUiVASryvSO/BJH5tHuE6zn1+2S6Rws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYU3mPSWzloDd6HFvCwu4Jtvb6445TWu9JkhqB6WdDxVuCh5CUy7ewkseUL3h0Ghi
	 AqTAQeC2akZSGFvxsy3HJsHwJ3yh0JZmppyWhVP7QUwb7a01+GTxc7Hv1eqapNSS+E
	 63dbJwROA8Z8HIYUkjezDqXU03UANl3VGQM/LzDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 180/273] arm64: dts: qcom: sm6375: Fix MPSS memory base and length
Date: Thu, 13 Feb 2025 15:29:12 +0100
Message-ID: <20250213142414.443103716@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 918e71ba0c08c3d609ad69067854b0f675c4a253 upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB): 0x0608_0000 with length of 0x10000.

0x0600_0000, value used so far, is the main region of Modem.

Correct the base address and length, which should have no functional
impact on Linux users, because PAS loader does not use this address
space at all.

Fixes: 31cc61104f68 ("arm64: dts: qcom: sm6375: Add modem nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-19-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -1471,9 +1471,9 @@
 			#power-domain-cells = <1>;
 		};
 
-		remoteproc_mss: remoteproc@6000000 {
+		remoteproc_mss: remoteproc@6080000 {
 			compatible = "qcom,sm6375-mpss-pas";
-			reg = <0 0x06000000 0 0x4040>;
+			reg = <0x0 0x06080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 307 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


