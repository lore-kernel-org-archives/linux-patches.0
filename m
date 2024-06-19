Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F44149007;
	Wed, 19 Jun 2024 13:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803737; cv=none; b=VT85bQKo5m+zaEAlrA/8eHDiSq+XZsjCkAgQqbc9eWpDNF6InklReJksefD4G+kZXBIY4dXSnbd3u7xg0JnM/iUSwYay64QJ7ZHpf5OIh5pcFELhm2YA6vlTy56PLN27Hl1tYJMDSEY5hQVHBFUCFrPOvgwL7DDCLUI6Fk7zVkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803737; c=relaxed/simple;
	bh=rXQv6y0JSPye6yqITUhadQCHb/TjGPRuXnBU4LetJQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5HlYGmSXTAlhp4EPJxFDRuazbmtie7gFQUAUN8oYFgNtv7GUoqrTm/LtfQB7mwU3IbiEOuy6IfeCEgNesHNbeX/TjzPjpzkMW7zszYZb1L6tHqIjkIwo21NlBUrA3lGtLAP41lJpP8GyvBAqgZXr8UTpZGERBYuyds5xNz4VKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0acIV1cH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0acIV1cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AACC2BBFC;
	Wed, 19 Jun 2024 13:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803736;
	bh=rXQv6y0JSPye6yqITUhadQCHb/TjGPRuXnBU4LetJQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0acIV1cH3mxHTo3wjb5eoa1AQh2tvdGso5NhQBG39tYjYTJT8YsHISgYcIhO4hTpK
	 ZZQbb4jDOLMamo6jrqTCGNQYtyog65FXi4UP7RfkovcwvBXWGMy2aXqUzgfIYPqerO
	 26HIZs9zty5UTwHQlbyreqJTlesBtIPwYsd94qn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ernberg <john.ernberg@actia.se>
Subject: [PATCH 6.1 086/217] USB: xen-hcd: Traverse host/ when CONFIG_USB_XEN_HCD is selected
Date: Wed, 19 Jun 2024 14:55:29 +0200
Message-ID: <20240619125600.006714511@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ernberg <john.ernberg@actia.se>

commit 8475ffcfb381a77075562207ce08552414a80326 upstream.

If no other USB HCDs are selected when compiling a small pure virutal
machine, the Xen HCD driver cannot be built.

Fix it by traversing down host/ if CONFIG_USB_XEN_HCD is selected.

Fixes: 494ed3997d75 ("usb: Introduce Xen pvUSB frontend (xen hcd)")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: John Ernberg <john.ernberg@actia.se>
Link: https://lore.kernel.org/r/20240517114345.1190755-1-john.ernberg@actia.se
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_USB_R8A66597_HCD)	+= host/
 obj-$(CONFIG_USB_FSL_USB2)	+= host/
 obj-$(CONFIG_USB_FOTG210_HCD)	+= host/
 obj-$(CONFIG_USB_MAX3421_HCD)	+= host/
+obj-$(CONFIG_USB_XEN_HCD)	+= host/
 
 obj-$(CONFIG_USB_C67X00_HCD)	+= c67x00/
 


