Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051221;
	b=uZE1ejlHhVeUo7ky1FASFNYDZxCZv10hTFZO0SV3WwnlpTP/j2lYFgO3LnJw33klMoxW
	 3YTTVskoAVfqiYS8mn03JlVsuSJIfKxU1m0Gbo0WS3fyU/TVo1NfehsErIvJgmAWmxmSN
	 nvEbJEG4uMeYGxJ5YgnWy/qZ8Fal7NhDIQSsxXtaAYSaI4vPj8KwW/vIexJSHMohQdH7Y
	 P0TfXZso0EzFDhG7UJeTZZKrwrJxGrWXOZxRfEi8HlnxXMiukHz/9Rd+3IqX3dEnaEnDu
	 HQUclisFz6dYp04LRXlbR5BZvdCJXkj5/reHUS03btR6UA4qhVTNK0CK0HQ3MOTGlvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kyzqdt1W93Af5bn79gtL803IqAo7IOMSHTsWXwpbGvM=;
	b=YVm6P+YlDssTruPj4b0EI/01dG+U6r8xA9/QakMERZwgYqh0SHBvehuGZfRF7ZXgLSnB
	 QIZZ5ghO6pLBkv5MYatn/R4b3L14WHBvirfkZUgkeIPr4LBQ03deM3RTyupsOx2rMi9/U
	 AsayXAZ9efmkveucIWnvb4F53P1sZa5tifiHu3+3qPxjG4JxVhW9FkgC+imCMVlmhi1E5
	 NPcFo98S8dUyscG4YfPZ9mbbKIa5pveHpgO7hZw2ImffaSwQjkYRzpKlyhLlxil9e2H/N
	 XRuD73lKvJ/obIKgYL1y2uR4MlWSJscnFIeRVjrpekm/LDjD2h3BCRei4/FOZoPFwLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZU5mA6C6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB467606A320;
	Thu, 19 Nov 2026 01:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZU5mA6C6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB8D1F000C4;
	Thu, 19 Nov 2026 01:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051221;
	bh=Kyzqdt1W93Af5bn79gtL803IqAo7IOMSHTsWXwpbGvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZU5mA6C6DuqcebiqU0tkLecmfYeUvmqZXW+W2fUjFDM0j5gzJ+8sZGKnN2wNxBTwY
	 9ed+yihK+XvB5EWIVQ/8Y7yAcs8JoRH9tLIs2F6QfMlDSSYkzpitcBifhQ4g8TAsdv
	 erFOtFmZ0KIlap3KZ1/pv+LTeQE7dVH72IBzWa+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0091/2214] usb: misc: cypress_cy7c63: check result of IO
Date: Wed, 18 Nov 2026 15:29:27 +0100
Message-ID: <20261118150013.612121213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



