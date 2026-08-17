Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6477B3DB980;
	Mon, 17 Aug 2026 13:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974566; cv=none; b=eFaBS47XCkIFUwSPeS+YQHOg42ek3wESy6G6XqgDp88wPzmawJ6RlfsuyS5hXuLCNAsKY8w4K1DvtcEYXHpIMb5XBCAV4+QgE/EWmOFYTZpxFTQRnDG2l+vmlmcps/cAxcBvhLHFKk/nm90SCh9Bkng6vrG7gK5CgN9cwaZXd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974566; c=relaxed/simple;
	bh=7snlBspQ0K4pmQcunCZoTYqVX3CVUyvF8/AYpCzklBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/UiR6d7tVaHCNrOHgfifqlQTZeCMRrBNGOMUeCI7DpzIchPqkf1aivs2N+fPDwl1yz5IYKbrovKJ5YgURMlrAPjRaPnMwj6vXL1B073xlSGqCyJE6SP0H5fh7SVu1DMNJxqv9NmkSlRlTyrDgE4khBjrsUIp82pGnskxz/4jPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2NNvV+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2NNvV+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645401F000E9;
	Mon, 17 Aug 2026 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974563;
	bh=cbIbu1S10m5cvtL4r/duJoXYAl+rkc4uxC9qUqvZUyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2NNvV+30tHlFD5+JVF6LIn8M3wSJnBre+QYRwCsFW+s6F36ETjNUOPCDU1md8gYa
	 6XLkylGQ7x6blpZYUIbx7yPyq5CV5UynReljbXMgiInLzNANqD2slOSj7F24E+BLi1
	 OiYfBiK6++nvzGj6XjICqxFXeIjYM/vwwyrnunR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 7.1 247/271] Revert "thermal/drivers/hwmon: Cleanup coding style a bit"
Date: Mon, 17 Aug 2026 15:32:52 +0200
Message-ID: <20260817132546.910006764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -157,7 +157,8 @@ int thermal_add_hwmon_sysfs(struct therm
  unregister_name:
 	hwmon_device_unregister(hwmon->device);
  free_mem:
-	kfree(hwmon);
+	if (new_hwmon_device)
+		kfree(hwmon);
 
 	return result;
 }


