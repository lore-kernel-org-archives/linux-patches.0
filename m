Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5D4235071;
	Tue, 17 Jun 2025 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177176; cv=none; b=qFn+grQYJwn+L8KD/tOsLPEWD7HC3+NXM4TTZ2zYM5tyr2+CxNjCCCdQGdmrOmUQwbuj6BX6pdCORUFhANHt6OrePTkzBHsGViE3ym1vinP1B4poB40Y7cr7dK3bOeV5BG/y6MjuakpdrDz+SRsas5/7+5VJr0zkRSiEvzNvYgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177176; c=relaxed/simple;
	bh=DvCp6X/wyQm4He1v4rBC3o7S1B4EryhpMc2b3NR/pco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baeM2NPMWOV0ADVDOu0nLu45cR8RLAiJcKd4HERbnzuYPyLn6avD6Z+48cL/yff9FUmaXaxtvfdv5FLXU0CSaCiIKBuoFQ2gMb3E+UrrfnDHKDzG1TMK7IanNVteeSfTnL5alfleFmEFA8XGdYXYOaW9ac+m834l6LxOJ/Bjv7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nvf8Fyl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nvf8Fyl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C070C4CEE7;
	Tue, 17 Jun 2025 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177175;
	bh=DvCp6X/wyQm4He1v4rBC3o7S1B4EryhpMc2b3NR/pco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nvf8Fyl7h/rccGGIGASdv0f02m1wscYJuWiUmRHufES9lI0iua4xLC4YejQqbwD4P
	 b+wX7K9qquhLhqQHyXfsXulhKvlogJTJJI1RRszMuyAJZgfV+dt/xzVd3UCXcGjC6L
	 XlnVM3FU4+u3wkQYZhZUhqcxcPx4ZFNhCkJyGLmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 355/356] net: usb: aqc111: debug info before sanitation
Date: Tue, 17 Jun 2025 17:27:50 +0200
Message-ID: <20250617152352.428374074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit d3faab9b5a6a0477d69c38bd11c43aa5e936f929 upstream.

If we sanitize error returns, the debug statements need
to come before that so that we don't lose information.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: 405b0d610745 ("net: usb: aqc111: fix error handling of usbnet read calls")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/aqc111.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -31,11 +31,11 @@ static int aqc111_read_cmd_nopm(struct u
 				   USB_RECIP_DEVICE, value, index, data, size);
 
 	if (unlikely(ret < size)) {
-		ret = ret < 0 ? ret : -ENODATA;
-
 		netdev_warn(dev->net,
 			    "Failed to read(0x%x) reg index 0x%04x: %d\n",
 			    cmd, index, ret);
+
+		ret = ret < 0 ? ret : -ENODATA;
 	}
 
 	return ret;
@@ -50,11 +50,11 @@ static int aqc111_read_cmd(struct usbnet
 			      USB_RECIP_DEVICE, value, index, data, size);
 
 	if (unlikely(ret < size)) {
-		ret = ret < 0 ? ret : -ENODATA;
-
 		netdev_warn(dev->net,
 			    "Failed to read(0x%x) reg index 0x%04x: %d\n",
 			    cmd, index, ret);
+
+		ret = ret < 0 ? ret : -ENODATA;
 	}
 
 	return ret;


