Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A51183090;
	Wed,  3 Jul 2024 11:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005586; cv=none; b=sgM0ZUCsVcF5+BBvQM3FY7YKZACJSk8Zu5R3ErkvqA3txZB7fkpyaxNnlwkINb8uL9f5rs5LzHTPsAeYZoG1bu+OUYOnzU1WV2M3sLDQeFeSlT+rZp/K1hE8lAI3TLt891fEi5v/AhF0nt5ITnACxQ1gH3gZxluqLwiMCanWD54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005586; c=relaxed/simple;
	bh=/orOn/PN+FyRh1LHPf3ZjKCP8QmUq5S3HjTGxFuxNV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBiTakSvQKm1BLZnrz/BVXEJIeZWHKWLz33hacAMx7LC3a5DCwjrO/K+JagqZ1NWamGfKh83aiTQ3D91PggiweXFAg/4Gg1oATDl2EkMX6Fv0bk4XRDEI8aBkzmuUfcjIjJqxWejbS2C9LIVKhE3b2P564TQTgu7UJ9eSZ4VJUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+i9qVun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+i9qVun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B65C2BD10;
	Wed,  3 Jul 2024 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005585;
	bh=/orOn/PN+FyRh1LHPf3ZjKCP8QmUq5S3HjTGxFuxNV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+i9qVunS5fuOqpYiopoTpXjoOepZAO3jjZV4I+QvQRnMgH66x7m0GB1508Nsir9v
	 yC17/AjAAIZa6+rPC1azIY1Mg5FfQy7T89anbgPlT24DowIZsHzWDoWFjSYYA3+9Xo
	 61U/rT/eMlEv0GNhGtharftoDUCpbEEsUTKF6+vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 130/356] intel_th: pci: Add Granite Rapids SOC support
Date: Wed,  3 Jul 2024 12:37:46 +0200
Message-ID: <20240703102918.017341011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 854afe461b009801a171b3a49c5f75ea43e4c04c upstream.

Add support for the Trace Hub in Granite Rapids SOC.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-12-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -310,6 +310,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3256),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


