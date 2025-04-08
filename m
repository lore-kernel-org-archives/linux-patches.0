Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D76F269839;
	Tue,  8 Apr 2025 12:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114290; cv=none; b=c9io8K+mB9ieR3wGrp3dOSEJpRyLOZNKLmPFFQdn0ynsmM8WM8+3HUXpEbXDNLwWs8OAeb6qYzOkdnY5gqg+DPQK6s4tKYgZ/L4FJe/oKxi123dpEV+TAA+oPeOEYuj2wyY/L16zFdUMj/FdazelaH5w81x7vzZkKPAcLSlbNMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114290; c=relaxed/simple;
	bh=0P2SDoV01uCkTISMYmEC9lcsKOCSAMLitInvr5nwDFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYuAdkf6W6wSfcLeZTvTEz2mT/IcVLwNK0JwokeO84TLBhMhH6kuo9xIVBscOD+3RWE2m6a+tyhwD0RgYSd9XHvWe+c2jNMNC1VR7/In9U78e0GLkB7qQ02cIGK9Oy/5CPZi7yR+8uvDve+nHFB5igSPycUVByfctXL6Um9SYc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzhS5Ie6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzhS5Ie6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B74DC4CEE5;
	Tue,  8 Apr 2025 12:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114290;
	bh=0P2SDoV01uCkTISMYmEC9lcsKOCSAMLitInvr5nwDFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzhS5Ie6WWLTt/yT4vVsgka4PfquE5n9RjIpsJjdwZWHYgXQEhrJXNkX0KLJ/dp0x
	 jn5wZPZdMqFcw7YsW1WQxX0S8ymy2bqpmF4e0Fu9itY2VA52dwdbeTGO/S+XVq27vf
	 aeOpuZMXLjIcyNj5JwrwGjAIFqtgP5WrMTXqPybA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 053/499] HID: remove superfluous (and wrong) Makefile entry for CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER
Date: Tue,  8 Apr 2025 12:44:25 +0200
Message-ID: <20250408104852.560181638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 24de45f3677d1..1f50a6ecadbbb 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -166,7 +166,6 @@ obj-$(CONFIG_USB_KBD)		+= usbhid/
 obj-$(CONFIG_I2C_HID_CORE)	+= i2c-hid/
 
 obj-$(CONFIG_INTEL_ISH_HID)	+= intel-ish-hid/
-obj-$(INTEL_ISH_FIRMWARE_DOWNLOADER)	+= intel-ish-hid/
 
 obj-$(CONFIG_AMD_SFH_HID)       += amd-sfh-hid/
 
-- 
2.39.5



