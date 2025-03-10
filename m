Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9C623236D;
	Mon, 10 Mar 2025 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628515; cv=none; b=nqkSaAeavB3dfLUDagBHccwBZNpXi/5QRntjY3z4teeM2cbna6YTtHXpkHXLPOaFzqYAutf3x21XyU9v0MhGGyWDGpTSZSGgCzaUvzD82vgVx2fh0Mj3XAcT7aCZMCiVWgwpZl/Wxs8KS9i6qp0kI0V67Aj05E3kAuDfNlvJb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628515; c=relaxed/simple;
	bh=m9dzySiwtRx1q6D105e0jPrDRNAtuk5o0JoMiI+LSys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ggyp/Te64waiQ6T0BLLvOGkPEuAVsiP+FQytuZb7+QIInlGYvPUPFlM4J8TRiyAs9dZj/FyAJixC0442Kq4nL2Wu+UkI8fTbyt1EO9tFpY8dFTsPdbC+lm4m/zEYeQ2MwfbUx8UNb1FN78UCwJ/uYt6uA3j2Oy6fs+pDC2VRJOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPcz/PjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPcz/PjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAE3C4CEE5;
	Mon, 10 Mar 2025 17:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628514;
	bh=m9dzySiwtRx1q6D105e0jPrDRNAtuk5o0JoMiI+LSys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPcz/PjZKLi+Uvuosxel4i/H2IbfY9YobJOQEpD8OGy5ihRcHK3qDH7QnnH+PB7NX
	 voICSUWpTV+rLJj2md84eVuiqeQF3siJ89aKSK8B/RJ0GMa8ogpcdcZ2JI6clQDc8D
	 /6W7NNkxEtrfNBNKOET9Vml4DnYoegT6/P24zkW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 083/109] intel_th: pci: Add Panther Lake-P/U support
Date: Mon, 10 Mar 2025 18:07:07 +0100
Message-ID: <20250310170430.865100697@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


