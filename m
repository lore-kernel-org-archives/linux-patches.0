Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063035;
	b=YIIBmrL7av0xaDEXFLmJ7RRpuDbFgVBbUnAC9SSsX1/E9Cf+ha2PVPCvDan7600oeH80
	 uyzJvaB4dumPjQCkg5rElbkEWPbkpWqGI+6g0rp7FnuoQNVn9t8NCIu9FGbMBBJhN/YlY
	 1GC1VIt5d0CNKsAbdl4/NwddqULFQLLkH0yeiRv3Kc3jVpfctkor1CQa8iQ5mmUG90tNb
	 k8Kuig71QK1O+KWZ9aQ178w9vyXbBr03WwN7ihthOOdQH3tBqoqfu9Ri5K8ckce5PXqhb
	 o1ZXoXPrwyNkO6/Omn4RrUUvV0Mpr1XaHKcbLP3ll09biRAAgAkPEk7eAsyJqMsUJHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xA9ElJepvq01xyOzgra5zHAMUCqWZbYDqUipofY2Ju0=;
	b=Ih8rHZ3xESUY3CJ1K0QSdVgqJBLJR+T/0aR/E7VrDqFVTkCMAWyy/Y5y5NyHaTT5R2eA
	 zLqkhI2ruwzpeWGgjJSZaQjz69y1bRRkfNvQoYSu0l9NpPUqKa1wNkJK1CSTR2QDBST+D
	 FFpfM6I5nSAlZO8FPElRfljf8JUy8IzZCgayXqAxdzU+eZquFnhS2Frwixc1mapl5NI9S
	 RDjoGLThQYxRHPuRaJ+8PM/S3rcgWl30P6GsjYeOgW8Sd5VtFOWouFl+HxgYAVRnh+CO8
	 zxFxM1Fsfv1RN5AIYodV7XtiezKmbPdN7vHstr9sxdVgyEIabok4KChP45X/toPpFbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ux7nE7og;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DD3606EE82;
	Sat,  7 Nov 2026 14:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ux7nE7og
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25BE1F0089F;
	Sat,  7 Nov 2026 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063035;
	bh=xA9ElJepvq01xyOzgra5zHAMUCqWZbYDqUipofY2Ju0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ux7nE7ogP4ka7u2qzOqcvpQ70YDBK5nnqOYynJUj1WKGpk0MPsVqWTyaYbAx1/5r+
	 BfJfutisnTHqmqz9x7O3uZt7mkU51U1sfxhzMVLWcerofRvPxvx/tvXHUuaTgR26HO
	 5VgU25X3t4vaod5Hadn3oQgl/OkILefo5nITDwQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/869] media: qcom: camss: vfe: Fix VFE reset while another line is streaming
Date: Sat,  7 Nov 2026 08:49:26 -0500
Message-ID: <20261107134901.359694350@linuxfoundation.org>
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
index 20e0d6604fa93..bf76ac3fd4c52 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -804,7 +804,7 @@ int vfe_put_output(struct vfe_line *line)
 	return 0;
 }
 
-static int vfe_disable_output(struct vfe_line *line)
+static void vfe_disable_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
@@ -816,8 +816,6 @@ static int vfe_disable_output(struct vfe_line *line)
 		vfe->res->hw_ops->vfe_wm_stop(vfe, output->wm_idx[i]);
 	output->gen2.active_num = 0;
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	return vfe_reset(vfe);
 }
 
 /*
@@ -829,21 +827,19 @@ static int vfe_disable_output(struct vfe_line *line)
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



