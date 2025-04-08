Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F8926982F;
	Tue,  8 Apr 2025 12:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115573; cv=none; b=NhO01Og5oGOIZGK9xv2vvM5p7FuEu0rRygDTcdQ0WD5yeu/PUIKcenPXHSBITeRy/m5LVBk5tytHI3yHUnT6FolI5XBM6MZukWlCVCB3PAK2MztzFAf2FzAK4hjCGyxxabufuEMfINMj6hRuyRu8VLNufevzmP9QAc/XbqaChqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115573; c=relaxed/simple;
	bh=TkcjwGXEcRgfdXgM30AfKfeYZEwi0jjdRmzg4pqMk+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCn/if8R52yDYcj8Bm1OSuqlP7+hZ/xu0MXJeCtamw5tad6nx5ZCQ0tdUm8ee4L4igJOeiKS2qQXN4wp4mLzwA+0CwiktgafYlnrA87ryc+/4JxbkKaOAbiEqMkU6NxjfpucB/ApSLT3khMfxk1HD9QA810CWG7fQk8f0YzRK30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7UQhcvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7UQhcvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC91C4CEE5;
	Tue,  8 Apr 2025 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115573;
	bh=TkcjwGXEcRgfdXgM30AfKfeYZEwi0jjdRmzg4pqMk+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7UQhcvsoB+mfuFveuj5u0k6u7xzVqvOMHe8rBy/PofaYd6Th0W3eZYWiDGkYNwE2
	 QWp+rf17oxYUW7nXxx0C79fZEimauyIGnv1zvIxs9VzTTI7ZP3jCpx3rhTB4pEwIS8
	 N9sy3rq8NoIEEMEq9+4BfUiBr5X5vdJaMFmeePLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/204] HID: remove superfluous (and wrong) Makefile entry for CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER
Date: Tue,  8 Apr 2025 12:49:14 +0200
Message-ID: <20250408104821.030625788@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e8014c1a2f8b6..86195e9c59c4b 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -159,7 +159,6 @@ obj-$(CONFIG_USB_KBD)		+= usbhid/
 obj-$(CONFIG_I2C_HID_CORE)	+= i2c-hid/
 
 obj-$(CONFIG_INTEL_ISH_HID)	+= intel-ish-hid/
-obj-$(INTEL_ISH_FIRMWARE_DOWNLOADER)	+= intel-ish-hid/
 
 obj-$(CONFIG_AMD_SFH_HID)       += amd-sfh-hid/
 
-- 
2.39.5



