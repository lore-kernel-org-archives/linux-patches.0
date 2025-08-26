Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF932FDC5C;
	Tue, 26 Aug 2025 13:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215475; cv=none; b=dhh51zlrIx+7e6KfZIKUwhIFDnLuZwoZz1J902LgeKLJcINFJmdrJgdOcTZSu7bMhcTbb/S0QkGYhBjsDDujypGQ5laAx/Vs+wz8t0/snsRWH13tohnKrTonx7Tt9es82i55ByiHux+HuQhqhLxyURcyK7dFk2kyBfcgAfIWcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215475; c=relaxed/simple;
	bh=RGnN2lnKJP/4x53iEryR3XC/5bYVRxr3mFHC/HCxGgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYE4T4Dc+2DkjSQ/M3BTybvVU0HiW0bh2i4JWobybLXmPFSrCSFt4fWJ3H0JrlwbhaC0lkX6Y5mXLTGZMIZhbohBfE5kg0cvFo6GYcd10PfBldtYXiIXJi3ndLmWxjEuACo1P0Pv97ZbruotEieo+a03LAHf16QZaOBMzL9YaZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTnCb4lW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTnCb4lW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00787C4CEF1;
	Tue, 26 Aug 2025 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215475;
	bh=RGnN2lnKJP/4x53iEryR3XC/5bYVRxr3mFHC/HCxGgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTnCb4lWoqyZE4FKcBJdRmf4/VfU3gqw/S+FJr0EQ4kh+IL9WefK2VAJ3ELd8+/il
	 e0RUZ/NCpfjysy3JSpQAAz/2gU8cCs2bT2sSBZoDrJ8S3YduhPVAextG1kvFD71gGo
	 9C4D6SdZEre+Lnu5iNtWq9xYvTqXSSAhicFARxpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/644] usb: net: sierra: check for no status endpoint
Date: Tue, 26 Aug 2025 13:02:18 +0200
Message-ID: <20250826110947.671303148@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit 4c4ca3c46167518f8534ed70f6e3b4bf86c4d158 ]

The driver checks for having three endpoints and
having bulk in and out endpoints, but not that
the third endpoint is interrupt input.
Rectify the omission.

Reported-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/686d5a9f.050a0220.1ffab7.0017.GAE@google.com/
Tested-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Fixes: eb4fd8cd355c8 ("net/usb: add sierra_net.c driver")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20250714111326.258378-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sierra_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index bb4cbe8fc846b..2979236621961 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -689,6 +689,10 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 			status);
 		return -ENODEV;
 	}
+	if (!dev->status) {
+		dev_err(&dev->udev->dev, "No status endpoint found");
+		return -ENODEV;
+	}
 	/* Initialize sierra private data */
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv)
-- 
2.39.5



