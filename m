Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064048;
	b=jukuetkk0W5EHVvN0q7qHYcnYGMJgaygdDNNUAEm1av3SvdG00qFi0N4+KyW8wCTCsad
	 xRd4/6ILL+A/QeQqWLXo1X7F1UYsO/hWg5ZULSOWJ93OUGTrpo5+dL52If86mQZGcBVtC
	 I23WOW+lYKFUSdmGqV0f1VhGUTYvQCTbH0jhmmXHFQqsITa5nKd3KIo319mC0ezYCHV9a
	 15fwrzQ0NeKSKPWva6cybvrSsxv3SojJN+069HbT21BrcyoST8X6gsZpoL6PfJ+OaJyU8
	 OP0zpDsRtKO6l+narZbWZGCRLCmch5alMNsCXFfjvbXykPJciMqf1IVRIOQ+/0Za0pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7wFTjGF0b0uWvHgYQ3s7+RyCfB6ajIBJ0iZBMi716c=;
	b=kdZYg1Ub/HAtRa6Vee1zfe5JBYCyXwEX736JfJAFDnO+Sb7w/EpmBFgf4qvmEAwXfbn1
	 OtwYVQYtOApAaIYNY2ZwTdPr2VUGHy9oB96IRBhyLXsMzOtCS14FJvC4Fd/xtT+aI9fJY
	 hCj7kpCcK6m2Oqst65iAchSmHn4GauP2SCBneLm5R3UVx2zOW8mGmkBTh2ehY2VMP2q1i
	 uSe8ti6VF4ZkcP0SZ0wIqA2IZyMnLNl5wzCbg0Q9whVseEihgyC+/ITdWcnbDuT1w1rce
	 cEDU7cqfrcHNfMvPufOrJlVFlJcTtdIF24pr7QBqGqMQUXGEBcRQ9XHbdHZgYo0ot+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lNpVcxf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF5D606C005;
	Sat,  7 Nov 2026 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lNpVcxf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04BF1F008A3;
	Sat,  7 Nov 2026 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064048;
	bh=y7wFTjGF0b0uWvHgYQ3s7+RyCfB6ajIBJ0iZBMi716c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lNpVcxfhsqkfy51+HK2B0NZwgQfAWR+8tJAc/IKxYh49wiLeOT6FGpMyQD5ZUBCw
	 Sfv+2B1EApR9KlIF8Y6KqaxNDPebojCjKpnm6B3V/OVtuKo6X9VPlx83cSlUH6hknH
	 E5ChaVINq53c8iV0XRO7iyjYrKGP3aAl49LDhv3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0221/1257] i3c: mipi-i3c-hci-pci: Set drvdata before creating LTR sysfs attribute
Date: Sat,  7 Nov 2026 08:41:57 -0500
Message-ID: <20261107134945.637629287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 2bc2b1b89f65b5b75ffae0cf3d67d2415611004c ]

intel_i3c_init() creates the pm_qos_latency_tolerance_us sysfs attribute
before probe calls pci_set_drvdata().  A userspace write to the attribute
can therefore invoke intel_ltr_set(), which uses pci_get_drvdata(),
before drvdata has been initialized.

Move pci_set_drvdata() before hci->info->init() so drvdata is available
before the sysfs attribute becomes accessible.

Fixes: 884a33131f2a ("i3c: mipi-i3c-hci-pci: Add LTR support for Intel controllers")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260920151248.46936-4-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
index ab595661db1e8..af9595009b03a 100644
--- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
+++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
@@ -445,6 +445,8 @@ static int mipi_i3c_hci_pci_probe(struct pci_dev *pci,
 	if (ret < 0)
 		return ret;
 
+	pci_set_drvdata(pci, hci);
+
 	hci->info = (const struct mipi_i3c_hci_pci_info *)id->driver_data;
 
 	ret = hci->info->init ? hci->info->init(hci) : 0;
@@ -455,8 +457,6 @@ static int mipi_i3c_hci_pci_probe(struct pci_dev *pci,
 	if (ret)
 		goto err_exit;
 
-	pci_set_drvdata(pci, hci);
-
 	mipi_i3c_hci_pci_rpm_allow(&pci->dev);
 
 	return 0;
-- 
2.53.0



