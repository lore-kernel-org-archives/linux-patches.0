Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4996223535F;
	Mon, 10 Mar 2025 17:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628185; cv=none; b=ouLBDHtbaa4//erXWA3UBQJNl5dkCoACOFI5ECGsmpY4dsSIgPPIvwksKqVurSwtI9OVDj4cU1D6T0CPyVDpC/DGdxVuhgPsu1rkg5C138fGGUnjMpHz5iO9hNOMgS3g0jb3XRnNdMRtNh/nOVYtQ97AqsJsInB+C7ePTNCfMrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628185; c=relaxed/simple;
	bh=c1kKYygG+kNCLBTHJ+Uidlhoq949N/jShltRBgyWwVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ph+LojdY1FFJf7BT9f+GGM17qPVHL6pq7f0Hw4mLfVLdanUQFd+8gNZT8IRbns1aoJb8I5070Gw8rMYYV4OOR/MaQtoczWC6CnBkmEUazgRfp1pCZbCsn4kCOxNQaUv8eh/Y3PnwET3P9c8uFZuTJ0eGr5iLBhB7I1Q6NED6d2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRJKzhTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRJKzhTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5D5C4CEF5;
	Mon, 10 Mar 2025 17:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628184;
	bh=c1kKYygG+kNCLBTHJ+Uidlhoq949N/jShltRBgyWwVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRJKzhTwevgxLrSN2JKSrIT6wEGWrGMMdLFeD4anl9dY/b71lY/rELwIZo2kzjyfV
	 4ZN0TNbdtWviH5fKPRGzl1OYRv3H+peWHzki9AkXaIEqdPGy9lmnB7FP1cbQEu0yYo
	 b4ZyFITeOG6AsZYfCxP/1IUssKDmAizhgAzj+0YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 117/145] intel_th: pci: Add Panther Lake-P/U support
Date: Mon, 10 Mar 2025 18:06:51 +0100
Message-ID: <20250310170439.482344399@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 49114ff05770264ae233f50023fc64a719a9dcf9 upstream.

Add support for the Trace Hub in Panther Lake-P/U.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250211185017.1759193-6-alexander.shishkin@linux.intel.com
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
+		/* Panther Lake-P/U */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe424),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


