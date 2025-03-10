Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01125230BF9;
	Mon, 10 Mar 2025 18:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630977; cv=none; b=SAMjDOcC7gDNANXloPJjn+hvClY8QdSHrfqX4TPsqfB5232EWOY8U2cLHRJJziiYJbdAs0QueNpHuFQgim0W8Mah4GT825Ko+awg9ZY908G1+6dmQ0j/cH2Mxk+2QpWItPqtq//kFur35RPtvhltyo1471yVua+9A3AXry3tWfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630977; c=relaxed/simple;
	bh=0fL1XpS6awqd6EHGnhkyWCFIDeFR+VuOq2DFtjSCm/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fm5rMDadkp5RW/4YkVE67xRlmpGRyShwTzMqxrfaVPo3YMBAMGOVuNVGXzRkeRtUIR5PDQer8x/TN+8vTQpP4BO5KNkruHZUHfrBgzuYgbLSOJQSJQ52Hx9v4+C1LxuP99ryAj52+bOazb094bBFLIyG5p5APLgxcW9HycF2iu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxSWgwNT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxSWgwNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2326BC4CEE5;
	Mon, 10 Mar 2025 18:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630976;
	bh=0fL1XpS6awqd6EHGnhkyWCFIDeFR+VuOq2DFtjSCm/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxSWgwNTN3vVVuKk6Lw9oMa3M2SggSW4YjqjFYcG/jibcHbbQVWUSinKOIJWe4Gu2
	 oGejNf0jg3rV19CUxQw0ks5NDfv0J5Q0yOolC8OvGlkZXHQgnLdtR9lltwFpF1j7eS
	 ilwEwTqD5Jhz6P4ObkHSDrvwnZ3ddXY7A/jUgMVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 600/620] intel_th: pci: Add Panther Lake-P/U support
Date: Mon, 10 Mar 2025 18:07:26 +0100
Message-ID: <20250310170609.217562892@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


