Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8870C2C9D;
	Mon, 23 Jun 2025 21:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713604; cv=none; b=lmzEoTYVaCaSUs0OfliekGwgCsjbejrQgIAp01L+tP1EHl6cxfjnj9kY50BGCAEv2QrG0z+UL36EGzu+02Sla+90pJEbSdfuqUbUZVW9QSRDD8c3zDAPz7ldwhakj52MG0qaaZs7i+PnQTEkgOSpSrS8faoXGFtbfwhGmS66HmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713604; c=relaxed/simple;
	bh=dfZ9gEoy+aEpbxKhT2wmFWr+38lM5ZGb01xxdm3Ydfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdBNXCqrqHkg4A4mkSk9NKTKcLbPhdtsSAGx2ItLTUaXIVWANUPiAkpvRYvB2wmhmmWAg7eilyYSlP70XuVMaHlSu8+Oox0wh4a9taYuGgs8VachxOllWe+Tw8TXBoZwqqHMPwdxuOyVao561Ax0gzfMdaYhIvXEnfjpvQ7zb+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beoVkZ5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beoVkZ5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214CEC4CEEA;
	Mon, 23 Jun 2025 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713604;
	bh=dfZ9gEoy+aEpbxKhT2wmFWr+38lM5ZGb01xxdm3Ydfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beoVkZ5wNrwVPzsT62bLn8RvU364QNXDr0C3exaeeygCBm/XVSqlgRWVoMMo/uTYB
	 5Oo+o58MsiCZ7s7WvBX0Z+NCDiaSH3OY3t7p71H6FbAAa3dAuuBeeAUJitJPm9CCH6
	 rH+VQXwT0xkSBPZHqaEOJMPCNzL0WTc3HiCh+Ojg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 155/355] net: usb: aqc111: debug info before sanitation
Date: Mon, 23 Jun 2025 15:05:56 +0200
Message-ID: <20250623130631.364766263@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


