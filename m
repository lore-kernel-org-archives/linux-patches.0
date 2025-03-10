Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0919722CBED;
	Mon, 10 Mar 2025 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627761; cv=none; b=ojETHAuAJ8aPCnAFokq5Y/U/+o/qwCulOGZioxnNB3erSVlOOF6PKDykCMCn7dFmmcW/wYVM6Bv2XNh9zwiCSgMiCHw24DhOcBjCnKS84P5mlMN8NTq/lQUDWD6vozBG96T4oB9YhtWeUlfF5QcUmuNTex5tY0Bi5Oq/muF5mdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627761; c=relaxed/simple;
	bh=5y19PrElUtBHWBuVPBxxElAUQll42PBrnT8nAYnmFMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCrZUR2UdpjqhNxRn8gNtLi3rgEgxVEArk2qbaH6sqIfMttyvqIpJAbkLnhaa7U5JAGe1f3WCBghUd4iMJIMWc2VaM1V9gxtogqUgwJn4tyL3ydgNABgUgW0XKCWdbWcreRTokN7XKpROn5WxI3bESSeD5rqzFWPvjWL32uCAvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZlAmlXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZlAmlXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A06C4CEE5;
	Mon, 10 Mar 2025 17:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627760;
	bh=5y19PrElUtBHWBuVPBxxElAUQll42PBrnT8nAYnmFMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZlAmlXgx6H/efgkZAZTpR5XEUxUwNRpBprGNKsv6l5/2n33qPLPvg2uRSoITjMIf
	 m7oLHQGzQ+B0L7e6QQuKks09yh333sR+8AxlplC5k11YlhgBwt2lJbE9/Y+OtCqcom
	 hfN0eT4gBxbS0iZ8lFPVUf/+7ZvNPFb1PJIBZJnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.12 240/269] intel_th: pci: Add Arrow Lake support
Date: Mon, 10 Mar 2025 18:06:33 +0100
Message-ID: <20250310170507.362974328@linuxfoundation.org>
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


