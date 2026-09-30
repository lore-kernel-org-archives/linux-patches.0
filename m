Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D0242CB08;
	Wed, 30 Sep 2026 19:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797166; cv=none; b=UJdECvWexNakLG6zC1EyJHP6xyHOqSmgsvHIE3mEwOCUQWEEjmLsiisNUg8po2jE0WgjRgoK0wLIXfY6BU6Of0wQvoOJpQTq1BFPzhiveFyaudwMmyWCF/OQ3i3tKh7tuKjCOs2KoG8L+qdKemY4G66Kzss2Aq/t3yLmTv7wAcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797166; c=relaxed/simple;
	bh=U/CxzqfxNBa3NxFjhvo8xDTY866wYn6gcPUOiwT48rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAoKcQmsOHuhJM1zkZgX8SmOAWEhtNz6vB8dxE8g5u6qKY69FD/Dlyucm+vxHzchk3cMVvetQrZDZcS1tp6HKq2Agj0OSDax2ZoWEOmmABcuSQATYPUSt/R0uVPk3znhdcEKz+P9UGcXkRJEMyPqZ+K1SwFd6rC4iaDk6uaFiBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuYJ4AOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuYJ4AOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D641F000FF;
	Wed, 30 Sep 2026 19:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797165;
	bh=bKhGC2j5T79bUZRG6HUjy2xS0vsT1FOTFzG1mwAKKD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FuYJ4AOYWwW+wDJqLxCuWyJmjUDG2ckMD9+3TZbCA2KGH7ZpxfssDtKPvVAEZqf0U
	 N+HezxSqH11PEvlx83hOBbWl9s029MbUqsZNXgR8HGqANswjaAJzErFZYgX2sS1GHG
	 7PpSKX/aSQSCK8gb6xS948Cu2E7FRJDYfibUncsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 6.6 1170/1193] lan78xx: Enable Auto Speed and Auto Duplex configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:30:54 +0200
Message-ID: <20260930152500.238506418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit 799f532de13601f91ecb9cc6169d45d6e6933b0f upstream.

Enabled ASD/ADD configuration for LAN7801 in the absence of EEPROM.
After the lite reset these contents go back to defaults where ASD/
ADD is disabled. The check is already available for LAN7800.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20240529140256.1849764-3-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Minh Tiến Nguyễn <zizuzacker@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3069,8 +3069,11 @@ static int lan78xx_reset(struct lan78xx_
 		return ret;
 
 	/* LAN7801 only has RGMII mode */
-	if (dev->chipid == ID_REV_CHIP_ID_7801_)
+	if (dev->chipid == ID_REV_CHIP_ID_7801_) {
 		buf &= ~MAC_CR_GMII_EN_;
+		/* Enable Auto Duplex and Auto speed */
+		buf |= MAC_CR_AUTO_DUPLEX_ | MAC_CR_AUTO_SPEED_;
+	}
 
 	if (dev->chipid == ID_REV_CHIP_ID_7800_ ||
 	    dev->chipid == ID_REV_CHIP_ID_7850_) {


