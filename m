Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062186;
	b=5UJGFbli1vMyZo3ChucUWe3mK3RhRgsA/OY3Tf6v6rcka1C4NaQVjxvoqrVDbdFo0Xv1
	 WjWa9M+mmwKJ2Fi4ud83uFKFrpnPoRVlAdU0pcNlvnj9PAsXcYDzXKxWqSlV0wJPEoq79
	 +ugGgETpTv8JFJQBd8/JDt30EgoGbcPKQjTBE2UmM5B8Xubf8Q3pPROGAbYuuEhYpzJL0
	 zm7zs0Ay/aZJ6AQ15tcLSAZjT5mM2Hnma3VT9+UxrNVS4CzQyFbvmFhXupHWas1eGOLYV
	 DFPzNqz1Xow+nkiDYGd0iyOx3mvbGKINJLkHoRL3JVN6z6gB02I/OqRLr2D/6BywOYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDNPehOmpU/xauXjOJ16qcqGg5HgqhdSe4qr2iWRdLk=;
	b=vDvBvYofBV7uzaFrle3wvz0KouHtCoYbkOnomq9Ci96/gM1lyCyAoN1Cy+pqpqT5aOLR
	 x+r5ojIV0Nl7tLzMGh2h0ymGIcf7LK4GQitkIM0EVdNiv+aa2BsKrBDEDDpKfaOeuYZsa
	 bEERppEHTnIoGhBRABKYSuHL+hSuW03VDBXVjsjipiAbTlRqPSRfil3a257yr01fYVCJv
	 9fW6vwiddV3HdTEj20DHYysdppsm4suETAHrRWaeLbfMZL1fLqHgNiPhUhNuQ9J/fk5RH
	 fm/sJ+gCDO564Q3NV4dDjXD171vvBEkaV/CmYpesSnti60Psa4dCKFbOgDSuKoI27IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXKszKgq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9613606A326;
	Sat,  7 Nov 2026 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wXKszKgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8877D1F008A1;
	Sat,  7 Nov 2026 14:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062185;
	bh=DDNPehOmpU/xauXjOJ16qcqGg5HgqhdSe4qr2iWRdLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wXKszKgqbfI9TcSeT5b+U8yE/JwhP0gEZ7njJuzxoPJKcAN4uhlc4u2QzQhMsadEI
	 PDXotiybMHvN5j9tOJDZ+Ez5KZzZ7LvByH/o86YEBNF+SmVsSmPtwRN+I8wVSwhXVc
	 qBbF1JlHdd3N3f71mKb9FvnC27CAtf0V7OQs2J8k=
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
Subject: [PATCH 6.12 1143/1536] media: amphion: prevent unbind while video instances are open
Date: Sat,  7 Nov 2026 08:52:39 -0500
Message-ID: <20261107135029.822761467@linuxfoundation.org>
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
index b2531a0e6c0b0..321f319d14a6a 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -718,6 +718,8 @@ static void vpu_core_remove(struct platform_device *pdev)
 	struct vpu_core *core = platform_get_drvdata(pdev);
 	int ret;
 
+	WARN_ON(!list_empty(&core->instances));
+
 	vpu_core_remove_dbgfs_file(core);
 	ret = pm_runtime_resume_and_get(dev);
 	WARN_ON(ret < 0);
@@ -868,6 +870,7 @@ static struct platform_driver amphion_vpu_core_driver = {
 	.remove_new = vpu_core_remove,
 	.driver = {
 		.name = "amphion-vpu-core",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_core_dt_match,
 		.pm = &vpu_core_pm_ops,
 	},
diff --git a/drivers/media/platform/amphion/vpu_drv.c b/drivers/media/platform/amphion/vpu_drv.c
index 51d5234869f57..53c38721e376b 100644
--- a/drivers/media/platform/amphion/vpu_drv.c
+++ b/drivers/media/platform/amphion/vpu_drv.c
@@ -230,6 +230,7 @@ static struct platform_driver amphion_vpu_driver = {
 	.remove_new = vpu_remove,
 	.driver = {
 		.name = "amphion-vpu",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_dt_match,
 		.pm = &vpu_pm_ops,
 	},
-- 
2.53.0



