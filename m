Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3C417B4F7;
	Wed,  3 Jul 2024 11:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004661; cv=none; b=SQQ67nZZFA/iMKXM0Ro1QLBDs6YyKbDXESxtyXi4aJLmqRlHpzAVzH9JrRq8Tv2vecyLpd2D4ugfT9jMKrT3fWRXbUha83nSjOsAk0ZVaswNK6uhWT5PHIbrwOIN6awbU0+m1zb/2wlAnGNLtEYRp9jFAqzUZE3vgB7qggpvnYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004661; c=relaxed/simple;
	bh=B36midJSBTnCCn8UWwLvJg+o//D5Iupy52mTfCS42Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogGe59dXZk6OKK+MjGY5OttKVHv6FZUvWqNyAQtgpUBitCSRFpm0wlu1QsS/dARIEJCWmmYgJ+nQ9y+1XvoVP1Br19LMLVzqbmCrgFE7KYjw9ataLbWKTjYeZSCw/3+LMqQhNNR4i5IjnAM6DCY/ktDiL5Az4YletOZ1+JssjeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYb7EvRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYb7EvRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1725AC2BD10;
	Wed,  3 Jul 2024 11:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004661;
	bh=B36midJSBTnCCn8UWwLvJg+o//D5Iupy52mTfCS42Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYb7EvRqvsgK6aBA1tYpmrGrrdZaTzQW5hj4OdUkyfDbLm8xIio6evRVjG28rfP/C
	 YLit3BLpDGto3Ydz9amE1y7l3PZYdJlerSJqDsOnttBlAdMbjCUUvhIhDAci7397u1
	 le2pLLcrHjHJ8ZBLH51P6wlQkObDM4faNMM9oNdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 089/290] intel_th: pci: Add Sapphire Rapids SOC support
Date: Wed,  3 Jul 2024 12:37:50 +0200
Message-ID: <20240703102907.553724098@linuxfoundation.org>
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

commit 2e1da7efabe05cb0cf0b358883b2bc89080ed0eb upstream.

Add support for the Trace Hub in Sapphire Rapids SOC.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-13-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -315,6 +315,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Sapphire Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3456),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


