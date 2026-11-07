Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064465;
	b=M7uAL1TL0Tp8GmHhGPq3N8PWqOF5mJmDDkuZFhcfX5tC/V0trM8c5mpaBNHjxfg/YvN1
	 3iYl7bhQh/b1FpDSwpPmdpoGPviW+o8ZX/gqjjUn9p4ONH74F+0Sf4gNX5a/enUXm84Y3
	 U5eZQ70tWhTO9BUZ8ivm9u7Zi0EOeEKGKElJ1RxsGFZ1eMfXR/WT4CPZt8G6w9L8/gJse
	 dDGAKTP4e2kmprTTMMlkgzGVLtkFRfhoMywyPJPar+C5Zz5nILcAhjxZQ1MTZaZFuijhB
	 sWwVO3pRa6H7u1NyqzDm6A2MaF8rLwo3/UWBMPA8HD8RPjil1ak4PEu5V2pliPi5d/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0eDzHbc0OufE04o6UXXqjvytKSq5hR9sI074po5/Eo=;
	b=xQUBEaIvcVWdLL8Z+FuOW19ESKiDniciCT66kgKWmJz/9bJ3fdL4gUmveLh0ITx/cNFm
	 97dBKCNnBokA1Uilsb0VRMaKGP1qJd43kQeMkdUYExu5v2MN3Lle6pGvIwJfnm4E9sJi5
	 fU6a0nGJYkiF7m6lKtDWT9UbYpbMRKD1FvwkEYAaPLtr6f/7S3q8XYOv8P3Oa9ixDZg4I
	 DY8IrJhlE6ursTJzhZXlGyU2ul9LSiEuQvFz9NN1BkuOxLnf368P9Ly9VJvFI2HwL3viA
	 vmAkJe+KdpJ973PaCFbvj+cz+zUrsggTq5QzAXqFF0pfJoZjpfFYxxCCHmmSRqqSwtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKvMeHts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFEF606A33D;
	Sat,  7 Nov 2026 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YKvMeHts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6651F008A2;
	Sat,  7 Nov 2026 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064465;
	bh=h0eDzHbc0OufE04o6UXXqjvytKSq5hR9sI074po5/Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKvMeHtsjsNiDWiU8MxrFyTcZIJFbVRd0S9Cg+RxR/3mHtiytQdAjpI+yTBMIV/iq
	 x7eUI0Fy8dk/fgPTvGlOma54Mw2W26GJ+RCBiiklB77iyzkTwY0+hObodPopf03TE9
	 nFs/BggcC39E2nO9BBzN/IdmPrTo0UJRvNXPdemk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0468/1257] media: amphion: fix runtime PM imbalance on probe failure
Date: Sat,  7 Nov 2026 08:46:04 -0500
Message-ID: <20261107134952.387350294@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 0cabf27cf1e6f7ee5f3c5893c0f1930814d949af ]

vpu_core_probe() enables runtime PM before calling
pm_runtime_resume_and_get().

If pm_runtime_resume_and_get() fails, it has already dropped the runtime PM
usage counter that it acquired before trying to resume the device.  Calling
pm_runtime_put_noidle() again on this error path drops the counter one
extra time.

Remove the extra put and keep the existing cleanup that marks the device
suspended before disabling runtime PM.

Fixes: 9f599f351e86ac ("media: amphion: add vpu core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index 2e8e08e05de7c..ad54f014d8f60 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -667,7 +667,6 @@ static int vpu_core_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
-		pm_runtime_put_noidle(dev);
 		pm_runtime_set_suspended(dev);
 		goto err_runtime_disable;
 	}
-- 
2.53.0



