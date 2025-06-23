Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8113C24679C;
	Mon, 23 Jun 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685529; cv=none; b=EB0Yi3oLKCqHCztCKQAn8QD1C2dfNHvXXiwnhFWDBMTlRdUAyAtYaFxVfKv5aGs0NLiEN3MJk1uf7fLFYBc/QIVNVICzrjABhE29q1vGE7wSAAY2s+28Ql++7yd5yDXxA5GlO9cT+JWL0Job0KA6uOZ4K9NYxyBhF3ZTKAus3dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685529; c=relaxed/simple;
	bh=Si1vfWjdN07q6CLffeB4tGzm0hr6AV0vKz1y7sMImMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wx9ToXfCxRZAeidzgZtzdox7l775ZnezcSmD2YJ4VvT7A+g3MOZTjjKz3HcJ2AWiE31NUIeObqAyX8jxTlqrsdUyvtV7koLVbKhJirM84Brv4g4QhtYHMdkJsSSpVbQ5w3OmCIF55occzqUsiVQdWHGay2yUZoui0VJirFbLuLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyGH+F9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyGH+F9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3238C4CEEA;
	Mon, 23 Jun 2025 13:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685529;
	bh=Si1vfWjdN07q6CLffeB4tGzm0hr6AV0vKz1y7sMImMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyGH+F9tGnbZgk5ufE/NEwbp77eD29gLmsxOWemp1p1xb72Gdy2s2Z+D+9N8tkLxk
	 KInBVwmbAO1CvFC/nN16PpHeb+d6+HJI2DX01Yib9tVA6ACkEceS32SPwKW3V+Sfuu
	 67rzhR3LDC8W3Hnvh9NS7oultUE2mmZXdmlymRK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 101/222] net: usb: aqc111: debug info before sanitation
Date: Mon, 23 Jun 2025 15:07:16 +0200
Message-ID: <20250623130615.153861043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


