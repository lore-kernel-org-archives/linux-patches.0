Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF73198E96;
	Wed,  6 Nov 2024 12:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896468; cv=none; b=vGOogGTPu0/cJNRibKp9RVooy6mcA3hxuQ5RK/bSGeEnZpq4UfQ1xweQGNCQ3PetLUEToG2URa0kEnT8H+QfOofyIpJwJh95GgQrfz7SaI48UBDZnIOxSpnrS/QnjR1LJygtsPlzPjlxtMvTezGxf/9sxpVQqamSOzRXeOAdic0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896468; c=relaxed/simple;
	bh=BSeKeT75Q6r68kNEmA6TLJ9l0xkfJsiF+NW7dGJr/EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQIvDFH+N6QQUv3UnfMmw4HcYlW39oE9VcJMP+W+Y6rf/t7rR6Z0c+Srs+NSnHHx+J4J7a2MMa7WRhiLkO4M8RvEeL70Oz9jesVjrm8Eeooo9BULprQIQ6TaTG4hnQb4AduGEYOK7jl00/UAJOaRgDIjObyZ3XkHNDhlbjztOkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSZXnuKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSZXnuKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A81C4CECD;
	Wed,  6 Nov 2024 12:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896468;
	bh=BSeKeT75Q6r68kNEmA6TLJ9l0xkfJsiF+NW7dGJr/EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSZXnuKi2Ky9dBglY6W8qHMZcrs/Pj/4FKFFqHsuLF6GrfzRGajXkkC/ZPfEZYcNa
	 1Rl95HmXYqhAbYCQNWcarkUwxJld6BWyEihGFqAvA2XiLc3CrFBWtEozK6jZb4In8L
	 h94+e/vSaCd8Kmt5qFmye9LS5UdZvC5pZYJwn+PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 213/245] arm64: dts: qcom: x1e80100: Fix up BAR spaces
Date: Wed,  6 Nov 2024 13:04:26 +0100
Message-ID: <20241106120324.498382303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit 7af1418500124150f9fd24e1a5b9c288771df271 upstream.

The 32-bit BAR spaces are reaching outside their assigned register
regions. Shrink them to match their actual sizes.

This resolves an issue where the regions overlap and one of the
controllers won't come up, which can be seen in the log as:

  qcom-pcie 1c08000.pci: resource collision: [mem 0x7c300000-0x7fffffff] conflicts with 1c00000.pci dbi [mem 0x7e000000-0x7e000f1c]

While at it, unify the style.

Fixes: 5eb83fc10289 ("arm64: dts: qcom: x1e80100: Add PCIe nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240710-topic-barman-v1-1-5f63fca8d0fc@linaro.org
[bjorn: Added note about overlapping resource regions]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2895,9 +2895,9 @@
 				    "mhi";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0 0x00000000 0 0x70200000 0 0x100000>,
-				 <0x02000000 0 0x70300000 0 0x70300000 0 0x3d00000>;
-			bus-range = <0 0xff>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x70200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x70300000 0x0 0x70300000 0x0 0x1d00000>;
+			bus-range = <0x00 0xff>;
 
 			dma-coherent;
 
@@ -3017,8 +3017,8 @@
 				    "mhi";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0 0x00000000 0 0x7c200000 0 0x100000>,
-				 <0x02000000 0 0x7c300000 0 0x7c300000 0 0x3d00000>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x7c200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x7c300000 0x0 0x7c300000 0x0 0x1d00000>;
 			bus-range = <0x00 0xff>;
 
 			dma-coherent;


