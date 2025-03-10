Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF5B22AE7C;
	Mon, 10 Mar 2025 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628512; cv=none; b=t1LWuWhMn95/D3ESjvOfPtYRH5Zzt1tkTbIz7EE0gW1QLxAAgTO6W6tmNZ+wafBIuZGDNI+i7szVqVhM1iHZggV6zsK4RN5J84prvFvwqZE+YfLPQ/BjvlsTCLQZV8Di66njuApiC9fNhSwXQ7PBFROurQnSsqbn9lEOq3Ih2+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628512; c=relaxed/simple;
	bh=RgV2mWGR6JpVgbI5+13BaqnyVwyo1wqyx0vNsvPIr10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwyuMpIlF+1SFUjpbV429lJzOrnZ0xaPqUujK04HcMEruIZumGhlds0QlOkfnPyfOyQFnu5jjR36k34oakK5rNVAsTf3ie79Veye7YzFWx9tiEsyhv+cVS+BakELZV9X/7yDRp+Knbhr0MVUGgk2C/RrNd1nCj3oj2Tazh3ugXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yE+7DPaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yE+7DPaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F35EC4CEE5;
	Mon, 10 Mar 2025 17:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628511;
	bh=RgV2mWGR6JpVgbI5+13BaqnyVwyo1wqyx0vNsvPIr10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yE+7DPaWIIai+RhtykhKi26hy6lWD1OOEb9aI0WKbKpsBRHIJBMpiYOS1tecbDJ1B
	 tu/hwQjEVwIf4cEh1zul3rR7XxD3ZV2PWURvMRyxA1atmhJ1tsZYs9DD6LfTtdqnFs
	 RaHQLXx6F9QrDn6QhfWJps+qVoKUgGOkexSnnEv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 082/109] intel_th: pci: Add Panther Lake-H support
Date: Mon, 10 Mar 2025 18:07:06 +0100
Message-ID: <20250310170430.825965173@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,6 +335,11 @@ static const struct pci_device_id intel_
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


