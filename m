Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A34183090;
	Wed,  3 Jul 2024 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005591; cv=none; b=Tg2vxXs4a4daKgmSo8d6O2Vq6DqoYUz/nXvuK0DuTfIfE4lSVEc3llMc3nPh9ZgLroFSNuhkiiwP2oUtHvtVxbza4jkmk63ehvx+RKXa3Bubu6PiEMy9mjpYr57a9Bbl53u1QTfQWxooNHBf+64PVg5bL/5f5OL8x64rvRJgl1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005591; c=relaxed/simple;
	bh=b0TxMZhtmrVfiqIbCVb4ICZW8jDk83pD9aZguWWQ4Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jp4AlGLhca0EtpEevSAedVzPZPa+5TNXlxv3X4p92rvgJXvI58xYwyP7cnPiEKp0snskf7LRl7ml7ycsUC2I4KMano0jjP8P8NIzScPEEviwwQ8r1ws9ViGuoszuJep+5ZqFs94C9XAo1HJB8SmrvSske/Tae+6pXcN2pls+74M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koMw6LaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koMw6LaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C471C2BD10;
	Wed,  3 Jul 2024 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005591;
	bh=b0TxMZhtmrVfiqIbCVb4ICZW8jDk83pD9aZguWWQ4Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koMw6LaCrzZ/nT/KJsDiMBrv8a/+T2fxRWa9PGKAXzhzRIRjClvfI83cZybnvQM4Y
	 I2PnfYRtYsRbM6e2l4+UHPBfy6kD12NqmQBo+JofoZxUrj7okzqAS0UFJ7oJuAdCvk
	 1SP6l54MjLIaO1MOx/AK2VfcYrTNvVf7+5YfPFGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 132/356] intel_th: pci: Add Meteor Lake-S support
Date: Wed,  3 Jul 2024 12:37:48 +0200
Message-ID: <20240703102918.093120811@linuxfoundation.org>
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


