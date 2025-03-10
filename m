Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30325223702;
	Mon, 10 Mar 2025 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628509; cv=none; b=jqdRSGBqqjYOJKHdEh/DIdMt1NnAA4E7Ea2yXb5DukpT6U93N9BypfXy62PkDLYmjPAZJ967prnLAY+AH6TJ83pFu3rOc5a92cgc+VYriZuRflz1ttZRoa3wVAzgwsiOeI53fy5lHcopu+RdEdu+wyCKY29sQzM/Rq9bhVg+59g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628509; c=relaxed/simple;
	bh=f3lSIkUfH9o7zNSFghLTUm7enZqFfx7G/rEdKHzW7jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6pnuZGc2X0jKk0TleWF3j03rWsq6OeqvaTbkHRhKXmUVjyLzkM1F3wGVkpHV/rXJEXdmijcie/0GHaEZNVBMbIMpoggQqKSLbOsCeCIgH4mgTLsIIiu0XwYW3rMxdjq9NQENPNJ4NbzElb9Y4bsnYRqMxR2DOJjFyHQmbgK0EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHxITJSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHxITJSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB8EC4CEE5;
	Mon, 10 Mar 2025 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628508;
	bh=f3lSIkUfH9o7zNSFghLTUm7enZqFfx7G/rEdKHzW7jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHxITJSMRtv8IO4WCPDpEyDn7+OcLCU82A/AY49t7ZyOodP5sjd39ouSF0Qt6XZ5V
	 Tf1xdO5rSt9epdSmRkkbCUe/9x2ReH2QXR5kUemwbgEje2Hx8wmXuU5/etEzEcY1Vl
	 9smlIOcv0ZhJVUcOMjikikrQP4xYW+nsex2oRW6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 081/109] intel_th: pci: Add Arrow Lake support
Date: Mon, 10 Mar 2025 18:07:05 +0100
Message-ID: <20250310170430.787630784@linuxfoundation.org>
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

From: Pawel Chmielewski <pawel.chmielewski@intel.com>

commit b5edccae9f447a92d475267d94c33f4926963eec upstream.

Add support for the Trace Hub in Arrow Lake.

Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250211185017.1759193-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -330,6 +330,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Arrow Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7724),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


