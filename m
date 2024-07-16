Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BAD19DF71;
	Tue, 16 Jul 2024 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144325; cv=none; b=UMBVNSevmKPJPaQWW3Nh+Jp0hXXNuyq4nkJQprCRPooMNJojV8t9jjW+evEBV/gYpSafLIpQma1sTiY3c7FoiUMGCn1i8FdWAs3odQUwQemq0mudeBmHTS3K0DK25zRqQCVk9CYMwqt5n6fASr5dSZhe8x+ZuImYwI0KBAfCEQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144325; c=relaxed/simple;
	bh=TKrUuKdsbJaxg0o9aTysdmW70TTjwauY92Oj7EkqIwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCVCcD6A1BW99R+/CyyQLycQJaD/WG6tl8uQkDczTekpxbeWJx8rXzKb3Dm7RK29b5+bX8vWYGYJv1z1WyKvMo4Brp/mrqmhgb5mquY+TWalkxZbgWVEiYw6mr7aQukQNxNMVcIwzWWU1o3XvxBmjy1X7iWvfTtIyvr4U8qoNkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bt4b6fEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bt4b6fEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97614C4AF10;
	Tue, 16 Jul 2024 15:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144325;
	bh=TKrUuKdsbJaxg0o9aTysdmW70TTjwauY92Oj7EkqIwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bt4b6fEbX3LGSYy3+oFP7+E5fzje5yae4g9xtlVK3RSfO3q8iVCE/3kAdfVUDxlNs
	 rJ/8zY0cm44u7VEs6taOx2Zatzh6kz5cchwj5v+Kr5vq35y7drtBksKO60SD+dsu2v
	 avNkncVJyraNF/cXe5eYxNLwKR8/Lax0UzR4EKtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 35/78] can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct
Date: Tue, 16 Jul 2024 17:31:07 +0200
Message-ID: <20240716152741.997332300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -114,6 +114,7 @@ static const struct kvaser_usb_driver_in
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
 	.quirks = 0,
+	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 


