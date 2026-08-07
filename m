Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EA543786B;
	Fri,  7 Aug 2026 15:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115533; cv=none; b=hu2x0Mq7paivZqZpQNKuESUPRAf4/QOWrDkSyPOk6+ABYwQeKGZwJs+MOoz/zZ28S8wpDrVTtCA99RX8jbSRAj1029n7HxjCZIzHHAK6M8WOMHY9zkWJPekIq6zsDaGrn97Uhl4ToPBNnacqm34uBHdzIlxUOr90K4w2Y5TaJJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115533; c=relaxed/simple;
	bh=wRekNIb/q/M5eKZCU0YUA6rhOfVD7eIuzn1D9MeoGXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0W7LjYxttrueb11BkNCuXL2D2cpCsYRMnuhg6CTUYZNC4YccxSRPg9QSNNFFwjMVLbiWnfLHhNrTOVjjY46A58EVkAqZHyUvzE9y76Yz0u9+vK1sfFDvS+IEv3+D1iEqX6MWAfBaI+JdgHFISah2Xl7rtKkM6loY2yeOEBI1f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0id7joaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0id7joaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408631F00A3D;
	Fri,  7 Aug 2026 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115528;
	bh=LTHFxcn6J3b7ZQf5quBvMsJDVLcs42M46fWhdh3yrsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0id7joaqJA2tmst5IzuNwS7zF9hd9k5cmF2zASC/2g8YxAmFrIgCJ7xhvHOkQkVmq
	 /QxDyXR4ngIfN0OTqhJ0p5YnTZ8dVQRyIObW+jU6uheFfaEFU2c86T6vdTXlyK/vkC
	 G/F/0RTwIWqzDLc6jQ6cTzq31L492qzZLamwxufE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 308/396] can: ctucanfd: use self-test mode for PRESUME_ACK
Date: Fri,  7 Aug 2026 16:37:48 +0200
Message-ID: <20260807143430.914494030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

commit c31a435933f18be0f874302161333e9f16e200a0 upstream.

Use self-test mode for CAN_CTRLMODE_PRESUME_ACK so transmitted
frames can complete without receiving an ACK.

ACK forbidden mode prevents the controller from acknowledging
received frames and does not implement the presume-ack behavior.

Fixes: 2dcb8e8782d8 ("can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260722192726.230729-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -340,8 +340,8 @@ static void ctucan_set_mode(struct ctuca
 			(mode_reg & ~REG_MODE_FDE);
 
 	mode_reg = (mode->flags & CAN_CTRLMODE_PRESUME_ACK) ?
-			(mode_reg | REG_MODE_ACF) :
-			(mode_reg & ~REG_MODE_ACF);
+			(mode_reg | REG_MODE_STM) :
+			(mode_reg & ~REG_MODE_STM);
 
 	mode_reg = (mode->flags & CAN_CTRLMODE_FD_NON_ISO) ?
 			(mode_reg | REG_MODE_NISOFD) :


