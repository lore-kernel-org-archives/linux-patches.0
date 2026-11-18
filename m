Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043038;
	b=v+u7HEI0JeJQ0JFAXr7s1NFbZFs1pZE/wjaZk1lTVN4EtLLat2xQ99oOlG7f+IYAfjNS
	 SIKr+h2xgoqI50RYYGxkeAwzoIEvuCwKbZe1DzDg3bl9jcStgehhxtfiLNzrytTzIak8X
	 kgeCp9EGugvgpuq9lw2thaOf8DdPbDGUB5/6bLn+LpTJjgEzE5laXdB7wku4JzMTsCTZY
	 y07PGho3YPT+9fdjXZ+am7wF02omHBLAjjx93Mq0pbzDm15KMgUQC0VWJwQZ6bUDy+43n
	 jOqgyKfAL78MSPELHhzMxlFGg+GXeANfrIKhpjM3T3jGyAbNE2/Y/Y9sA1xUdm+XdKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hzmYEuEd0uozUDimAAE5ObO8RLtYhiE9lTH+AJ7/e2Q=;
	b=IKog6hwlhru7KpBFrunG5yGKN5OY2tww0Mh6qT9//UVC4QeOYFCGdWKO8GxLrXf3ef+c
	 shbLcBshASreKHapkpnHntuFK2oZ1iL812i3fsbfeFMGpY88iPApLQIJvV87Cnqktwg8o
	 prCRBqiCyflCQslBou38S3E0qLrk45pUsTkLqtFojMCKPpUYRgigICkBifhaBjmsMCe9j
	 jJrbNGLDCUWa1sZdGbZWF+4xRSYM/2smpHlTz9VY2STq7PpXgp1844+ExYdVSQzY6zw+a
	 1VuLdzK0z4nhIb6wRENFDu9RluD0uZM4mRlm9Puf1LTG9s0FPNx6roX1YGsAu3J3/Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6c5rP3I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD23560A262E;
	Wed, 18 Nov 2026 23:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m6c5rP3I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF4B1F000C8;
	Wed, 18 Nov 2026 23:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043038;
	bh=hzmYEuEd0uozUDimAAE5ObO8RLtYhiE9lTH+AJ7/e2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6c5rP3IM45XSfco9ESDzVGUgZywaYAiY6g/SrRNP3gXn8N8sRJog+1Z3cG0NKTJp
	 Dtt2YHRkO5SIhuCzfOJTfuQqiprRXWxyRt7zDSVEVX+wlz0Qps1x0D6pEAJdGUweTc
	 L8K0Nugb1wEvrGEzVD2jtpefDsPCpPd0VXisvcj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0069/2857] rpmsg: char: Check for ongoing chrdev destroy
Date: Wed, 18 Nov 2026 15:18:23 +0100
Message-ID: <20261118150203.804928517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lew <christopher.lew@oss.qualcomm.com>

[ Upstream commit 1f9c2897afb0fe86c1fdf4f5e23c5fb8f7442f6d ]

A null pointer panic is observed when stopping a remoteproc and closing
a character device using the RPMSG_DESTROY_EPT_IOCTL. There is a race
where each context calls rpmsg_chrdev_eptdev_destroy(). The thread that
runs second will call cdev_device_del() for a second time, which fails
because the first call already removed the device from sysfs. Add a
check at the beginning of destroy and exit early if the destroy call
has already been done.

[ 26.654130] Call trace
[ 26.656658] kernfs_find_and_get_ns+0x28/0x8
[ 26.661140] sysfs_unmerge_group+0x2c/0x7
[ 26.665357] dpm_sysfs_remove+0x38/0x8
[ 26.669305] device_del+0xa4/0x3e
[ 26.672811] cdev_device_del+0x28/0x7
[ 26.676675] rpmsg_chrdev_eptdev_destroy+0x68/0x98
[ 26.682765] rpmsg_eptdev_ioctl+0x130/0x11c8
[ 26.688318] __arm64_sys_ioctl+0xb4/0x10
[ 26.692448] invoke_syscall+0x50/0x12
[ 26.696312] el0_svc_common.constprop.0+0xc8/0xf
[ 26.701151] do_el0_svc+0x24/0x3
[ 26.704570] el0_svc+0x40/0x17
[ 26.707810] el0t_64_sync_handler+0x120/0x13
[ 26.712288] el0t_64_sync+0x1a0/0x1a

Signed-off-by: Chris Lew <christopher.lew@oss.qualcomm.com>
Signed-off-by: Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260406-rpmsg-char-fix-chrdev-destroy-race-v1-1-7317434fa246@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/rpmsg_char.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/rpmsg/rpmsg_char.c b/drivers/rpmsg/rpmsg_char.c
index c02949adf563d..74f13f181a749 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -75,6 +75,11 @@ int rpmsg_chrdev_eptdev_destroy(struct device *dev, void *data)
 	struct rpmsg_eptdev *eptdev = dev_to_eptdev(dev);
 
 	mutex_lock(&eptdev->ept_lock);
+	if (!eptdev->rpdev) {
+		mutex_unlock(&eptdev->ept_lock);
+		return 0;
+	}
+
 	eptdev->rpdev = NULL;
 	if (eptdev->ept) {
 		/* The default endpoint is released by the rpmsg core */
-- 
2.53.0



