Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BFB181D1A;
	Wed,  3 Jul 2024 10:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003482; cv=none; b=dvkmFwVpZCjaVX/8OvfJuRr38SmGVU2E+bIr9uunkbSXm5ZZMCX9M1Rs98Vi5U2TjhLrxevlSrW9vcIrpIY+zJK9M13tjJ2w8FdBm2RcOz0oGmt4jpA5cEetwnNqT2goaaCgj7dB05Z8cykkg9wVJdOOUm+xKb7+PgdUc5RUrg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003482; c=relaxed/simple;
	bh=0FTB59pNPdTNkAlHDmvu9sgqiwkQCRGKsdVbz2KPVs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkDR6A/DAIgeKajf/Xm90JCLogLP4eBH52fyFmpYcyuxzHgg/ZVpCmxbkUR1vhC/6BLeKRANQ3z1F5W4K1s2FRIM/Zi+hoJrA75Sa8SSHX/0aqE+i87qSZj1wUqOrCXKA4jo3FASZABIM6IRlfHvrWkpvcfFY1G0Y2Dv6vKy/ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+2SvNFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+2SvNFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D7EC2BD10;
	Wed,  3 Jul 2024 10:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003481;
	bh=0FTB59pNPdTNkAlHDmvu9sgqiwkQCRGKsdVbz2KPVs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+2SvNFiVSTxlWsmd6nmbLUvy34FBPU4jmeDn6GvJlHIvtlSQyrexppAoss79SNEl
	 AV230qMPIUvIJJIFeEUur2XeqHzoQfHse34KJVSqpZGbs6St5nMgO/TN+JxrEB0ABT
	 hTPurSlgFJ829ZTqQvpr5tg5dyMufxIKheBzkYbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 4.19 055/139] intel_th: pci: Add Meteor Lake-S support
Date: Wed,  3 Jul 2024 12:39:12 +0200
Message-ID: <20240703102832.518640226@linuxfoundation.org>
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
@@ -256,6 +256,11 @@ static const struct pci_device_id intel_
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


