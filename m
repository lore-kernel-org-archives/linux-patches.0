Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49779279DC9;
	Sat, 30 May 2026 18:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165658; cv=none; b=DdnQqkp+Pmxr6XSLL1feEB6ch4mC0r8Gh9CmRR3tv29Knat5f1RJT7L9IXD+vFXTQuPFWnM11fCNEcf6rSghs6qnaYw73pZWYH62+7q4eqhR33zjEKDjhNk64I5NbvZ2c6MlUNdw0J4Sg3I+vI5xlc+X88bxVryipXsx5hE1pVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165658; c=relaxed/simple;
	bh=DUvV1HesAXIAmCp3qcl+Ykaxk4f17asbkrSlhPenJxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivWoi4vJ1eFGa2wsBtQm1b936Ml/vHW1nLJ8nAbB8jtbYE6qlXGrB+9TJmaCewK2X0JQx/AZ6dLpWoN3woONTIMcJvNugnY6gSGvWdb7/6eTGt1+w4xNTXU1shknIbZOosx9ELb4eZeosBywnEX/axPuz0jaufs0p7l7Y5lo+Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoKrPGpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoKrPGpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBEF1F00893;
	Sat, 30 May 2026 18:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165657;
	bh=P/nfNh0T8m/1KkJAGbePJ6ny6W4cxyD6T5UpMZhX/XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WoKrPGpr38m5J5xadENWPXknnki6BEPf8zGJLdWOvWcvmmTJj2MKixzVn/tPl91cg
	 wIypVaN3VuU9n7B9TTJidBRFaD7wu75yqiCvhTmGVhUWLauRpPnzOIfTb+L02Jvoct
	 2/gFYzNqJPr5cxZgqSNTRNY7HLJuFEGZo5r3UCRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Julius Werner <jwerner@chromium.org>,
	Samuel Holland <samuel@sholland.org>,
	Brian Norris <briannorris@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: [PATCH 5.10 144/589] firmware: google: framebuffer: Do not mark framebuffer as busy
Date: Sat, 30 May 2026 18:00:25 +0200
Message-ID: <20260530160228.565585984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit f3850d399de3b6142b02315227ef9e772ed0c302 upstream.

Remove the flag IORESOURCE_BUSY flag from coreboot's framebuffer
resource. It prevents simpledrm from successfully requesting the
range for its own use; resulting in errors such as

[    2.775430] simple-framebuffer simple-framebuffer.0: [drm] could not acquire memory region [mem 0x80000000-0x80407fff flags 0x80000200]

As with other uses of simple-framebuffer, the simple-framebuffer
device should only declare it's I/O resources, but not actively use
them.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 851b4c14532d ("firmware: coreboot: Add coreboot framebuffer driver")
Acked-by: Tzung-Bi Shih <tzungbi@kernel.org>
Acked-by: Julius Werner <jwerner@chromium.org>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Julius Werner <jwerner@chromium.org>
Cc: chrome-platform@lists.linux.dev
Cc: <stable@vger.kernel.org> # v4.18+
Link: https://patch.msgid.link/20260217155836.96267-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/framebuffer-coreboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/google/framebuffer-coreboot.c
+++ b/drivers/firmware/google/framebuffer-coreboot.c
@@ -50,7 +50,7 @@ static int framebuffer_probe(struct core
 		return -ENODEV;
 
 	memset(&res, 0, sizeof(res));
-	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	res.flags = IORESOURCE_MEM;
 	res.name = "Coreboot Framebuffer";
 	res.start = fb->physical_address;
 	length = PAGE_ALIGN(fb->y_resolution * fb->bytes_per_line);


