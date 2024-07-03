Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A9A183094;
	Wed,  3 Jul 2024 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005594; cv=none; b=d9SHlg+ocouWTqUe6bm3pzXKCfcgMMonK5w7C8P6cJTHYCBelloJoYI7mBcSHngJbxKWqFMazfxr6GW58OKbn6vSRICK0HkZALEjP6xmiDnK5SV1akLFGrbyvLrinSARcjaS1Tb/JzaGJQxUizo2VDnexwmCLnRgbuOzDTmwkEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005594; c=relaxed/simple;
	bh=cuaHQT7EgTPLTs6D2JDC0yuTDsrwqO2onEbnv3AdsAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXaCx0tThBrXaThL1lA3VDws4602QFRZ+cgs5vQmByv8KxlcVscb0TMEp3c9agLLqI+JUlRszyvdg8Nw+6gt+4mwOaILGyZYk6qQcSKmW6PZhfOSYMF5ram+0zygzeZLgJuSiahERcasXojsrJaouZK6vL9xZDwdw+Y+uLkh+J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13vRjVN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13vRjVN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E90C2BD10;
	Wed,  3 Jul 2024 11:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005594;
	bh=cuaHQT7EgTPLTs6D2JDC0yuTDsrwqO2onEbnv3AdsAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13vRjVN/yVlx1rGmvMwa7q8J8ix6jhlaA6WDIM2D+VllvLJliSO+p+u8YiUlr3yUJ
	 38ulPPd/oGxfnLL8KvLMWtUp5KG3Ait+/Mjm9TNe/xTZFKvrV3UnJELAQLxbRIjnIq
	 ug3h0fQUGddMo3PLBckBUF91vECPzXVC5ydDZr64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 133/356] intel_th: pci: Add Lunar Lake support
Date: Wed,  3 Jul 2024 12:37:49 +0200
Message-ID: <20240703102918.129760948@linuxfoundation.org>
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
@@ -325,6 +325,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Lunar Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa824),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


