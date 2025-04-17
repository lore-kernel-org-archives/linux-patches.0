Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B17255E4C;
	Thu, 17 Apr 2025 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913052; cv=none; b=YGThugMAvkSwD1h/SU22ROB751zrmFNTXR9Kcbs4XnHQLQdcAVKcKSs3/RRBWBGG5jg/qcxtPVvNgWAs95mARqYh72MeKAlNumUzrD2tOmAX5qgNFfu2psTx+OjGCQ/WJerAXJTgzGi/6d91639bjtUPl/2VmkAvTafOUFJ6ULM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913052; c=relaxed/simple;
	bh=7Y6R9bSlDbjAy33+EBEiPSpajgZrGV58WjvhE1JZVsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tP+Owjy+Hxm7Ts5FKe/8MrlvMcOG9ymXyEi251BqrpGyn/r2UocNIO1m+d1yMOFKL1FIbTWfOu2Q9D6E6N+m24jFEDHxtAAmrVDsMOKjFGg/K1Meb7KjA94qJbkpv5QLrWcfZnjvIZXP+5R5p9N2iC41vsd1augTBgEI2J9DWtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGgb+NVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGgb+NVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42848C4CEE4;
	Thu, 17 Apr 2025 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913052;
	bh=7Y6R9bSlDbjAy33+EBEiPSpajgZrGV58WjvhE1JZVsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGgb+NVCUfLOsYvrijTkBBdknFhEH2W2soDMiq2pJsCdbNKvzoprJs3pYFpTDLY4P
	 +/VFrMxo75gKOg8yZgGNhwdAUuI60po7lz4/7ESP9QhKtcLEEXX8fjFiDQSwKpiP47
	 SW0IjhLGI/Ld4H77neU8UXIB6M+oX6yluReZL+Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 212/449] HID: pidff: Rename two functions to align them with naming convention
Date: Thu, 17 Apr 2025 19:48:20 +0200
Message-ID: <20250417175126.511540756@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit bbeface1051142bcb0473fdcc89102ea5b31607d ]

Driver uses "set" everywhere to indicate setting report values and
requesting HID_REQ_SET_REPORT

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 6f6c47bd57eaa..ffecc712be003 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -552,7 +552,7 @@ static void pidff_set_gain_report(struct pidff_device *pidff, u16 gain)
 /*
  * Clear device control report
  */
-static void pidff_send_device_control(struct pidff_device *pidff, int field)
+static void pidff_set_device_control(struct pidff_device *pidff, int field)
 {
 	int i, tmp;
 	int field_index = pidff->control_id[field];
@@ -578,10 +578,10 @@ static void pidff_send_device_control(struct pidff_device *pidff, int field)
 /*
  * Modify actuators state
  */
-static void pidff_modify_actuators_state(struct pidff_device *pidff, bool enable)
+static void pidff_set_actuators(struct pidff_device *pidff, bool enable)
 {
 	hid_dbg(pidff->hid, "%s actuators\n", enable ? "Enable" : "Disable");
-	pidff_send_device_control(pidff,
+	pidff_set_device_control(pidff,
 		enable ? PID_ENABLE_ACTUATORS : PID_DISABLE_ACTUATORS);
 }
 
@@ -591,12 +591,12 @@ static void pidff_modify_actuators_state(struct pidff_device *pidff, bool enable
 static void pidff_reset(struct pidff_device *pidff)
 {
 	/* We reset twice as sometimes hid_wait_io isn't waiting long enough */
-	pidff_send_device_control(pidff, PID_RESET);
-	pidff_send_device_control(pidff, PID_RESET);
+	pidff_set_device_control(pidff, PID_RESET);
+	pidff_set_device_control(pidff, PID_RESET);
 	pidff->effect_count = 0;
 
-	pidff_send_device_control(pidff, PID_STOP_ALL_EFFECTS);
-	pidff_modify_actuators_state(pidff, 1);
+	pidff_set_device_control(pidff, PID_STOP_ALL_EFFECTS);
+	pidff_set_actuators(pidff, 1);
 }
 
 /*
-- 
2.39.5



