Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB4882495;
	Wed, 19 Jun 2024 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803421; cv=none; b=SY5c8jBoAtxPGaIDqBLyYpf8ETL0YhvUga0U8iyLBY2OwrO4nWYeYelkIY9z6ZZXcxSRUrNDeoP8R3C/y8t3F0hXyZMRYSSJCz9+ZGTGqpxnMcQkI7AUop2+rBX9XWWgjm5Nx/poInt789WUQcHzDiv4dC9dUv9qlsCMkuPavgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803421; c=relaxed/simple;
	bh=DnGohI0V8CLDIJjlGXPfHIhl2xwAUdRhwFa99mHHSe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1wFHKtSdR+7LPo7G14J3N68XxKnMgarGXej2qQ/x1MmcBpnH88htpQNx+j+ViLpfIANBCuN/M7E43z9z3OhBIVZfH9xScRMV3RvCcSQUAuWqj9YMvTHX1pTiExNkRzY8FDHPsdEPY2aweT/54nzRgyIdmlii1Cgue9r2cSywG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lR9oHXzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lR9oHXzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E73C2BBFC;
	Wed, 19 Jun 2024 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803421;
	bh=DnGohI0V8CLDIJjlGXPfHIhl2xwAUdRhwFa99mHHSe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lR9oHXzjoSvO4qQd0ONOn2LzdHdU1h+LYA4C9hjK3puhV3jkyV/4PzB8vp3p/0IF7
	 bNrzP79uRXfXgxnhhV4QX1XL3CBAMnMln2us0GBuZTbOaCJOuYg268m4I2mtuvsXyU
	 xcEJYYIZTpaZorDhD78EIinftmFKbEoLv4MPoXcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.9 262/281] intel_th: pci: Add Granite Rapids SOC support
Date: Wed, 19 Jun 2024 14:57:01 +0200
Message-ID: <20240619125620.060511564@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


