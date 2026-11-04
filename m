Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829433;
	b=fo52JBTiB1yA75/Zl8F2019cgh0sgZeBPj/PZ+76LBza0CFGZy8EXHpdOq5HIPUd1gDy
	 gOnQKGm6D5WoBv3p9/O5UO3Brvtamdwwd2M92VGbVu/PP+pDDNDlubFOzvLRWbL0fPUBP
	 6Fzs1WylaKiRdR3qKE4gylcGCtAZB0C/RCLWWJtfhMpRDRCP6UlCJE50p3FP5lvOk2jza
	 VXDOF7FeUnKC5IPozRyCvq29Ao3Wuxd9dM8+oKGG+8akp75I3sTucqWQaK95++xiwjaiw
	 GAyFmZUkTn+VyPt7fR/cCRIs7rgggO5fgH3Cdvidmr1CuDnCLhZr4pwqi00vMaBU8MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=soTewUN3duw8sty0gjzWl0bGeAf8eazvpogYAY/Aj+w=;
	b=2YbORnR1xU4BUHIrPzZI+kza+EL8RWZfSM6KqOApdS0RPZ8jA40wPKT38lrXHYEedEig
	 r9z5FEpIwXNYSgVZhvwIgNehiItwOqW35bRBCGzxFb/nrAbZGya9EBAPyh0lpcwSBtVNy
	 fCaAECgU1ht+Yobh93Scz416lNX5GL70OJ5yXT14Vu+IxZjdf4WsbIKJvbk2x3R7RCIrF
	 Iww0T5mGkLR/xHM6He/Zb3JqhSfRJAADn8I2UKztnBF5jPpYRIsTs1IQFLWz2z+uyqRRP
	 QkX2XOo5Fr1xMsq+IefnsHfNhI3Od9Tt0wT+EiGjVhhelRzLit823BTyIr6oN/ZXQ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVZQQnnw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29351606AE06;
	Wed,  4 Nov 2026 21:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVZQQnnw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FDE1F000C1;
	Wed,  4 Nov 2026 21:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829433;
	bh=soTewUN3duw8sty0gjzWl0bGeAf8eazvpogYAY/Aj+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVZQQnnw1XTLfCyMIiyLNWyaPsZm4EYmezTh5l7F/8zUJkIAvAhGKnRFnt8MgWmn5
	 EswnRNznnk1TwsL+g3wDVpStsZnSRFt9YGwAwwBN9dV7O9ArMBfAV6kvKRruK1pl0F
	 WSg38EelQgIxfonAoZ64ZviCnX2bNGdfE8W2nhiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lew <christopher.lew@oss.qualcomm.com>,
	Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0122/1005] rpmsg: char: Check for ongoing chrdev destroy
Date: Wed,  4 Nov 2026 15:57:35 -0500
Message-ID: <20261104211047.088639795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



