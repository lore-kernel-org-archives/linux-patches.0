Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7904B14389C;
	Wed, 19 Jun 2024 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802588; cv=none; b=fhG9IOHFvnsvY8DYOJO+FIC80bfEtLGCaeO5hp8hu/d9+nDwHtiYeyz+07JtoKzMqfaAix83ivd9PJUiJnTSr936wN6CyGyILUU2ttsxGHCJzfpyg8hYxG+UFx49HoYrrJCPCmAe1aH/Fm1h24XPchkauWUMWxsnSPmQ1/yjyVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802588; c=relaxed/simple;
	bh=9AZwRBxiNBR9fZgm4Sb8YjecrwbZ/WiHm5RKHF8DJxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY5geCnKqXiPYEzVafMC+tcvK8HQ6lu2Trfysm6ij5Pm+3TShmga4XaGGP7k1hpAsizbjUhx9aPHONO4uZLn8c1R/bwDET5mwDgMYYJdvBZi5qDps6o0QfyV/dQ29qKzjIdyPDl0eUb0EPCL224fvZdzyrSJ51+h5S7qmqkVjQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyictHwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyictHwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CFCC2BBFC;
	Wed, 19 Jun 2024 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802588;
	bh=9AZwRBxiNBR9fZgm4Sb8YjecrwbZ/WiHm5RKHF8DJxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyictHwi5C/XiB8TkZE8Wo8w2ZliDy8PTNU6YJrnAoQEc+H8YHZUS0KX/dFQn/jv5
	 xhQF2jO5l220sVQy4f5OV2VEy5zNqRfbccSy5wDNDTU3tKRzcJli2IegC5cJyZ1fyN
	 EUnQW4eNdwLCDkE8/oNPmoXaPLfqO6Eo1ESA5nBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 220/267] intel_th: pci: Add Granite Rapids SOC support
Date: Wed, 19 Jun 2024 14:56:11 +0200
Message-ID: <20240619125614.770961216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


