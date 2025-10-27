Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C707309EF7;
	Mon, 27 Oct 2025 19:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593618; cv=none; b=rx4ADepmJa9ErVVOTPcWpxQ1ApAlS+FIAPz5zBSwfAq2z0gSEwFKsvmo4JfRsGyWIvriwO/SVcEmnNUow33rrabL4ewXsO3+wSG50U+AP/j9pTjX8mqrWHJHpvFtVJZaR1IXKzIMv0RhrnThYuq4vvt/Slgdcv3JoGJBhJ7J13U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593618; c=relaxed/simple;
	bh=rhhiffPSlTmNRmgU3AZif/pttDNJl1vQ3HZ7REPMp4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqDj5STpmNeylvBFv2Fzz+fVq49HMxoqfjHZj693WQrKvpX2aQaHMQ2j4Sl15Ab0UmImS055eLfzj2/1jRSVyEaGuWr8QdlOcCiqF8PDOa/aQQFaz10hTu4iEwdFrcvzeIXZKRCZ3MLjgVVTx6AFRLiGVk6lnRWPvZqS0bqY6U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aA9YUtVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aA9YUtVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4D2C4CEF1;
	Mon, 27 Oct 2025 19:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593618;
	bh=rhhiffPSlTmNRmgU3AZif/pttDNJl1vQ3HZ7REPMp4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aA9YUtVP+5b2QXmrsnK4L683nwdVGgPYuAA0LxOiPoE79bhQSAmvCLs4fv01bjW6z
	 fmQIYjmxmcSE7CGf80bS4ZiwV9kpWf1QfUIdyKToKSPjGMZouisOw2PXH3IYCi5fJg
	 cnjhLdn/xzTZf6ohKUqN+j8lf11e2eDyvKg/u+90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.17 161/184] nvmem: rcar-efuse: add missing MODULE_DEVICE_TABLE
Date: Mon, 27 Oct 2025 19:37:23 +0100
Message-ID: <20251027183519.260184493@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

commit 7959ffbec062c35bda02aa635d21ac45dbfacd80 upstream.

The nvmem-rcar-efuse driver can be compiled as a module. Add missing
MODULE_DEVICE_TABLE so it can be matched by modalias and automatically
loaded by udev.

Cc: stable@vger.kernel.org
Fixes: 1530b923a514 ("nvmem: Add R-Car E-FUSE driver")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250919142856.2313927-1-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/rcar-efuse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/rcar-efuse.c
+++ b/drivers/nvmem/rcar-efuse.c
@@ -127,6 +127,7 @@ static const struct of_device_id rcar_fu
 	{ .compatible = "renesas,r8a779h0-otp", .data = &rcar_fuse_v4m },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, rcar_fuse_match);
 
 static struct platform_driver rcar_fuse_driver = {
 	.probe = rcar_fuse_probe,


