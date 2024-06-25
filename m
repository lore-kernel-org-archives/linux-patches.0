Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1208A14A0BF;
	Tue, 25 Jun 2024 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309198; cv=none; b=aRbKJXNvPuYqlpHwvQ1eXKvva5cIW5u/cpoT3E+dD4CGufvZ+1oHjT7raGkf4hOdwiHVQVWOoB1ghNkouRyEGI82u8vJm9dzlo969A6+AzRoNqrd3JsuxLvfKD/iC+4qU4rvo/U75oIJ33w5rvBlY1bL7+0msuedLqk3/f9jmpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309198; c=relaxed/simple;
	bh=KaFLL1AC2VPgk9rLEsxlVVGEOvv+BU45fRdDT+bvLLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw+/WS//TytWyCXVcGBX7ooXuEKGjdb/FiCPjAzNPaWkkThM1pYbGfnBnxJ2m1l2pT8cp3pGjbaaf+HxUgW/1VTlHTjfyHPagLW5ZkSi6GHbiP7oDgknS8mlfiha/fH8Dm9cgWTYdxfj1GZt1meOBtxPVrn593L61nnL3LOBBYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkdOoHMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkdOoHMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891F3C32786;
	Tue, 25 Jun 2024 09:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309197;
	bh=KaFLL1AC2VPgk9rLEsxlVVGEOvv+BU45fRdDT+bvLLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkdOoHMgAn7rc57oPxtys0Kigx49ZjP0g2udlg+Sg7AdNzfeLauSsSuKSumMlHkZN
	 mE/1wAu4MGVZnNy14i3eHz1Q8MyNH5Kfv2SKRKKP9xpq7nkhUM2wtTYNkgTBxM0UsI
	 Oraex2oyDFFWEmYnMOPe/nKUD2S9mox7da51916c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Shawn Guo <shawnguo@kernel.org>,
	Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 6.6 129/192] arm64: defconfig: enable the vf610 gpio driver
Date: Tue, 25 Jun 2024 11:33:21 +0200
Message-ID: <20240625085542.113667869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Martin Kaiser <martin@kaiser.cx>

commit a73bda63a102a5f1feb730d4d809de098a3d1886 upstream.

The vf610 gpio driver is used in i.MX8QM, DXL, ULP and i.MX93 chips.
Enable it in arm64 defconfig.

(vf610 gpio used to be enabled by default for all i.MX chips. This was
changed recently as most i.MX chips don't need this driver.)

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/configs/defconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -623,6 +623,7 @@ CONFIG_GPIO_RCAR=y
 CONFIG_GPIO_UNIPHIER=y
 CONFIG_GPIO_VISCONTI=y
 CONFIG_GPIO_WCD934X=m
+CONFIG_GPIO_VF610=y
 CONFIG_GPIO_XGENE=y
 CONFIG_GPIO_XGENE_SB=y
 CONFIG_GPIO_MAX732X=y


