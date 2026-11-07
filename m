Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063115;
	b=NSjSZ4XQO6iKs0C0wXUqMPW+rF4r5mHwr/pxQDPquQyaIkldEhJiaTOIUAuBtix8op0Z
	 YCU0L2nOZqsrZUyYWsCmC2vGq0IK9TrLtZabSyHNfiJyLRg8lfWyQgmPydxU+MMCqWORB
	 XDtZxkS5rcR+AGPzxwJjHTHvroA84oDfy4ZpggD2SLqg7pdLvhDnUXZKPDvzDv0Su0uVx
	 XtSFM8ZLt8VlJKW0zlqGEQJBXAm9JI/aF78F3D7npm0ktZFgU4CB3Drav3EA+19zMwOsr
	 AWZwxQ+PBOWl/s64LoHXJP7BCpjUE0vWChscsU8vf2ld/t0q78xh8jPWUbT6dTuxjzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9OBOLn4eH4QxA0zs6RS+8zmGiLSo0PBlYxIYsdcFPOs=;
	b=URbTq1jBUu0l6MxUoY4UJyOGLOJUdsM+YCI4nK+Lv1at708LXLCadQcJ9CDNY0nbWN1q
	 oePUt4M1c9wjbEWkYK5n7aeMHXRGLLv6jMtRnzzrcRKI831WXwpvfsjZpy8drZ21rmKdM
	 VIIsXQ7U3Lv8trhny9e8TF5GSXNIOmWdhJdwni+ArnLyLEpBpXOoKDIH+qeXfQVB8ajsV
	 xxi0MZKlPIIFZJ5dV++qO3/wC2TeTQ74olwOifycy5V5i/JxmUuKs99+t+O5r3vg25dJ8
	 MffMw0ceW+NukxjYMQdGhOiJJn1WLRC4dylR576Vv2lONJxhUfh+/hcZJjhZbbQ2SVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsRHu8KA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C6606A33B;
	Sat,  7 Nov 2026 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LsRHu8KA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4201F0089F;
	Sat,  7 Nov 2026 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063115;
	bh=9OBOLn4eH4QxA0zs6RS+8zmGiLSo0PBlYxIYsdcFPOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsRHu8KAFEWSBlooqbPC4L7orsZ16t7AggfmgL+fCmslrv8WlrCA3rwJqXQPt/YBT
	 q5VxOT972xdFcSM9zZMzcjf6nn8yCFJVgQMxy+m+KoEgYXgCxRvvYqHBBwD4MY/gtP
	 zcXFJfzShErUoSZJ7Iy8n+PKCP1wmEuTTwDjNJw0=
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
Subject: [PATCH 6.18 346/869] media: amphion: prevent unbind while video instances are open
Date: Sat,  7 Nov 2026 08:50:28 -0500
Message-ID: <20261107134904.121941268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 0501c2383ccf7..56f6888f101cb 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -719,6 +719,8 @@ static void vpu_core_remove(struct platform_device *pdev)
 	struct vpu_core *core = platform_get_drvdata(pdev);
 	int ret;
 
+	WARN_ON(!list_empty(&core->instances));
+
 	vpu_core_remove_dbgfs_file(core);
 	ret = pm_runtime_resume_and_get(dev);
 	WARN_ON(ret < 0);
@@ -869,6 +871,7 @@ static struct platform_driver amphion_vpu_core_driver = {
 	.remove = vpu_core_remove,
 	.driver = {
 		.name = "amphion-vpu-core",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_core_dt_match,
 		.pm = &vpu_core_pm_ops,
 	},
diff --git a/drivers/media/platform/amphion/vpu_drv.c b/drivers/media/platform/amphion/vpu_drv.c
index efbfd2652721f..67d48c338fd11 100644
--- a/drivers/media/platform/amphion/vpu_drv.c
+++ b/drivers/media/platform/amphion/vpu_drv.c
@@ -230,6 +230,7 @@ static struct platform_driver amphion_vpu_driver = {
 	.remove = vpu_remove,
 	.driver = {
 		.name = "amphion-vpu",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_dt_match,
 		.pm = &vpu_pm_ops,
 	},
-- 
2.53.0



