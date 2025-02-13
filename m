Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1A970805;
	Thu, 13 Feb 2025 15:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460947; cv=none; b=d+Ko7vvHi+CJVJjO4ksxoPCvp/J9mR47z+YsFQQmaglpQThyXd5LX49JPrjuCnh7VN1FRXF7Sn3JINaCJVYyVrErQBat0k6XeBeaq9m0OeKweJtE3d7qOjBUoSY10WKrXQSBKQ6p8AAaDkz9MwEsZmCvYvuTvwt1ZdgCPh/+uxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460947; c=relaxed/simple;
	bh=9BAsNTUamD/Z1Vo9utiflDPlB4caiXJnrVS0beyeZdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaAcdqhpRelOX/6nIlLOisPZR6ALU+ejlnZ2BV+uP4gUujUznKd6cpMKNCuHm+Ny0yjVUaW7f6H9kUTDWAn1dSCD14NBGwIg+3i8abzG3S9CI/tERrjzWKI0KsrqGxHVBDrkvMU88LEQuNj0obrCVMLCJ6PztcGWtlsQOWu8wrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT1U+XSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT1U+XSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A562C4CED1;
	Thu, 13 Feb 2025 15:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460947;
	bh=9BAsNTUamD/Z1Vo9utiflDPlB4caiXJnrVS0beyeZdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT1U+XSHxXelk3J+yB0IGPumjTgcHpwhobqM/BC5BkERb+tFcV+jR/U/nBboFhB4+
	 Z0uzS2pYdDJ8VoDsmkOmGwr4xLgIPcqw9qOhYbPgiDAj+snL60nWQhzzay/153/RA7
	 yOkoaljjRhFoOKbOy8EozDkiHFgNcxQRabayIEgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	stable@kernel.org,
	Peter Korsgaard <peter@korsgaard.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 258/273] rtc: zynqmp: Fix optional clock name property
Date: Thu, 13 Feb 2025 15:30:30 +0100
Message-ID: <20250213142417.615085653@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@amd.com>

commit 2a388ff22d2cbfc5cbd628ef085bdcd3b7dc64f5 upstream.

Clock description in DT binding introduced by commit f69060c14431
("dt-bindings: rtc: zynqmp: Add clock information") is talking about "rtc"
clock name but driver is checking "rtc_clk" name instead.
Because clock is optional property likely in was never handled properly by
the driver.

Fixes: 07dcc6f9c762 ("rtc: zynqmp: Add calibration set and get support")
Signed-off-by: Michal Simek <michal.simek@amd.com>
Cc: stable@kernel.org
Reviewed-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://lore.kernel.org/r/cd5f0c9d01ec1f5a240e37a7e0d85b8dacb3a869.1732723280.git.michal.simek@amd.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-zynqmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-zynqmp.c
+++ b/drivers/rtc/rtc-zynqmp.c
@@ -318,8 +318,8 @@ static int xlnx_rtc_probe(struct platfor
 		return ret;
 	}
 
-	/* Getting the rtc_clk info */
-	xrtcdev->rtc_clk = devm_clk_get_optional(&pdev->dev, "rtc_clk");
+	/* Getting the rtc info */
+	xrtcdev->rtc_clk = devm_clk_get_optional(&pdev->dev, "rtc");
 	if (IS_ERR(xrtcdev->rtc_clk)) {
 		if (PTR_ERR(xrtcdev->rtc_clk) != -EPROBE_DEFER)
 			dev_warn(&pdev->dev, "Device clock not found.\n");


