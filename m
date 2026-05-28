Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DF133CE8A;
	Thu, 28 May 2026 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999289; cv=none; b=bHnwN5mPShM/0Ti+EGyc2edVk9Fsc2oRGrXdYct372YAoe9Oi27qoWK6ZYbguUEDi09HvtP88Rddiq77N8rbThJ89NULbH2HOnqXsDs5AMmFO7+cxfoxGevUGG5+McDwYhpmF9+c3GaEThErLXJZUETZIPgl1sMy27FdHUyoY5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999289; c=relaxed/simple;
	bh=oR1Kk6/JXg9Hd/wdh/HjJg4uoD45ObtLfLD+tnD4Jdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abhf4gV/Eoya24o3EOnHPp4dvCe16ntlEXQfwGeOJ9un3npy8mdfUHwDhC05CQKAliyzR/XsCD/PGsQ33EVXw6b2fotEM0qx35lFXeFQPNOOMghI4vzduN+rGYWJYpfKczyHg2tcJw7E45pgzMD3QETFbQmuyw+QJ90DP7Y1g2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPcOd6H3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPcOd6H3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13361F000E9;
	Thu, 28 May 2026 20:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999288;
	bh=574SU6Dq6ivuDEqZc4Q2XoBZjXNPZ7b1GWE5pm5c9F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPcOd6H34JOQz29i472Wc9KaQQIZKDCLyLyJPmzehjXONmQweIf/yv3vWgMwke+94
	 J/J2+3sLaEsgDkhDOwYrAQWQJ/9oEec64MeDwhJJ0b/1xRHgNpGzcQ2tLKl/OW1WC6
	 pvNBf3ttD6nTM/oIBMt2yvSUILoovInYCVloFGj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.18 014/377] mfd: bcm2835-pm: Add support for BCM2712
Date: Thu, 28 May 2026 21:44:12 +0200
Message-ID: <20260528194638.799893287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

commit 30ed024fb0768e9353f21d1d9e6960b7028acdfa upstream.

The BCM2712 SoC has PM block but lacks the "asb" and "rpivid_asb"
register spaces, and doesn't need clock(s).  Add a compatible
string for bcm2712 to allow probe of bcm2835-wdt and
bcm2835-power drivers.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250917063233.1270-4-svarbanov@suse.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/bcm2835-pm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/bcm2835-pm.c
+++ b/drivers/mfd/bcm2835-pm.c
@@ -108,6 +108,7 @@ static const struct of_device_id bcm2835
 	{ .compatible = "brcm,bcm2835-pm-wdt", },
 	{ .compatible = "brcm,bcm2835-pm", },
 	{ .compatible = "brcm,bcm2711-pm", },
+	{ .compatible = "brcm,bcm2712-pm", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, bcm2835_pm_of_match);


