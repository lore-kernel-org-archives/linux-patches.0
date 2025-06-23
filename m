Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893371C5D46;
	Mon, 23 Jun 2025 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714426; cv=none; b=DH8H+pp/1nDyvX3glyhTj9OJbJJ38dKlQr+WXi7h1FMrYtygJRsxmibnT0XvTbEJaoHZr5nCjz2qs5lycIGGuWDvwV+9nJop+mc6M7DAp4Us93iadG3/9VpO39BqjjNrnxw6GO8T05RmGapQP8+AqBU5q4EeRRF8NHIeRCqp8NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714426; c=relaxed/simple;
	bh=DTdvBDa68+WJMlhWxmppQVYqvlSzvkICmW+UDKo28oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5dPXIefDJJ1IikpL0W4zkk01N89D6V24Xr/Qltwms2NPTBl1vx/EG4yWcPlvG2+Y8FjRA2wzgycZP866VETrg/qD8myGP3Ves7Lv5crtJfBi/xeUSYSFjUSAeoXu1GBB86EYQ+AyHPiQ3B1Fr0YQ7MyTbLQzxTUSCtJ+qx+pGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Us4/8/1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Us4/8/1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5A2C4CEEA;
	Mon, 23 Jun 2025 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714426;
	bh=DTdvBDa68+WJMlhWxmppQVYqvlSzvkICmW+UDKo28oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Us4/8/1c8oL25+wHRtz4/Nk0cc/rn2CmA6FfaB6+csZL2SXdCDuEOR/6Y+PWCz7UK
	 I+w+simMeczoXW7j/0U0iTVnbTa4KTQ/+CuObAsA98UPf1Mi1qf4gFl+vrEXppuaDx
	 RZ2hkKJWEYk3LqHy9rnnrPB1Z/czrzYOw9DWaUtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 187/411] net: usb: aqc111: debug info before sanitation
Date: Mon, 23 Jun 2025 15:05:31 +0200
Message-ID: <20250623130638.389925921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


