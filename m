Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D1C17623C;
	Tue, 16 Jul 2024 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145767; cv=none; b=pJXofLK8hfPNCUZkltW5prjxT2Cn4rEeRbIh1vO/LoMiZNRzSD8057yjChEPmrRhW15pLgPU9s+U5LvWlPqKPMVNPkb7rIe6nC2O9WxeEXuPa9GeGOJf/n3I7HA5jggW61P8nV/yZHwAHpYShUPfZ5HGXuhzBLnI5TL+2Y8GbJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145767; c=relaxed/simple;
	bh=K+dXzT6GrFkMr3jX3Sq8oMtdVJ4F7aAtv6D/FGfEYkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlK80pLeO48Mww7Mjz+YtpzYuPYTXohv1HGN7oD/xrAwdwIID898CO0bCINgB5FRVpxFk8YoTBSCQIRqIhigIAK4KvUZV/EqFSOt2ZQqWcWCRcW75U+T2bUUfiwHsmyEQgVvczHOrmDEpWs4MB8VkCtQXud6J4dVEXBPK7LCgvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKrVweDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKrVweDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F430C116B1;
	Tue, 16 Jul 2024 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145767;
	bh=K+dXzT6GrFkMr3jX3Sq8oMtdVJ4F7aAtv6D/FGfEYkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKrVweDimP9ujkygcv+4Ticfq1S/HrXESGb5VgAoTO+Q2QYTwDk/u1fMQ9RaiBeb4
	 +6513j+u0eKlW3kqbsdxmyHUApWgk1FwEdWIE22eDSQyH1GsDcwVyFjwDWyDdyLgkJ
	 hkDwsR6bUE18CaiGldTYrg3CnZfLK2J56dXmRTCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <quic_congzhan@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 077/121] arm64: dts: qcom: sa8775p: Correct IRQ number of EL2 non-secure physical timer
Date: Tue, 16 Jul 2024 17:32:19 +0200
Message-ID: <20240716152754.290855945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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
@@ -2398,7 +2398,7 @@
 		interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
-			     <GIC_PPI 12 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
+			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 
 	pcie0: pci@1c00000{


