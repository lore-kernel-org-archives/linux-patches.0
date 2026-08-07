Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A908279DCC;
	Fri,  7 Aug 2026 14:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114370; cv=none; b=hQxYQaOvm9CULuUnJcub7+IufotnEEcVFzhiiYdxkpmWvYr+1H7EJmr3wGh9nxTQDElVeZR/9/4qLS9y+utDtx2VQ+n7ZCB1DVR8b7B/Ac/ZoDaA7YX5uI1e5WpccigljYsJxNdEue+alE4fsznJWAZXjB++q8yRWcDFYc3NouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114370; c=relaxed/simple;
	bh=71AmaV7RfIH5a9MNamo1neOLKUR9BeyvFmxGPflYyug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxLgnIpLghDYMtOruXgvzReyDVuyw5IbF2pIOUWQOLaCSSONjJf7I/UJg22UPABfv9StYwsBJMo1DzRZdMEjXcwv/0J9URC36TEpbymGkUaQAF0ALtuONreXKUZDWd4xDXGgLs/mSH66JxHJdzSw2l31QMil9FIEQczB+Vj6vGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytg6vXm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytg6vXm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E705D1F000E9;
	Fri,  7 Aug 2026 14:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114368;
	bh=UfGLDTxcaefnetDkEvBbhfMXaaaYTJhyjcf5ayxhOYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ytg6vXm/YB38+gw9qEH3puIeq+RW1r5HElwcgjvw6DAE+AM2PJuwZsnx+UCnn4pwW
	 H4cmszFWfYLgS6nrsnUdFoA4/RHMBZbymsQV6vhzeUEofvyZr08KDGa2KpwlNlBeRz
	 NSaQK8h/3naa0E3BIC1r9xDEkklHr2BXJbZ6Jkas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 239/337] can: ctucanfd: add missing MODULE_DEVICE_TABLE()
Date: Fri,  7 Aug 2026 16:37:22 +0200
Message-ID: <20260807143423.730700412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit d937bdb244a751fe5967052ea2d64a7b2c476cc0 upstream.

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260704151957.48194-1-pengpeng@iscas.ac.cn
Fixes: 792a5b678e81 ("can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.")
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/ctucanfd/ctucanfd_pci.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_pci.c
@@ -274,6 +274,7 @@ static const struct pci_device_id ctucan
 		CTUCAN_WITH_CTUCAN_ID)},
 	{},
 };
+MODULE_DEVICE_TABLE(pci, ctucan_pci_tbl);
 
 static struct pci_driver ctucan_pci_driver = {
 	.name = KBUILD_MODNAME,


