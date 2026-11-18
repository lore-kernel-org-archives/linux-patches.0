Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036297;
	b=v32Qz5n1JMi5kdhD667yBK7rs1v9Kp2Eqw/MipMggEz+HEgjIE+l21aTzC2hX3z2TeH7
	 +HLGDReaQJzCklD3CMGWf6lbkBZeQWX+a/ROhGnXLnekoS+7eiBN9rrVIyuyGdXdW024s
	 f6J3m255PD+S1gob8r4boxQEzFiNLFFO2AtfC98Ux5OZFnH47LT3L39jK6+NaFkM7s+Ol
	 sN/looq9Teu4QEo3ReVtuwdpIKSnYt79Ak8cgYIgwLrhZex9sKd8O9adO0dG8rY9XzehN
	 MnKUx044Gwz/omBMamoEEmv2L5ImX8PWNdQQtQAOQHo0zqzSBFogP4roATTw1YhF0pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FR7VLvXksrjgVEDL9JtTXYCYHQgqU+qj6Ma5YcaJ9oA=;
	b=rrHd/5ZIGcHnGlIOkVFL4IA/qKLF7xE0yIquM8CDaXPmW2iPrZ+UzGhT1mVexL8wJge2
	 sJ15DgHD5Y8aObDi8gVx1Dd1EByz9cmjkL0JrjOlPmCmYObj973eKxlYsfb7dFZZVIazA
	 vQWm7Zb1g0D+Xqw9fLzT2/910FMWlkAEtG0AZoxw3GcWOosmMuCMvBbAErX+xffo+Z7x5
	 7XatJJ9votBWu5AdHyHbLohI/qBb+FaxUWbzLntQX+FW5ZeCTlvY5PWTloF6sTmrJYw22
	 /e0M85KsddjoWD0LmengW9seLYooljXXbh/2pYbFGzQTH9rarxgqFnc9Bp+tpVGkWTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTzzcXs2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CD860A2606;
	Wed, 18 Nov 2026 21:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTzzcXs2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC101F000C7;
	Wed, 18 Nov 2026 21:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036297;
	bh=FR7VLvXksrjgVEDL9JtTXYCYHQgqU+qj6Ma5YcaJ9oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTzzcXs2mi4ehu4abIKDtjXUD8kCrKIyfOkD4EgM7IzbliL7/ADi5L42Dc+hw+ePi
	 aWbIIdMH1EX2G1Ahfd+G+n5KNrTAj3apc5Gnvw9iZwmWbIUXd3K9W1v/7npgiln4wS
	 wU5R+zzEA44QDEBS09rHxzBSp03A1jdQHXYgh58c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1007/3318] media: amphion: fix runtime PM imbalance on probe failure
Date: Wed, 18 Nov 2026 15:27:09 +0100
Message-ID: <20261118150350.089087667@linuxfoundation.org>
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
index 321f319d14a6a..d6e3b5042ec24 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -689,7 +689,6 @@ static int vpu_core_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
-		pm_runtime_put_noidle(dev);
 		pm_runtime_set_suspended(dev);
 		goto err_runtime_disable;
 	}
-- 
2.53.0



