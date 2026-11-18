Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033848;
	b=zqNPl9CSMbIAcOpmd9FqLdM78aP+hybQk7LEjdvU68nDgmfiXEg2XJoPRyAqK7Vrpzpm
	 B9vDS2qFAZvqim8ynM2jTlokKXec90qkfJ1QnZVkNirLGhHqRT35mEkH5Mruylo1fLoHH
	 TpClSkLYnmSavtxWG/upvffYn/GQY9BrqNMKof8zIWHYF8tfjBax2NNxmHbeytFFHYm0d
	 XBS5uiMa/5WaOrhQzV6cJK/tolMrfpv1FxWp9g8EnQ/fpTRO2KB21pBCiUbX1tk+F1d1G
	 NMhCbqb/7iWwv0jtXORondyjzwGZ2zIm55XiECdQDFHOtYyUl2d7RvvfMLYrW9m8/sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gj/Yilb31ambxsfGuFP4gX2NVYLHhC/tkcHgSxNU3w4=;
	b=FA35aOmmCvrM1HgD6NpMnxc0IPP98WixCGFKRt4RRL7SbBdWdHrkCa6YoCx72Pc220LC
	 M9mA9XOf/2jYNzmbSkDUqQhjqyrTo1fJWAH/JHC1AD2jsgjDv6nlarulYMZk5X+iG1gwo
	 e4C9O6qoAkpQonlqB/FiZYas9JKsuOKivJz8FYxSnZDbPzNTKIVQSN9nhCajg5ljkiTpb
	 OqsxDjZwltk1YfeX6ZlH+LbUU5t7cC94Pb9WGpVg6giUB0o3pZlJlW2DeGqLs6HM89uzL
	 LD5rAhoPXVUVofBM0AI35W3UgxBwvsrkPQ/GwkGGaz+9xI8jves41l/F3AHjL6jbRJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sm61j5Iu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D5460A2605;
	Wed, 18 Nov 2026 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sm61j5Iu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA111F000C4;
	Wed, 18 Nov 2026 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033848;
	bh=gj/Yilb31ambxsfGuFP4gX2NVYLHhC/tkcHgSxNU3w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sm61j5IudB43+uH0Za+jnSHiPWmbqI/BwTnOaCWi6mf7ASXCglThCHiF4/sxGaqm9
	 IAF2c8pfTakJTbqOsvplPUU7l6ISo8ZnDA3Tw/UltlNyjPlyvHt1WWOcTOOU6zoykz
	 bva0qSWmh+pR98fzdBr3qL3b+b5U94ddgBop0h6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0119/3318] usb: misc: cypress_cy7c63: check result of IO
Date: Wed, 18 Nov 2026 15:12:21 +0100
Message-ID: <20261118150317.890405713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 75f5a740cba39..e1a0c1ae93f2b 100644
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



