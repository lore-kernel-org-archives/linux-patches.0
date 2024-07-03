Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE0817C238;
	Wed,  3 Jul 2024 10:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003957; cv=none; b=XN3e9vXtCt+2x0+rhZwvQHZqviEtuo2NOIdbNOcWeuQeHXKvSrkihyVvzibmpffkNBbm4jFu2pVSa+UuwPcM0GFK8YFZ5ktukRQovfKLqgBwfV5d2BE5CG/gsMNDsSyzPYNrYAa7mhT8MNbsbMcgQKQIuh0Dpt2+MeYrPDGNYuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003957; c=relaxed/simple;
	bh=y2rQj+MJVQom60xm5HWNWwP82VO8jbYtqjScj6KXCJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKKcCDPAlUW6wQdRTo61t3VFj0z0JdRS8uY5bxlU5CXuY3CHYk+Hk3+3qDBLcpdTJTJTtN+0QrXKeP53nEZZbV+s2mn+Q2HRMSgfPJm55MS+k7Ef9CJa9wPYKDKgCUjroGCYmDI1FCXNymmzm+FJxZiCbvVaocO/f34CXXffEAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vspHy+LR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vspHy+LR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F46C2BD10;
	Wed,  3 Jul 2024 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003956;
	bh=y2rQj+MJVQom60xm5HWNWwP82VO8jbYtqjScj6KXCJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vspHy+LR8LoYuaieywDfqNSZy0rleUx8KKFmQ/Eykl0ybEyn+Qte5vqGGU/H1WQLS
	 zqFepbvF8KwuzgiEhWrUM0cN9mSBWjLTVoLH1ZBJ6SYy2pAhb+32bXRgR9Em/w0BjG
	 k6yfm3B+1Jj2SZlo/C4/uHrl7S/RCT6V9/XUuAmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 076/189] intel_th: pci: Add Granite Rapids support
Date: Wed,  3 Jul 2024 12:38:57 +0200
Message-ID: <20240703102844.375112275@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -300,6 +300,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0963),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


