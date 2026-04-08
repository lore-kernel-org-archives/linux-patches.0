Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EE8346FB0;
	Wed,  8 Apr 2026 18:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673863; cv=none; b=PpV8vOYZdsxI1WwkU3EFCrHOtShG7D/bQ8Z/Z61syqRwHY32hmBgAoqC8kpmdwjhoXV31AYRHO+AgsOZSoi9YHa7Ld72tON4rOZ2rQXlnVLQVWaDCJvG0dtIReiTCPLADor7jVSdx8Q5t0ZSZBlHVrX8lTXc6LKXJtFepHFCU5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673863; c=relaxed/simple;
	bh=Ok9msOjVvjPdGwy0E8T3BMypb7tIUgRh3rKPtOj1LIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkuITSR91reu+eueRahX4yn9fe4OxgdmuWxrXA7slYX2LTi7mfRlt08mnEVfvuYBVGEk3ruieee//CKKuTOPS2ePnS22yyE5pvJ4HKPO+z5joi3jWY0u8LSiVz6uvhle809OOaxLh0+NXdMrf8jXcfD9W0XSFlv7GlzC8x61E6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPa7R1Zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPa7R1Zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A825CC19421;
	Wed,  8 Apr 2026 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673863;
	bh=Ok9msOjVvjPdGwy0E8T3BMypb7tIUgRh3rKPtOj1LIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPa7R1ZftoekVWqW/UgRYb80wl8x8Orv6dxMd1gPudICJsGcHT5+osytcWhD3yFc1
	 SK6FUAGUDSAwWtIkBiA6rnzfUUy3yimes7F20kdsrrK2LP+jwgREDbGQf0JbtCjNuh
	 LTw05buZkQwLYW579Z4QoYpbIjR2tUKhi5C57TgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Karsten Hohmeier <linux@hohmatik.de>
Subject: [PATCH 6.12 119/242] ALSA: ctxfi: Fix missing SPDIFI1 index handling
Date: Wed,  8 Apr 2026 20:02:39 +0200
Message-ID: <20260408175931.541257263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b045ab3dff97edae6d538eeff900a34c098761f8 upstream.

SPDIF1 DAIO type isn't properly handled in daio_device_index() for
hw20k2, and it returned -EINVAL, which ended up with the out-of-bounds
array access.  Follow the hw20k1 pattern and return the proper index
for this type, too.

Reported-and-tested-by: Karsten Hohmeier <linux@hohmatik.de>
Closes: https://lore.kernel.org/20260315155004.15633-1-linux@hohmatik.de
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260329091240.420194-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctdaio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -119,6 +119,7 @@ static unsigned int daio_device_index(en
 		switch (type) {
 		case SPDIFOO:	return 0;
 		case SPDIFIO:	return 0;
+		case SPDIFI1:	return 1;
 		case LINEO1:	return 4;
 		case LINEO2:	return 7;
 		case LINEO3:	return 5;


