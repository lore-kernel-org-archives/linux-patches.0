Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F952309BD;
	Mon, 10 Mar 2025 18:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630973; cv=none; b=gaANGthW7UhUYA73Uq66CV4TTIEladkBFBtIHWFw0wHlVzXBsyWxHnhvXp7omnUuiTFfFmptj034WRSGAEWQaBDNyKmko8FDBwQo6iHhzncadzBhVbXgLp+p6cwsFHZ44kbe6ftEScHz1XHcmwVQza/D43a+BbaXKEGMlkCek4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630973; c=relaxed/simple;
	bh=ypxQHDDJNucihLED4dQ5zBuF6WQIG2cTFDhThzDzBpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzOPWxozO7ORcD6jRAF6NC6Lan1CkH3q7H5adYswpZ30/wXHfvjk31V7UPC7b1UJx9Gc1MHwt3srXevAQ/UtLxsrZV2EHZ2pYvjACTCQDMATKpNvKROm3v5VGyVlTPiyS8A0aLJauho7mzRNcL6rt8ERI8Epy6ytZpQ9RcsvZXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1bA2Msg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1bA2Msg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB3DC4CEE5;
	Mon, 10 Mar 2025 18:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630973;
	bh=ypxQHDDJNucihLED4dQ5zBuF6WQIG2cTFDhThzDzBpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1bA2Msg2YEsWlcH/Y6FLHBJeKBvNUzHVH6e/hCoNFyJJY+CxDPLjPExg1YC7wdCu
	 Ta0LPZltUGAOyuJ/RKjpKrB7y7GyPtQzPRk3PUqD1eEAl4HLacQsxa06mdF2No5pEN
	 MAQRTac7Pzig2Ld1DmvZ7cwjWACcm9QT81TF2u7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 599/620] intel_th: pci: Add Panther Lake-H support
Date: Mon, 10 Mar 2025 18:07:25 +0100
Message-ID: <20250310170609.178855787@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


