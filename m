Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028866;
	b=YJwhnJ3Cna+Xf6yihHeEfaoN1r7YecmdYwT96Dt9UivBpVrR7LFRkLGArAAKOI+1LaeP
	 gnqH7ZYjm2MupAaQKaXaTMczhcyOUO1RPJaGJGH2de/SXsVhCbKEf+TeUK++qS2EQ4MWb
	 ye6MR3OM3CpNLggC8oOVQ/amZlzZpayUH8iSVB3nPm2ZSLncOR35ZI2m+pqlFU7IzoPx6
	 Zge5t8Ddn8mQrbkv2jpMfeMVbaj4nxo0MBaSL3yJPoR973RmGfIaqGzv2ORbqWp4AE5TV
	 fSJy5dPS6WtZiQe8Q87I0vX4te07ay2kZzvfe5wsYGLzcGSX4n/ogYt8pCNnLXmt6Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4AHzEa0KmjUCJxbQkBk72cmuhq46gZkyMybSR/aRwC0=;
	b=k0m6bc7nwAgQjd5eH9ozJIiJsTHUXuXC/fcus4TcFsTyG9Z87B3DHeJtDfDWNPDpvMNN
	 m+jBW/coTBJdBNGFiZzbXWmznr8ozx/t2VcSg1O15XSsTvfcrpisrRb+Qp+D9emN0Nme4
	 V9Hxw31UlwVRCcgtTKUJxMxVf9p46yGhDxumcxOK9zbedDlzzCZIJnWzRC315KaPuozE4
	 ts8Fq0nl+wG9tnqd7BWHfHBx6m+nwb4bFIKGTdWZjvzwQF2F87Jm8Q0nTRrceIgtnc0b8
	 fuJKIPY6hbWeAuejZMSfP0hbnTmuxFJ4MIfRcds2j+fuNwunG8lQZhmc6/0NsfGfLmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JziL7PcD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE0E60A2609;
	Wed, 18 Nov 2026 19:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JziL7PcD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3051F000C4;
	Wed, 18 Nov 2026 19:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028866;
	bh=4AHzEa0KmjUCJxbQkBk72cmuhq46gZkyMybSR/aRwC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JziL7PcDUfbi/tbTumw2zs0vxpasDuNy+sJKqTBii4V0+bfe8OFhKCxP19MdDyCeD
	 myAVMWRdCWqUy2ZwH7auTaHc9PEM64m1RQXit4fRMJhMWYr4KfoKbhM4R4iTZTIHRt
	 /jCHZrT4SVk2y4tB3B/qwSqE9QRkPugd64Ad2WTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com,
	Chandradhar Kumar <chandradhar.2003@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0146/1756] regulator: fixed: reject incompatible platform devices
Date: Wed, 18 Nov 2026 15:37:53 +0100
Message-ID: <20261118150013.957414876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandradhar Kumar <chandradhar.2003@gmail.com>

[ Upstream commit f7396c2dbbc1bed6c2c554d1ddf80d16e4780a7d ]

The fixed regulator driver expects non-DT platform devices to provide
their configuration through platform_data as a struct fixed_voltage_config.

An explicitly bound driver can bypass the normal platform device/driver
matching and attach the fixed regulator driver to an unrelated platform
device. This causes the driver's platform_data to be interpreted as a
struct fixed_voltage_config even though it contains data for a different
device.

Reject non-DT platform devices whose name does not match the fixed
regulator driver before accessing their platform data.

Fixes: 4b74ff651249 ("regulator: add support for fixed regulators.")
Reported-by: syzbot+bfc9e55cf4f98183c636@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=bfc9e55cf4f98183c636
Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
Link: https://patch.msgid.link/20260822065519.112441-1-chandradhar.2003@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 254c0a8a45559..0f5451532c883 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -29,6 +29,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/clk.h>
+#include <linux/string.h>
 
 /* Default time in millisecond to wait for emergency shutdown */
 #define FV_DEF_EMERG_SHUTDWN_TMO	10
@@ -229,6 +230,9 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	enum gpiod_flags gflags;
 	int ret;
 
+	if (!pdev->dev.of_node && strcmp(pdev->name, "reg-fixed-voltage"))
+		return -ENODEV;
+
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct fixed_voltage_data),
 			       GFP_KERNEL);
 	if (!drvdata)
-- 
2.53.0



