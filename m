Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A464D9EA;
	Wed, 19 Jun 2024 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803418; cv=none; b=iaAq4ini+82HB02o1y0Z5kchLA8q/pl+iNziO9rgtyqBe5sijozIb8IzK3KEqn/ln8WBr6Rxh7OQS1Yp8r/JMhHieP3s+ZlLXKy/e7xFOauOSovzdOfCMG6zoYkMkDwsECNtdSkW3UkRKj8ES/Z9z3dlJ3pc72ll15lTKsSCuDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803418; c=relaxed/simple;
	bh=ywnvxbakoGQhlsa2YEkHJ3/uGjsjdZ5JGwxJuBKTMuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQA9wZ0b1bBYl0shj98DVIx7c02Uj8pqehtRGtl/sBNFzmS1Qpsi2AV+ywsZkCvu2mTEfVx7Dpx/+BoduKZI+JDIsjGqQazilgAuKlRLd16wuB2KHdWMymmgytI17UU86QjyhyjNuSg21nuVukbtN7ILVKSRHOhPXjT9zdrkDEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVt3OrvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVt3OrvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF31FC2BBFC;
	Wed, 19 Jun 2024 13:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803418;
	bh=ywnvxbakoGQhlsa2YEkHJ3/uGjsjdZ5JGwxJuBKTMuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVt3OrvEXVlP8yyAYu/WqDFvXRVCTGgpgyBekf+1hTQh7zvPAW3m4ODVXd1Ht43ZG
	 /Jrq0jIgGL13/oqerjrPvqjFBkQc4SsEhIP6CooTOv40uEzOGP3SleJyYgbSxK8TYm
	 EI1mW6WE0GtFGJ/YQAqHChdz6P/a0ScoHg1+sIb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.9 261/281] intel_th: pci: Add Granite Rapids support
Date: Wed, 19 Jun 2024 14:57:00 +0200
Message-ID: <20240619125620.023322467@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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


