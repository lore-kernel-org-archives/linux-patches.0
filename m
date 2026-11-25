Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618796;
	b=QH2rCYetK6SR+UJdLoCkZfIevcENekfmPjftm55yrpr7iS7d58QjQDhZYXyRMaQDYRRK
	 Eu61OYr94iyav4OShvsPNCssX6n/DoArve37BExltKETBKkOJ/qZfXNUHJ4F8sPlHE8ZQ
	 ygp5msxw4gyTVyJSsDkekL53Kk2xlWH96pTtE0wmsECjQeL6HkGbHi7Dd9wd9rTJuTtR1
	 Ia+AZj5dlJg6IvDHvs9B44bAdMQuVQR5Occ4ywkHVoao2RDDeG26itA/NmiWQG1Hd64aP
	 fqaQNbc+/BJjiCmKA5UgfhSZDV83kUwPLplbN0dHRMK3FuDQKFV04O9ZvqNnrktTBDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qgs2VK1RvIhHBmKnFL92gaevobCNMNLyO4Mf9SbOXMI=;
	b=Eeu2r5XV5psTjPbC4y5QPFwBUJcVH3PvxMA0qwRPaA2TTN2O0et2FNlQRv3oFAEwO4cI
	 sxclrdm++e7W7nyAUvMJxxPNjAF6PtNVMlk44B6nFjBSWNFlxqk8ygHoF7u3cVByzKJNc
	 aSwnDGlzKewAtXoxMf7sN996oDugZ0hBsf/i5Ds9zI+M6gL0++2K4cDbhgAoXYhuTQ6DC
	 fMPF2aurWZybAy8XuRgg9Cs44EtE+PJI6DZLS7IWlhCt1ErziP8pdoRlft6WeUXQVTg5Z
	 cY1fYAiA/9y52SmNaPGr+zZsIkWhYYHxF7wkYEYfIjMeP5ppONwP9VaaxA6FZAG0rKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUF3l0NL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43EF606A31E;
	Wed, 25 Nov 2026 14:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUF3l0NL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEF41F000C4;
	Wed, 25 Nov 2026 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618796;
	bh=Qgs2VK1RvIhHBmKnFL92gaevobCNMNLyO4Mf9SbOXMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUF3l0NL/YhnXn8ZL2dnPdpsFp2Mihg1ofFHwHfwTTpTpWmPYUG1y8/D78zy0/C/P
	 bzmFYK/wW8tZIxqdlqPbo+SeNXgu6TAv1LVGPlkiZ2R11V1pNi0d/A152K97Hr5i0L
	 4ktRWbTRhAbrWoNUtpFHKj1dxPzk9AkbrjHRR55A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0391/1005] drm/xe/hwmon: Handle unavailable memory controller sensors
Date: Wed, 25 Nov 2026 15:28:49 +0100
Message-ID: <20261125143830.903666092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit dbd199c775cbedbd1acaff96e1d7f4c398e558d9 ]

Skip memory controller sensors that report invalid readings when
computing the average temperature in get_mc_temp(). Return -ENXIO when
no valid sensor data is available, and allow the helper to be used as
an availability probe by making the output parameter optional.

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Fixes: 3a0cb885e111 ("drm/xe/hwmon: Expose memory controller temperature")
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20261015071434.1063785-6-karthik.poosa@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 99ceaebb888944d00932063a649ebb41bd8af1d2)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index 4b55a625affa2..b47c083e52b6c 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -868,8 +868,8 @@ static int mbx_temp_decode(u8 value)
 static int get_mc_temp(struct xe_hwmon *hwmon, long *val)
 {
 	struct xe_tile *root_tile = xe_device_get_root_tile(hwmon->xe);
+	int ret, i, count = 0;
 	s32 average = 0;
-	int ret, i;
 
 	guard(mutex)(&hwmon->hwmon_lock);
 
@@ -884,11 +884,23 @@ static int get_mc_temp(struct xe_hwmon *hwmon, long *val)
 		hwmon->temp.dword[i] = cpu_to_le32(data);
 	}
 
-	for (i = TEMP_INDEX_MCTRL; i < hwmon->temp.count - 1; i++)
+	for (i = TEMP_INDEX_MCTRL; i < hwmon->temp.count - 1; i++) {
+		if (!mbx_temp_valid(hwmon, hwmon->temp.value[i]))
+			continue;
 		average += mbx_temp_decode(hwmon->temp.value[i]);
+		count++;
+	}
+
+	if (!count) {
+		drm_dbg(&hwmon->xe->drm, "Memory controller temperature unavailable!\n");
+		return -ENXIO;
+	}
+
+	average /= count;
+
+	if (val)
+		*val = average * MILLIDEGREE_PER_DEGREE;
 
-	average /= (hwmon->temp.count - TEMP_INDEX_MCTRL - 1);
-	*val = average * MILLIDEGREE_PER_DEGREE;
 	return 0;
 }
 
-- 
2.53.0



