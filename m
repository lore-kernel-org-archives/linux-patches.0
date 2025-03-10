Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277B422D4C3;
	Mon, 10 Mar 2025 17:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626989; cv=none; b=Vgqm8kwaEPczSp3eaXGzXDKMSShZ9a0BtDJIl94P+eP8LP9dlbvjdqGUr7OG8Cud9a2TksRCGoQhPb0UR1+X5sdFbhXOY8ODuZrTi3naJICYNEaxqdcn6VOr7d3LbNu+otIkaDceqqoUIuKGNdcUw1tNAm5qYBN93SkjiVRYAu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626989; c=relaxed/simple;
	bh=tkwRAYb/gpiBX9RvzoSAgiiuoict60PQg0wPe8jwg94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTxsZf1RXWbBim3BZNqPqC1HXqsXr11duAWVtX82q3+5rTJArD+ikJdsFXgCGC29E74CyFPIIh4qJJkXCr+Yc1xP/J8lVPGfdC5N4MIFKJ/jFTTM+czz+KSRkBY4JVq4hBZ6gLgKzwDAodB0Jdiop2vtlH34prb//awMJF7ERRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRqF2rEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRqF2rEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FA0C4CEE5;
	Mon, 10 Mar 2025 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626989;
	bh=tkwRAYb/gpiBX9RvzoSAgiiuoict60PQg0wPe8jwg94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRqF2rErtmT6HHHq1JnVKTBjxEgXS39m6Ldc9pUYd1/9g2J0O08KPTEII9jfe0rhn
	 25fs9FpZMXT3991CjHIVFYe9AdOzCiccnS8Igm5vQO2gvQ5wwl205lnT9cGFUxni/o
	 7lX+5YTXU4DJoNAnwlEczfPailLxMynyBgC2iA4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.13 183/207] intel_th: pci: Add Arrow Lake support
Date: Mon, 10 Mar 2025 18:06:16 +0100
Message-ID: <20250310170455.062750036@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -335,6 +335,11 @@ static const struct pci_device_id intel_
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


