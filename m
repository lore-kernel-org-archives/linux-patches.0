Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60115513555;
	Wed, 30 Sep 2026 16:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786088; cv=none; b=QBjpI2VN1imEXhhj9GhOK7UGKH4spOX3UBvkEbz7U/VlZU6ygExqTTXzsDTxozZ6Q2WkwRvJzqWJsTe7O5N7Ps1NjyEti/N0zvaEHRqjSUkMDvvpH1M5lcn1sWACK6W9xFi2PVcEIpCt8tODgBe0WV0dZaQGEjaYJQ8tnTCRumQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786088; c=relaxed/simple;
	bh=zDzzWagEuqDuCjEAyY7OmXsDD9a4S0DOTVvH4+liLy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwThGIuiGMkCoa3kgvxEG8+LLrt2/BW/miPDcW5iXZm6N9RIV4Zez6bxghhb6KK8RuI0P2nKn8GBlvnUFfsXOxVpfHWqVfpgdj9QIMZ+Pt7IDDM2psxCd7hsP3Gai8W5mpdmaMRBJXEDnl/YbjloPdaXf9IVyqyv82KUl9IBRWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN/BcdES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN/BcdES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABEC1F000FF;
	Wed, 30 Sep 2026 16:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786087;
	bh=uc133f2fdcD7Fy906zCJGF3Pjw6V9adtb1XC8W4swMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sN/BcdESVyip4gdHZhj86qTvo36Sm6gm+wwOA5mUQoH/+BzNJjK4IRRzfDZHXboLB
	 WbMKnFWBf2+QjKA9Dmqbj/jie73iyDBC2i+Aymb9f5CmgT/E1pKttzZjAHfJntfQPF
	 RhYIWo00n7RRwxHPBm9Sm+UL/SUXydKhRcpfYs4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erich Sartison <byt.es@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 693/982] Input: xpad - add support for Victrix Pro BFG Controller
Date: Wed, 30 Sep 2026 17:23:49 +0200
Message-ID: <20260930152431.645450401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erich Sartison <byt.es@mailbox.org>

commit 971fa7ea8621e123feb9c8d7dc61be1c656bd945 upstream.

The controller doesn't currently work via USB-cable.

Signed-off-by: Erich Sartison <byt.es@mailbox.org>
Link: https://patch.msgid.link/20260903103137.630170-1-byt.es@mailbox.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -240,6 +240,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0213, "Afterglow Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x021f, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x0246, "Rock Candy Gamepad for Xbox One 2015", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x024c, "PDP Victrix Pro BFG Wired Controller for Xbox", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a0, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a1, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x02a2, "PDP Wired Controller for Xbox One - Crimson Red", 0, XTYPE_XBOXONE },


