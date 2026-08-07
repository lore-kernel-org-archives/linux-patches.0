Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D036F306754;
	Fri,  7 Aug 2026 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117604; cv=none; b=sWtdwDqI0MMyY8dyViz1aF3Mb8QSyt5vho/YcQ1HNqmb2gs1my3w+ZQfT430R42FJ9jt9JY9ADrpjb11qPiKl5FFYcosN8ROhevaAIoXvSla7wMxaOSWaS3bYp2oFochPsfTHXe2/Po9tQC2sBDbxPBE3oie41SJsl+yvXG2pZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117604; c=relaxed/simple;
	bh=i+uzlVPLjv3QsRtMms5IuoB1xNudczbU8RqJ6Sxi990=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEWllmcHXdRdPsMcf5Nr4oo0/h3n3XDjA73vaEPPHKbm4Xz/OqqqLvpvBgrPcCG91HoGxIDL2InM30FYzM4WQBEBxuAMc5frUNzFhFrLc9MYtJfkMx9vZFCurlNTdi7kQI1LlJuTNIBUG9H1WUchTD5xL+7NTztR0lR+LHfHgco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r675i15q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r675i15q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372851F000E9;
	Fri,  7 Aug 2026 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117603;
	bh=0tpA7/EE+wyi+nZ1e+BGldmwXS6C6sV1HzbRmsdGIuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r675i15qMTlaqfkcsklzwmkdkqVF/+9P7vVYuwFilm9jLrK2aZmQVFddjfFx4QEVy
	 1fF0PFQwpEvjrd0xo46seTgNTS8NByh79VbAS8HLVoQ+UTWyb/ccWCp0SGuph3Qk1H
	 +bYx01kq6A0iHHsAf/Xxwvc7pWI0Vt+ldrMqePRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 377/438] can: ctucanfd: add missing MODULE_DEVICE_TABLE()
Date: Fri,  7 Aug 2026 16:39:33 +0200
Message-ID: <20260807143436.004381371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -266,6 +266,7 @@ static const struct pci_device_id ctucan
 		CTUCAN_WITH_CTUCAN_ID)},
 	{},
 };
+MODULE_DEVICE_TABLE(pci, ctucan_pci_tbl);
 
 static struct pci_driver ctucan_pci_driver = {
 	.name = KBUILD_MODNAME,


