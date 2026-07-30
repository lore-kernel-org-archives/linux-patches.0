Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C6430567C;
	Thu, 30 Jul 2026 15:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425220; cv=none; b=EQqSfKwlvvNO3oXdN051pMqDJlf4SZgL0Lg0c9nPmXdf330VwdI3je4PL6CblnpRm/V0l0QiK44ViIUQuc8JT34yNQ8FmH3pILe4XwpRJRuOJvv4HxLhD3xO0dINCiGecI+pERRiFgxu852k9aP+hjJo+LWue6W6ic/+ROrS5x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425220; c=relaxed/simple;
	bh=L6kvIMMIMk1zcXFqVmxUKnAF5QqgWxiQQpg0LoMIJqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6vNBsSkwYYdvXH/iMMscecqzNpCsrBorpaJrj0o1HGnOH9PBO4aghbSbBIzkraN/7u3eZaacKjmKStc6hAMD05lrqTPdQPQdHqbGPmY7oTXb1fFI+5Mc36V/AjQ9RhvSndlVz4hcI8YvmrTeRuYf/J+CZRO1dhJuiAqpMSdfjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OB5AFZU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OB5AFZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D841F000E9;
	Thu, 30 Jul 2026 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425219;
	bh=sjZRGCj2+sINW/Vj8aJub3DzUJDM0zQRakUNJxUxV3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OB5AFZU8qt3TNw+7MFds8fBqDcoM07gywxzvK3lSgw1d12Jo52JLz1CZv81YQ1/N
	 nUk5gm7wWp2aPCajgX0/rmE9awtgbX67VwPeY1OevpljMsEzRUa2kTKKOjGncUGOp+
	 lkWAmH1BaVsRoKS9RfiFGqJziepSFj5OHvovxy2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 665/675] i3c: mipi-i3c-hci: Fix Hot-Join NACK
Date: Thu, 30 Jul 2026 16:16:35 +0200
Message-ID: <20260730141459.289660847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit fa9586bd77ada1e3861c7bef65f6bb9dcf8d9481 ]

The MIPI I3C HCI host controller driver does not implement Hot-Join
handling, yet Hot-Join response control defaults to allowing devices to
Hot-Join the bus.  Configure HC_CONTROL_HOT_JOIN_CTRL to NACK all Hot-Join
attempts.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-3-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: c6396b835a5e ("i3c: mipi-i3c-hci: Fix handling of shared IRQs during early initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/mipi-i3c-hci/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -147,7 +147,8 @@ static int i3c_hci_bus_init(struct i3c_m
 	if (hci->quirks & HCI_QUIRK_RESP_BUF_THLD)
 		amd_set_resp_buf_thld(hci);
 
-	reg_set(HC_CONTROL, HC_CONTROL_BUS_ENABLE);
+	/* Enable bus with Hot-Join disabled */
+	reg_set(HC_CONTROL, HC_CONTROL_BUS_ENABLE | HC_CONTROL_HOT_JOIN_CTRL);
 	dev_dbg(&hci->master.dev, "HC_CONTROL = %#x", reg_read(HC_CONTROL));
 
 	return 0;


