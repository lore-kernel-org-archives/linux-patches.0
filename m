Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045286;
	b=KiD/KUcgldTZozw4lZiM1k1DqsWGIrGmqR6VNMdVqklEXalWJlODhqe50CLeg7nRE4aE
	 gesXV5QXjmwdzvs8LApljP6ntvNEaI6LZRlCtJDVqvLMMP87+PZNaeMZbs3FZomaRoV7V
	 3AsCZtSEjy4XwZZ2VHN78MFd/XGwYVRkNIE7gdBhaNJtspO++HUXx6BjzSE7LrqHO62zQ
	 C7td3zX4V5lSgPCP7Wg8LWpr+jN9uM9iNjU0i7suNl4a13qEXWwF/atfFEAWGSM9ivYHb
	 RNAfKf6Cwj5HfaDSH+o1QWojkRskcSS9e5BLFpfkH0siqHMPrJ5lQ8+jV6wewOV4OZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9MDxyw5MGM2BE4Le4S1t5F4Hr/3OuSof9kedTo12p6E=;
	b=tBWUyGw2mg88NrvmvMJ0Ftf+IFErQWQh3WRSgw4brHzv4bx5IZJ+odS8nCetXW0ka23x
	 PqSfM89fa9lGa/Dx6FZPtkYKolsrAdYECRZidugiKQU/sEm6CHWce8s2eW9uYMQXd9Fwp
	 xmIXMMhxGDFFd506Xs9K+ldDYe7ATPI9854X3w9SeEy9ufvECFf9/Y9W/IoP7o7q/YBmz
	 8K3F5olGCzZsd3KRvX27l3NW/XApxBRyIFOhAzQpWcFx8WhYst7lC1VdH/s4+s9tXzgh+
	 1DVGZa/NKjjXcrdpGuaANB/N2c+s2QO3kGwpFG3GNaEEROAUcZ/3vKH41TGKxwxVv6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlSHXPe6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67727606A325;
	Wed, 18 Nov 2026 23:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wlSHXPe6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A541F000C4;
	Wed, 18 Nov 2026 23:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045286;
	bh=9MDxyw5MGM2BE4Le4S1t5F4Hr/3OuSof9kedTo12p6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlSHXPe6miGagYWPEzwVflgNgxf4xKP7bCg6R+ohyPKKMM5awo+VI5FtPT5OBRsax
	 6Vsbp9fjsdDJU4GGm0nCd4oMviEQgSESvzP/THch05rZBQyc7sbWjBO2ZjiNA+9GXB
	 QJU1b/iVk5l4daVCrkgDZOTH055HUYSmurnTe5dA=
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
Subject: [PATCH 6.1 0868/2857] media: amphion: prevent unbind while video instances are open
Date: Wed, 18 Nov 2026 15:31:42 +0100
Message-ID: <20261118150232.815089009@linuxfoundation.org>
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
index d549c0f4fa36a..c054fde2b754e 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -718,6 +718,8 @@ static int vpu_core_remove(struct platform_device *pdev)
 	struct vpu_core *core = platform_get_drvdata(pdev);
 	int ret;
 
+	WARN_ON(!list_empty(&core->instances));
+
 	vpu_core_remove_dbgfs_file(core);
 	ret = pm_runtime_resume_and_get(dev);
 	WARN_ON(ret < 0);
@@ -870,6 +872,7 @@ static struct platform_driver amphion_vpu_core_driver = {
 	.remove = vpu_core_remove,
 	.driver = {
 		.name = "amphion-vpu-core",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_core_dt_match,
 		.pm = &vpu_core_pm_ops,
 	},
diff --git a/drivers/media/platform/amphion/vpu_drv.c b/drivers/media/platform/amphion/vpu_drv.c
index 9afcf0236cf01..46259699aeafc 100644
--- a/drivers/media/platform/amphion/vpu_drv.c
+++ b/drivers/media/platform/amphion/vpu_drv.c
@@ -232,6 +232,7 @@ static struct platform_driver amphion_vpu_driver = {
 	.remove = vpu_remove,
 	.driver = {
 		.name = "amphion-vpu",
+		.suppress_bind_attrs = true,
 		.of_match_table = vpu_dt_match,
 		.pm = &vpu_pm_ops,
 	},
-- 
2.53.0



