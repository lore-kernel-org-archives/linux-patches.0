Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE8F46E015;
	Tue, 21 Jul 2026 18:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658043; cv=none; b=pE23JmAkv56WYJBBbT1q+XlbmAH7+toRj4cYaeMQVsFOHWsDRd97G2UWDrTVgNJaONXHlUm+Zw0ovRazWf1WYly+acUJ6YxKuAX9QyBv70e7wb0SVlcp7T9CHTShyAD5Qv3t8Dp1wq+Y+cTLTfSa6NuuwgUdeIMFJut88kbgLBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658043; c=relaxed/simple;
	bh=t2VbMxUPlwbdlRguOFJYy0YJMwDW/Dprc1W0nyVlytY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2b8rDT9oaFNQkyqLCVYqI1kL9IEz0BKQBnmbGaDH5OFavpAbBIvdx8ktntjNEMkMUUtS2bV8dOk+HijV1r5F68k1CafeE606gvu4C3qLGFmH7f1Lf7bE2bkUHp9vM5tz6oqd3M8tN+XtUf/NzrEneGeKb9m85ZhgxWt2b5CT78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uErQf4Dv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uErQf4Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4DF1F000E9;
	Tue, 21 Jul 2026 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658042;
	bh=xahLY+848P64qBm1+zP+8axxTFZ5WBcRBv61tbfx9hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uErQf4Dvwvoz29mrAphDjHIKc0QaEoy8STFVc97CUwRSoAAV9z5cQbNmgKlWJddw9
	 LrQdRGzH0pNGp2NpP2UaGlHG9qH7MkMCOId1kkeOhNdTsJ/Vn9zOCTajJ7m55lZvSi
	 QEVHXeeprKtbd9oc1irsuZR1X8uMJyfgw2L2zqz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0994/1611] gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
Date: Tue, 21 Jul 2026 17:18:30 +0200
Message-ID: <20260721152537.749858804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit 8d7e62d5e9b2d2ff146f472a9215d7e29c7e2307 ]

Out of memory situation on driver's probe is expected to be reported to
the driver's framework with a proper -ENOMEM error code.

Fixes: 35570ac6039e ("gpio: add GPIO driver for the Timberdale FPGA")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Link: https://patch.msgid.link/20260630145148.4081967-1-vz@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-timberdale.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index f488939dd00a8a..b77c9d16fd166a 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -235,7 +235,7 @@ static int timbgpio_probe(struct platform_device *pdev)
 
 	tgpio = devm_kzalloc(dev, sizeof(*tgpio), GFP_KERNEL);
 	if (!tgpio)
-		return -EINVAL;
+		return -ENOMEM;
 
 	tgpio->irq_base = pdata->irq_base;
 
-- 
2.53.0



