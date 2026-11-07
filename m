Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060666;
	b=tFTQVeeYHU2xWcgoe6vZf+NoE2a2WFPBh5JPiUwtNQzGbTofDnDgKeyQjFUD4Md29enc
	 wxttha2rhbQ/PaQJkVJ8/VkPrGSjpoyb4qiPqOXUFFTD2WFKcgcTTmBo9fnoFIPp7k68w
	 lzpnPWrjWdTHH6SIAjTKFAu1YVrITsWQmxI++pKUPpo9C4p6UvGex4EhmJoNa4Yr+3V2k
	 U8CgmskLAms1HMYiMq20bgzfjc5yjKOwaiZDWsY5A+TyGZ3TcHtNHb2rO8VCFH3CNY1SQ
	 7huOXEgaqimVh9JBgQDafTdI/kjfHrLu3EOpWV9gjC/OpSBMU7U3Ar4ZclJdofff12A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ojj3vFJApv7aDOmjJdkjihm9x6pVXkDbFXwD+zOwi4=;
	b=nDExK99hDEVMB8YAUZxBQudjUHA4agL6sdGEtPAeFJ3cQUJuyIsycqqAhDG8O5fSkYfE
	 fOafJvHbi9zQw35+XOFjMQIim2cCrypL7yujfiXXEhlc5FaKE10DYpEnku9JLnczAIy0L
	 Znb22XZg3GJiZ9FYyXyke0G0WDg1R9mdEnnGP/Ye1hhGIhMsu9zA6DFPU5DIgMhL2ghM+
	 jYgSoCTjEKS2LTHCs9l5otlqqRnBBgNSFKXmBFXty9ylMzaT00BWObNlQQDM54H6YCbu3
	 rkMY8D139yaPtyvE13phvRByLLnLj0DMvIQAi+PUtzWbrG/bkBak1Ep2zlQd/IA8gyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VScoSIaP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94134606A326;
	Sat,  7 Nov 2026 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VScoSIaP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7251F0089F;
	Sat,  7 Nov 2026 14:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060666;
	bh=3ojj3vFJApv7aDOmjJdkjihm9x6pVXkDbFXwD+zOwi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VScoSIaPKe+++BZ77KUT+io90OjDBiTUQnYgbS59Me33cytmfL+L072OLmi77kvid
	 0VwS5+sbj9kBDqwj9FuRBi2RYZaDBOyfx+VPyYRhhpFJlo8Cx/W26aRS4ByKV7pYZq
	 JqvtXp8cZ+VHF66dz6M74tbP3qNUY/gD0eZb6w7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0103/1536] rpmsg: char: Check for ongoing chrdev destroy
Date: Sat,  7 Nov 2026 08:35:19 -0500
Message-ID: <20261107135000.564435453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d918cb30db9b0..3edc95f48967b 100644
--- a/drivers/rpmsg/rpmsg_char.c
+++ b/drivers/rpmsg/rpmsg_char.c
@@ -79,6 +79,11 @@ int rpmsg_chrdev_eptdev_destroy(struct device *dev, void *data)
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



