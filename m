Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB8B34A301;
	Tue, 26 Aug 2025 13:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213975; cv=none; b=ZsOS+eFh62GXe13lsahH1Q/F6Ssi2e979WHlmxp/zMAB93Bozr6x25iGuf0U8tHBTFNYHDShUSCryw/KksuScyL84jsjaTxxntXDAJLEx9q1gvD1kkgrZ0Hdi8eILMEZ76JIiYYrzrhG5b0xRfpE6Kp3uKJxIopEtRrePvWkDSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213975; c=relaxed/simple;
	bh=bnT4b4TyKLoKLCueXhdGmeQB6s9DzOTllPVyUM7TFpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiDMY4iFdq/NKPXNg3o1TFyBNwDEiClRHHkyt/C7lys71GhEq1TvukDHeSd0zR1glRmjdKwdHEcD8AhJL4uYAR6Nk3ASvtjZWuxEVEZO2t9PvG1lRJbOt2sFTuYzOYDZAA3ZpGcsIFs04bYImABuJIdyJ3VfBoDPXhxqhoK8kWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVYweZAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVYweZAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD94C4CEF1;
	Tue, 26 Aug 2025 13:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213975;
	bh=bnT4b4TyKLoKLCueXhdGmeQB6s9DzOTllPVyUM7TFpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVYweZAqeLroo3iZoG2+TUViQci5H/uLdHhqE81IpM6vnop+o46tCUzzFJPmDHbML
	 EPsrTE97pVmC3RnJDMxnWsi3B8Jp9URG2aClEOkbsL0+4QNpTHUpfWmwE/X7Yz3phW
	 H1u9ut5B2axIQ8hg33yDLzmhBaABznna1G3na6J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 519/587] usb: quirks: Add DELAY_INIT quick for another SanDisk 3.2Gen1 Flash Drive
Date: Tue, 26 Aug 2025 13:11:08 +0200
Message-ID: <20250826111006.199145450@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Miao Li <limiao@kylinos.cn>

commit e664036cf36480414936cd91f4cfa2179a3d8367 upstream.

Another SanDisk 3.2Gen1 Flash Drive also need DELAY_INIT quick,
or it will randomly work incorrectly on Huawei hisi platforms
when doing reboot test.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250801082728.469406-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -371,6 +371,7 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
 	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x5596), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* SanDisk Extreme 55AE */


