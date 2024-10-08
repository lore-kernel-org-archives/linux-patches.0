Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9908B1DEFF6;
	Tue,  8 Oct 2024 13:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393459; cv=none; b=UN0FL8iAcVLBdXYtX4srtsT5iNHqGqCyqE55CMa4mG0345A9k/51v4cv2/yWxmeju3S2mQpU1UeQgSdIERQ2D0EzZZ01m+GU5CwpPQiyTk6kxXEsOot0+aXDqehOMpRrgyqvlLj5Sq4bKADpz+Fo9eZxCBIDOj53N8zMqrw7PEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393459; c=relaxed/simple;
	bh=uHKne9paOoXw/2MbhadEmNavQm1QyTob87V24Vzj5lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eyn6K3Cka6gQAu2zBLDOVoWxyuGIEOz2zvKM3G3J10OYf6+OOG0+DxoPlKPLhDhLF0tIvTC8q3zj7wJZzhdfLTcJOfssM8g0ldxNygh4yykG4l9FwD3KIISCoQ1+CUXzyjsrREdYPWgW1w5vpUW0Td0vjeKklnYZvo04JT9Awc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gp6T4kJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gp6T4kJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50BDC4CEC7;
	Tue,  8 Oct 2024 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393459;
	bh=uHKne9paOoXw/2MbhadEmNavQm1QyTob87V24Vzj5lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gp6T4kJ8pRoapMeWliqvkIlaiI80l4pleyFeAWFp9jVJuhaXcBmIZWDWXns/njWsf
	 AAKqMM6ZSJgJwZVT7K8j9X1NNccQi1vXWbzJ+tek+kk66sbkdZCctpxo9/zlPG5r6r
	 wqGdh4ATejPVmVGT8Twbtpqp6lEPuWugMSjxqmwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/386] power: reset: brcmstb: Do not go into infinite loop if reset fails
Date: Tue,  8 Oct 2024 14:06:12 +0200
Message-ID: <20241008115634.434576550@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit cf8c39b00e982fa506b16f9d76657838c09150cb ]

There may be other backup reset methods available, do not halt
here so that other reset methods can be tried.

Signed-off-by: Andrew Davis <afd@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240610142836.168603-5-afd@ti.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/brcmstb-reboot.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/power/reset/brcmstb-reboot.c b/drivers/power/reset/brcmstb-reboot.c
index 0f2944dc93551..a04713f191a11 100644
--- a/drivers/power/reset/brcmstb-reboot.c
+++ b/drivers/power/reset/brcmstb-reboot.c
@@ -62,9 +62,6 @@ static int brcmstb_restart_handler(struct notifier_block *this,
 		return NOTIFY_DONE;
 	}
 
-	while (1)
-		;
-
 	return NOTIFY_DONE;
 }
 
-- 
2.43.0



