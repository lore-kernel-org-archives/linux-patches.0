Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829517;
	b=qaUZ/fuBDteUOoUAL1aLXCwwURMST2Uuhf092dg8dTzuxmHSqlVODhhsXGgXlBEKyfJF
	 ZZ2wWwVqnn8EkM8sCgqzpcT+H5rTh2+AH0bgsvH8oUziwQm+EptR1nwvINTkvWmtekUNR
	 zSEo/KnmuT7OvGLW/2oRorBq4R7MHIiA0KOodlzf9wIVThIdK0jY5bKZxB5l9f5FozTn2
	 KG8XFN8YvI+pViY3aM0U6jwY8kedK5rUwBeHRux4JAFbh1jLKDRrfyH/Axq884DTX+GAg
	 JgwshhfffQYyENn/eM+CybEQTdSC1efx3DT95T1Bvh+bokIKvd/eiPWNX21JXFEpF7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oxvdltQhJfjV2DV7rlR1G4yfSkBBgIo6MZKJOe8Ekn8=;
	b=r1e2PNBx6jrfUXey01mynkxomSfCKZzLAH9rHR0HSYMFvsDlO9UqdOHjRi1FIDAVUv9+
	 r7N/R+DKq8KS0tCCwjiZxpZYvyG4PN8WzkS50AlwLqwWY5+cs2asRZORZlR/u2BGCABtd
	 xBh+0kP2wi0woHN7Z83Q6dYRMVLiPVKnU41QU4L5cuipZIkobz8WZPc3Do7VYqc0+6Ps5
	 4jShq6+Li9MrM8MYSTST79dKoWwJdKeJi/pOXAfARnNXa+PPWB0BRA2em5FP104hMld3F
	 acVwsDRji+COt/V7o6ZNn6uyCocqOQFw34GMficaooRzzVupO7RzdFNsP75yDSb4+9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4uYsdDr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50CF606AB36;
	Wed,  4 Nov 2026 21:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4uYsdDr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CC41F000C1;
	Wed,  4 Nov 2026 21:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829516;
	bh=oxvdltQhJfjV2DV7rlR1G4yfSkBBgIo6MZKJOe8Ekn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4uYsdDrBInQWMx1S6rY9JsQCqtIPDVDgLkG1va0ZZtL1LgtGrQy3aczwQoRo6bhh
	 Jv7rcNqEhQGUjGMVz+F7KLaCDVI4SqfVMb8O6EwLLlR2PYtAAniTNs0ZOVH0o3TH0C
	 rPQStsOm1L1hx4sQXwWsQDS1qYEmfZL+nbcPAZ2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0173/1005] usb: misc: cypress_cy7c63: check result of IO
Date: Wed,  4 Nov 2026 15:58:26 -0500
Message-ID: <20261104211048.621221945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



