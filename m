Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C915A22B8BD;
	Mon, 10 Mar 2025 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627766; cv=none; b=gHEdW/e0crCI1YvvouTrhTcimNUQ5tEGlrv9gO46SnJRq+n9BIrpp+4pV1cDfMSqDXMgZ6WmFATWLtTWEbWPNL5ydbnZUO8F5T9gC1OnuV15sctQo6XhsdLTsjhzYEpd9hVOY3EIpAF51BFDNibw4YFrX4BgKI/bqB3J5aPHsxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627766; c=relaxed/simple;
	bh=M9DJvPANTGkU1xHNgAhnI/XN4l53XTiAU7Ip/tWVghw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJNaYExbmrhZLVVwYIkwNyCeBfPqUOkXDrbTmyJiS6XFRfVhw4jqgSnUDPNfO6IE/zeBFD5JqIxaly7ksOQGB9xBQ6mQ67ZZJpMQeFs9TfRXS3Fo8Qw5D0uSqQfDUj+uO0/DYSFX6T4Dl+U9qlGUyYiG4axWxzH0SSDEUSa/DR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbVn+i84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbVn+i84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51855C4CEE5;
	Mon, 10 Mar 2025 17:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627766;
	bh=M9DJvPANTGkU1xHNgAhnI/XN4l53XTiAU7Ip/tWVghw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbVn+i84HGBjAeCpOF8llVaK9oly7qz443Cujp+foQfHQoY7QBq81LyroqgAulMCk
	 n2IG89TGF3GC/dG4mFlKpHHrmMd/znEq2pGziltGB+kDYGXus3zIA042EQ3X7qGHpm
	 i7o1E06Z+Mq8VkZpXtmCCZbDh4ifT1fZ2EBsRuU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.12 242/269] intel_th: pci: Add Panther Lake-P/U support
Date: Mon, 10 Mar 2025 18:06:35 +0100
Message-ID: <20250310170507.443361210@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


