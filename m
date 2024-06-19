Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461A013F428;
	Wed, 19 Jun 2024 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804042; cv=none; b=M/0EMEP4BlvoOOHgs1ZKufFAAYwXoOC1Uu3D74DuB7t2xQwdNyzdkqiLOaTvudDyr3elRztJbsFVheEg2HX8zqYPNLeEsB9X7SD93wAIanKInuHzR4Y6HlEqWT+aj4RGAtoQ4xrR/rwCvbqW3++j3VrZUIOmNZjcTWy7W9l7n7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804042; c=relaxed/simple;
	bh=FHR8hnKXLatqv4ZKn2bZB1XIiRgs/sHLWXPPklMVA6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtywIhSULbam1JnBLzYElGULQoUnYN7sRylmhwnBM8Kasfaeetsf4FbLcteBH+Flfwzb3B32C84LReRL/4/mQCsi237ilSXDZiGkkFbzoQ5ucMvaX3n/sSm+WhyIQ57lId8E9aZwEYR9lfI5Gakovwoyf+2zfOwEDd1TfuQeRaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uarxtE2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uarxtE2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBA4C2BBFC;
	Wed, 19 Jun 2024 13:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804042;
	bh=FHR8hnKXLatqv4ZKn2bZB1XIiRgs/sHLWXPPklMVA6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uarxtE2o0ERRAWPe5YZDV32MqzglFCtrpJ7ogpRHeVoodzcucKcvaBU5vESFP+hYf
	 Y1XVki6k68+cYKJ/hU0pbUGeznN8IaJWbPksiDX9L0qpBbRNmcJKTFEkpRVL3tSmFW
	 pDLLyWPWdmUccVz9lXyFJhaJ8t174jXPS330abZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 189/217] intel_th: pci: Add Granite Rapids support
Date: Wed, 19 Jun 2024 14:57:12 +0200
Message-ID: <20240619125603.978603759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

commit e44937889bdf4ecd1f0c25762b7226406b9b7a69 upstream.

Add support for the Trace Hub in Granite Rapids.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-11-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -305,6 +305,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0963),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


