Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8DA55E4C;
	Tue,  9 Jul 2024 11:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524697; cv=none; b=pjb45hQ07SIPyYqA1aRBMENKr1Bjjx+wx1jVDoKGsX8KNcI6FHlljm/Il6xZ+aK0Aj9vh4ajawfUD+df7Yqq9iAIsCbYZSghGUF4FkWQlKdauI3wcPHRs6+bXI9ImlSgG77jOSXEIRq4fzhtIT2IyxGe077ozYqAQBSjD+FsWAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524697; c=relaxed/simple;
	bh=zYjBZK7/sGfRRVj4pRIzSsjSEEjcJq0ZGNoOxJu5mYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiCXmUBWJgBwAGAmjbO44oO6m7v7vV/iRv0IORxgCmxVxlQF8NdQo1wHKXRp6qb7OzCXllWcXhNLQxNC4apsjvl96EmPhCjzDS58Cojkx4udtnsox08R6Dy8fT7oCMviPyL/HzcO5h5XH979QMEZg10YEswSr+haOpe6wwg9N/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGea0vCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGea0vCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D683FC3277B;
	Tue,  9 Jul 2024 11:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524697;
	bh=zYjBZK7/sGfRRVj4pRIzSsjSEEjcJq0ZGNoOxJu5mYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGea0vCSUICYyeeurluW+Pi4+F3gUB7tKLXDBQxJqfaju4TTOH2RjfhDFn4xVl0bQ
	 0GPhuMonqZYb0jpKUvU8i5vyBcJ7ZTagIrnEKUiJmQoiII1r9AbfcBv3WSFoC4NX0D
	 csLgZy2WCQPElwFrbOYGGEx2MeCUxVqpbtfBWlpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 071/102] can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct
Date: Tue,  9 Jul 2024 13:10:34 +0200
Message-ID: <20240709110654.141453408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

From: Jimmy Assarsson <extja@kvaser.com>

commit 19d5b2698c35b2132a355c67b4d429053804f8cc upstream.

Explicitly set the 'family' driver_info struct member for leafimx.
Previously, the correct operation relied on KVASER_LEAF being the first
defined value in enum kvaser_usb_leaf_family.

Fixes: e6c80e601053 ("can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20240628194529.312968-1-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -124,6 +124,7 @@ static const struct kvaser_usb_driver_in
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
 	.quirks = 0,
+	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 


