Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060719;
	b=rGZodDvxmYf9FnubA708grE/OV04O8it2pmXA+4nEho3Mn44l+toZ8wcbPvHpEosMMIH
	 Jngd2veQzzjReK+Eo3srmMTdMDKgu8GOZoE5OTfqLrUq9mgYbue/WeLQUAjZnVGn3v20g
	 993Fr4Y7j/2xtdinrgSt8MGkTphSQFyc+VVuu5uML5OTAs00XWORig83lh7YCGaosacbB
	 X2r3LK0JaKJIiU34WQT/dAwFU3AqtoBd8lFEXnQX1LFblf4gNT5xpXCQ/cMhUqBk84kMV
	 vJR9gqzZeCJCPEM4YHXPBVLT2wOb1uRjmacIkk+ifxnlon49/DgsUOGq97GPaAuyVlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+pC7goQamOoHK5/e7aIuzmOVvXWSFS2Gj1+BfuJbwKo=;
	b=C3C5xnnoX9zC1hrAku6027qcvjhHkGYtnBfGwk0qYB1jWjvBUrbQpTI56GhjY9BmTsA7
	 3mENm856iQk6TzzZ8cPU9OxEGUxrwHsOcr7BJIA9PV0Su4jTsGtXoNwul9ahvEDYZTqJ+
	 BLtTgdT1+k0BLN/kkwhF4P+94JGgg3U4NOwxJT50HorES4d8j56OIWDtLkGfffY683C+q
	 DUaP4QljU5w9hu3Hw5/LhFa33vWQGD3nrULI5OWCN/62Lc85ydSywx8y7or64Ckb7sWa5
	 KAbhqbeQbG9uNv0+vFsSLOSksIoXQByt3g1yiTLE7FfVTfL8TM0Ir22g3lFt2jdAauw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e1VFBZ/t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C260606A326;
	Sat,  7 Nov 2026 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1VFBZ/t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8D21F008A1;
	Sat,  7 Nov 2026 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060719;
	bh=+pC7goQamOoHK5/e7aIuzmOVvXWSFS2Gj1+BfuJbwKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1VFBZ/tAJIIsltI2Xne+ERaumYbYPL17IJtu2G3P80r0WTwxxDy31XUYkaIsd/UG
	 Za1NQmJGHe7K0YJEDRAwqpkIea9frvFOIr/B7v9NpDVxRejbtMR865qTFN5gAueYlM
	 ktQXGze5kxZuWIrgAkQqaG5NWfhZvWvXE97OOUG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0141/1536] usb: misc: cypress_cy7c63: check result of IO
Date: Sat,  7 Nov 2026 08:35:57 -0500
Message-ID: <20261107135001.647697236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



