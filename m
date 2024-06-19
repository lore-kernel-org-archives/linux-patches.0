Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2470513DDC0;
	Wed, 19 Jun 2024 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804048; cv=none; b=IR1JZurngsdjK+Eo8/Nrc9cATyNjx1QBaq1WT/bV07Hemu1IarBEcciCR1Yeni9bm1fBE24eRtqU2fN+NqnvgFMe8jQsqSFuORSTPaHA3KPXeSQVLN88ZQD4zxuInzsq3BRH6MRQ6m35KTLD5i8JWmSpyAF1NDjSs036UObmywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804048; c=relaxed/simple;
	bh=TshrxYXDfMxS7vVG7qtob8pLtu7x8YKu722zzGRtumI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLA6Y4drrWQRxfmf3qw1pxCKKfZoBZFl9QbRCFLCE4NgA6kOQijBXjl2knLNA4S303bkBtis9DEzbApztzW6Lgb/BmQaHVc+CqZmaf5n4poR3Lucb7xizOIzhzVUJ5d1Kp2zwiTd2ExuKtVo0YutJnM5c6Xw7Mq/V64FV8SouJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuBjfgwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuBjfgwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5DCC2BBFC;
	Wed, 19 Jun 2024 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804048;
	bh=TshrxYXDfMxS7vVG7qtob8pLtu7x8YKu722zzGRtumI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuBjfgwTKcKFpxhv0Y4zzAEssXqZ8YXsHZucK/uh/D9tj16/kvMbfx+4WfTn367tx
	 pDCxFeSS/Mgvdrm9qnl9MQjt5PNTKVovltdPGd5iYZrUpGtma6cxxrZ9dTBQgCEct5
	 KuoSjbwItS7lDyrYqi3l4Za++IujonTFzQ/6oWZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 191/217] intel_th: pci: Add Sapphire Rapids SOC support
Date: Wed, 19 Jun 2024 14:57:14 +0200
Message-ID: <20240619125604.054377325@linuxfoundation.org>
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


