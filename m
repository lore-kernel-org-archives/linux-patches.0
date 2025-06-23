Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC6D3FB1B;
	Mon, 23 Jun 2025 21:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715846; cv=none; b=QF/HrVXQ3XwTgAuZcw3ybo3F0sEcHR7VMnxd+VWW4EMfK3MmKFCtTTi1uoUu3kSjwjLTrYh2ZoMVhd8yht028dmvW3l7iDnBX/gI2JAvYKIa2GbncCsa8desCbILckF7U8wgSTcovP+l5BS5ifv145l8OMP7MPJkB2SMJMS9ukI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715846; c=relaxed/simple;
	bh=mjaYp0+snr7S4g/eBOWaY7qgBTmSgzCCXLC3S+0VIDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNxwqNkcIaUp4th7318GOx4TkstxWd96vtThiYDtoAz3Msu7IjY0gBLW32ka8COMrYnjCO4yF/drXuPWXpjkCdDAfIu7Jaq5uezrVEtMFiWKd5kbCVdnaifCQrUpKuilm5K2grj24EYXFfHu0eS96g2P72sb75XFI4eSn7JUz+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJfoZXjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJfoZXjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C92BC4CEEA;
	Mon, 23 Jun 2025 21:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715846;
	bh=mjaYp0+snr7S4g/eBOWaY7qgBTmSgzCCXLC3S+0VIDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJfoZXjfEH5I9gBz7rsnv+L/zC1ZQPlaUaDr0xSFZnY8TgW10t9aQ+9kHdoAMDYUN
	 kWjloD3Lj4AU7yQOH0nt/tZNH6iFIXryaGA3U0OTTyHd0l1cgE1bOLsl9SBByFCWPD
	 mQF0xV519i39jrP6Ovbf1DOETACFtrtho4IoYdyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 285/508] net: usb: aqc111: debug info before sanitation
Date: Mon, 23 Jun 2025 15:05:30 +0200
Message-ID: <20250623130652.279563415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit d3faab9b5a6a0477d69c38bd11c43aa5e936f929 upstream.

If we sanitize error returns, the debug statements need
to come before that so that we don't lose information.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 405b0d610745 ("net: usb: aqc111: fix error handling of usbnet read calls")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/aqc111.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -31,11 +31,11 @@ static int aqc111_read_cmd_nopm(struct u
 				   USB_RECIP_DEVICE, value, index, data, size);
 
 	if (unlikely(ret < size)) {
-		ret = ret < 0 ? ret : -ENODATA;
-
 		netdev_warn(dev->net,
 			    "Failed to read(0x%x) reg index 0x%04x: %d\n",
 			    cmd, index, ret);
+
+		ret = ret < 0 ? ret : -ENODATA;
 	}
 
 	return ret;
@@ -50,11 +50,11 @@ static int aqc111_read_cmd(struct usbnet
 			      USB_RECIP_DEVICE, value, index, data, size);
 
 	if (unlikely(ret < size)) {
-		ret = ret < 0 ? ret : -ENODATA;
-
 		netdev_warn(dev->net,
 			    "Failed to read(0x%x) reg index 0x%04x: %d\n",
 			    cmd, index, ret);
+
+		ret = ret < 0 ? ret : -ENODATA;
 	}
 
 	return ret;


