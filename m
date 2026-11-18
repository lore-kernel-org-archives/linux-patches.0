Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024436;
	b=WyjxHryHEWnQ+mJVtWohEwCi8ALB6p2r6/07m2z3W6j6Vp8q6fz6mWASc0uUfu7/8UQG
	 yGhcJSHf7GD9xHbxk5TS/fCJ/+vrXqRkKNsl9RLyWeiQNtWjEjItqHDIyV5mRycCMo129
	 oQC3ZHyHQi1PK/K1DlCqerVwzLNGKNnBAy7dvNg4D5QmwawXyX6AeUR2azjij8P/qFZln
	 myMR1dS7MU+Xgg1QuKwLoHPpvNd13jfAEwKx3uV8Zw1rWlBbRdH5P6DXrBXxyBjU0tEas
	 RGaI2YD78yLwXcFhVI1XQGDWnW1QyUs3tlzZM+Fk3FbEVAC015JaBucLpqST3V7GNBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9MZDBbXml30jY8EeMYhQ51+gSBwslf7H2O0qtelD3YI=;
	b=EcEtAplcb0TCSNLUllAnTXGPjUcLsLuYmPsm6J1uQlkMIPP8f7MXZAnc/vdijM5Iux/U
	 Tu4NFIzNX8SEAUAskJZ89RF2OFAItTb1wg06+d+yGa2FGpXOw+rkZ0q22LUdTgDdSIunb
	 QliWrVqQIBm7B15ilFH6T1tkWBmICzPyIakMI8g7s6GmG9UKl9TBtydp78fajhbQxaUnH
	 /Is+UIZ7mF3YHGvI5Tj3byVn/BQQ35VmN1kjFVUTJnpPKZWl9ezPKS5S/O39lYS0h/p0X
	 EeLRWbw3DcMgUS6F1DhtjDXfNpTK3uIu3qZy2LEO+lHEeEnDENrswOADDRHMwok0PJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LqDkIdH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B72606A31C;
	Wed, 18 Nov 2026 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LqDkIdH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283CB1F000C4;
	Wed, 18 Nov 2026 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024436;
	bh=9MZDBbXml30jY8EeMYhQ51+gSBwslf7H2O0qtelD3YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LqDkIdHc2C5Ep3SWCCP6QpOEnqLd+YL0JLVwgdIDMiCz2ktu1yPVg7SWDDLgeyEo
	 nikTNIK6LAFZUjcEQUbwsFZUnYLNF97Qn1KjW9OhtlhxT495UoEQ9oUL1MeDSUsLka
	 yBr76amtPRRlgpSxoepkfyCWG5UwDZkft7Lenr9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0724/2151] arm64: dts: qcom: x1e001de-devkit: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:40:59 +0100
Message-ID: <20261118150148.413588448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 0297c8e98a054fc2a0afcb96114f57603a02594e ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 7b8a31e82b87 ("arm64: dts: qcom: Add X1E001DE Snapdragon Devkit for Windows")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-2-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
index 701f35af7d5cd..bc15a988f3011 100644
--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -1188,7 +1188,8 @@ wcd_tx: codec@0,3 {
 };
 
 &tlmm {
-	gpio-reserved-ranges = <44 4>; /* SPI (TPM) */
+	gpio-reserved-ranges = <44 4>, /* SPI (TPM) */
+			       <65 1>; /* EC reset */
 
 	eusb3_reset_n: eusb3-reset-n-state {
 		pins = "gpio6";
-- 
2.53.0



