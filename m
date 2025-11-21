Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBF264612;
	Fri, 21 Nov 2025 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731532; cv=none; b=H8jSprkM2oxniehCIs4671/MOzwTQOa359Nodb0uTPhIhe87NOjvNgqMQtxQpKn3plZHdpySHw7JUGb45bCoA1e5Bua3a5WpA5Knk+MgYvEDfjUf9zlc8Ye9P0b03bD+5Je7/s7g7kQU82S8cG1FResK5hnef40Djbd1/D1Ytfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731532; c=relaxed/simple;
	bh=daFoqM/iYbLnkc1sBKOFp54tKnTnjyew27Bl/uuTgw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY36fEU9YIUg1PO1Z9qnHavdBgOWINZTmdUTsnz1p9YBbWdKbUTkMsMGYVOugQZbPRHZd+/9iwIlbric6LQrlWMv5VvEhid1QI076aJ4hWSCbj2Uf0sOtl1xZlTqLjwvP9mN3JhVdbH6y+Nv3cxpieAD1tvrXRqX+JJ01pHSLAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McVdeROS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McVdeROS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8946C4CEF1;
	Fri, 21 Nov 2025 13:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731532;
	bh=daFoqM/iYbLnkc1sBKOFp54tKnTnjyew27Bl/uuTgw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McVdeROS/+0ojI2JZwGM9ZapqoiVlRPp0bJHftB2tnFXHmxu7jG7QqadmVMz4Z3ty
	 O64hzSPHe7/MY8OUOBRGnRIii9tXqpBTv0O4EHTQIsguyYvTXHUPydDHHldauZoJGx
	 7ijywlEYq/5D0lmjpzpgRy6hEg3sKYUwAhIP1vEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 241/247] ASoC: da7213: Convert to DEFINE_RUNTIME_DEV_PM_OPS()
Date: Fri, 21 Nov 2025 14:13:08 +0100
Message-ID: <20251121130203.386888604@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2aa28b748fc967a2f2566c06bdad155fba8af7d8 ]

Convert the Dialog DA7213 CODEC driver from an open-coded dev_pm_ops
structure to DEFINE_RUNTIME_DEV_PM_OPS(), to simplify the code.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/0c001e0f7658c2d5f33faea963d6ca64f60ccea8.1756999876.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 249d96b492ef ("ASoC: da7213: Use component driver suspend/resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/da7213.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -2247,10 +2247,8 @@ static int da7213_runtime_resume(struct
 	return regcache_sync(da7213->regmap);
 }
 
-static const struct dev_pm_ops da7213_pm = {
-	RUNTIME_PM_OPS(da7213_runtime_suspend, da7213_runtime_resume, NULL)
-	SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
-};
+static DEFINE_RUNTIME_DEV_PM_OPS(da7213_pm, da7213_runtime_suspend,
+				 da7213_runtime_resume, NULL);
 
 static const struct i2c_device_id da7213_i2c_id[] = {
 	{ "da7213" },


