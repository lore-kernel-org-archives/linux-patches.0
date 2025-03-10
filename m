Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0144322D786;
	Mon, 10 Mar 2025 17:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626995; cv=none; b=GmHHnDK/lt9ldbDP5is+MYG/6f2wmEWETKzY0uzJLddDceyqpOHkTKNhLFPxLSANlP0BxUhn0YcIgdXTZ5M4aRuNCKr99Eej8yq+gNqOdKFSIQ4kS7ugxpR9TCWBtWQUhrsqxgIxMoWxLWPllR/JAjP7QwSmo25LbLc4Ynqksnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626995; c=relaxed/simple;
	bh=GUmmh+VA7XVi2PJuLSkurOlK7hF4motVTkSDayw3Igg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIVToY0P4tfopJsKV4xuwPUcKl9p0saStngPkg5kqm1TT+GNsQTGyZE45VGQDDlcYyynzf6gHaTobqc4TxIn82kTeR+1ixUbXNGbmOw5z+5Yft2K0h5adYVtAQakR1fyqdU37Z7BbsRn8OKBvz4QWuL7WLVQq11qPUK8U1q3f34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGt+h966; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGt+h966"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D41C4CEE5;
	Mon, 10 Mar 2025 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626994;
	bh=GUmmh+VA7XVi2PJuLSkurOlK7hF4motVTkSDayw3Igg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGt+h966CyxRTjnvw2sg0ayTb9/j43U6zNaeJEV54FTXtfE8FgcCXh/5WfxuE22AO
	 su0V0n/mYXkFBdw7Y4ASqiWKUZb1+miAntfpsJF7J7gyX5zH0WR/njss966LWpkhhF
	 p90ElRPTvTWvv4KpsCI79McTPayD1+zRXBHFjbTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.13 185/207] intel_th: pci: Add Panther Lake-P/U support
Date: Mon, 10 Mar 2025 18:06:18 +0100
Message-ID: <20250310170455.139995109@linuxfoundation.org>
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
@@ -345,6 +345,11 @@ static const struct pci_device_id intel_
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


