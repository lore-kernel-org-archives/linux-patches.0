Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FEE2676E1;
	Tue,  8 Apr 2025 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113193; cv=none; b=Gt25eCpgtB32LFQHy9LsBuV/uplyvs25BDwS28XL6aN7xUfsbr9DfpH8HeM6N4c231qGGF5wH9bzCbP+cgK6vquQqrPGNxz+XFsOrl/ZXSrxs+Ij4+ATlZyfoYC1S2vGbJuo8H2T0/f9JSSnPwTyt3vZzFEN1L5TST5ah32Qgxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113193; c=relaxed/simple;
	bh=IeK5gYWFqAEcPg38qTAeJ23u7Z7bb0c/IQFyF4KXbY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BF/rrqPgytHHv5GqCOYvpnXUFjLAmvXffX3lPaop8oT6RaeZ3baLc2xOldLP7zNCmG38yrbYreSbEqWtv2CLXkV/eqnFD9Gr1jNYpVAeUw5/eXvKGILsskNw+vI9bKyrfnobghHTYaNFO4tEeucewg2yfO2sALCuVZqJFuOuayc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19HdcZBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19HdcZBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B8DC4CEE5;
	Tue,  8 Apr 2025 11:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113193;
	bh=IeK5gYWFqAEcPg38qTAeJ23u7Z7bb0c/IQFyF4KXbY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19HdcZBn3XRA8Auz7iSRRDqqM6NWxOjDzs+HfX7BPXWH/eXfcaNjvXaVWzpWv+Abj
	 HKLKRc/iXhQVYV2ny8baedyu5dXwsw8BinEDerqe3eT11Zm/3Srir+1K9KvNS4gMC0
	 4fFQY3Bn6SSxqAaLkB68BSJK8QJzAdA3SyKFyQk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/268] HID: remove superfluous (and wrong) Makefile entry for CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER
Date: Tue,  8 Apr 2025 12:47:19 +0200
Message-ID: <20250408104829.263018027@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit fe0fb58325e519008e2606a5aa2cff7ad23e212d ]

The line

	obj-$(INTEL_ISH_FIRMWARE_DOWNLOADER)   += intel-ish-hid/

in top-level HID Makefile is both superfluous (as CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER
depends on CONFIG_INTEL_ISH_HID, which contains intel-ish-hid/ already) and wrong (as it's
missing the CONFIG_ prefix).

Just remove it.

Fixes: 91b228107da3e ("HID: intel-ish-hid: ISH firmware loader client driver")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 082a728eac600..f5a06b62b385d 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -165,7 +165,6 @@ obj-$(CONFIG_USB_KBD)		+= usbhid/
 obj-$(CONFIG_I2C_HID_CORE)	+= i2c-hid/
 
 obj-$(CONFIG_INTEL_ISH_HID)	+= intel-ish-hid/
-obj-$(INTEL_ISH_FIRMWARE_DOWNLOADER)	+= intel-ish-hid/
 
 obj-$(CONFIG_AMD_SFH_HID)       += amd-sfh-hid/
 
-- 
2.39.5



