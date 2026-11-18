Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039269;
	b=Rr+6s7GCqBDyTIbtVGZHl0bqKB53PaqjR4Z0OZMyqvZEhff3AgngS6Vy9DSZiHRgJSJg
	 3pIeV3nraJRvQLqB9GnvJcllrNTAZV4nWds+FrqYjQQsl7/Ib8/VeFePeQ4bZk3lNj+ii
	 LqqpSmmpvxJ+77sCQg1rWTIyLcUI9fCt3SrZrAUoh8dueD5HA//E4h1/cUECE7wJr3LBU
	 EHClt55wWh2nQ4+LY+rlZjC2EJQcJbpUW32EBKgj8F5Bh3lG1v4TYQljuQ2fNBGgNti54
	 /R9/cvnYlYXNg7jZDxduIE1peFKpBZgl8gkxGhDuohnNQBYENDdy5Exm9PC4VaichFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJEF8zuscHVGSxsQLhAqwD5vb5iOD2XDffHfhLfK/JM=;
	b=R3OutLKOi6KCGjrxRFEcH11CALLbDFI42p7vTE5hqyFpgRM1P+Fk2OV3eCJlxJAqFlCg
	 cw4+pIYoQ2U1B+ghL5C7f5OXfGyZ7wA6C85e8NlT3GPy8aN6NynsKsdAkxfTTKbIQ1iGb
	 v6zBX2du7Fx5TiHfXJDCtMRAp2dq3Rt+GVtFWFppScQwmBen68ZwRXOuqekqwgjs6bPMg
	 IsvMA7MJ+xiqsib1a3Euea5nrr82vzvfPiW4StyoFeCcpnh/fTUEgTp+CcklN9EC98i/h
	 G3qLi+KGHKXL6i7nP3wKNt/9aqlCSx2F8hOtnI55o/tMHTNji5FG8ic/n5Hx3ESEmqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxRs1crt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3CD606A31C;
	Wed, 18 Nov 2026 22:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxRs1crt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCDA1F000C4;
	Wed, 18 Nov 2026 22:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039269;
	bh=PJEF8zuscHVGSxsQLhAqwD5vb5iOD2XDffHfhLfK/JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxRs1crt0IldCq5wreSjYttcKWPzzmhJUJPBrs0lS2DqSf2/xYewwZpFlXktVQO4C
	 89Iz0MZuefGU6u2GIQg50nPszRfgikJoyUwoy0azBF2x9eg8xMyu2AziuZYf27p0Ew
	 HexVodq8YVf4qwWr2Ai/yaaabkQWtcT33JTq2w4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2039/3318] remoteproc: imx_dsp: Acquire runtime PM before adding carveouts
Date: Wed, 18 Nov 2026 15:44:21 +0100
Message-ID: <20261118150423.212504232@linuxfoundation.org>
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
index 491c5a48770f8..1aa5920160e29 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -686,14 +686,17 @@ static int imx_dsp_rproc_prepare(struct rproc *rproc)
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



