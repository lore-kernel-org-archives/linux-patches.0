Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210763;
	b=inrBNQpjQWIgqYt38IeCxq18JxgEmRXLXvJpoD7WWLEGGaeAJAx+9crPk93WxlDuKwIL
	 e/231zEprBf0bFTuj4CsR6lh73ZQ7qI69XArDq/d1nS4nUVBHAPh/IjxxogKzFqWvcHcK
	 A1w/opVP97OJWm1nD16GJsGPA4U6MOojkeEBAUoWgrBLbnT7dL4g4FgL0YOxtnhd43L/K
	 /0VaDVaT9eE/Z/VXr0RVtdB/lV2dGSyiCrx80EPo7ynxn22f9pBv4cDf3N4Cri8zu9tGg
	 9PuQAcJ+lHt1iKFhvqh4yFWWiu+PGsqqehiRYyJCWKNZNKkawfiQAaaWJDYvKU48LEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RW1HiPYzmZNX7tlpbekGH+ay75yrrH0asTUPgky6U28=;
	b=ll9nGtCXIxVpb8dmxKTNZZ/KR8FSG301Ls28wNYMNnTW/LZ3Dl5J1Nn9Qp8JSz8P6HIo
	 WptfghUI/Kh+zaUEEnrp62AZ/jNW7UsF6zfgwU7DDpqPYXtIYfSiCs0ITajaBnF8451Q9
	 sGhjJJtZYcFDeVriOkot9pO92qj7V511dBZAWDfKcsEQbxAmJCsCLkQCKhqDxQz7Kz9h2
	 PJKCDDWud1L0EBgaJ1kLxKHx+sTB3mFrhfD9bJUvruExEjQbjmdr38yp7Wzz+LNznHpvX
	 5e+13c/xvIQGcWlhgpJAQ8QEf8iIRX66pVLceHi1jq0TmWCN8CM3AJ2TidGG9Reg7gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+aP4cBz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67699606A31A;
	Wed, 28 Oct 2026 18:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+aP4cBz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A61F01825;
	Wed, 28 Oct 2026 18:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210763;
	bh=RW1HiPYzmZNX7tlpbekGH+ay75yrrH0asTUPgky6U28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+aP4cBzHIkZ/hAUpC4Pn24fcgi5MvEyIB88k+6HBhYXcQIYgJ4omzX/c3+D/nSnd
	 nQ+AFUUkU5Qy5piGLwD3XUX53yY+bJkZ9kJRl/89ziM1hq6Dph7IT/tASwA47CROhY
	 i3ae83qGrg5Z1+IC65pCL+UtSFqlDW8RlTISrWyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 141/571] rtc: spear: initialize IRQ state before requesting alarm IRQ
Date: Wed, 28 Oct 2026 17:54:48 +0100
Message-ID: <20261028170011.362760927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 055ef5ce9f67a6a3a1363fa663007f8196cc0fb8 upstream.

devm_request_irq() enables the interrupt before it returns, so the handler
may run while probe is still initializing the device. Initialize the MMIO
address and spinlock before requesting the alarm IRQ.

Fixes: 0942a71e435f ("rtc: add support for spear rtc")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260902080318.3498434-1-runyu.xiao@seu.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-spear.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -357,6 +357,12 @@ static int spear_rtc_probe(struct platfo
 	if (irq < 0)
 		return irq;
 
+	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(config->ioaddr))
+		return PTR_ERR(config->ioaddr);
+
+	spin_lock_init(&config->lock);
+
 	status = devm_request_irq(&pdev->dev, irq, spear_rtc_irq, 0, pdev->name,
 			config);
 	if (status) {
@@ -365,10 +371,6 @@ static int spear_rtc_probe(struct platfo
 		return status;
 	}
 
-	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(config->ioaddr))
-		return PTR_ERR(config->ioaddr);
-
 	config->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(config->clk))
 		return PTR_ERR(config->clk);
@@ -377,7 +379,6 @@ static int spear_rtc_probe(struct platfo
 	if (status < 0)
 		return status;
 
-	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
 	config->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,


