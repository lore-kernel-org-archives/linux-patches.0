Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062800;
	b=ftS7nWClMXkoVG7s6Q2in8Sd6daIgyzGm08qXjFwLZEy/9Ctq/jqvnDvUGi6lK8fjrTz
	 bgWTQ54Q3E3Qzec+rZrsrc/GKSwG2uVP2T/8i/UGOX2gE8097Vm7rmI3AoEZDPrr63yWL
	 nLZe7Xpxe7j1qY/yfIBt8xNtXklPCjA9KPHM+bwIZeJ8R/C8ktw78wqrVeOzbSasYwz3y
	 RzNd0YfL+xGnM9QRJK2vusBrid6SMpAzuzlnB4kumOY24ibhHsUfj/v0D94VBWMlrIGHl
	 ivSQztFRLm+gPoO3pkQoh4jadABO3VqE4QKMlA4Y3I1FEwAURz75bTN5ld9nFR3sqAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NTyMem0WD2LFDlQ6+acVyEWfkBtH91kduI8P3WK+Ho0=;
	b=CbP2vQ0N3+2CqDsLQcY/FGWCmlqq4gQVCoUV2ePFcaGaf+aIK6v+Du/PwYjinfkltNpa
	 ock8LYIm5RSekkL7Qyst31+YQU0TPq32AoMVlx9RTXw994t0XlC9N5VLkveT7d7v6CWVN
	 RUGj9Tq6WvbTY9ppMZScCatBrc3b9ljs4U6Om1MRLi32xkKwFDbYk5BGmxDN0oOtuH0Ao
	 Jf7era/zEyKUwW+NQ6BzKQSzqL9sMen6NextObDFcK9D+kJk6KjFphR0H3j+qiPfcpeuj
	 D1iuh2OPqdpPoaCbB+7ETCOB9JD4nTIddA646pxwrhixPs83gy6PLJrkItAu91H7qzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2qWor0es;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44808606D807;
	Sat,  7 Nov 2026 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2qWor0es
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74181F0089F;
	Sat,  7 Nov 2026 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062799;
	bh=NTyMem0WD2LFDlQ6+acVyEWfkBtH91kduI8P3WK+Ho0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qWor0esDP++xZJWm7uExwkcF85nVYnKqrqaoteL1o/brZeKMEyFHjrt/J9jOEIOe
	 CmT1+AWjYRhK+T4q0tOy2NJ8p3tMjx3LYfbFNIYGTN3elS9ZPJbiBUbgG/tsde/1Qs
	 xI4spaFa4l6inlPZlJnxNpEknHQJ+2F4zPHaiubo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/869] media: stm32: csi: unregister async notifier on cleanup
Date: Sat,  7 Nov 2026 08:46:24 -0500
Message-ID: <20261107134856.099390360@linuxfoundation.org>
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

[ Upstream commit 4957d480a0c87cf3d024e6ff1f57d1222f9212cb ]

stm32_csi_parse_dt() registers the async notifier before probe finishes.
If a later operation fails, the error path only cleans up the notifier's
connections.  It does not unregister the notifier, leaving its entry on
the global notifier list after the devm-allocated csidev is freed.

The remove path has the same problem.  A later async operation can then
walk the stale notifier entry and access freed memory.

Unregister the notifier before cleaning up its resources on both paths.

Fixes: dcb0f4c16be5 ("media: stm32: csi: addition of the STM32 CSI driver")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-csi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/st/stm32/stm32-csi.c b/drivers/media/platform/st/stm32/stm32-csi.c
index ecd0ed8e76b59..78c68cf90ffcb 100644
--- a/drivers/media/platform/st/stm32/stm32-csi.c
+++ b/drivers/media/platform/st/stm32/stm32-csi.c
@@ -1059,6 +1059,7 @@ static int stm32_csi_probe(struct platform_device *pdev)
 	return 0;
 
 err_cleanup:
+	v4l2_async_nf_unregister(&csidev->notifier);
 	v4l2_async_nf_cleanup(&csidev->notifier);
 	return ret;
 }
@@ -1067,6 +1068,8 @@ static void stm32_csi_remove(struct platform_device *pdev)
 {
 	struct stm32_csi_dev *csidev = platform_get_drvdata(pdev);
 
+	v4l2_async_nf_unregister(&csidev->notifier);
+	v4l2_async_nf_cleanup(&csidev->notifier);
 	v4l2_async_unregister_subdev(&csidev->sd);
 
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



