Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DCE219301;
	Tue,  8 Apr 2025 11:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112643; cv=none; b=BE/SaQDVd1nGLpyLHg/9K6VBzJaQTQbbHuV5kRvZMZ40vY0aPYgr2RA5SwzjIHxWunrbtpis9fNgRgqA9oEDkflBAzqQy0THOHm3e4qGajQxjT1Go23KytwHZpxY4nmcHzSf4IFDH1KZBEJoxlyVWyVfGhd648QWjfx3Dve+wUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112643; c=relaxed/simple;
	bh=TGv6RFF+BcPfzW2k3P2LAHFvBRPlBmuMRZhGq53Sseo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwZahNFtUm3hU1rJlglqR6fPa4BozssoR6A8m2c9l0OwHX/uBI3eAq+yhGRn9kSb02NVyMvkb85bVfqgbj5c6kso0APFDg+L/gyOseJJ89ulP/j36Gvo1mzuIguiZsGdAraWxXa5Z1BbVuN7b8DqIIL47Ihf+w/EYIQt7Hvhrnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0LgUgwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0LgUgwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFF7C4CEE5;
	Tue,  8 Apr 2025 11:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112642;
	bh=TGv6RFF+BcPfzW2k3P2LAHFvBRPlBmuMRZhGq53Sseo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0LgUgwu1xgNq5imVgj22qx7eVjolzlygDBFEPHIaJvqhFbQemBe2cIc1ymZiWA6O
	 CKWs98ozv8AfXPwWDCeAC9y9KnPHeLj7xWIcmZgtJW7sxBxzGsGJLJAI3cZRDnpODu
	 JbfY1mnDmanbkBgaBBSN6Sym22XhGqIAAQxXDHJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/279] HID: remove superfluous (and wrong) Makefile entry for CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER
Date: Tue,  8 Apr 2025 12:48:47 +0200
Message-ID: <20250408104830.227434725@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e29efcb1c0402..9fc46db0a3da6 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -144,7 +144,6 @@ obj-$(CONFIG_USB_KBD)		+= usbhid/
 obj-$(CONFIG_I2C_HID_CORE)	+= i2c-hid/
 
 obj-$(CONFIG_INTEL_ISH_HID)	+= intel-ish-hid/
-obj-$(INTEL_ISH_FIRMWARE_DOWNLOADER)	+= intel-ish-hid/
 
 obj-$(CONFIG_AMD_SFH_HID)       += amd-sfh-hid/
 
-- 
2.39.5



