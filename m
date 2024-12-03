Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816CD204F63;
	Tue,  3 Dec 2024 15:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240589; cv=none; b=r4tzfZFfuYy5Z4kD0y2BfWtfiOA+mYoQgZgWlnwzCkHy54lex7HQ1mULOy/dzJAjH3hOWZEu0VfImVPWrnJL15I5TdgqlN3xrsXmJRmAswkvW/u6rJzeDcF5l0PgBO6nMpYx88uyCT3SrQFbLGnel5AbqgQK10jKbEtBoaTFV8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240589; c=relaxed/simple;
	bh=sQStcBw1M9JFkJ5OQIX3kT77GaVhZZPDFpazxn2DaZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gsfbtkb1Ie/y6SBwNVZACAxK3mLxGOeYGV6HAIUmy0X3J4QsdEk0lT3bpK+68bB7zlGw7hi34Tz6V5Xa4vwpMkjQalsjEg1VR64GchGXuXomkHKkUNQOjyTEgTb/feL8Y5nS/5cs16tfqLaySQHwHuDeurQYZ0T9tXO6KOQGVys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6oeg+ym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6oeg+ym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF50C4CECF;
	Tue,  3 Dec 2024 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240589;
	bh=sQStcBw1M9JFkJ5OQIX3kT77GaVhZZPDFpazxn2DaZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6oeg+ymFjQsgupnCcDQMdcN/Go0m3DkA7BNMV3mpi3vNxSAHJBDYl6hCc537a5bo
	 kAi8vCwM+oE/p/LgSZsRs5fLuXtD1uWLBIizyVL0uLltyU0+0eYpMWL3PtbdfSxlPK
	 wy8AjzGwV5taZQkS/7WblFsTi3IVGsNM/mHDdcpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/826] platform/x86: panasonic-laptop: Return errno correctly in show callback
Date: Tue,  3 Dec 2024 15:38:27 +0100
Message-ID: <20241203144750.757720494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 5c7bebc1a3f0661db558d60e14dde27fc216d9dc ]

When an error occurs in sysfs show callback, we should return the errno
directly instead of formatting it as the result, which produces
meaningless output and doesn't inform the userspace of the error.

Fixes: 468f96bfa3a0 ("platform/x86: panasonic-laptop: Add support for battery charging threshold (eco mode)")
Fixes: d5a81d8e864b ("platform/x86: panasonic-laptop: Add support for optical driver power in Y and W series")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241118064637.61832-3-ziyao@disroot.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 2bf94d0ab3243..22ca70eb82271 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -614,8 +614,7 @@ static ssize_t eco_mode_show(struct device *dev, struct device_attribute *attr,
 		result = 1;
 		break;
 	default:
-		result = -EIO;
-		break;
+		return -EIO;
 	}
 	return sysfs_emit(buf, "%u\n", result);
 }
@@ -761,7 +760,12 @@ static ssize_t current_brightness_store(struct device *dev, struct device_attrib
 static ssize_t cdpower_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
-	return sysfs_emit(buf, "%d\n", get_optd_power_state());
+	int state = get_optd_power_state();
+
+	if (state < 0)
+		return state;
+
+	return sysfs_emit(buf, "%d\n", state);
 }
 
 static ssize_t cdpower_store(struct device *dev, struct device_attribute *attr,
-- 
2.43.0



