Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7B72F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2379CC433EF;
	Wed, 12 Apr 2023 08:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289347;
	bh=8yvw5nfTbRF0oJZP2vUQoe80x2q+tz0LWnS0w2/oPjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpBBNwv6Wbzsjml562hUhlms+Qr04R1tDBL/jLKtc/jJGHysRHlduiBzmiKpq3KG2
	 or4P+mWbXSTkOuQC5WUxShywEjYJh5vFM2tyOw5zbcNWHJyWoT1XuoL99sV096Aznm
	 uYHNrxdbODcyWIE1xICQt7HeqJKgcTfeo7byRecI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.2 065/173] usb: cdnsp: Fixes error: uninitialized symbol len
Date: Wed, 12 Apr 2023 10:33:11 +0200
Message-Id: <20230412082840.706949384@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pawel Laszczak <pawell@cadence.com>

commit 1edf48991a783d00a3a18dc0d27c88139e4030a2 upstream.

The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant
Status Stage" leads to the following Smatch static checker warning:

  drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
  error: uninitialized symbol 'len'.

cc: <stable@vger.kernel.org>
Fixes: 5bc38d33a5a1 ("usb: cdnsp: Fixes issue with redundant Status Stage")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230331090600.454674-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ep0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -414,7 +414,7 @@ static int cdnsp_ep0_std_request(struct
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
-	int ret = 0;
+	int ret = -EINVAL;
 	u16 len;
 
 	trace_cdnsp_ctrl_req(ctrl);
@@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_de
 
 	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
 		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
-		ret = -EINVAL;
 		goto out;
 	}
 


