Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6D9143C52;
	Thu, 13 Jun 2024 11:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279566; cv=none; b=CBOIYT6Jpu5rmzNfI/kZWsnsY7z5inWdO/QwkokZYbB+VKmZx6wkupJfUV+3us8E9OF7lPjU7tLb2gHF9e/OEZ7lgIxZKartqsE7hah2UkE3jtgqWJHCZtqbM1DPvNeXsqLoa7g8XvxjgB5WjSD3Drdu3vdmqV5IjGFHaYJwhW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279566; c=relaxed/simple;
	bh=Tl++MwmET4vReSQkKJh68lLuE+9xQ4axe+2Vxr2IgPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCdmIuvni0v8tDKMRfleRFn3x4c5xXX2bZd/+FcaXIu7AUnRuQgKMvpvtycl3hazyfXT5sH6yOS5TLp3Y1uclUiDo/22h3BvAAi9J9teDl4u7ScHVoPJnYWb3zQrEr8CCh015mNrzfb0zqkdvBsfuktet/CCG4Gb27oqPeETT5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkOe8vsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkOe8vsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265F7C2BBFC;
	Thu, 13 Jun 2024 11:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279566;
	bh=Tl++MwmET4vReSQkKJh68lLuE+9xQ4axe+2Vxr2IgPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkOe8vsMqFluffWg4db8YTxCo181uTf0syskj+6E4zcrtUjNDa4NJWLjno0MMMXYr
	 UJVvk+m0N9Sq18oRYWjW+Vx1xYs1DT81Te8sXU+G8rBrGoENG3rWWow+MBJBPETjY+
	 BUmPFF5hA3nJVrN39ffF7BL6iFNJ9e5Ni49E1cGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.9 092/157] intel_th: pci: Add Meteor Lake-S CPU support
Date: Thu, 13 Jun 2024 13:33:37 +0200
Message-ID: <20240613113230.985168515@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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


