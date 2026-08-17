Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C723E9580;
	Mon, 17 Aug 2026 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977777; cv=none; b=cVvEjI5dZbzPmZBmLs8RCOKVMcH4z1bYXcjCQTrkD55SQ4m1zsT/y7MN96OHai19XK2FlSAPgChvi+N/eiTYOWFjWvX9+SwEYaJKcqGCXPKDs4zbL/xvD08NnkRFw/Po4Kzupc0vPBJQZOBhTMwHj7c/2GeY97u3YixlCKon8T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977777; c=relaxed/simple;
	bh=+1mWwrr3wUCNuRx4alLjr7KU4gznCbTPNipKrjtpnwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdjlHxFITtcZDEB+T9X14AJS5tZgVXWRirLQlWJsh0oGwAoTAPaKo8A5F0Ymd+fqykKIRWVGZwenDh00r9AKuMpH2tw2jvP/9gQXL6oYOWgH+E6iKViqPP86UvR59xOiRc0luc/mQE4yc7VQuI0SD8WdYW25qz5T+Dps/Dj1m4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCxqTQwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCxqTQwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BF41F00A3A;
	Mon, 17 Aug 2026 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977776;
	bh=2/VM+cb4VgwTRAwdmSIZ0SbxbvO4uMkZpcdqyGaa+VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCxqTQwvdoGvNR/FOjrgzMk3VSuSU1Qvn8kPyXyqIUKwyy8ZuTE0a/CllXCFsslqI
	 CYvYkxtMKcVc/da0s9kiM3Df9iX/0qmGlCK9eMP0l4cQWqsKrpZW5m6e6ocQIXdUe9
	 1egMZepOTp2vsicMA5xRQaCRC3zxXpSb5+33i11s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 5.15 447/456] Revert "thermal/drivers/hwmon: Cleanup coding style a bit"
Date: Mon, 17 Aug 2026 15:33:57 +0200
Message-ID: <20260817132556.538225603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -209,7 +209,8 @@ int thermal_add_hwmon_sysfs(struct therm
 	if (new_hwmon_device)
 		hwmon_device_unregister(hwmon->device);
  free_mem:
-	kfree(hwmon);
+	if (new_hwmon_device)
+		kfree(hwmon);
 
 	return result;
 }


