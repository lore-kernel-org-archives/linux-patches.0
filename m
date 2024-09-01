Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6485D2C190;
	Sun,  1 Sep 2024 17:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210484; cv=none; b=BrsNNNMmeT4v4qeA8XcZ8liMVL6ZmPrGerVojYWViBcRnO2LTLtSdyxFJRn+lR/Q1F39js17WuLPOGJGjZI5XxeMNRgGH9QWnpnjA2/nBiKedq2R2atQU9BBQPzLCxracG1Bx95Oj2HnV+MSsoVXreupCDD4aIS5z6M40nCYvow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210484; c=relaxed/simple;
	bh=09jgOuzhY2Wq4pFzfCzei1q90gg11ImEvgkFMyUgIEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkEJpiQKKT9yWwyMzpXr+GzbUU2Y5bm3SV63gY2tG7JaMgpn/xgh+9sIqubR4CW/1xyztzzx+5VRSDZ6wID4VKa1oKNePDzRkupyoRgGfg2mk1B7ka2T4oGUaJD8ZEoJ7PHa1UrYsTCRoSpNGDRsX9K2zZT20ociVhpAkIk5UsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psXq3FNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psXq3FNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E83C4CEC3;
	Sun,  1 Sep 2024 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210484;
	bh=09jgOuzhY2Wq4pFzfCzei1q90gg11ImEvgkFMyUgIEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psXq3FNddaZK43la5kW+ZS7tj8BxLhai2J9FPdLwnVXzbzAW6gxzAmJtrcjeLcZD4
	 Vvxej9CvgLG15X9MKkqGnKLxXKFQg4D7MmzdvB+i104FBTu5OEaQk9ljoDmlkOebkx
	 ksCbUXzLEX/nJAeNRSth8mO3Gt1n6Ev0AwMgm2eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Ray <ian.ray@gehealthcare.com>,
	Oliver Neuku <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 202/215] cdc-acm: Add DISABLE_ECHO quirk for GE HealthCare UI Controller
Date: Sun,  1 Sep 2024 18:18:34 +0200
Message-ID: <20240901160830.990498130@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1741,6 +1741,9 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x11ca, 0x0201), /* VeriFone Mx870 Gadget Serial */
 	.driver_info = SINGLE_RX_URB,
 	},
+	{ USB_DEVICE(0x1901, 0x0006), /* GE Healthcare Patient Monitor UI Controller */
+	.driver_info = DISABLE_ECHO, /* DISABLE ECHO in termios flag */
+	},
 	{ USB_DEVICE(0x1965, 0x0018), /* Uniden UBC125XLT */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},


