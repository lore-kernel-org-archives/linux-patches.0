Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B0F4D9EA;
	Wed, 19 Jun 2024 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803430; cv=none; b=HocFdFej3Rom/FcZGdh4mYhpQgRt5qcAPie8TNsQEsm30bekCGcuirDZjfxxWk/Ue0PbtIXs8ntqI28YyIs4XWWBtLczL1yzN5jfq41H7Sp8q9QHUg6lYF8zJWRADP00XVuXZr0euBMohF+R3rwdmsvP3y9jOn8I6mDnhSsdtnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803430; c=relaxed/simple;
	bh=nOExpo5N7nUuFRMm3SkJZc2XaJqzR1+Bi1m+iXiAgTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUDjxKfpOzekfuPhcy4+HMAmAh7oWd83e/3+WDV1RSUC/QauTqbYWpsf4KNWLHUGwc5eFa/6mF4YguGFWxveVBzSfHYw05PJrWhq+zcbSJsK39cxe3cOkC+cPnLIVeGBmQF6xF9wxqMBAMRNYzIVj7sgBxjWoTgMOxuv27NktnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dThaXNev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dThaXNev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EC4C2BBFC;
	Wed, 19 Jun 2024 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803430;
	bh=nOExpo5N7nUuFRMm3SkJZc2XaJqzR1+Bi1m+iXiAgTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dThaXNevYpNa7Qsx5MKRskIWodqEFQkikqSrp9Wghs0U0yiVknXQHLOjA56BsY4Ce
	 UTY3Ur9R83J7lvINI9AzZxhOp0xJQ01aeyQhTkPegrEFYd270v4b32tZ/CbKN3brt4
	 T82Z9fXI3Rya2fvZ+QfVwB35u4SQFEjx17pUm8gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.9 264/281] intel_th: pci: Add Meteor Lake-S support
Date: Wed, 19 Jun 2024 14:57:03 +0200
Message-ID: <20240619125620.136036630@linuxfoundation.org>
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

commit c4a30def564d75e84718b059d1a62cc79b137cf9 upstream.

Add support for the Trace Hub in Meteor Lake-S.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-14-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -295,6 +295,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Meteor Lake-S */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7f26),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Raptor Lake-S */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


