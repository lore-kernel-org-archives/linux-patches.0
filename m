Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C15E3209;
	Thu, 13 Jun 2024 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281633; cv=none; b=WqDuhxaGdHnHWGxrqQu97U2D8Lt3yf8fjhf5IwQ2ZITNDzIaaYEZ4uT62Zbyy691oyqkupKL3qq3gVsJZnp8KhMqIv+jvhHbdBNNbF1g0jZnS7sg+VjygaIvFyHg56ThG8acsMKayXBS9cYz67p9nR3yu33ykP6g0jVzhAIhFaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281633; c=relaxed/simple;
	bh=lRGFIPSgvR2ue7hzEEBmRAMqmKsj6JgtthzmwIxcs0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2ULf8lJcA6V9C0QH1RFRrVWsFdZ3HXIfOL7FiAip6SvlO13wPybd+8SN3Le2rNNq06Qcs1/A13PTeP8Trw65pH4Cwl1dKxwPAGYAoN7A3Mt0A9FjB79mzpSWlJnCDe6L59Ftg1NmRtjwQRR0X/azxd7Rb3ZZWMAcqyXGG0KBzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8MCeDcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8MCeDcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD7FC2BBFC;
	Thu, 13 Jun 2024 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281633;
	bh=lRGFIPSgvR2ue7hzEEBmRAMqmKsj6JgtthzmwIxcs0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8MCeDcsTcHY92Gv2z+c/jG92/0oVeEzC22btdzUvnKAtHZceeeUL7zq3FFXyf3q9
	 p/dkK51A/kKKnE+FjNgbNtV9/xLOBnfigojIuQdnAW4SwJK47RptZ+2i6mpY5r2czB
	 tvd4h1vc0m2o1kGEY0uc0AXS8Mes+nNor76jM+qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 300/317] intel_th: pci: Add Meteor Lake-S CPU support
Date: Thu, 13 Jun 2024 13:35:18 +0200
Message-ID: <20240613113259.155624360@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

commit a4f813c3ec9d1c32bc402becd1f011b3904dd699 upstream.

Add support for the Trace Hub in Meteor Lake-S CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-15-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -290,6 +290,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Meteor Lake-S CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xae24),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Raptor Lake-S */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


