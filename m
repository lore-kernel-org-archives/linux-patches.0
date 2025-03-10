Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B351A1DE89C;
	Mon, 10 Mar 2025 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628178; cv=none; b=BospHQ/Yvz0MCJaRQlUsn0UVLHBEJcOVczbR4FrcBCyb9jCZBtWT8NjRtEir0K75XsXCxUjc6534pSDzfL10aogx02FNncmd2pAWR4TEN8IJNQR5dLiT+Kd/KE3eJbyeZM4RWAV0o4G4cAyN3ePzWXNhi3Epgbf27GPTL4ddGP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628178; c=relaxed/simple;
	bh=hajizn/xKl9fe/KteHv+tw0/+cpZ8/fixCgzpO/Dlmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Moz0nsFZI76bWLDsTrJF3KVwYrlpVSaIXl8WZXUYZra3KV1KP/2wCT6MrF/X5wIGhnyXIKoI2x5O3Wygov9Q6aIX20s77az+bVs5H90hAsumAcDdlmV2IsYkrGjcle73T4o/SPULsYepwDeV6QstaMfkz2lr5IPRTlOB3p8jRVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmH4v0bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmH4v0bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3253BC4CEE5;
	Mon, 10 Mar 2025 17:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628178;
	bh=hajizn/xKl9fe/KteHv+tw0/+cpZ8/fixCgzpO/Dlmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmH4v0bg6jrN1v74KUjc9HXAKkP7sxgsxczyQxMlsa6ntkLOW9NknqP90XR+wi+yq
	 HDkyTUdE7L1vqANzQcGbvQNJTpElW1j/+L4Iwu65C4jLE9rmyTJkiEgtlkuezIOADY
	 4tCVlxYy+fGTdZjJHhla1R/ZyaKVHnsF0RwCPy7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 115/145] intel_th: pci: Add Arrow Lake support
Date: Mon, 10 Mar 2025 18:06:49 +0100
Message-ID: <20250310170439.402119326@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,6 +330,11 @@ static const struct pci_device_id intel_
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


