Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAA23B8120;
	Tue, 21 Jul 2026 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673041; cv=none; b=TcjbhRCG3UrLiBdz5K+++pNBwy0GpTxUY3IZSUkLynL1hWIrrdHdWkY55glCRVgvpmZb4a4J6X13JXSdHIwbfX8HNy6UQewEqwRPtge+jgv9dmc92xd3NOKTqKn3svpbTgDhbbNiEiJksr/Lje0bvbRFLzsjFoC05BmWh3MY+aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673041; c=relaxed/simple;
	bh=n0bdagc+6GMscDlzDDeORL2O8g9lZWol89LE5c1jJG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcHuhd4TS7WCnUGE7kVzRdjNjKE324wJjdqFwBo4u4zebfN5sML7CzPGi2epRFUzskYq8+qbPzuF4GG5okSJh0gBV4/X+LEbX0IPSbZVaerzt6UiEQi6mBja4rpFbEaCBmpLxtK2hkHudDuhxWHjZOKPCme/glnpGq+iM2xgtPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XE2KRfFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XE2KRfFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9031F000E9;
	Tue, 21 Jul 2026 22:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673039;
	bh=YJQ1IIiA2AdAjtIwypUl+yfV+RhipLXGidLSmRUrKqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XE2KRfFxaFq4ZB7V9IHSSIEhZm5Y1v11jux3lNyX/gPc9aWRPp02+ZhqQmDt9/bYX
	 MX1tNnFPxzoQJOf+gaXT5GY13TADGBvNTrAa9jhxxkh33sMYv3kwIyRXCSe4AlKpzX
	 5YJ1p7xmwMY19hB1QZJvLqMzh4OsdSRasjmhhcoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Abel Vesa <abel.vesa@nxp.com>,
	Alexandra Diupina <adiupina@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/699] clk: imx: Add check for kcalloc
Date: Tue, 21 Jul 2026 17:16:04 +0200
Message-ID: <20260721152355.798686117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit ed713e2bc093239ccd380c2ce8ae9e4162f5c037 upstream.

As the potential failure of the kcalloc(),
it should be better to check it in order to
avoid the dereference of the NULL pointer.

Fixes: 379c9a24cc23 ("clk: imx: Fix reparenting of UARTs not associated with stdout")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Link: https://lore.kernel.org/r/20220310080257.1988412-1-jiasheng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index d4cf0c7045ab27..be0493e5b494e6 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -173,6 +173,8 @@ void imx_register_uart_clocks(unsigned int clk_count)
 		int i;
 
 		imx_uart_clocks = kcalloc(clk_count, sizeof(struct clk *), GFP_KERNEL);
+		if (!imx_uart_clocks)
+			return;
 
 		if (!of_stdout)
 			return;
-- 
2.53.0



