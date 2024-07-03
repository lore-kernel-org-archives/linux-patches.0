Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18536183079;
	Wed,  3 Jul 2024 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006244; cv=none; b=pi4ivzHcdj6u7hoSRpP6tIiKSdtcB32OjINDVsrAs3TsZ60vlN+j6jgYYisliQMb2qePDvYgka8OxabY8yTWlbqZaj8pdniTIbt0rvmBc8rcZSXqVdKddb4K27hYdZSOqHWpFhzGSWoidWFRW5w2nvCOciFO2yUOCTRrrt/SyYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006244; c=relaxed/simple;
	bh=izql2Vlww/1/vuofIcshz4/EmlFUFh9MqT26x7Gyd48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9P8ycE1VbRaDpakPAjxxxbLf+KGMgkg3+48RrZe4tT7Xp1HloVbENDvFRlee2HWeUNZNGCxctZATjXVcy5E5zcy4VFLmPrasvTf4Com9QbELKER9a8LOZJVeOs0MEcNBJpYefdyf39eIjRULPpDOLn31QBqBrUAsPSjcRuEq+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOiSs2LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOiSs2LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF34C2BD10;
	Wed,  3 Jul 2024 11:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006244;
	bh=izql2Vlww/1/vuofIcshz4/EmlFUFh9MqT26x7Gyd48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOiSs2LE7V6QKENvINkrqmqEsbvk5w+lVTcegUtQg26IWBsU4kb2MKtEvyPtYXPbD
	 Tl1+cjSnMW35wMFBrAMl48PAjQTuR7woG5cGXNcXUpDxmWA78GJED7flKZkqxer33r
	 SyNk5P4focx9cETq8ho6j8gcUviFcCqjJ4QSe1+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 317/356] usb: gadget: printer: SS+ support
Date: Wed,  3 Jul 2024 12:40:53 +0200
Message-ID: <20240703102925.109349170@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit fd80731e5e9d1402cb2f85022a6abf9b1982ec5f upstream.

We need to treat super speed plus as super speed, not the default,
which is full speed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240620093800.28901-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -210,6 +210,7 @@ static inline struct usb_endpoint_descri
 					struct usb_endpoint_descriptor *ss)
 {
 	switch (gadget->speed) {
+	case USB_SPEED_SUPER_PLUS:
 	case USB_SPEED_SUPER:
 		return ss;
 	case USB_SPEED_HIGH:


