Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FA21DFD1;
	Sun,  1 Sep 2024 16:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209339; cv=none; b=C9R0/lQhbgPwQhbMLI8iGBIA/hpLD4aLEGt1x4HV5qUOJcNGFP2eztwOmDRrp08YwhOH4ra73UMKsMJyo8rO65JtwM6TdM8619g6Fo5qafVKNIVzB0wBOG7UAgvRzPS6Yvgo/4JqwyHCJT137DA6580zaLnVCw4NsFanDSV2Rkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209339; c=relaxed/simple;
	bh=NXQTx5PznoPIttkgJvBKZxT+YKIJS9FQwB5iMB08dac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKFF1uG7ZtvEQ1N5O5dzk5RC74sbBZi8pf0Tdzxi2Iu5bQSk3fU5LBpLwrWml456yNnGHgaDy5xYZdkM0xw/Ty/ijs4nbsY8ktflSp8jOnSYwJRlRtRC2gEmIRuKkqUvmDgw91rW88of7NK9eO9c9zkc8kLYXhWQp1rfx3WlQgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvR9rvr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvR9rvr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAD6C4CEC3;
	Sun,  1 Sep 2024 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209339;
	bh=NXQTx5PznoPIttkgJvBKZxT+YKIJS9FQwB5iMB08dac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvR9rvr+3AUCqVFV9rhTp5EalbQgH37rZoZVaET2XtGIRCXhESsTrSx5sNz1oWpKp
	 fn6qiJju5HxINNTtfeXtfQ/mEeO2Y/6Wl59rujxhJVS/oZht1ZQCChOBWtN81nD7If
	 H9JNQUWkty71tWKg37R6AKiyAP89eB4nkgE2plr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Oliver Neuku <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 57/71] cdc-acm: Add DISABLE_ECHO quirk for GE HealthCare UI Controller
Date: Sun,  1 Sep 2024 18:18:02 +0200
Message-ID: <20240901160804.041321103@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Ray <ian.ray@gehealthcare.com>

commit 0b00583ecacb0b51712a5ecd34cf7e6684307c67 upstream.

USB_DEVICE(0x1901, 0x0006) may send data before cdc_acm is ready, which
may be misinterpreted in the default N_TTY line discipline.

Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Acked-by: Oliver Neuku <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240814072905.2501-1-ian.ray@gehealthcare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1737,6 +1737,9 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x11ca, 0x0201), /* VeriFone Mx870 Gadget Serial */
 	.driver_info = SINGLE_RX_URB,
 	},
+	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
+	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
+	},
 	{ USB_DEVICE(0x1965, 0x0018), /* Uniden UBC125XLT */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},


