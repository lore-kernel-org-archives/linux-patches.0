Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017292;
	b=FLyKEts6O0xdaAnTSdxuzN6wUQZ9X3++38OLWQnguuItiVBgeNbj04z8c70LrM3sb9Az
	 fdOFFXliGb4hJPxFfG5RSpeHKCe1JzFuE3P7QnThU4Hvyb6CFqxfvIfb0nHh5X62ApF92
	 2wq8PbjM2gcDW4dtehba4YEc28Npw7gtyq0L4Qgfr+n28aAmCB+2YRhE/0YtJ7WLiLpYX
	 RyN1vsYYtJHpmTHMzyxB1zFmU+tlNzGJsGeGA7XaWhx4X4vHiNujH3tE8z8ZcPlueSv57
	 6vBkvZDEtV9lMVzR7quT6A+Y2j0/kmOsUFtopojkXJoNBpoBHYQ6FUnetldYORnFHEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pc0qcYEcYYH486QX3BIAYkuEAK8vITdHbiuaZXLnsTY=;
	b=tcmvyIAbu/4QGRFU0rZJTvA8jHxMAOblyaCt8Z5/h45SsGvqAePW9lG+xKmBZtfvmV8g
	 PdTLVVOSjDa2FSvacy0D10g9Jj2eP1HVFK9cBVlbKq1j4t+ubewjhBovm9Zf5SXCmqB0Q
	 efZwnEvSqcdI1pc8U7/+wqWIBMkjQzXJ0UYr7DRun/xbLlJGBbyiH0ND3K1UwY/RgRjCr
	 knrOTJWhkyRzBlqy6sZdEH+jIiWOSH8FMkf85gnQpGwJ6iuoAOveGBt1Edqyqx9meB4I+
	 btJYOd/UkxXI4JDu+9X+kTUs0XeUpK5o6ZjdNNoqSE6Ca8XMdIRmaFUSN42omCOK6BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZQpnYNY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D672606A320;
	Wed, 18 Nov 2026 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fZQpnYNY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410591F000C5;
	Wed, 18 Nov 2026 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017291;
	bh=Pc0qcYEcYYH486QX3BIAYkuEAK8vITdHbiuaZXLnsTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZQpnYNYXNIEL6ny438w3o+z35agZpu3E9oKZwto10y1KL58cwbHtT9o0Rj9Dz4bc
	 DI8gA08qIgAsLN3y1j4EhAOujEIx/yTyCgGwKJTC2/9VDCmgnk++A5E1WmFVVwdhru
	 OcgSGYMS4w6o3Vd+h58FPgcnrn0tvSrRdXoEFn+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0833/2651] arm64: dts: qcom: x1e001de-devkit: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:33 +0100
Message-ID: <20261118150317.871642858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index be1a8ac8c699e..3ba45a7884a23 100644
--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -1194,7 +1194,8 @@ wcd_tx: codec@0,3 {
 };
 
 &tlmm {
-	gpio-reserved-ranges = <44 4>; /* SPI (TPM) */
+	gpio-reserved-ranges = <44 4>, /* SPI (TPM) */
+			       <65 1>; /* EC reset */
 
 	eusb3_reset_n: eusb3-reset-n-state {
 		pins = "gpio6";
-- 
2.53.0



