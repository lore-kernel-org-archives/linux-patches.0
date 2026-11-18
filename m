Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022972;
	b=o6CL7Ygi8G7qB3u9jd9OJHdo5VmjVwyFLPlptINrIpYBYV1LaDPfLwzh3ak0+RzSQf/z
	 l8DD2w4Ryec6Xn9p6GRqWMfdAFpdzhP4sGApKraCqRjbCJ1qcsphixJXMLE5Z+CNgevUv
	 2QqabY/sABzMYFaspOVKSWO8N8hL2h+93DjsYkHjzQ798Qyqu4f20mTfbUnjAhbLZS1IV
	 RyoQZJaXaHVCdT3n8fPzhDXAY+BK7MMBVqUFexrxCjNm2P6MmrPfRjIlYDg+5y+J/68NV
	 +b02fgqExqWG+RnHlyxbvztyQqN57v1c9LKwwur+MpMKNYw+GDE6CLYlh4k3LGaVo6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pi0jxWHqwfWDEsr8fY7SOa/qenWHcRsQcdiREd3RngE=;
	b=T1E9ayYnqV8era2oz0vUJSu2hUAhh86PgEisXcgfohlTxWWDOt8zfyRs2eKAd0LL8abS
	 Vh3HYBSC73M9ps0SNIkYmvumhcD65FPFIodM5DUcqbZfr/TuzbGAkMEKGzaawHglFJZU7
	 FWGufIOCMMnAb4XYY9eQLLvY0DW7Jh4mKosZDizS0PnO3AwYY6vMLiy4Z6Fg8PqQcM5cL
	 qvKphsAAbamsyTqvNsK0NpHN5vJyGWHy0t7CQmeBZFBMmGMgA/hCFC12l//dJB//ppNCR
	 Qxl2PdgR0OLSK8SnK5OwoWw7aBEAEy4qBVX5rj7BlUDvKwLekE/kvCzHAc+erXNCGdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLZ6skVu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9B3606A31C;
	Wed, 18 Nov 2026 17:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLZ6skVu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CAF1F000C4;
	Wed, 18 Nov 2026 17:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022972;
	bh=pi0jxWHqwfWDEsr8fY7SOa/qenWHcRsQcdiREd3RngE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLZ6skVuDyv60a9jKALWaTstw2fGEeHM3//I+cFKkjDGz//GiehvhDOEc0qcd8fmC
	 4mfoP3fClNWMGm9dIhjqzGtdDwBCJQq2wMJJiajopOQoE8gVtYlwgX6Uj5C//MapAI
	 I63FnopvVhtlerOGZAilPNjG1UKO8ViZumiLu61Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0204/2151] remoteproc: imx_dsp: Acquire runtime PM before adding carveouts
Date: Wed, 18 Nov 2026 15:32:19 +0100
Message-ID: <20261118150129.214085957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 13df1fa4f1a30571442eda64c73d6cac7b9b5c95 ]

The prepare callback publishes DSP carveouts before acquiring the
runtime-PM reference that establishes required clocks and mailbox state.
A PM failure therefore leaves the prepare transaction partially
published.

Acquire runtime PM first and drop that reference if carveout
construction fails, so a failed prepare does not add resources before
its hardware prerequisite.

Fixes: ec0e5549f358 ("remoteproc: imx_dsp_rproc: Add remoteproc driver for DSP on i.MX")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260830133310.6926-1-pengpeng@iscas.ac.cn
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_dsp_rproc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index b66991008d6f1..bead9a5ea8baa 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -776,14 +776,17 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
 	struct device *dev = rproc->dev.parent;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
 	ret = imx_dsp_rproc_add_carveout(priv);
 	if (ret) {
 		dev_err(dev, "failed on imx_dsp_rproc_add_carveout\n");
+		pm_runtime_put_sync(dev);
 		return ret;
 	}
 
-	pm_runtime_get_sync(dev);
-
 	return 0;
 }
 
-- 
2.53.0



