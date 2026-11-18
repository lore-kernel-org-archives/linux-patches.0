Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057290;
	b=Nz2clwSiQEK+gV5SqDte3b4YokdJahwy724rl47oDV38W8aC3nAqcoc0nCym70pgJIMp
	 Yv0nuEwrRQvD4Qnvq9EVeK48AnuGorQHtDgebisWWph0vyMzmZHzpz90pmcsR9Gg3Ydey
	 /5sLAnAbVG6+W+jq8pAI4qJNCCBH7BIERO48dDmXEscaTnIWrkSpYLbyMF4qr36mEP4er
	 aP+IyhgTgHaLjvdp+/QYTUzWVY9N3ld27Ic/ZpGhtkAfmWw7+NG0sIThw98aLI2qboasP
	 DZJug3ynBw5/YjwKEuGJDwax1JZirWhsX/Z8Z8sWvNc5OIXOL6CEQapT1pSqJ2QjfNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/XG6I3s8FMnZuWjxGIISZTGCy/IKacDK/c/qQvwYHgg=;
	b=BtcSkk9MgnYWydnMoaAA+Se8T25q6dV0xYrUePWYGGiR4XiNQbphHb9DLcxj1UJ3/bHp
	 rSXKJFQWeDfyEl2qN6oOZSFs5MR9WfufNIX6De5mJdxUsBm36p3vyFdQKtf4KzF0dRFd9
	 PxCvgefTVST9eyYuZ4sJBYdQliBl7bU16D0926/msDNqKk+dm/iEEAkIA9YpeIAdGhNGN
	 CWOP8fVA45RjvjFjqmJXlH8vUTIr+JfpqJWkQZjOOdaM0f+Z3dEHsBdkK9STsS7gylOvL
	 rId11sZ+xb4KBncNGtgWK13E53myd+1SQfEdKmfVT5UIaZCxmmbHzOxzXgCPPrmw2HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaVQdqdY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A9B60A2622;
	Thu, 19 Nov 2026 03:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaVQdqdY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA8B1F000C8;
	Thu, 19 Nov 2026 03:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057290;
	bh=/XG6I3s8FMnZuWjxGIISZTGCy/IKacDK/c/qQvwYHgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaVQdqdYoYJQ5QSKm2XPdhYBItS2jFPsSbEOlDHs/BSzpw5Kd/cW1uZJnVNEK63Cy
	 XoNxuJsiALi5JuwtXBLGhJuR35DM5iOuC9Khfkj7HlWUPy5cvfjHg6TpkT2yYCqg9W
	 HXjRkHzezmbLTJN6zv7ALtLxeUwIV8QTnBRWxJUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0078/1848] usb: misc: cypress_cy7c63: check result of IO
Date: Wed, 18 Nov 2026 15:35:16 +0100
Message-ID: <20261118145914.394555144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 0673b919e0933541ae56bb3f0253853f696d3773 ]

If the device returns a bogus short read, treat it as EIO.
Actually check for IO errors.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260710095523.1646308-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/cypress_cy7c63.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/cypress_cy7c63.c b/drivers/usb/misc/cypress_cy7c63.c
index 3be5551a98678..3def90646fdcd 100644
--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -89,8 +89,11 @@ static int vendor_command(struct cypress *dev, unsigned char request,
 				 address, data, iobuf, CYPRESS_MAX_REQSIZE,
 				 USB_CTRL_GET_TIMEOUT);
 	/* we must not process garbage */
-	if (retval < 2)
+	if (retval < 2) {
+		if (retval >= 0)
+			retval = -EIO;
 		goto err_buf;
+	}
 
 	/* store returned data (more READs to be added) */
 	switch (request) {
@@ -175,8 +178,9 @@ static ssize_t read_port(struct device *dev, struct device_attribute *attr,
 	dev_dbg(&cyp->udev->dev, "READ_PORT%d called\n", port_num);
 
 	result = vendor_command(cyp, CYPRESS_READ_PORT, read_id, 0);
-
 	dev_dbg(&cyp->udev->dev, "Result of vendor_command: %d\n\n", result);
+	if (result < 0)
+		return result;
 
 	return sprintf(buf, "%d", cyp->port[port_num]);
 }
-- 
2.53.0



