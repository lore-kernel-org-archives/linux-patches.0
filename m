Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA591FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54717C433D2;
	Fri,  3 Feb 2023 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420071;
	bh=CIFkJZf8sCdAydqdQGyJEX/FTSLpU5hjgwBIQF+up5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+zetsGxBiE1brdMMnk30tpPoqGe2goUA6Pcvk2uUf2fNR9JUjOMXTPZVVVxVmqhy
	 bbzU1dp0jx0XISkh7pybBC+EoGOUP741HaMPeVF4UfwILr9C6rWDBKr1Eg7H1EH8TN
	 iYoiT/GRWUTxI9vdXB917+rQIoYSXmvVvuA4oQsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/134] Revert "Revert "xhci: Set HCD flag to defer primary roothub registration""
Date: Fri,  3 Feb 2023 11:12:56 +0100
Message-Id: <20230203101027.048263237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This reverts commit 049849492b77aa0df7f7130f1d522f3553c4084b.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 35d96796854d..b8915790a20a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -693,6 +693,7 @@ int xhci_run(struct usb_hcd *hcd)
 		if (ret)
 			xhci_free_command(xhci, command);
 	}
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
-- 
2.39.0



