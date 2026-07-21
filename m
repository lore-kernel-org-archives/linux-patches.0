Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A201356A12;
	Tue, 21 Jul 2026 20:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666821; cv=none; b=IZudSM4Aw+XFkGk9Afuve1QX1NMKdlt1YDDcpq3bIGjr1z9ru+sN0cEGF2XskmX80fuUmwRNHZJUoEODLBilGPOF1YZZMgUI0+r8x3fb++A/3QTGzul5Sa1iI4g3PJjvSi8rfKnz6eTsQOBcmGDG3uzuqnG6khwF+cQewvUvf6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666821; c=relaxed/simple;
	bh=nQ5l7u7tT5d70rmepKIR8wJTaE9Oqz0EerMtqk2fVwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndgEUKHOFEsuAeOC1mnaUhjLFVlTYtSGDFFWmTjROQTV7jMjXEY+JKxOyoOugh11YOD2CxZwmVoT4dAy5jG9s5xx9YDctB5BWgHJlsKBZ0Q+jOCrm51revxMPSgQ1FUeJFTeQEcIHKuMIe8+DG1/9I1VG2/TwEK8V3MDl+P3tgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ1SKCGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ1SKCGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE8C1F000E9;
	Tue, 21 Jul 2026 20:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666818;
	bh=66Siu9Px2ziC2It/rb54BPWaax1OXSVh/07Cc9SD7xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZ1SKCGJq2PZ/EqXliicCDjHEYsbXLZPArydRS59YFppKpoh71r4VHhK4vEjxWekX
	 t+2FzA/QCLqG6txANPwz7VUdpX5Yag4U4f7kVPdSYljZ0QqaF2WC+g4WMq94wQh7rF
	 ZkV5TfSSiIqocmzoYBvRyMir4/z+/8zgOcoYaKgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0825/1266] gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
Date: Tue, 21 Jul 2026 17:21:02 +0200
Message-ID: <20260721152500.316013592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fad97979748653..c40fb5ec93e6bd 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -228,7 +228,7 @@ static int timbgpio_probe(struct platform_device *pdev)
 
 	tgpio = devm_kzalloc(dev, sizeof(*tgpio), GFP_KERNEL);
 	if (!tgpio)
-		return -EINVAL;
+		return -ENOMEM;
 
 	tgpio->irq_base = pdata->irq_base;
 
-- 
2.53.0



