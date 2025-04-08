Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61126E15F;
	Tue,  8 Apr 2025 12:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116177; cv=none; b=V1QumqJAjOkmp41si7eij+hHxbNopEJ6JSn7BPGfaY5EJaTRZVZIUjUUa+P4YDL8/X6a47eO3W+zHyRwc6vJWejL0U4dKnZox1aPhOJGnzaswLL8zqXTzJQx5d8VrXTfXa51LXN455BmlvVLui7fLwYLUax68E7HwD2xWzCO1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116177; c=relaxed/simple;
	bh=8/K527tOIoM8hXTJYpWkA9BUB2TYxwwfAU1fvIUyWNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaQe+aTBEfiaaYrFdieyXB7uSv6ZGrc6OFzNmmN4OmbcFqQxy8m8kvrIdDWxqV+5Wzyd8cFF0wq8BzELLsM6PxAdmRzjHOGZmRJ0ORKaXBONi8oIB0aSgqJj+J8pxiXafZc/H7i04a+8+IeCQzI7drSCrzys6h2Eq2LWef1eMw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpCZnrUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpCZnrUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C903C4CEE5;
	Tue,  8 Apr 2025 12:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116176;
	bh=8/K527tOIoM8hXTJYpWkA9BUB2TYxwwfAU1fvIUyWNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpCZnrUcB5tFRwZ1xavO/JZKW5Z99LuPd/ncYV6LQykolkqX3kE3ZW1cJCWYOK9Xp
	 BYJrC3lFIVoUuPfjkve3q+DtMQyvepSO/YNda2uIJr2sJn+NbzOjc9DiLExs376Gtp
	 e8w9PaevnPgGF7N2ObHPu8egJNVnDsGFNQ+zX73I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/423] HID: remove superfluous (and wrong) Makefile entry for CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER
Date: Tue,  8 Apr 2025 12:46:08 +0200
Message-ID: <20250408104846.729669332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 496dab54c73a8..f2900ee2ef858 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -165,7 +165,6 @@ obj-$(CONFIG_USB_KBD)		+= usbhid/
 obj-$(CONFIG_I2C_HID_CORE)	+= i2c-hid/
 
 obj-$(CONFIG_INTEL_ISH_HID)	+= intel-ish-hid/
-obj-$(INTEL_ISH_FIRMWARE_DOWNLOADER)	+= intel-ish-hid/
 
 obj-$(CONFIG_AMD_SFH_HID)       += amd-sfh-hid/
 
-- 
2.39.5



