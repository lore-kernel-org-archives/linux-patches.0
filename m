Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5A54322E5;
	Mon, 17 Aug 2026 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978331; cv=none; b=WGK4mo0gMxHhKGU+g/Zyvt/UqgbjGr4qcUp3L1i2ZRnShlzRcgbIPszfHeSSmwbhquJJQx9pPSADVOVtGPFrx59/jNdxUX6B+J8FvtyOcIklaz/8wmNLU6/P20cfPf5qQ7rrGrpGB4i2nu/KwDFpSCeMCLokPIM0+1D/uEeutSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978331; c=relaxed/simple;
	bh=AGG+yoUnV9zqMJOYXH/+C4Fzabltc4kLukbT1LxWcCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrS2SPOLPg/i5tQHMKJL+Fcn6WJnTJ5eznCzD7yGBQvWXY+YrxUlu5OzqaJbs5Gs/MEKQki54uvCdqq+0vQ5zhcT0eLMS6t+Y8TsFoDmsUABocvMeU/ivYGv5FZrj6g+7clcIHXSiERLhuXBAd8PD4ojESRudiUEjXK3zn/HMDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK6VdGvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK6VdGvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DC71F000E9;
	Mon, 17 Aug 2026 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978330;
	bh=Tfe9a4QuM9zqc54jXUzQ9F7o/0XG6E7RYbrKqcgwry0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK6VdGvvzC4IY4NpC9Dtr5nNwTAdOUoIzbKcIkTEil0MNI+QaV4SI/eCjJbcJkwmG
	 QSzCGFDGUg7pPVDByedtJZqU1JZgLmExaLNbHAXVtbhrNKCtIUKf+7nTA5OA9LKWgZ
	 AVhQXHZQQZmfYwJDZKOjybATHcMxlmxGu9nd3qbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.12 164/181] Revert "thermal/drivers/hwmon: Cleanup coding style a bit"
Date: Mon, 17 Aug 2026 15:34:18 +0200
Message-ID: <20260817132542.137690531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -215,7 +215,8 @@ int thermal_add_hwmon_sysfs(struct therm
 	if (new_hwmon_device)
 		hwmon_device_unregister(hwmon->device);
  free_mem:
-	kfree(hwmon);
+	if (new_hwmon_device)
+		kfree(hwmon);
 
 	return result;
 }


