Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFCC142904;
	Wed,  3 Jul 2024 11:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004676; cv=none; b=AlV8d0BU+qaQ0AjnqagXye4nYc0xanLKo4XaO6QeBgoFlIAtj1NHb6Lb2KVpFdWTEHvHOmAGslvI863OmDKCdectfajesc0bAu8nrP1W7Xgd+k482wLcVX7MFsQ62zsiNynFbZB3rlgqtQ5jfciKyc/NOGPyCfphuVSlIPY+IRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004676; c=relaxed/simple;
	bh=KU/csz1QvPjkupSF2ggRoTUO3UdpzlXRkZLn0rplIbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRByTJfR6pXXfE+1DZvdLE64rSnfd/c6GBcFL9tQQ+66URf8ItKKHBgZxhFotlbzggF+cUHhNT7HPvwQEjiiO6VCNLIiTrG68hjtSYT4yYi30pnNzvGllcek6hzIvktm3TqyDeEH4gxlwFOchv2zPicXvK1yV0FoWVqKzvIDcmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgiAFlbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgiAFlbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4377C2BD10;
	Wed,  3 Jul 2024 11:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004676;
	bh=KU/csz1QvPjkupSF2ggRoTUO3UdpzlXRkZLn0rplIbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgiAFlbjZBFxlxyGkRDtDnsGxQrtePFm76WEqWM52C7L0uCRexRQ2FUjME5PDhWLv
	 +di31bb0NzGEm2gwqhkiJuIF9CMfMjn8n9UgCR63H4R+LUr1YI15+w0CSJbsL5Kr9s
	 xeVthqi+Jf8I1nyM8HEbQV0+/UNLkahOKNj8AgoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 090/290] intel_th: pci: Add Meteor Lake-S support
Date: Wed,  3 Jul 2024 12:37:51 +0200
Message-ID: <20240703102907.591141371@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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


