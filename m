Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064376;
	b=RMcbMBSqed9dhFIdFzDvavz4WSRXDANLKdRL8qTbXkqO+qz3C6Poc9DuMEvmnd8+kG2W
	 POcz79IJZ7dIx6zt7IbIDUy1YkwQMEISFsBvkLmS2KGgMyASccrn3f6r5yPbmDBtqHK7+
	 wnc3AaxJVJvSk1tkb7G8k8T7nCXzqN1PD4kc+a+6JixjG4R7jmsdAosr9qLB5ZohMGp7/
	 V0jmX9rSfy8Dugx5Ljk386HjoNb3yanoN3IUwNEJLLN3figdlt5OyzUdqllVYlrNRupfK
	 Jc/E0SMG1ZDiDLMUPP1IJ7nJzeasggHa2T4V4Hq2uraD8/YtXWmyohsg/ush4p40ttA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Erchc0b0Mdd0v92ZeFdVc8MdZSekN3byev8AGFuyF98=;
	b=nOg38SVMmZcL3CFUZkejfI2CukIU1wwWDvK3yGqAH+ognXhRN0P0/jU6fVhIVUY7QJqz
	 66OwidYKCicVwU6VvkS0MQQyYTHGFqRaEZUsDd8p2WQcvHVroFUmsbNIrtg6sECT/ubSy
	 YdT+Us+R5ZEFqVsioKlZ4tTDIw6jwB+sfVPwY6O7um+tF89ZpV+UOguNa8Kl5rR4MCV05
	 YnfzHjdO6hosWZxlwpjNv7ZRq2n2Wx1dASAP3DB+u3cC2QlKjjjlkxNn2ZiD7IxjtPjpY
	 op0HkBzvUZA25Nh0G1kSl1cB1EDtHD85LAGD+yWVj6AlK9j0036AoyWw7lRo2wLC2xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxAdC8gC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F306083610;
	Sat,  7 Nov 2026 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxAdC8gC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F021F008AB;
	Sat,  7 Nov 2026 15:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064376;
	bh=Erchc0b0Mdd0v92ZeFdVc8MdZSekN3byev8AGFuyF98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxAdC8gCZKEb8clkd2zbQOIcgrLzYMvPkXWAVArkVELTWAIcQX1nQ7ldeI6B9+3oP
	 cmTMCEQj362HDJTt1ya8HQTVK0l6okrsipAZkAgZbuZY0mFkZNgylXJ2OOIfSYmB92
	 NX18U7og1O4hURM592H3hHip6O73rh/v+VaYnq50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0454/1257] media: amphion: prevent unbind while video instances are open
Date: Sat,  7 Nov 2026 08:45:50 -0500
Message-ID: <20261107134952.014904467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 96ea6bc6835f1b18b75303d536a7f9a3829c9bc1 ]

An open video instance holds a plain pointer to its devm-allocated core.
Unbinding the core or its parent through sysfs can release that memory
while the instance remains open. A later ioctl or close then uses the
stale pointer.

The video file operations pin the module, but sysfs unbind bypasses that
protection. Suppress manual bind and unbind for both platform drivers,
and warn if core removal ever encounters a live instance.

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 3 +++
 drivers/media/platform/amphion/vpu_drv.c  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index a0c58ec97a424..2e8e08e05de7c 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -696,6 +696,8 @@ static void vpu_core_remove(struct platform_device *pdev)
 	struct vpu_core *core = platform_get_drvdata(pdev);
 	int ret;
 
+	WARN_ON(!list_empty(&core->instances));
+
 	vpu_core_remove_dbgfs_file(core);
 	ret = pm_runtime_resume_and_get(dev);
 	WARN_ON(ret < 0);
@@ -846,6 +848,7 @@ static struct platform_driver amphion_vpu_core_driver = {
 	.remove = vpu_core_remove,
 	.driver = {
 		.name = "amphion-vpu-core",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_core_dt_match,
 		.pm = &vpu_core_pm_ops,
 	},
diff --git a/drivers/media/platform/amphion/vpu_drv.c b/drivers/media/platform/amphion/vpu_drv.c
index 2cca61f41beae..9c6f32c5eae96 100644
--- a/drivers/media/platform/amphion/vpu_drv.c
+++ b/drivers/media/platform/amphion/vpu_drv.c
@@ -205,6 +205,7 @@ static struct platform_driver amphion_vpu_driver = {
 	.remove = vpu_remove,
 	.driver = {
 		.name = "amphion-vpu",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_dt_match,
 	},
 };
-- 
2.53.0



