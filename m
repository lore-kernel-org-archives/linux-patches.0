Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A98327733;
	Tue, 16 Jul 2024 15:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145188; cv=none; b=XLHrYObiPOAFyLNMuX7pjXoG9j0IO9rG538xHriJVmuDXK3nbKHljZvzUoRNqwmHG8boFzkLaaULFr1wSGzXOi9jlj0eSQTT+nmOjhmfTb2b3Amw8eSfh68Pz3mB2KFutMv8GQuVvbzVq7h4FBjwl3NH71vr+S9ccJEHz2TW+hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145188; c=relaxed/simple;
	bh=uMpyrHGx9gmJ2u+zvaATIstTBrGPYDDDwf9ZEyBfWfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meqrZ7yfpYu8Z7APsld8ATGI6qmzP8uGMxMJNQSNgh3T/0rxvwnRoXYnZb5184/wFm5zuAib8Q2ov1ZAogxXtXPWyrRAub06SsPTCTpBwXY/kGEt759CRrit7P6MV6mlketcXvrzXnvss1j/ccnNgSl5BgoU0PCLLFYrXk//8D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB6JN5sA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB6JN5sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1200EC116B1;
	Tue, 16 Jul 2024 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145188;
	bh=uMpyrHGx9gmJ2u+zvaATIstTBrGPYDDDwf9ZEyBfWfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TB6JN5sA8RPTkZlo1+Uka6Lb+4Jlyo7EjpbGbihsrysniyVlVATqnj+g8tYCGM7P8
	 Fd5Eun45MljKi65tGjC4jFiZoXUUKzQ8XsJyE0bRIdgUixA86YIs2p+j6OqL4g9VJw
	 1/bg/tgFffVHv5o2rEm+CTr7Z5E45mfojreBcjjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <quic_congzhan@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 095/143] arm64: dts: qcom: sa8775p: Correct IRQ number of EL2 non-secure physical timer
Date: Tue, 16 Jul 2024 17:31:31 +0200
Message-ID: <20240716152759.631085026@linuxfoundation.org>
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

From: Cong Zhang <quic_congzhan@quicinc.com>

commit 41fca5930afb36453cc90d4002841edd9990d0ad upstream.

The INTID of EL2 non-secure physical timer is 26. In linux, the IRQ
number has a fixed 16 offset for PPIs. Therefore, the linux IRQ number
of EL2 non-secure physical timer should be 10 (26 - 16).

Fixes: 603f96d4c9d0 ("arm64: dts: qcom: add initial support for qcom sa8775p-ride")
Signed-off-by: Cong Zhang <quic_congzhan@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240604085929.49227-1-quic_congzhan@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -3605,7 +3605,7 @@
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
-			     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 
 	pcie0: pcie@1c00000 {


