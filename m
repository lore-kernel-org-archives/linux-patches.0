Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047126;
	b=1ZCY3fFn84m7gh3MxtTndG0ML4sv5LB4JU4l29KglnUcgJyAmPOqz0HSuooeDhkEnl5A
	 PY9WGlJvtqnWUwM0lGTp4NqU/0ccXPEL1xPjm9v6gyMMj6TP6cWjr7wggWWbMjYS46LeV
	 Y4yjn6AWufXiaVUhd1Xb7/GxT89RbUCkKeG63IPqcSsK40t6vN2hi9G0wGJRu8PijxQyZ
	 3vXTWp3QxxY8rbt20y5avsHBY/uzXE0Iw0fOuABp63z4VHx6UaIF6AKtOW8zWhriTJlfJ
	 2Zi1RD28NQVW0idz50oUq6xV/K2Yh/yjJvgHZVP4hx83DOH8aIeWdCYnqYKWGerGhXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7IoI8nvtLPFk6HgNPVUubffNbqKMizE3c/P0gV+18J8=;
	b=VIFrbfFUQku1gF+quvAkUN5JJ366kELF5RqBbtdetoqXlUyYj1df0Zi/Wy/ldnFc7HGq
	 zNTtTjFIRveHM3FJvMLV0grPOnCe1c5fnVM/ryHYoJ2LALkjG8fApylyHbMFHJZa3sPAB
	 8AFwl9hAmldpql2uxFNDVeILMkx6zWAL+xXDZuUwjDzLxEUjz4Yp7aXnKsIuZHSZI2th3
	 JBF99FiJp4/d9cKX+V49RZlD0FCWH94IIAFTVO9mzaaA164/OsmjNvG56Vyg0X+mPkSF3
	 89Yam+jzG73OgcbqL4/u+lZnlth9LTb9kyvRMX1y7CwX3UVnBSNxOaDuqWeCEKQrLKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0eLwNuEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A83C606A325;
	Thu, 19 Nov 2026 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0eLwNuEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7631F000C4;
	Thu, 19 Nov 2026 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047125;
	bh=7IoI8nvtLPFk6HgNPVUubffNbqKMizE3c/P0gV+18J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0eLwNuEbb82Nkt2+USWwy9y2Y+9XKMf/UkOLFK0sQVqZIR0gsBUC9fpBV90u7b6wa
	 KHyPwrBU6DyXNCRtEDcQwFDnNCkhWpLmXcXAlhcfB5HyMU1vAREyKCuYgjan8u4pRC
	 ZcfC1RhliZQFE2OZ00xXh5Gc577atH6wARkppezw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1527/2857] media: qcom: camss: vfe: Fix VFE reset while another line is streaming
Date: Wed, 18 Nov 2026 15:42:41 +0100
Message-ID: <20261118150256.304996776@linuxfoundation.org>
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

From: Hitesh Patel <hitesh@ebytelogic.com>

[ Upstream commit e5d4b0e69a4017fd39354499c9d7583f625f0524 ]

vfe_disable_output() stops the write masters of the line being
disabled and then resets the whole VFE. The reset is not limited to
that line.

When two lines of one VFE stream at the same time, which is the case
whenever a CSID demultiplexes several virtual channels to different
RDIs, stopping the first line resets the VFE underneath the second
line. The second line's write master configuration is wiped, the
buffers it had in flight are never completed, and the VFE is left in
a state in which the next global reset is not acknowledged. Stopping
or restarting the second line then fails with:

  VFE reset timeout

Move the reset to vfe_disable() and do it under stream_lock, as part
of the decrement that makes the count reach zero, so that exactly one
caller resets and no line can be enabled while the reset runs.
Stopping the line's write masters is enough to quiesce that line on
its own. With a single line streaming, the reset happens exactly as
before.

Fixes: 7319cdf189bb ("media: camss: Add support for VFE hardware version Titan 170")
Cc: stable@vger.kernel.org
Signed-off-by: Hitesh Patel <hitesh@ebytelogic.com>
Suggested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
[bod: Converted vfe_disable_output to void]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index e333e4463433b..096a284c6bfc2 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -407,7 +407,7 @@ int vfe_put_output(struct vfe_line *line)
 	return 0;
 }
 
-static int vfe_disable_output(struct vfe_line *line)
+static void vfe_disable_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
@@ -419,8 +419,6 @@ static int vfe_disable_output(struct vfe_line *line)
 		vfe->ops->vfe_wm_stop(vfe, output->wm_idx[i]);
 	output->gen2.active_num = 0;
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	return vfe_reset(vfe);
 }
 
 /*
@@ -432,21 +430,19 @@ static int vfe_disable_output(struct vfe_line *line)
 int vfe_disable(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
-	int ret;
+	int ret = 0;
 
-	ret = vfe_disable_output(line);
-	if (ret)
-		goto error;
+	vfe_disable_output(line);
 
 	vfe_put_output(line);
 
 	mutex_lock(&vfe->stream_lock);
 
-	vfe->stream_count--;
+	if (--vfe->stream_count == 0)
+		ret = vfe_reset(vfe);
 
 	mutex_unlock(&vfe->stream_lock);
 
-error:
 	return ret;
 }
 
-- 
2.53.0



