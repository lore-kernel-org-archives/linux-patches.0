Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E44922DF80;
	Tue, 17 Jun 2025 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178507; cv=none; b=RNAU0YhHVC8eEuKEWbCd05jt4JEY42Wnn4oYLUg+EWVHSKbeCm7s4gFW6ESp+gUpljWxCfNixH45uFTHLtreiTWQoVoPwXt0kxEHcvkT5SceYQmEF6NcXlKqclb05b7HF7ZOZLi64inLrdKoocgD8SmkoLVB8SDYmG5+0yK4b4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178507; c=relaxed/simple;
	bh=yOyomGc2QEHR+Bcx77guj65/46dSSYDFXxv6fDL94Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZyCg7xsGs+UDxC6G/XEbbcQjZy/fJnpfNQkD5TSMs1sIU2lqeBa0w55+pnFRrYzFhnNbGVBGkOxxvIb20hU9lwO//Vxc9HByYOEvXb8qcARtDl6GzkvvyAbZzxrLcyJ1tLKbNTgvFkLsPrHAW2ShVEw2NwCwQy04gNxYCsjec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LN2NnnkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LN2NnnkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D96C4CEE7;
	Tue, 17 Jun 2025 16:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178507;
	bh=yOyomGc2QEHR+Bcx77guj65/46dSSYDFXxv6fDL94Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LN2NnnkEmZmH3BZ3kRDcUb9IMTOEQtv2cIzl4D7L6mSretnSgQT31YYMgHRLnYZHy
	 nFcCK9q2i2w0fIiyYlwFYWw3WtiOLeQhtjc47K4jASwnccCjA9Ub9Y8O6eHnOkfaoh
	 7whMY/p2dC/mllQN4ogNDEV7tuRn51Q9uBxor1r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.12 509/512] net: usb: aqc111: debug info before sanitation
Date: Tue, 17 Jun 2025 17:27:55 +0200
Message-ID: <20250617152440.239359738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


