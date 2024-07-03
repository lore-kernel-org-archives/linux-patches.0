Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CC217C218;
	Wed,  3 Jul 2024 11:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004679; cv=none; b=UoXXZXkNPCu4d/gtcckJpwyyPAbxlXEqbkJFy/jsGHJB5fJsBRk7yTERG4BS6HQK9KCxK/kfGRIVB1fuu9J89ljptPT1H+6TKj5VyVfFceWp896OWiI2I222lMZaJUpiisFyAnB3BIEzk0NHYIsaGPLu+DpDCST8f9tfz0ERDs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004679; c=relaxed/simple;
	bh=pXlUg4Y/srlEsYTZ3jca6CUDf4Dj6S/HmeKaXL2mneg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8+mTpIpj+UnAtCv9X1RsTIOHrwQlx7SJ2U4rUR+wVUIWkRBpVduuEi/n85cXw4grnVbSbg7rMgbXvelx06IA8XHD/G+nJNT86gSkrogkPAr4Y8PpyCgh+2ArxBfv4qRDSQUaiSUzMdjYx2/gdeOxc3A/WxoJPsLbIdT5O84tSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLh5+XsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLh5+XsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8E0C2BD10;
	Wed,  3 Jul 2024 11:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004679;
	bh=pXlUg4Y/srlEsYTZ3jca6CUDf4Dj6S/HmeKaXL2mneg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLh5+XsVLbd3jSIX/rKHHGdBDHQK0yb8AQ75m5ZJ3Nb7TegYCj2775Gb2xIGoKSi+
	 UBglqJskyzCFOir/SMWNIfPpUhFqXGWFZqaoxuie963JmT+5NBQHVxZF+zr8ragz0H
	 XFJlgCqHe/maaIxqG05gsWh8NHKZp8YdKtcO5wvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 091/290] intel_th: pci: Add Lunar Lake support
Date: Wed,  3 Jul 2024 12:37:52 +0200
Message-ID: <20240703102907.627780398@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit f866b65322bfbc8fcca13c25f49e1a5c5a93ae4d upstream.

Add support for the Trace Hub in Lunar Lake.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-16-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -325,6 +325,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Lunar Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa824),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


