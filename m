Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038685;
	b=adFfiF66z/MN7cG6V6olwPKohCaXNyaWQQoRdzKyy/zBxKrn2ROTEU0TukyiRzTOP8Jl
	 LqO4dbJcy0zUi81d6+p8PsK6z4BIwh/YP2AhQylGZReg3pyCwTSAQ6ljiB+/9qWg9lF8c
	 vkMAQeHRre4HXh2Bz9i1bk0eVfQSQZRh4kPilLpzkK8DyGlSWvqMzDgVTQtYt3y1HXq0r
	 eBJlpq9dU3nmFslqxkccnpTVbjcQN3uoUj/jgy6d4Q6Ri0xRjRp0yTAFZdLQ66f124wFT
	 CouPEy4ElSDs5q384BiyOHpGS2IrK0AijmRrWRMiAK1PJ8tJ6TxqmWxdr5+bL7HtaUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2que2kT783Q6EPzlrHr+ACbPXKDZU7c/EAvgbF7iGR8=;
	b=xZBlmF71+eWkwshZNTnBxwq5nP2sZqJRHXuoIKmIfA+aRPX28ONwiSVqMGZ4wfQNz6v+
	 CFW+87789d+xs5x5yohtETxztI5WC4uWGXIM0KzDChVlbaQMo0vRN3go3BQffUYvNozzZ
	 jIPyZm+HLoFE5mAzOLWJdMcXcDFYP8nSiiJJj9wK9ty+VYwJqShvtBj0KQ7aG5dlRM+Md
	 D94oH0oFMZ6Xw1BkLOfZegw9JTiJv2w8EltlwsjP4Epf9Df8Cl5h10OHjZLYLmlErbYli
	 HTssWq4M4dnOchOaZ+Gu9TafbCjvnkYRZmxmXdjUsdVevN8pemOUa4SEf/JsLXKeE/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOdFb7hk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB45606A31C;
	Wed, 18 Nov 2026 21:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zOdFb7hk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F681F000C4;
	Wed, 18 Nov 2026 21:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038685;
	bh=2que2kT783Q6EPzlrHr+ACbPXKDZU7c/EAvgbF7iGR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zOdFb7hkBYLqPxB7RouqVDUOA4inlbMG6gJ8CM6dZQGAP/ieK4r1r1/I36UB/0lEu
	 DwDGTMidTltkSfiN12EqbMZ6uxRk/84wKi5L5bD83LbfsoqTd2eJm57XaC61lIDMe0
	 s6CxLloMDcSATii0/tSUDIWqhEqN1qsipFciESbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1789/3318] media: qcom: camss: vfe: Fix VFE reset while another line is streaming
Date: Wed, 18 Nov 2026 15:40:11 +0100
Message-ID: <20261118150415.528439694@linuxfoundation.org>
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
index f4a4f0fda45db..10095818cfb23 100644
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



