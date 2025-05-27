Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2BC1AF0BB;
	Tue, 27 May 2025 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367658; cv=none; b=VAfAxYYHw36aHt9g6/8o7J/YMs83dhLoHW+vqoSAGgPN0jfH7HFoImPgp7BMNCEkjKbpirKKenzS2RycHg9WNAnlBfne5+jdkEFsIt4LVO+ne2izfRoOmZcq3aQsESRYg5rWnxdFAQtpagxZWp/DLjogtf1HdgmVC/vIQ+ElIVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367658; c=relaxed/simple;
	bh=Cj2YllWeZpmfPBousj+Ie4ZifmdblZpRNVFmq9JpjE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9LXm7yRd9Se2mkMEZSYnFt73/E5/RRaESVXE3zw88wxhgu07qkzo8Ul/30Z64ABzQr4zEi1yi4zlkhJTyStx0iK2qP+wNsI8FvGHyRGzoESWc2JBtBep3cwxrq//pQGmjE78+89Fe/jqwJzeW67pxQdk9rulKtKlmqg++1aPLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEfNB1G2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEfNB1G2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCC6C4CEE9;
	Tue, 27 May 2025 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367658;
	bh=Cj2YllWeZpmfPBousj+Ie4ZifmdblZpRNVFmq9JpjE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEfNB1G2Xt2z+uu9FnVV9r79+FdfY/RLHvPAuwWfGshydpsc0noTXQ6ZfnwRMoSeW
	 mED4Majop1r8xMeqocNl1DHXMaOI9YIHcbvcg+yAIfCa8/nbh269J4seLmqv98/anQ
	 JHHtUnMvfxs3HB+HCrQSDO3Xiu6LExLCuV5pL3nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Chan <exxxxkc@getgoogleoff.me>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 458/783] clk: qcom: ipq5018: allow it to be bulid on arm32
Date: Tue, 27 May 2025 18:24:15 +0200
Message-ID: <20250527162531.774794611@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Chan <exxxxkc@getgoogleoff.me>

[ Upstream commit 5d02941c83997b58e8fc15390290c7c6975acaff ]

There are some ipq5018 based device's firmware only can able to boot
arm32 but the clock driver dont allow it to be compiled on arm32.
Therefore allow GCC for IPQ5018 to be selected when building ARM32
kernel

Signed-off-by: Karl Chan <exxxxkc@getgoogleoff.me>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007163414.32458-4-exxxxkc@getgoogleoff.me
[bjorn: Updated commit message, per Dmitry's suggestion]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 69bbf62ba3cd7..d470ed007854c 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -217,7 +217,7 @@ config IPQ_GCC_4019
 
 config IPQ_GCC_5018
 	tristate "IPQ5018 Global Clock Controller"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARM || ARM64 || COMPILE_TEST
 	help
 	  Support for global clock controller on ipq5018 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
-- 
2.39.5



