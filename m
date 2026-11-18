Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047851;
	b=A8yih5BLLWaS3jkDeYXMOMlOAiijmIUSgVfG0eI+K6iUYLb7jXza4PlzYBfqwj0obRuP
	 QjAjUqAb6fIiHC0ck9D0tUrv1VSCrcHXYEaQhrCjP4vIPTgoODiSlRS2yxlsEk0mtb0Jh
	 naTqaZBU/uFJz4S5RFjk5GMhnwdsReOWhpzMUauPyxZzNodR9XG+YPauBa/PoePePcCLO
	 /gnJdhs/7OBu9N7OYZhWDi8PkO2WJ33CmH185+I+FKRYY9ye9vB3WdTZDiCiaHqFZxPv0
	 KSsNpo8UQoDaE/hfh/ICc8CtJt3k9pP0zq2HQ6DSUiLjzRZR7JL1i9zxGLHUi2WYs2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EXNNyU/FiQ2wp6Nd+45Srocp8e/79kULCwKcu7xc9aE=;
	b=ugQmVDu6lIAQssKiUTCKC6GARr7XLbYZf7Nh+AByz7vRk3c4kCBm+sDUzZQpk3peMAxI
	 K2V9zhMUnz8tytQ3vlGQsHvDZ/SU5bDifxHJED/hE/G71yuklVTO91IhFu3csI2fFprhU
	 zR3sWst+pE+KUiPNH3kfK0edN6IAZz+JDsOY9NNo25jnM9HbD7nzqCssMHCfdUBMVi/tm
	 scYWjpUt5ajISrSAZV0TjkUMBTK8e8lZy2hIq6OuKJ3InB5hbGL7g4EVfS0MvR5RkGPBk
	 mnTKMJiSdBaqCDJX7TPY7sai9/BVrsqwuix+GmeEe0DrdXnQOUJPCzxgC66o/7R/GJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSp7AMBi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BC4606A33D;
	Thu, 19 Nov 2026 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSp7AMBi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7574E1F000C4;
	Thu, 19 Nov 2026 00:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047851;
	bh=EXNNyU/FiQ2wp6Nd+45Srocp8e/79kULCwKcu7xc9aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSp7AMBiU6x7I1BM8L7t9/CVBb9QBV96DGgQVd5ecwvxgXZ4SqaTB4N9dD5BRRZ2F
	 0QYUzxL9ioalWqZvgmNbaFmI4uPsaWspI2JLGfKzRDvVo4Uv0j/+FH5mcEAmZGNEJP
	 waalxyxTBkXxHYbW9KXJvipkbOgQWk4p05SJuo0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1787/2857] remoteproc: imx_dsp: Acquire runtime PM before adding carveouts
Date: Wed, 18 Nov 2026 15:47:01 +0100
Message-ID: <20261118150305.613134642@linuxfoundation.org>
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
index fd0e75e326979..8325068704767 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -668,14 +668,17 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
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



