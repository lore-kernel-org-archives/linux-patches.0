Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB5A350A03;
	Wed,  3 Dec 2025 16:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778484; cv=none; b=jRxfQ7JvaBJzIWaUbbpMwXpt+XeNBV+rBa2qL30cbkKXzhWY+y9VC+oHglRks00zQRbmb+GYWxbjmhWx868xr518tT0pVWhcNxZPPiUqLG/aMK9sJtDIVFHjzKVTlPsdxwzi5uX+LWxgfCAvlXZhK0wSRsbqMz6CbGvt4/bkxGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778484; c=relaxed/simple;
	bh=ySWV+Up9JvPLAZ//Dc5T1Dd3K1leFdHLjyRWMf24Tts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q67uWa67x4D87/4FUORN38aXgG8rW4WS+TNs5o43AmHiz4CkWOG8tvPwt9PzPfPtUsCN+jkWX1O7wQ2MIhhmBMjTZJe+itgxTthzLkCH+YFrbWyaIORgIUVtWEVC+U/ypGpmfkXr13FLXhUKrajwbLcHAZy7xYLBC/oDIsBGP6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhq9bVpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhq9bVpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDA1C4CEF5;
	Wed,  3 Dec 2025 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778483;
	bh=ySWV+Up9JvPLAZ//Dc5T1Dd3K1leFdHLjyRWMf24Tts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhq9bVpWwWmHwulNbMEFn65LgnaZH7UXl3ZHL3LY2BYmo0hdY/QqmtLtO19pe0fnQ
	 qCEO+tC8+EBnSR6+zsrnUB19lx8WHC+7aFrETPYPA7HCjezZYHqoFiwrq8uEVyGBvB
	 zBANGUnjGemncmwB4bJERdejXwfcoQKkjQJKO+pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 360/392] thunderbolt: Add support for Intel Wildcat Lake
Date: Wed,  3 Dec 2025 16:28:30 +0100
Message-ID: <20251203152427.413032642@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

commit 3575254546a27210a4b661ea37fbbfb836c0815d upstream.

Intel Wildcat Lake derives its Thunderbolt/USB4 controller from Lunar
Lake platform. Add Wildcat Lake PCI ID to the driver list of supported
devices.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |    2 ++
 drivers/thunderbolt/nhi.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1459,6 +1459,8 @@ static struct pci_device_id nhi_ids[] =
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_P_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_WCL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -75,6 +75,7 @@ extern const struct tb_nhi_ops icl_nhi_o
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE	0x15ef
 #define PCI_DEVICE_ID_INTEL_ADL_NHI0			0x463e
 #define PCI_DEVICE_ID_INTEL_ADL_NHI1			0x466d
+#define PCI_DEVICE_ID_INTEL_WCL_NHI0			0x4d33
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI	0x5781
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI	0x5784
 #define PCI_DEVICE_ID_INTEL_MTL_M_NHI0			0x7eb2


