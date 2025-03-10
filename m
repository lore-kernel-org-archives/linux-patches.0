Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDC82309B0;
	Mon, 10 Mar 2025 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626992; cv=none; b=N/z3CWjjNInaH4wjBGdWJAhPaBuw0GwWKtBBwh/UX7hZSnXrVTm+wy/9ifCsGxDpI7yFrUdPNY5o8WsrD9xiUGwhZnNgwYXnKDtMnoA490mzEKQi0OTskvRKtrpZI6O27/yYES0GRob+5q+Z3ZzMBMVqXos956Qra0U11LGnApI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626992; c=relaxed/simple;
	bh=YKCmVSafDs0VKnFnDOH2EzGPdrAPAiMO0ByrFdpaKdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ryBRp9cBtOn1FrFmIeEEao8xF9QJcvBFg6MzwFEBGe1SSg3lFubjqz+zpgaA+OmFFNqRRUj8A5grBljvAgK537EBFelfpLhni3tHHErDuX4wdneTYrB9Qx7DJNNXrULQY3gYOumznd0kyKeSkmY2hiYv/i/m760qW0wVNZFPFyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoRIDD+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoRIDD+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B058C4CEE5;
	Mon, 10 Mar 2025 17:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626991;
	bh=YKCmVSafDs0VKnFnDOH2EzGPdrAPAiMO0ByrFdpaKdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoRIDD+LNWVcc4qmqrOn3MJhPGBARHtbe7/wFH3JDI/GYXr+p/M8Jx9QpaM9Mh4UJ
	 9ZdYUK+zNZaIeqVG9/A7wF2V+cUVPHW2iaCxDHvwaqpD+OPYdoZgutX8CW/zHQJx8i
	 XpPgygvug82T5lur8U7ZzdSxZOPaQoerj1XS3xaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.13 184/207] intel_th: pci: Add Panther Lake-H support
Date: Mon, 10 Mar 2025 18:06:17 +0100
Message-ID: <20250310170455.101261384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit a70034d6c0d5f3cdee40bb00a578e17fd2ebe426 upstream.

Add support for the Trace Hub in Panther Lake-H.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250211185017.1759193-5-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -340,6 +340,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Panther Lake-H */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe324),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


