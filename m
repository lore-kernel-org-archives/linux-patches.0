Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DD416F84E;
	Wed,  3 Jul 2024 11:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004629; cv=none; b=f8sLWOtERMxUkPJddaODjkqDopSy7GyQoQQeoiq1rFTq1zmHPJWJwqg3p0SkdVI1qmamz4rDxgBmEVdsFcuwE20+nHT0ZHmyuIJmQ9S127XiRBFXRM66p7EnPJC3HEMVRopPiVDIHCfGGjup7dEXtTUVmLlDDuoXo3aUmncR06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004629; c=relaxed/simple;
	bh=W5sUk9gdt05Bq4Z+eWHWiivVjDMi+AItGQFYBPT2cVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsgYBX0RwkV9eBle4J8y2qq2F3BNmoo7ewBVg2vSy9Qfi9cVrVFcUUJ/BqA5QipOK+ZM87/6QwK366KS1UPlWtylRfpLAOsasTl2wGRLCnkSnahIcA0NIn7yxe7docIkXwKxZJwsqpfd/g5i3sL261QsHggSk5CJW3DRb3oZuDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4lTWoK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4lTWoK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDD2C2BD10;
	Wed,  3 Jul 2024 11:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004629;
	bh=W5sUk9gdt05Bq4Z+eWHWiivVjDMi+AItGQFYBPT2cVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4lTWoK9OAEaJ8C/YS0F3CU1EsuFR+lw3MUK2q0T0JiYrDaS/twSmo+iriKRoZCS4
	 H5luO6Uu2F72CvxnDsTccSZt4KK6Qak+W3zWtG5ickpiMcGNo52z/UCJRu+wLcov2m
	 f6AoTRQMBuyh9jAWj+II2GRXHs2BDCFSAm7J3lsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 088/290] intel_th: pci: Add Granite Rapids SOC support
Date: Wed,  3 Jul 2024 12:37:49 +0200
Message-ID: <20240703102907.516585723@linuxfoundation.org>
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


