Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E59A26B971;
	Mon, 13 Apr 2026 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098267; cv=none; b=nqyac2bx1cUm5Rb15ii88uE5gOYJw2h26uF5zpWDXTgAqsqNN5P7WcqRkWAv3R7wiIWq+rsTTeYwL+/bGNvazuPUmJSaN/wL0lK4RcQXhF+1RjRvHb+5wTMAsk2gUq5f7w/ySljpgvyfI8vUqPRuxBBIOvbB99K8eFygdbYNR7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098267; c=relaxed/simple;
	bh=GonBX0TabBVRF8P5U274cZj6NjyQRJcU7bXjg5lNHpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqR1vk2X4skwCxK/Gh7SXA0IPFOrUxjBIHS5Qr1QNHGRG06zRBPEtL4PScn5NxHOoODqMsHTecCZ8lTI4H8EPAd6VIDldfSIFAJwFxnEkUKItx2sVh+n1kqLHedcGNmIT3PIH7efq+1mBU1VTqEpP30NLHVvmGntkqz86bwkrio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJPaO/C/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJPaO/C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996CBC2BCAF;
	Mon, 13 Apr 2026 16:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098266;
	bh=GonBX0TabBVRF8P5U274cZj6NjyQRJcU7bXjg5lNHpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJPaO/C/51W0/P9jJvXNbwPw1gwK9BSc4Tp1rBNmfsS1LEEyD5URl4X5Rdua2sOc6
	 okJQhlRoDnEUuw44WhiS+vuUcSYay7pM0v182kk5+RxFpf3KFEcfJ7y3YVzGIjtjiE
	 ZL2/H2i6liB5PQB/HBv06Q+L1aW74oIzdnh7S1BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoltan Illes <zoliviragh@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 458/570] Input: xpad - add support for Razer Wolverine V3 Pro
Date: Mon, 13 Apr 2026 17:59:49 +0200
Message-ID: <20260413155847.626079729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zoltan Illes <zoliviragh@gmail.com>

commit e2b0ae529db4766584e77647cefe3ec15c3d842e upstream.

Add device IDs for the Razer Wolverine V3 Pro controller in both
wired (0x0a57) and wireless 2.4 GHz dongle (0x0a59) modes.

The controller uses the Xbox 360 protocol (vendor-specific class,
subclass 93, protocol 1) on interface 0 with an identical 20-byte
input report layout, so no additional processing is needed.

Signed-off-by: Zoltan Illes <zoliviragh@gmail.com>
Link: https://patch.msgid.link/20260329220031.1325509-1-137647604+ZlordHUN@users.noreply.github.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -271,6 +271,8 @@ static const struct xpad_device {
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a29, "Razer Wolverine V2", 0, XTYPE_XBOXONE },
+	{ 0x1532, 0x0a57, "Razer Wolverine V3 Pro (Wired)", 0, XTYPE_XBOX360 },
+	{ 0x1532, 0x0a59, "Razer Wolverine V3 Pro (2.4 GHz Dongle)", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },


