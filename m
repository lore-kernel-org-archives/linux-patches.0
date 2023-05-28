Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F8B569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB8C433EF;
	Sun, 28 May 2023 19:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302203;
	bh=e1ibWDqXencHGGF+R5BOTNT8333GZrGkmCoDaZkYzgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmwN55HT/gX7PshTaUYWPtY2ZaetgxT5gFNN4zH6c86DGM3u0J3QH7psoyiVa8JR8
	 1gPel5/OBQ19IJ6O2lTtbIaf3MiAp8VFKDhuF4QH5L3Hx0kW9JG7t69Wcl7C3ddZ0i
	 FYCG4nWCWryrkVwrXdsZjl5P2JJ5/3H1h3hQGDfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.3 041/127] thermal: intel: int340x: Add new line for UUID display
Date: Sun, 28 May 2023 20:10:17 +0100
Message-Id: <20230528190837.677878816@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 5f7fdb0f255756b594cc45c2c08b0140bc4a1761 upstream.

Prior to the commit "763bd29fd3d1 ("thermal: int340x_thermal: Use
sysfs_emit_at() instead of scnprintf()", there was a new line after each
UUID string.

With the newline removed, existing user space like "thermald" fails to
compare each supported UUID as it is using getline() to read UUID and
apply correct thermal table.

To avoid breaking existing user space, add newline after each UUID string.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 763bd29fd3d1 ("thermal: int340x_thermal: Use sysfs_emit_at() instead of scnprintf()")
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
index 810231b59dcd..5e1164226ada 100644
--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -131,7 +131,7 @@ static ssize_t available_uuids_show(struct device *dev,
 
 	for (i = 0; i < INT3400_THERMAL_MAXIMUM_UUID; i++) {
 		if (priv->uuid_bitmap & (1 << i))
-			length += sysfs_emit_at(buf, length, int3400_thermal_uuids[i]);
+			length += sysfs_emit_at(buf, length, "%s\n", int3400_thermal_uuids[i]);
 	}
 
 	return length;
@@ -149,7 +149,7 @@ static ssize_t current_uuid_show(struct device *dev,
 
 	for (i = 0; i <= INT3400_THERMAL_CRITICAL; i++) {
 		if (priv->os_uuid_mask & BIT(i))
-			length += sysfs_emit_at(buf, length, int3400_thermal_uuids[i]);
+			length += sysfs_emit_at(buf, length, "%s\n", int3400_thermal_uuids[i]);
 	}
 
 	if (length)
-- 
2.40.1



