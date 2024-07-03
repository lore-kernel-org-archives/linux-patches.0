Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA4F17C238;
	Wed,  3 Jul 2024 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003960; cv=none; b=ubrQVov9bJkZ6H5ORT9xGfEGETacK44VF4F6Jif7g5ACQ+xsDzGwr/mzhAHgEyiQrQGXjMkNC0d151yMlakyrXAgm/lEswFMx5x5bkIleTU3/zipVoDXJxbFbSGE+NozWcDhOyjcAZoAaKmGP7O00E8V+q1rsyKxD76jNns8BL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003960; c=relaxed/simple;
	bh=b0xeKa+5DR5pgSAUQOT4zKUXutidM19fx1KehpfSzaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIcUgpIBP33LHxpPki1jNnCKM913deDgQvJwFfzhh5I/Rv/KMi6H4dPMCAMCdIM65H0QUasi9paRwsxbzUhDnaJqMcia8vb2jrKMSK/HnEY8/n8lTuj4XMw9ils9tAhdfvsncwJBlRy4FQFOkR6JZDJBUk9qPT1j0jFtjpKpFBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifKWG/y3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifKWG/y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5315CC2BD10;
	Wed,  3 Jul 2024 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003959;
	bh=b0xeKa+5DR5pgSAUQOT4zKUXutidM19fx1KehpfSzaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifKWG/y3VF/K5gECSOyqeakobq2iD2EzJCsNIQ9MF7VySWGCLQFxBqKe282RfJsLQ
	 4P0lw2oDD3Xh+UrGFntu+dn2iBYZ3gWyMnIquSTbeX5fWhQnorZLFV/NRLBFW5Gbgo
	 k4l3HtMDpvAy+xQP5FfJMWxksOGzxkLKR4M52oHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 077/189] intel_th: pci: Add Granite Rapids SOC support
Date: Wed,  3 Jul 2024 12:38:58 +0200
Message-ID: <20240703102844.411275736@linuxfoundation.org>
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
@@ -305,6 +305,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3256),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


