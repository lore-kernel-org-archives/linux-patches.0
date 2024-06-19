Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C37B13F428;
	Wed, 19 Jun 2024 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804045; cv=none; b=ebkT5MpJqIpSzRM5ygJsceyURktjab2tZ+kxVlM+uvRPvQ+wqxSaT95bQWuGw2HGUJaboZNaCaKO/BsgCpfpa828lG2a3+lmj7qaI5B7FoJKo/8n2dPqdmpf4e8RPaFW+3Hzp/tJ1tG2xdtJNk2dxABDNBdvtPHidC5hjZEvfQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804045; c=relaxed/simple;
	bh=P8AIKJU2H/oiwc8f3cCVBJtVTOxlCdv01qc9ia72a+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NF5X5yE6mnWDH4iSjsJ64dy5Lg3j4v4WM6RBcKhyY4fCClU8jdukNmEHKnOlcOv2/90G4W+tneICguRULgHmTRtUk+7503C70ArvQs/aoBnD4SjJ81I+t54p3l6sz/cojNKxpkD5eNj5LNn7iTJsOH7zDE5x6+ZJ6O+CS6Xq9XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DDPRhRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DDPRhRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB20C32786;
	Wed, 19 Jun 2024 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804045;
	bh=P8AIKJU2H/oiwc8f3cCVBJtVTOxlCdv01qc9ia72a+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DDPRhRrXchimU9pNb4lYjs3SCRoMeOyhv7zbgnsJhaZ8b2I+4gqNx7gvqbjWnIj5
	 CABOEN5zjDAHIXxkCh1i/SpFW9O65sBRYOjLKn6J0H0VeEa/sLyQTRtD7pbhL0kHac
	 7LWzdTth6V7xwrI1LkvFZ3AZ/KLnTFxDdZYuziWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 190/217] intel_th: pci: Add Granite Rapids SOC support
Date: Wed, 19 Jun 2024 14:57:13 +0200
Message-ID: <20240619125604.016453847@linuxfoundation.org>
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

commit 854afe461b009801a171b3a49c5f75ea43e4c04c upstream.

Add support for the Trace Hub in Granite Rapids SOC.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-12-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -310,6 +310,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3256),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


