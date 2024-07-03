Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DC8183090;
	Wed,  3 Jul 2024 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005588; cv=none; b=ihOcC8ls/t/GgKFMcAWV/faMMydf3B0ZmBRjW7WO7v3EqLPxvzmoaQudDH7Qe1gS17X/ENFRDvTEzbHkQXz13eUXgAPYWHl26RWH03Wq3jHKhQ+VTB63KwPG5a+E1R4bXLeJgy+5Y6zL1sJ9DfClZh8rtEFFe7oLHP0Kcq9QAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005588; c=relaxed/simple;
	bh=x5cOgeGT1SaLIUP3hrFAnsmusYBVGOlwlrhcTMTevkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCUV3oqSNq2uLsB9TieuuosgTtsNwsTrF1jLLxSm5YD8FFtDWUfMsYffdpSicVQGTbi0xlsNubFIEm3i1DOHY+JXKZgO86T0+s5mVikVaCxByW7t2gYrMPo5Umx1+Dz0tMxb5OFpzNzCqD30UIfF60TVsR7UT23TrMl6inM50WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWmHkAmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWmHkAmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A69C4AF0B;
	Wed,  3 Jul 2024 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005588;
	bh=x5cOgeGT1SaLIUP3hrFAnsmusYBVGOlwlrhcTMTevkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWmHkAmMJxPb3ClFvINmG/KL3WQMkjdqWObdRIaI0JN6oUmZBF4mQdRy5IBvET96a
	 1kDu0XnKxfDrrVbEpN3zxRFFdm4FnlwSwBZ8ykGivTxOQ4klQkM3dzw6LMzFBeGF+2
	 HFanliHJmkUMPxFoiY9Lx08yMf/MeH66SyRicfj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 131/356] intel_th: pci: Add Sapphire Rapids SOC support
Date: Wed,  3 Jul 2024 12:37:47 +0200
Message-ID: <20240703102918.056219775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


