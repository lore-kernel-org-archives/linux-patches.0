Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFB236D50D;
	Wed,  8 Apr 2026 18:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672172; cv=none; b=sIsyE0WKGSLKCS3GYBc+k7q6faNQdho9X5td+fEhUgc0zKUFIdvOlRwrDYOYrhPHm7GdRjRX/eQyd6xw8bFzjjaUDprdv6gD+9NcPhvSeJLsS70BSmf9NnjsKc8C/mvufxbB+FEJ+OVAz6YjY9JWexnFTu5z9L2wj7gwTNHbOx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672172; c=relaxed/simple;
	bh=T44GsQ0bO/KbOCwbGDFGFRdstqRprLai1uuh3Lxlb2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce+ScZBluJmbONH8exp5Sp5PED2UHKIUzR3fO8CkeJDVUQiTUVRKmsNndXblC8D3vMGZi1Tex61mjmLpw+9vuWyvKkbmmxszsRY01SbwJhiILNlBDyvt8oRdLe2ZzJHCQwMtbCEtvuX6bE9/y9X7g9OtxDRh7RpA7R7mtd/5AMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpcUBS54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpcUBS54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375C1C19421;
	Wed,  8 Apr 2026 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672172;
	bh=T44GsQ0bO/KbOCwbGDFGFRdstqRprLai1uuh3Lxlb2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpcUBS54UDbXHyxn3ckJvSEhQNp8fRtffwhtZpmJIfqDQ1ODNt+ib7sRWbqKex2yI
	 DKoytPNhbb1rsT/kAapjX3dXBDBCgsR617vYuGWQuHjUNyNgiao1Qplmp+mlqQDpsz
	 TEFPzpnAMV+dGDi0i//8Ug95+5rjBuzGQOFyb1g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoltan Illes <zoliviragh@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 217/312] Input: xpad - add support for Razer Wolverine V3 Pro
Date: Wed,  8 Apr 2026 20:02:14 +0200
Message-ID: <20260408175941.861524350@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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
@@ -289,6 +289,8 @@ static const struct xpad_device {
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a29, "Razer Wolverine V2", 0, XTYPE_XBOXONE },
+	{ 0x1532, 0x0a57, "Razer Wolverine V3 Pro (Wired)", 0, XTYPE_XBOX360 },
+	{ 0x1532, 0x0a59, "Razer Wolverine V3 Pro (2.4 GHz Dongle)", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },


