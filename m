Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3685914288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUVWw1LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5A9C433C7;
	Mon, 16 Oct 2023 14:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467853;
	bh=4ZbaiS0xxa8vL9yw/WUOq6857V6vdSeC0KCzNkNFf9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUVWw1LA3mXrXyhQ7Wtbr9CJTt+hUssgxk5eCP5wPHiwbAMaPyiMkZnBjQMk4G774
	 eYg5A8u+Xs5pXywX5V3Ucjx7xVE8dkABtNjxdXkHj36D8VbVXM6IPENyDd3z6s/5PT
	 l0+IksBPmOySoCWMgkpV0g4eWWRpbZ3xod0nSBHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Roger Quadros <rogerq@kernel.org>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.5 105/191] usb: cdns3: Modify the return value of cdns_set_active () to void when CONFIG_PM_SLEEP is disabled
Date: Mon, 16 Oct 2023 10:41:30 +0200
Message-ID: <20231016084017.842602099@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit 9f35d612da5592f1bf1cae44ec1e023df37bea12 upstream.

The return type of cdns_set_active () is inconsistent
depending on whether CONFIG_PM_SLEEP is enabled, so the
return value is modified to void type.

Reported-by: Pavel Machek <pavel@denx.de>
Closes: https://lore.kernel.org/all/ZP7lIKUzD68XA91j@duo.ucw.cz/
Fixes: 2319b9c87fe2 ("usb: cdns3: Put the cdns set active part outside the spin lock")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Pavel Machek <pavel@denx.de>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230926075333.1791011-1-xiaolei.wang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/core.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/cdns3/core.h
+++ b/drivers/usb/cdns3/core.h
@@ -131,8 +131,7 @@ void cdns_set_active(struct cdns *cdns,
 #else /* CONFIG_PM_SLEEP */
 static inline int cdns_resume(struct cdns *cdns)
 { return 0; }
-static inline int cdns_set_active(struct cdns *cdns, u8 set_active)
-{ return 0; }
+static inline void cdns_set_active(struct cdns *cdns, u8 set_active) { }
 static inline int cdns_suspend(struct cdns *cdns)
 { return 0; }
 #endif /* CONFIG_PM_SLEEP */


