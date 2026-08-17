Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7513B811F;
	Mon, 17 Aug 2026 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975295; cv=none; b=MTAJx9F4SXYMSesCq+7h5ujO5YqiDkihi1rjWPNvh7JmEVhSvb32/a2HKje68SDxb8yd1WJ+AiEYuATKSI+oVekdDerZBQSIXixiMi2vy3YxAvfZPtWNNZEyTgcSPgELVNX9LKJmvk4a4Sgs3tEy3Ooe892kJ6tpgj0gKJz7EpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975295; c=relaxed/simple;
	bh=B0ysJh2kSBpN2wqsd09R1Qc2TP3bCJ2GswjDMqqYpcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGLR9/Io/8PKF788sdNXI/YU6wtCrUCXAwwbAttRC2LCTqKGZvPEimx3vVGgl/Nbgeflgec0RYEESvQeL/1ryIaeDSDEHKJTkcmOohYT32/P7dKS5s7y427N6DwKaWYJvb5pdHhwnfSW8GT16ZZMyhy1j6r7xEQoAMJTmv7yGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ax5d+bo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ax5d+bo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C04A1F00A3A;
	Mon, 17 Aug 2026 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975293;
	bh=FyQboKTkBjtoCM/Lf96i4x/kSrqiOT4eYzXUy7E7lEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ax5d+bo06JYGkWmY6IfoUecMqtlyYBYIb21enr3L8bFfLFP/E5mHYTCIjYMCiW5OD
	 ExG/tlMtTe+QcbECimfnXqy2HhRPE+byvKa1MyE/kTNFS7yfncQf9vnvVuU8g37v/k
	 j986ynhHUYf+nTQEm+FHYKj/DDNscTeFWlxfdq/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.18 228/250] Revert "thermal/drivers/hwmon: Cleanup coding style a bit"
Date: Mon, 17 Aug 2026 15:33:09 +0200
Message-ID: <20260817132545.826511098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit ff8da20b6f47c48d46e47f93f7a59e2d56ee9107 upstream.

Revert commit 030a48b0f6ce ("thermal/drivers/hwmon: Cleanup coding style
a bit") that introduced a use-after-free into the error path of
thermal_add_hwmon_sysfs() by removing a valid check from it.

Link: https://lore.kernel.org/linux-hwmon/20260803183915.4ED7D1F000E9@smtp.kernel.org/
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/5123895.31r3eYUQgx@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_hwmon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -212,7 +212,8 @@ int thermal_add_hwmon_sysfs(struct therm
 	if (new_hwmon_device)
 		hwmon_device_unregister(hwmon->device);
  free_mem:
-	kfree(hwmon);
+	if (new_hwmon_device)
+		kfree(hwmon);
 
 	return result;
 }


