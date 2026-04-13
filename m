Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D1531E857;
	Mon, 13 Apr 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099543; cv=none; b=RRSyCh8jlcPWVkjNepOGunjAySf4EY8FuneJuCgibcYxLJKjqka8VTV/CcGavslPS6syqhgn5ZVD9xKNKD3V5vDzmNojD+nDsiDJTUOxmxskv7WImtdADudQYS8t0IpCJQT9PC/0c467RhQlscVaHlO1GCudV2Gx3cyTQu0YnMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099543; c=relaxed/simple;
	bh=U3G4BCBsmc3cQcU53izCd5d2tOUwpeVVQMBpEXxKe1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITXWK/WV2WQnxq+tfBwWZOFRndt0Z7701VPc+sToFz5XvXnb9rWfMutwQm/Zc52ykayqdO7mkggTVfjEl1kqp0JVz2Fu+r+EkvxVj9bKFtzUZSMXMYREcg0bU7SXY9J4bWs0L5VE+4B7rvVNyi7VkxklHIQ0vl/9EU3SLL2rvW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Co2ayS/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Co2ayS/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B1EC2BCAF;
	Mon, 13 Apr 2026 16:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099542;
	bh=U3G4BCBsmc3cQcU53izCd5d2tOUwpeVVQMBpEXxKe1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Co2ayS/R48D0e5S1jG5s/ga1gvMocEtIdoiR8IhvUq9vknFiMXBbm5r2d29V/5hQz
	 efVf7zTRzqojJn+pBFMoz7oZW2zYbcMRf/FlEHRa7R6310pUer/nUBg7llKCVtZVM2
	 imPX+aek0LmlDxhgaZ6SK6xeyqS1fy3JmVXk3t1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoltan Illes <zoliviragh@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 379/491] Input: xpad - add support for Razer Wolverine V3 Pro
Date: Mon, 13 Apr 2026 18:00:24 +0200
Message-ID: <20260413155833.222521161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -269,6 +269,8 @@ static const struct xpad_device {
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a29, "Razer Wolverine V2", 0, XTYPE_XBOXONE },
+	{ 0x1532, 0x0a57, "Razer Wolverine V3 Pro (Wired)", 0, XTYPE_XBOX360 },
+	{ 0x1532, 0x0a59, "Razer Wolverine V3 Pro (2.4 GHz Dongle)", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f00, "Power A Mini Pro Elite", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f0a, "Xbox Airflo wired controller", 0, XTYPE_XBOX360 },
 	{ 0x15e4, 0x3f10, "Batarang Xbox 360 controller", 0, XTYPE_XBOX360 },


