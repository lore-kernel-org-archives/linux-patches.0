Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034537;
	b=PhYGhy3Q1tQfqd7ldUnxSdWpqJSxclQ5XApr/FSoxve/Kfb+Au1wd8MD6c35kNeOqVf+
	 3/xUN3Qqqvou7wKugxW/w2cRe44g7nli8GCKgS6wzxIYWLVRYg5rrIN/595fhyWlEVouc
	 H20n5nzHhw2+net62ZmK/rVdiDcIwsvYBghC5IyiKQzKh3ZiO6aSv45Df0u0OSf3DJV5O
	 l2iM28viR+mVlt0DNoDVXN6VSZPN0NoJjV7v0hEIpP6QGOEhnbsmRmxbCSnrHeDEjvPOL
	 hHy2ZVN4f0B6Zj3506qSMxQzAt+/mDS7oAuxwKW4qOslQnZx/LHqDAfEgrTTdU8WunA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bcPSHe13JFhJHt//3mWQQ6vgGbAFmMayJlwsTSK/J4o=;
	b=keHvJ5QbzeNTn4lhRWyfJti/PBAvy8S3lHLzRs42CYzJirlfpe5y+mLwnfMKepwq5Tne
	 0j+eTUOGJJ/lDTnt/8jr9t+quG4OoKpwtTWxEiwxA+gUysL7s1rs+HvWEmhtS3gEuu7+n
	 lFdaWKVIly6vb1a5tBsfvjZolyBfx71dZ2/quk8A7DPXZMpRr/JXIKxcGTQ8TVE9GwPN+
	 zwhBhJ48UnxUR/PprXCpSiCVRcYIhJhogC+jGuRYmKjV88Xpjf02MIhKx6/QZvzeEuWWW
	 IM2oFox9z4QrkGSU8Ut1/+2wvjbpp9BpG78PcrwvbDvtH55p8cybA+GNgO+Kt3H/L2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tBTg/hXl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00B260A2609;
	Wed, 18 Nov 2026 20:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBTg/hXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA10B1F000C5;
	Wed, 18 Nov 2026 20:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034537;
	bh=bcPSHe13JFhJHt//3mWQQ6vgGbAFmMayJlwsTSK/J4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBTg/hXlEYepfgeJXdJoBXnqkxOf5bisXVohhjTZgaSeha2L2EaJlIobYqamuFqRU
	 xWmqOn4V9wIeJf7N5wvG8s+wVRTk0shgZNdkzWbRU2Cyt2UzE8OoiDoZ8mhQ+QX1xO
	 FcsHto0Up9ow0tPPfdsfvPwb5g166acAAi9n72OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0405/3318] i3c: master: Fix potential UAF in i3c_device_uevent()
Date: Wed, 18 Nov 2026 15:17:07 +0100
Message-ID: <20261118150328.601736474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit e5e8dd2e959f470524c16ca444d001c90d6bb3ad ]

i3c_device_uevent() dereferences i3cdev->desc without holding the bus
normal-use lock.  Since the descriptor pointer can be replaced
concurrently, including when a uevent is generated from sysfs, this can
result in dereferencing a stale descriptor and lead to a use-after-free.

Use i3c_device_get_info() instead, which protects access to the
descriptor with the normal-use lock.

Commit 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling
i3c_device_get_info() to avoid deadlock") replaced the accessor with a
direct descriptor dereference because i3c_device_get_info() would
recursively acquire bus->lock during device registration.

This change depends on "i3c: master: Fix recursive locking during device
registration", which moves device registration out from under bus->lock
and removes the possibility of that deadlock.  Without that change,
restoring the i3c_device_get_info() call would reintroduce the deadlock.

Fixes: 6cf7b65f7029 ("i3c: Use i3cdev->desc->info instead of calling i3c_device_get_info() to avoid deadlock")
Cc: stable@vger.kernel.org # requires "i3c: master: Fix recursive locking during device registration"
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260807145638.168865-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 35d02234471b6..51fbff1e33890 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -280,8 +280,7 @@ static int i3c_device_uevent(const struct device *dev, struct kobj_uevent_env *e
 	struct i3c_device_info devinfo;
 	u16 manuf, part, ext;
 
-	if (i3cdev->desc)
-		devinfo = i3cdev->desc->info;
+	i3c_device_get_info(i3cdev, &devinfo);
 	manuf = I3C_PID_MANUF_ID(devinfo.pid);
 	part = I3C_PID_PART_ID(devinfo.pid);
 	ext = I3C_PID_EXTRA_INFO(devinfo.pid);
-- 
2.53.0



