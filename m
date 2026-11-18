Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017302;
	b=AHJ0Tl19aAhfGZE0xFVeIWji7wgvhZFgJCubNn9DHTxARbga3bOGWzg6EeuyZpXznIFx
	 sM2S9YCw+zpm79Y9ueARAyqlrl4gCskEQZr7zRP2tT0CMhPI7aajg0StHYaTq+NWzJRyU
	 UtCLStiRkmZ+8kwb8lNF2n95hCK25zLjx42tRi7DPQmd7TcnHOuCV0nHibmPw2HwY6eW5
	 cmMTxOUD0SLtNH11g3Lk2FVKxKaXTR5jSWFn6+QNnoNEI9+zv03fsOUmFG5qC/eNz1sbW
	 H9jHXnD+toklPdJT91DB1RzZF5Gs8mDAP6XtO2hcmNeW4cYc8b/sqteiRFL0Os8O1RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v4PRRPCVIj0PTlpKi4Ei8BfBTotLymnIajXbJcmTZDg=;
	b=BJcqkogLhHFAL5hDQOp89n9te4ZeKYJh6WqE2JVfkXirfb/MtXmr1Lif8ya/sG6P1WXs
	 g7czGaTGrPs8Cyzr93Jk7zu1ygpaUQ0+G9E0xUJCAtQpqrydBYWACf69JXtx5j/r5o/qI
	 pTr0t+I5aUpzV9FegFcGjOi69y4xetrMGSbjSc87eKGmFIiuB8Yvu/Jl2/G0xMFsdJv6y
	 Kk6PEeboVvflHX5l8wvMTR29/Nx2ScsE2PdNhwZLzMMVX4ty4myiV3QvT8VdBNq8Ym9LT
	 fcloTp7MRJixP8LtUBX8Fs+zZKEqx4sqGvY7x8iRWoYF/l7QNkEmSG8Y7CWvVi+T+lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gg4qFbpv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D975B60A2604;
	Wed, 18 Nov 2026 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gg4qFbpv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654F81F000C5;
	Wed, 18 Nov 2026 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017302;
	bh=v4PRRPCVIj0PTlpKi4Ei8BfBTotLymnIajXbJcmTZDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gg4qFbpvubfBbrDeC/MeTXTqTixZxHqT/8xblHZy6VnKs4pfWJpj3dnQYUnbpwvC9
	 MHyZSyrWQCMC/wkEKLr1gqvL7L/3Jw2mvBo7MCkSVEAh3nZteacanBSjj4disy+PbW
	 e8BuUg0U9Pv3lal5sWZLg0ETKiEmv+frC8inLvCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0837/2651] arm64: dts: qcom: x1e80100-yoga-slim7x: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:37 +0100
Message-ID: <20261118150318.012425305@linuxfoundation.org>
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

[ Upstream commit a92ac66d35dfd8438b6e40bfb956ff69365798ac ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 45247fe17db2 ("arm64: dts: qcom: x1e80100: add Lenovo Thinkpad Yoga slim 7x devicetree")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-6-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
index 9eb2dfd99f20d..3e4ab58d2f6f5 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-lenovo-yoga-slim7x.dts
@@ -1350,6 +1350,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



