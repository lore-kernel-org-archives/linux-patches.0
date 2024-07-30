Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D26E1A6192;
	Tue, 30 Jul 2024 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359162; cv=none; b=nEfrwzk0XMpKZ3HcQQ5oXrlAhNXOslydxCyQW8nPmPOB9IsbcsSi/x36Dg0QWBEkRQPqtmbs7AtYsNbls6RdTFHRo7QmJUy+YxoRR0jpMHb3MwEhDKMBplh+iHuV6iJNwPLe+P1Ekytq1H/iEeD6sE8ean4JbtFUSzSW8NObzqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359162; c=relaxed/simple;
	bh=jZsIbgySb1Rhwwfbc89WQ8nev7no0LuM41J+HtUY7Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5W7+NgMaA+lVHoBxPgKwo0cZ1ArB1i22k85EhmiarIX9rVhtXtxDfLS6UrIU5M9zvK5O3mPiyNfxDSi7gTWhElh/6TiZEA8lwus7L/tiks07YjPzDLSOdxiC3DCZadnRlvlja9GbJEDzhtg5ASERjvJE5w1Xi12opOnyfd+FnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgTDz9Fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgTDz9Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E617FC32782;
	Tue, 30 Jul 2024 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359162;
	bh=jZsIbgySb1Rhwwfbc89WQ8nev7no0LuM41J+HtUY7Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgTDz9Fw7Zf/lW5tr83gVvAP+/2fDsXbHuiAjiPjPsLZ/wf/q+Oh+nUuW3GvF4Y4t
	 tUV/kV/MOsqyh0JMKeWlCnTpzmcG+E88swvUTQEnskySyc83oQkVDTyDIuHxMO7WL3
	 Gp5fmceNikQxTnAtQU2Z1iIWe6EQHrZRMTSTwDtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	David Lechner <david@lechnology.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 441/568] clk: davinci: da8xx-cfgchip: Initialize clk_init_data before use
Date: Tue, 30 Jul 2024 17:49:08 +0200
Message-ID: <20240730151657.109019436@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

commit a83b22754e351f13fb46596c85f667dc33da71ec upstream.

The flag attribute of the struct clk_init_data isn't initialized before
the devm_clk_hw_register() call. This can lead to unexpected behavior
during registration.

Initialize the entire clk_init_data to zero at declaration.

Cc: stable@vger.kernel.org
Fixes: 58e1e2d2cd89 ("clk: davinci: cfgchip: Add TI DA8XX USB PHY clocks")
Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Reviewed-by: David Lechner <david@lechnology.com>
Link: https://lore.kernel.org/r/20240718115534.41513-1-bastien.curutchet@bootlin.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/davinci/da8xx-cfgchip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/davinci/da8xx-cfgchip.c
+++ b/drivers/clk/davinci/da8xx-cfgchip.c
@@ -508,7 +508,7 @@ da8xx_cfgchip_register_usb0_clk48(struct
 	const char * const parent_names[] = { "usb_refclkin", "pll0_auxclk" };
 	struct clk *fck_clk;
 	struct da8xx_usb0_clk48 *usb0;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	fck_clk = devm_clk_get(dev, "fck");
@@ -583,7 +583,7 @@ da8xx_cfgchip_register_usb1_clk48(struct
 {
 	const char * const parent_names[] = { "usb0_clk48", "usb_refclkin" };
 	struct da8xx_usb1_clk48 *usb1;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	int ret;
 
 	usb1 = devm_kzalloc(dev, sizeof(*usb1), GFP_KERNEL);


