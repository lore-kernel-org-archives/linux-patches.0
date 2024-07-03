Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68F17CF1F;
	Wed,  3 Jul 2024 10:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003514; cv=none; b=OL3CHEzkFxBELOYdly7w2BCYWPQd3R1p+Z+A3V+VPjLqUbMxri7l1lNyte1fqWRS3xBClLoor4t1XArRoUu3NWhGbbVUZ4A3raMXlB1PGOBZzeE9d6aejuwKBNnEZeQOagoMhe7esDQffD8o5uIDIjKcBoGYdfEX0mOhpFgPN3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003514; c=relaxed/simple;
	bh=VOje6+gxDR2NkLDE98kOhwtguPaHqlhbByF7z1KD4Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2HOo707W/LDkoA66oLBLZW3VUisTE8sCRKmakyVn39qiGaeIwq7J2Ff2KplaE5bYwv8gXss4TWxVLm777pyiZ4L4DVIqYyC/bfTWzm67/3EcdiM2iHDM7pA0Pq93BROU1/352WWlLQjDT7kLCeAX41JE9v3T22Hemeo8PLLxGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tn3XEHsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tn3XEHsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CA9C2BD10;
	Wed,  3 Jul 2024 10:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003514;
	bh=VOje6+gxDR2NkLDE98kOhwtguPaHqlhbByF7z1KD4Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tn3XEHsgGGQN9csr/NPyRBw4Bu5shR1ZhHgYYbdMXM1TxKUhz2NuIthONssRbboqr
	 AbosXpENchOgdxmOSUmVgT+nxhv8kcrVitKEDx+0DXQ71JMYOqGVpe3FZa8PJMr42L
	 r5gQdRyHYqNOpFSBoVHA0dz7b+n/Lg9pfOk5ABrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 4.19 056/139] intel_th: pci: Add Lunar Lake support
Date: Wed,  3 Jul 2024 12:39:13 +0200
Message-ID: <20240703102832.555566703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit f866b65322bfbc8fcca13c25f49e1a5c5a93ae4d upstream.

Add support for the Trace Hub in Lunar Lake.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-16-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -286,6 +286,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Lunar Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa824),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


