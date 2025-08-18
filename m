Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051B631AF24;
	Mon, 18 Aug 2025 12:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521488; cv=none; b=mn0SeNPp1dwPJd3DYBQptbJ9TV+tLRB1KJk4OT+FNVNnYoS3g86+Ey+3V/ruBnL8qhoJK7MhbePXdkx2agMMRuEYkr42zEP08hdL/xF1RBhsiJ6x7783SqiMBSHwuXyBInHBHgj7svRmjSSiCQZrw5xTNtYzAgDQJtatyS5gHJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521488; c=relaxed/simple;
	bh=bCnD/Dm2UD+YjqOfhy0V6Z1iBr7yAjvstvJlNRaNWh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=peU/YHCTKaV/CtDQ0jw8kLvdbWZP8BiYZlpGMRnzZAtC1gDwdsQv6FWMaYyUPgkBok2FwIDJ7wPCnm9iYFih4yQnMSqAUANT8aiuS0jQOWQODWqOJWIUJ2ZdYH3/AZmk1BUAPlITZBUk03yur4zaHxVlZ3hBmYDa/dtHY/TIpMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLRlcjde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLRlcjde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684B8C4CEEB;
	Mon, 18 Aug 2025 12:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521487;
	bh=bCnD/Dm2UD+YjqOfhy0V6Z1iBr7yAjvstvJlNRaNWh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLRlcjdeRa7k4WnLPwXr0+KOt7ac0tjARNRK6Wbp/9yeZxBOOfyQ0svR3nFy2wxCo
	 dcj1TnKk3QsaWD8nzvOTuXBnM6GKAaBmzIQ6u/r7rsbrctsjutxEusbW6y2NhyRNYz
	 w6oIrYvDxyYGj144zXUx/WbOVFerzcqBtGt7vS2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 034/444] clk: samsung: gs101: fix alternate mout_hsi0_usb20_ref parent clock
Date: Mon, 18 Aug 2025 14:41:00 +0200
Message-ID: <20250818124450.209693971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit ca243e653f71d8c4724a68c9033923f945b1084d upstream.

The alternate parent clock for this mux is mout_pll_usb, not the pll
itself.

Fixes: 1891e4d48755 ("clk: samsung: gs101: add support for cmu_hsi0")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250603-samsung-clk-fixes-v1-2-49daf1ff4592@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-gs101.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-gs101.c
+++ b/drivers/clk/samsung/clk-gs101.c
@@ -2129,7 +2129,7 @@ PNAME(mout_hsi0_usbdpdbg_user_p)	= { "os
 					    "dout_cmu_hsi0_usbdpdbg" };
 PNAME(mout_hsi0_bus_p)			= { "mout_hsi0_bus_user",
 					    "mout_hsi0_alt_user" };
-PNAME(mout_hsi0_usb20_ref_p)		= { "fout_usb_pll",
+PNAME(mout_hsi0_usb20_ref_p)		= { "mout_pll_usb",
 					    "mout_hsi0_tcxo_user" };
 PNAME(mout_hsi0_usb31drd_p)		= { "fout_usb_pll",
 					    "mout_hsi0_usb31drd_user",


