Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A93817FD;
	Thu, 13 Jun 2024 12:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283075; cv=none; b=G5/UBKBXmJnzujlO411Q+8FI95CX49gehgXRYZ8J2OiqLKrPEZ7gu/0kYp9SoFCckEk+fV1vxN3RxvvFtPmGPF5S8luJ+dcJ+IRnhML5lUypF1cpvLnhUJz5vpK/eodTpU6F8ls2/mKNqheg+wv2cCzxz6MNMtC1505VERgXIj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283075; c=relaxed/simple;
	bh=onSOy6EXbA4I0vnm2n6GVT4C9UTg5MFYwz5CgvX/Sxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPRSSm80+hC9YFJiB+HwzFqpXI5/Gc2GbiGSr0XA0N6CBOqBa81pmpF1Mm+30cVwl0kmlnf+dwmrivoL7kjfPHvAaYzxrQSSUJVHp2quP0bZzJcxnYL609h8uD3AOW4yVSwsmv3Zpg37IMsY0gseVi5TUhejk2YwbR7s95dIMJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmaXF7vO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmaXF7vO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7248C2BBFC;
	Thu, 13 Jun 2024 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283075;
	bh=onSOy6EXbA4I0vnm2n6GVT4C9UTg5MFYwz5CgvX/Sxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmaXF7vOcnZpRMimlND7lHadFxStsA98k0S5FEJPdVbTnHwNe/ZNNTgMC26YnZI7q
	 Bzm4nnQmYD2Ak9PJrfjzAPINT6uEF/zz5ClfIuuryCKxSVeD5a6p3CEstxa2JOKDYp
	 bJT3hkxAvmTpZFiEWjHDxghWFk8BB6YPkDNWpwyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 60/85] intel_th: pci: Add Meteor Lake-S CPU support
Date: Thu, 13 Jun 2024 13:35:58 +0200
Message-ID: <20240613113216.454210107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit a4f813c3ec9d1c32bc402becd1f011b3904dd699 upstream.

Add support for the Trace Hub in Meteor Lake-S CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-15-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -290,6 +290,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Meteor Lake-S CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xae24),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Raptor Lake-S */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


