Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018155;
	b=bapuRMEURsIlg4si3YFIKiyaGoOICgkMHkIG9ydXaKl0YrCqCHNy3oQkpIBWb3WXp+K6
	 qDy8UJPqtv1NOU6EgqYuO8FEh8yDns9lB1vEy1ALTGZNFxoew59hk/uFAoHtLywI69vLM
	 wVA7owYMBn1VBh15W4RDCc3KKjEz4IYvRyaz2Xao3czatbZnht/QWy6bv4UGvXKU4s6J6
	 v1T5xQAaNTpuUrRgC6OekkB9oo77l6CdQ2lwTluHBYA/HJApTEBJSONjGfv8QMz3vOE6H
	 KUGo/xxMwHX4824nlyNb5FtwBW8y/mqgf1f/SXcXK2qR0ZTpO9BuM9lx9mXUnCJ/SRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=afSMtRz1HzfpuQ3sNeM5Nk8Go8pnMnV72DZANxc7nI4=;
	b=RsfyP06ntGXR3mHj6V2dYpVoSsE4snsgeWlIoQULmTpy21NTdMomnTxUFyP+4yXsIVZa
	 tsrY83pH26tqbuMfhV5t20frPfdGePp2OEhZlzArShbCUtbZ8wxgRnU6SJtOM7DZIxAuO
	 zlkGdD7REQ0XFwSYfttD1BOaRAOOxoVvDIAcpuwuglev1xBn9qaP8qILOFB69d3zd8+8+
	 4VL2T9cJnnMjqZMn+MgqlvsIGeB0K8hN9Wdbh02M5GrkpcnWuMgupwDcdrWSHgNIU663S
	 QtOf5vA4ae6j/da7liF8nZdlpqadK6X1Hq2OoqG0ScxPCtEp+U8enk/Jdxr6QRod10Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfTNr3+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2480A606A32A;
	Wed, 18 Nov 2026 16:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfTNr3+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D513A1F000C4;
	Wed, 18 Nov 2026 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018154;
	bh=afSMtRz1HzfpuQ3sNeM5Nk8Go8pnMnV72DZANxc7nI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfTNr3+wrIZvqG9uCakq0IB9AzGwu2DXbYXWej5agJ6Z1arvRxfmqxxipUQFfAd57
	 lw2aNbUBCnETfPBFKQMTuO5zoYINRcyX5n7GibPI+ChkITtVJ3iPmeggZDg/JEs/J9
	 IyDQrhPXsrPQgLzeGq+ww1QaREKHTJ7cjzYbF7qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1140/2651] drm/tegra: Fix syncobj_in wait return value check
Date: Wed, 18 Nov 2026 15:39:40 +0100
Message-ID: <20261118150329.048908531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 27836c46a3db5a7869a9f7e181136f0c4d8bc0d1 ]

dma_fence_wait_timeout() returns the remaining timeout in jiffies on
success, zero on timeout, and a negative error code if interrupted. The
return value was assigned to 'err' and checked as if it were an errno,
the opposite of the correct logic.

Fix the code to use a properly typed variable and check each condition
correctly.

Fixes: 13abe0bb15ce ("drm/tegra: Implement job submission part of new UAPI")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aJM_te551jUwnRv7@stanley.mountain/
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260730-b4-host1x-syncobj-wait-v1-1-afa730410392@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/submit.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/submit.c
index e5841857c9378..5dad6dc4eb8c3 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -530,6 +530,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 
 	if (args->syncobj_in) {
 		struct dma_fence *fence;
+		long wait_err;
 
 		err = drm_syncobj_find_fence(file, args->syncobj_in, 0, 0, &fence);
 		if (err) {
@@ -537,10 +538,15 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 			goto unlock;
 		}
 
-		err = dma_fence_wait_timeout(fence, true, msecs_to_jiffies(10000));
+		wait_err = dma_fence_wait_timeout(fence, true, msecs_to_jiffies(10000));
 		dma_fence_put(fence);
-		if (err) {
+		if (wait_err == 0) {
 			SUBMIT_ERR(context, "wait for syncobj_in timed out");
+			err = -ETIMEDOUT;
+			goto unlock;
+		} else if (wait_err < 0) {
+			/* In practice, -ERESTARTSYS */
+			err = wait_err;
 			goto unlock;
 		}
 	}
-- 
2.53.0



