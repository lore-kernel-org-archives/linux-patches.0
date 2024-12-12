Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D723874D;
	Thu, 12 Dec 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020604; cv=none; b=Lzvm4Dr/yJIXYeWMSfujzlOumaLTofH/J5phxALtQsXQE+Fbu0e+u3/VTBLAFDYIWxcI2fEnZgEtTtw3Gh6TZy78XHmu0KU+EPMQqQ3vEGPaZuvusg1Rv75wJDrDob+2uqh6CH9J0Hol1kP4/SdjaSYseXZK+4tHLqFChR3vnbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020604; c=relaxed/simple;
	bh=MEKrE5vio2wtmTjOSBXzMuQBVypzB+nxwRIZAIe/nT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6y3eM6F/V/yDm0uBUthXSyMXkyjgN9I6KTRglbz8nC+N5kc20598e5A34W6amnhjRfz9ivldHtltLmICe0VRc2PA+P7w4EQL4o1CRfer31TvpbujXKD43pHvwzaYKElc2P4Nd18NflBCtaI3Ui+cdavZtagNf4PdvFppzdexSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpN3UZsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpN3UZsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EA8C4CED0;
	Thu, 12 Dec 2024 16:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020604;
	bh=MEKrE5vio2wtmTjOSBXzMuQBVypzB+nxwRIZAIe/nT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpN3UZsypFAhnfgXyKloZIcf1gRe5EBBuAvHDx8bLwI51cCB5LHu8j3rOg5FmOiLb
	 UjxmfwLzys24e81Q/AtyA+z7gayNsrH9o0tKeE3UTwa2XbdS+Va8nAboyeW5+kc0oZ
	 ftuxZJyztOuL6doKhtzPl+8VuqwnXkQdSTZdxslU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 511/772] can: gs_usb: gs_usb_probe(): align block comment
Date: Thu, 12 Dec 2024 15:57:36 +0100
Message-ID: <20241212144411.066946220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 5780148bedd6aa7e51d3a18cd70f5b9b6cefb79e ]

Indent block comment so that it aligns the * on each line.

Link: https://lore.kernel.org/all/20230718-gs_usb-cleanups-v1-2-c3b9154ec605@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 889b2ae9139a ("can: gs_usb: add usb endpoint address detection at driver probe step")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 1d089c9b46410..cb96e42961109 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -1400,8 +1400,8 @@ static int gs_usb_probe(struct usb_interface *intf,
 		dev->canch[i]->parent = dev;
 
 		/* set RX packet size based on FD and if hardware
-                * timestamps are supported.
-		*/
+		 * timestamps are supported.
+		 */
 		if (dev->canch[i]->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
 			if (dev->canch[i]->feature & GS_CAN_FEATURE_HW_TIMESTAMP)
 				hf_size_rx = struct_size(hf, canfd_ts, 1);
-- 
2.43.0



