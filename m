Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC212B98
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEFCC433C7;
	Thu, 24 Aug 2023 14:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888898;
	bh=5WqTcoIHYOO8xCOAukHJuFlTzCWeTEwW0DosCea5RgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9k/IZNUk8IuzVmcByAmcM8WUnNz3mxujGf0QknH+IBf83vDc1piMqxJ2AECTXokp
	 611km1GmtxakfBiwxZ/TfgJ+nKDh9TOllPtVAhiIQknV30mrVuwOaJIfilyONAimtw
	 +x9MAVDzRP9+TuuMQi5aBCV6JqH1aBZVxdO3i5K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kushagra Verma <kushagra765@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/139] usb: dwc3: Fix typos in gadget.c
Date: Thu, 24 Aug 2023 16:49:36 +0200
Message-ID: <20230824145025.935667922@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kushagra Verma <kushagra765@outlook.com>

[ Upstream commit af870d93c706c302a8742d7c751a60a832f7bc64 ]

Fixes the following two typos:
   1. reinitate -> reinitiate
   2. revison -> revision

Signed-off-by: Kushagra Verma <kushagra765@outlook.com>
Link: https://lore.kernel.org/r/HK0PR01MB280110FAB74B4B2ACE32EA5FF8479@HK0PR01MB2801.apcprd01.prod.exchangelabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c8540870af4c ("usb: dwc3: gadget: Improve dwc3_gadget_suspend() and dwc3_gadget_resume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e0c67a256c214..2d5a4d0e63c61 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3531,7 +3531,7 @@ static void dwc3_gadget_endpoint_stream_event(struct dwc3_ep *dep,
 		 * streams are updated, and the device controller will not be
 		 * triggered to generate ERDY to move the next stream data. To
 		 * workaround this and maintain compatibility with various
-		 * hosts, force to reinitate the stream until the host is ready
+		 * hosts, force to reinitiate the stream until the host is ready
 		 * instead of waiting for the host to prime the endpoint.
 		 */
 		if (DWC3_VER_IS_WITHIN(DWC32, 100A, ANY)) {
@@ -4059,7 +4059,7 @@ static void dwc3_gadget_hibernation_interrupt(struct dwc3 *dwc,
 	unsigned int is_ss = evtinfo & BIT(4);
 
 	/*
-	 * WORKAROUND: DWC3 revison 2.20a with hibernation support
+	 * WORKAROUND: DWC3 revision 2.20a with hibernation support
 	 * have a known issue which can cause USB CV TD.9.23 to fail
 	 * randomly.
 	 *
-- 
2.40.1



