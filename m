Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66FE181BB6;
	Wed,  3 Jul 2024 10:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003458; cv=none; b=GdayVnN5/Ejc9A5rjuq6ENSLcMoOJDF8EQqYyq8CCNLrEmAx0wbM7vpBxsdhBclbD59TXw2+O4wr9H7DjqDY5EZMP8KRYYinMIj9hvEP7QNFmnOpOUGl6+LuiZaRyLYOpJebRGDGoUhNYKBYAQbg93jaVZGNFP8mXzh5Iy1ODow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003458; c=relaxed/simple;
	bh=O7Vd+yaS1zaxDadjMM+07xAEqzQPJfVpF3KE6udGz9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWu3UEDfgrz2irefxVnFSc5btkB7JYR3pSA87HjMEKFtV83/wgPzmQ/hMjKhgl/mqRq11o8byyKUs85+fwl9CqMhSu4YNsI6tcZdrBRdJ1YADpthijyGPihGP5WLrVlf5VEVho6VFyGmj8W9+JCNH9yX49A7i5Xuexc/BfwPqkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmNxx12c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmNxx12c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DA0C2BD10;
	Wed,  3 Jul 2024 10:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003458;
	bh=O7Vd+yaS1zaxDadjMM+07xAEqzQPJfVpF3KE6udGz9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmNxx12cEuRzuDLd5BQXWnHEEA47hupLHNsKEnhXotOD3M21QdXU3P9D6OKnh6Obv
	 fN1f4F7lqxaC7Q9sL0emGC+tjK+RwyRw2Hn7lqf/ICXRxVSlsgBJvZsgYe527BAGFm
	 1xnpScvjb96hagOcNUl5hHjb5XteObmp2dTjScoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 4.19 053/139] intel_th: pci: Add Granite Rapids SOC support
Date: Wed,  3 Jul 2024 12:39:10 +0200
Message-ID: <20240703102832.442903231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -271,6 +271,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3256),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


