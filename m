Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036260;
	b=4tdAEa1qKi4fJBzElMledT7enCynYCy29zhKyEkTHJrnfYGZAb1KDWT0KFgfClHLRTgR
	 phj7y3rTtJOno0HIcyldnfHrmtPfTyuhe/vClgExXtuNwjwf6pWrzIgTnfRHdFEku1Wrl
	 GAf6/exrFJrMQ1BKn6Z516M/COwnSBPyzr9JaDjW5S6EQVbGk7CzYSlwq+rjm96j6Y3vu
	 WzHhDndVo1ScdeZyAKI9mZ4Z3otojO3GbDNkxQzTNfNgYspEgHt37kcrDGsQF8Kc6+TYg
	 Wx/0Fhpz7Zef5nDImr5Xp2N8ETc0XTCAHY1kqymFYRBOypsngkOkSnR3vMIAfnJI1Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yn/RtmhILMtwn5yIGQOdllQ9yydFCrFc0yanqzeJ6S0=;
	b=tFjVbR03Yd4TieoEIHMzU7AKoxclEa/V3o4zZ83tUTKHFe3x48Z2KR15kVEUxpmLR6W9
	 zHqaoq8uNM6zjfL3VIMna4pxL+JmcDS0xhx0zZe4DYvcVKv8fOkoZdk5xzxsMowNODyDo
	 FqRT3DicgC0TcQ2nR3BEwjmccDOdn8TVvys+6YftaaTO7UV7ua2fdYPlUDLhrav+erx5o
	 H14UZGBKabKeCT9yvAoW+gJoywzVdLI3RT3h6BaHC/tl2MXZ7R7kmClGuFJ40vxSQfDbV
	 FMR7C6uLvuyHrsHF16n6g76VVf5vs2LvvjEQ87O5fRGJjVEKNb0NWho2I4yUydhXV5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EB1bGAz0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E19D606A33E;
	Wed, 18 Nov 2026 21:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EB1bGAz0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603091F000C4;
	Wed, 18 Nov 2026 21:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036260;
	bh=Yn/RtmhILMtwn5yIGQOdllQ9yydFCrFc0yanqzeJ6S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EB1bGAz0o5WQh81r0XgMH9DSMRRWEA/38YbV4qUv2xlAqXAnDdiUUXYii0RgiJTY/
	 YPJCHlzrqCAxmiDOhQk7UCftsTObxOKUl+f9lkOgdArzqBGaahTpq9MYkeA2MKBOVi
	 pnjBJ8EtEXaNBOllkAZ8NgiZYFikIrgHaJoWTMTk=
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
Subject: [PATCH 6.6 0996/3318] media: amphion: prevent unbind while video instances are open
Date: Wed, 18 Nov 2026 15:26:58 +0100
Message-ID: <20261118150349.714914294@linuxfoundation.org>
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



