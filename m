Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74432135CD;
	Tue,  8 Apr 2025 11:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110447; cv=none; b=se0u6VpwXp7b0do47Y3rtEn4JYJ9CUbt3zKU7IU5hKpf00tooKSeRHyrMUP/16Ca1odgVUGvhDZOpMQDeHpz5iHiGb76BDbnxiTy6oLcURA5vOOY4aGLDuGo7PSoIanO4A+uMW1jqUJHOLvF9Yv94xxDn4s3luUSLyTeIImYetc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110447; c=relaxed/simple;
	bh=xzSFVnHu0lX2uHYNvYnVC23U7T5KZkCH/2gN7mllse8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHxjceMCMe278pD5v3Wa70kBYs71QkYyNrvgvr+guSJJomntKMCP9H2ExnsCmOZ4OVAWe5l5NAwq4aS8sAjPMTlrew7gjuvzdJfOBjvshI71paFZhj7Y9R+C4y7SPMCsClmnsP4qVoSEhv/6ngjnX29KD0IQBpsEx23A90LTexI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCo+B/GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCo+B/GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD2EC4CEE5;
	Tue,  8 Apr 2025 11:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110447;
	bh=xzSFVnHu0lX2uHYNvYnVC23U7T5KZkCH/2gN7mllse8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCo+B/GPSJK2kG9lBSlOfsKQAqm1oiF9gBHYRInzE/d0HHu284Uftl32aSD9RFYZM
	 +WzD9lUjM4aTyLcioWI/LAqx8FHBko16JU4+zYNqf3ndPUoBYmKDrFfJQNyJrtM7p0
	 qkgoJDqNQYFcTdUA7e3ysA3CU+bJvxzajqCnScvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 067/731] HID: remove superfluous (and wrong) Makefile entry for CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER
Date: Tue,  8 Apr 2025 12:39:24 +0200
Message-ID: <20250408104915.830929451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 482b096eea280..0abfe51704a0b 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -166,7 +166,6 @@ obj-$(CONFIG_USB_KBD)		+= usbhid/
 obj-$(CONFIG_I2C_HID_CORE)	+= i2c-hid/
 
 obj-$(CONFIG_INTEL_ISH_HID)	+= intel-ish-hid/
-obj-$(INTEL_ISH_FIRMWARE_DOWNLOADER)	+= intel-ish-hid/
 
 obj-$(CONFIG_AMD_SFH_HID)       += amd-sfh-hid/
 
-- 
2.39.5



