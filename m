Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016820;
	b=z8MsiBmsoLZ3ZXx1KezlmJRgEj6PFh3po7dIBGBE8eEgsrrHXNhDuzG4VQ+8uiC0IobM
	 3rUvzJnkA4JigJ3HbgEGQNnSiBv/99Rsy7mqO7IVt3LvSFqHjU3mmUcTwurJUuGyNVBMb
	 ZRhVCXLo/X1HWLpvQkKjQgELCOcWvjXy2076RBI9pT8TsET50da1PLNudzWJnOXi8Zmmi
	 LU5hRlyCxq4AywEPU8dncz+BnonynhsyhclIVZ16P5XqAiVjpn8C0L9qkW3Wgr0N7AuRh
	 RlHcCCQ3sXVFVpTSTocl6mwqg1vVWnokuudaE+lTJII9wq9BIrrCUSAQBfumClXX3iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=606m3cbCxziK6WfiLS0Mk9dUo0+28R81y+/dD3sshbg=;
	b=38mqHVWzzx8dxcB2KZbXwR0S66k0xgnp9uFfLVgbnBDIciw2vhP+lYL7pSSSYpzBXU4M
	 0PmIygRBQlkVKY5Bxa4l800cjhFobUkAafMIXFlZmSc1qNJfRiaRGhNrs7iFvGiVBAndP
	 ePvYwdp4s7+W31ICO6cliOJs0NCs4JRLsjAmM8esVlGz7HPOSTOz53vjH+3fqj3HYoILq
	 tHyp9wD+jTLVa2gtnWhIe2sXO7MKY5uLrAAB9qxQkCcEOCw6E8yUp5jq6Iz4FhFBrtexr
	 fYl76RQA1n1LPEshTjxEUem7edULiotMGphc9Qyud3BaQqzCM1GqO0wM+MGkA4r1jFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFg6p6ZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2894A606A320;
	Wed, 18 Nov 2026 15:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TFg6p6ZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5771F000CA;
	Wed, 18 Nov 2026 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016820;
	bh=606m3cbCxziK6WfiLS0Mk9dUo0+28R81y+/dD3sshbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TFg6p6ZTJ0WeO2PFnPTrNh3SjaDF763K1qSkdLfGjWzspDXV8SLL0+fKW9ce2Aodx
	 dC0oqVmjf/SJM8EJF8VGsol+kNBZGrU5Z3nQiYfMYopEtgcrP7/OnSv6mhk/z+JQjP
	 0Ovlt+DeSNpojjhxkkw+yparFSjJ/APFwVZKUNlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0665/2651] arm64: dts: ti: k3-am69-aquila: fix AQUILA_B73 gpio-line-names typo
Date: Wed, 18 Nov 2026 15:31:45 +0100
Message-ID: <20261118150311.817992637@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 558c01ff1d9dc1961e0e0a91e5d4bc07eb081d56 ]

wkup_gpio0's gpio-line-names has "AQUILC_B73" instead of "AQUILA_B73",
inconsistent with every other entry in the array.

Fixes: 39ac6623b1d8 ("arm64: dts: ti: Add Aquila AM69 Support")
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260914183516.28865-1-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am69-aquila.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am69-aquila.dtsi b/arch/arm64/boot/dts/ti/k3-am69-aquila.dtsi
index 5119baf62a4c2..b6854acee8fec 100644
--- a/arch/arm64/boot/dts/ti/k3-am69-aquila.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am69-aquila.dtsi
@@ -1573,7 +1573,7 @@ &wkup_gpio0 {
 		"AQUILA_B70",
 		"AQUILA_B71",
 		"AQUILA_B72",
-		"AQUILC_B73",
+		"AQUILA_B73",
 		"AQUILA_B66",
 		"AQUILA_B62",
 		"AQUILA_C21",
-- 
2.53.0



