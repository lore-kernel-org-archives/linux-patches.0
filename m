Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F80F261571;
	Thu, 17 Apr 2025 18:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914361; cv=none; b=jELhQlSLbsq2zJoIVUMSXFlHw9U0EJYoj0a9j8larIpbVRrL1ZIr/A03lD8DwK73IjJSFzgC8IAfEV7x+lQfFaTNzWHZU/CSnE0+2xgH3k/UEjqdzqdu0Xv71r9lYFk4rp+2/ImKUCjAzQGPu3Aj5s3fr+P/i9GHHQNpA5pRWVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914361; c=relaxed/simple;
	bh=PuydFdE/D+rzPU4ZVD56rj4TsJLACIwSk7o9nXtl9Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iIjj10Yv06j2kpYh8PfMdzcJJjcWg/6r7pVuEOzvPMIK49OVXJ/GD0BJ9OIXGMHpeYEjPpuIu99eWgUvVoF415TT2GRGkbpLCSWFg9QeqS66A98w+kFgft6/Ea4cTRizN/FPg4+HQhYrCrg99x8ap+zEMWd1Muuw4Jn2chQAEOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZC31cRdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZC31cRdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FCFC4CEE7;
	Thu, 17 Apr 2025 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914361;
	bh=PuydFdE/D+rzPU4ZVD56rj4TsJLACIwSk7o9nXtl9Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZC31cRdkf2flMfpqig2Wg1aygr+tEQLNtJIWq+5F1H0GvBRM6fWNoAckNW8zWaFem
	 nxexRwVeQxBr6ll2W5t7WA8HtWPR011vnundDpAXMwYraYXP8hSGJ9KMZUH9CFQGtG
	 YCm922m9MjOjxBkdBIoeED8tWnGksAfjZNccumQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 190/414] HID: pidff: Rename two functions to align them with naming convention
Date: Thu, 17 Apr 2025 19:49:08 +0200
Message-ID: <20250417175119.084018538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



