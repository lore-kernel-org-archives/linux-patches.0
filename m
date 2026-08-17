Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D623EC83A;
	Mon, 17 Aug 2026 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980112; cv=none; b=S4FcGITuvVm7ADw7EzMoWifSFiPrukuLZc4/2+etVJSmdsjshEjxq32xpDX+9NscUK9eObrqCKflXeWGG37oxivsaJcS9+u+9LBg5vcOIj/Ztm2mHyKjDs7/FzkgfeWzqTlLhvLrqW1XejpzVBt/CYg0zGAvRCcI8y/nfPsmN1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980112; c=relaxed/simple;
	bh=eknELRgPBQOgxgs9LvCjDuExOo0H6Bz746o8BZW3Z50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Af98bVNfIssK7loUWTcIYZIehY9FYRRDhGZwzOfDkyHkTP+QwQ+5AaYDCQ21Hruymke3yUeDlmkYzR/RfunY83qFr6ZRKB3L7xWXbOhHOkDibLXzJvxR8O791oHaaOgyFQ5tDpNW/FkhqA1UA58qx6fjyZ3h/28zgNtyHuCAWTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHuiD+6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHuiD+6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5C11F000E9;
	Mon, 17 Aug 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980110;
	bh=XR8+yIbIizOnp3UA/lUM52v95uBHwzlPouDfTmSI1pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHuiD+6LnmHlDKAb/jnZ4Knyelw5doMm0Lw5i4vEK+ftjnIdsiHC0e4U5F+aCPIea
	 rsEkq6dupN3jOWMe7rBUtjK8txEmjBgFYpBRe4H1nSbp9swc122mmeUiqrQY7mHrsy
	 cOacWRc0TwQblbXpTx50HBhySmKJAkGobyGe4mRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 460/609] can: ctucanfd: add missing MODULE_DEVICE_TABLE()
Date: Mon, 17 Aug 2026 15:32:36 +0200
Message-ID: <20260817132559.410985527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -278,6 +278,7 @@ static const struct pci_device_id ctucan
 		CTUCAN_WITH_CTUCAN_ID)},
 	{},
 };
+MODULE_DEVICE_TABLE(pci, ctucan_pci_tbl);
 
 static struct pci_driver ctucan_pci_driver = {
 	.name = KBUILD_MODNAME,


