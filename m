Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E6D26B0BC;
	Thu, 13 Feb 2025 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460008; cv=none; b=O0wHWcpy4U4zapcV84di6BHZM4k76t+iiyM+8vKaKzBWvRWQHha1O8J5tuOIoNABxFfITZPm5ZWPSzw6kEEjqFrixDtn2RDa2O0Bh7Uw/JC/LbN2ueAWGn1tv1hLvH36TzsU8n6AdPRnvXcyGfpJaTvQf41CyRgo+Dw7cXKXulY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460008; c=relaxed/simple;
	bh=jfNJOlQKD8FmAcKjzDAVsJvxZ+hzgFdOMfrIC5qj1BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gpkeecqgg/5M3cln7FlgusJl+FN5FYecwdxY6xdjr4A3sHZW5IASPMvfjRIahXKxeb3COBcdV/YNO+fNuTTyjDMTrPR2zEihRQtIZqafj4wMbtxF1djINwFlGNIbnPrkbgdNzCWUIBB4lJHIF4rPG7TKqcarov8PsccoZn4X6AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFe5j/1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFe5j/1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A3EC4CED1;
	Thu, 13 Feb 2025 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460008;
	bh=jfNJOlQKD8FmAcKjzDAVsJvxZ+hzgFdOMfrIC5qj1BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFe5j/1f6PYEmXmgmwLf0Q/kQcCt5h3ZGXOWuOG8LjtCXr0D2BSJVCEJwGTgCdbH3
	 4WiHGCcjjJ9o1blWw+oEC4qgSLCh4JKifYWTTTYeAFkuPIBwilIQjMOtLyrpIGyvNu
	 S8lvCC2V0w7n65tPIBOU380Ke/o2GkMkfNXjreEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	stable@kernel.org,
	Peter Korsgaard <peter@korsgaard.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.13 430/443] rtc: zynqmp: Fix optional clock name property
Date: Thu, 13 Feb 2025 15:29:55 +0100
Message-ID: <20250213142457.213647190@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


