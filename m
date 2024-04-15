Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE778B49;
	Mon, 15 Apr 2024 14:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191307; cv=none; b=CpR/trMPKAT8xxD4ADoRfmVZ1sZjqIxMQIAFEiX6/rVzbILjFdDqpYS9TlybGYzETANeKrK/BRwarwRdY36EtBFk2RQ6eTTynOAm2pYwN8ncwrE4mEh5ijY1FJ6h+8P2C2De1DbAdY+8GXyqtPioDrJf/g/Yg+lhCThz4h1p8D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191307; c=relaxed/simple;
	bh=PMvhYYt3sjLDVf8dGm2FkF9/tkQxOx3w8lJ0QE/Kv+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnUJBuwajKyNa+iYxlbBtt14LqjvUn+rbOy1ow3uqFxCQphDau7uVyxhigLwFS8K5EVwAMaCl1r3FuQq0NWzv7xUM27N1MKbCj8j39eAIgmCNWMO00VmqazQCzMjVG03yK2OgAkLVgyBcttx7Z3SMjxs+Bgk1eDVFH896t5NNvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3hQQGzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3hQQGzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FACDC2BD10;
	Mon, 15 Apr 2024 14:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191307;
	bh=PMvhYYt3sjLDVf8dGm2FkF9/tkQxOx3w8lJ0QE/Kv+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3hQQGzCyWuX2DzSVdELsrRC79pak+GURExhuDpB2N4Rqk5HUqd+I0aKEydSGGk9c
	 WI1/U8ibXfM7W8YuRMEt/lYXSTdzBRLPQnXBqRNQhXDLJMOwX5+5hVFDmvo9J9vfjz
	 G9EKqdR61H88JT+9lmO2Uy9eF0pbt6GievvJHU7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 101/172] drm/xe/hwmon: Cast result to output precision on left shift of operand
Date: Mon, 15 Apr 2024 16:20:00 +0200
Message-ID: <20240415142003.464933951@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit a8ad8715472bb8f6a2ea8b4072a28151eb9f4f24 ]

Address potential overflow in result of left shift of a
lower precision (u32) operand before assignment to higher
precision (u64) variable.

v2:
 - Update commit message. (Himal)

Fixes: 4446fcf220ce ("drm/xe/hwmon: Expose power1_max_interval")
Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240405130127.1392426-5-karthik.poosa@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 883232b47b81108b0252197c747f396ecd51455a)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index 174ed2185481e..a6f43446c779a 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -288,7 +288,7 @@ xe_hwmon_power1_max_interval_show(struct device *dev, struct device_attribute *a
 	 * As y can be < 2, we compute tau4 = (4 | x) << y
 	 * and then add 2 when doing the final right shift to account for units
 	 */
-	tau4 = ((1 << x_w) | x) << y;
+	tau4 = (u64)((1 << x_w) | x) << y;
 
 	/* val in hwmon interface units (millisec) */
 	out = mul_u64_u32_shr(tau4, SF_TIME, hwmon->scl_shift_time + x_w);
@@ -328,7 +328,7 @@ xe_hwmon_power1_max_interval_store(struct device *dev, struct device_attribute *
 	r = FIELD_PREP(PKG_MAX_WIN, PKG_MAX_WIN_DEFAULT);
 	x = REG_FIELD_GET(PKG_MAX_WIN_X, r);
 	y = REG_FIELD_GET(PKG_MAX_WIN_Y, r);
-	tau4 = ((1 << x_w) | x) << y;
+	tau4 = (u64)((1 << x_w) | x) << y;
 	max_win = mul_u64_u32_shr(tau4, SF_TIME, hwmon->scl_shift_time + x_w);
 
 	if (val > max_win)
-- 
2.43.0



