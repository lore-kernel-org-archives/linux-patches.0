Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E160248BA6;
	Wed, 15 Jan 2025 10:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938198; cv=none; b=SqmGH1vmfB5AD7+weLbsMnF74k76J8laMNwuJ42zHPxPwTEMxRmxPUJMJDpTA5yQqRzZLmosKfRhUqQ9/iZ02TPQI+L/HLLf2GtF1s+4Cr5P0utjTrPixhwpHe4fd5VhDAXYVLmhy5DQq6GtgT0a0osJpSEAEi2a/BlsR/X8S8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938198; c=relaxed/simple;
	bh=UsAxz5g1I9pYPYJDUU+7rfReVPA0uFQXdRwZGBfn9Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq+z5e8nJknJyxIiKdgAwQFe1pqpkFHcHEoUChe1xS2Yk5Xmht/Xac8Rgakh3rlqPxdoQDQ0MByCikNoU/cMMlsBEAzfgQ4PbS+sPu1UTEH0daqX/YnpBvcfYqqo3ugFUZ+tbNl6FP8iaK4gcW7XQ1SukRNtSx8k20lU885xgvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kvuf8iGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kvuf8iGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF38FC4CEDF;
	Wed, 15 Jan 2025 10:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938198;
	bh=UsAxz5g1I9pYPYJDUU+7rfReVPA0uFQXdRwZGBfn9Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kvuf8iGzYcA7kaAhc+Tb8bV2I4+nEdAmu46lUF2yVFcZIagcbS7cgR3B8cG92a1J/
	 Ut+/KeXaZP3uiAykRJBCEXD75M8heFa/i5AbOEql3MskJV305s6EjuvW+d7reEsiBN
	 ZZxXr5g7gxIGO9Q2RRsuchTSkQIhWzUQqgdhQx/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 112/189] arm64: dts: qcom: x1e80100: Fix up BAR space size for PCIe6a
Date: Wed, 15 Jan 2025 11:36:48 +0100
Message-ID: <20250115103610.921172468@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Qiang Yu <quic_qianyu@quicinc.com>

commit fb8e7b33c2174e00dfa411361eeed21eeaf3634b upstream.

As per memory map table, the region for PCIe6a is 64MByte. Hence, set the
size of 32 bit non-prefetchable memory region beginning on address
0x70300000 as 0x3d00000 so that BAR space assigned to BAR registers can be
allocated from 0x70300000 to 0x74000000.

Fixes: 7af141850012 ("arm64: dts: qcom: x1e80100: Fix up BAR spaces")
Cc: stable@vger.kernel.org
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241113080508.3458849-1-quic_qianyu@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2925,7 +2925,7 @@
 			#address-cells = <3>;
 			#size-cells = <2>;
 			ranges = <0x01000000 0x0 0x00000000 0x0 0x70200000 0x0 0x100000>,
-				 <0x02000000 0x0 0x70300000 0x0 0x70300000 0x0 0x1d00000>;
+				 <0x02000000 0x0 0x70300000 0x0 0x70300000 0x0 0x3d00000>;
 			bus-range = <0x00 0xff>;
 
 			dma-coherent;


