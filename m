Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064261;
	b=C0yDk4nvrFclN7NCvoGQ76q10ijpCGL/cyhaL/8M+GgJqoTgPVfoozHgiZMvJrxC52ik
	 grI0a6yw9Tbnnl+FxJG3VzIwBFPW7Nby73okR9xji/UvWN8tNAlRVKP6c7C0waI7umwbC
	 4BO5GDxuzz6f7Vc/3ROqeaLGQEcVRlnCAT9nn36tTBWhVEE85y/ja5+9k4YsJuGJAMtOr
	 8XFzg0Tuhsaunv5KhtrxhguMh64n7nvEe9XlfF5gc0WuBWoCp4XClxDy0aUWOBoDAGwaD
	 kYmDABqvL36/+92HVHFQRDPkmRrg1wWkvvkKtomH16c+8ieAH7QnJX8MK+apg+T8qPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=moOwTBqWI/bPQv9OlLL1IWUd17OIAxVO/ZyVxYLm2Cg=;
	b=OKB3yE2OTZQQ935lYYqVYHtC/1QcQrSMJzu7t+MUrORtArKeNPe3R/7Bi4QbrRA0ywg1
	 asVxt7TDt4sQZPw+17PfYKaBWX1TqEjkDtUor0xfpmrB1MqzPEvWdzixw2Dq4YMbTb0xj
	 aNkH697hT2fdxYRsqrxSk4oOkJ56/EO31ucKYMiPYdFveLkvYQmu7FBEgmSjJXTq1YXIF
	 rNxdD8kgclydejulMjfty0s3orOmXxgMgMGvLshNaW55hmUiaLVGt1HVn1Kuw+Of2RvQS
	 EUg3qmuAnYFvEwICDf3KqOSqdK8A4Y/+yJjn7Oh+8BAXgiTmEnotb+jPZqmK5OknrkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dq1rWkm0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADF0606A334;
	Sat,  7 Nov 2026 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dq1rWkm0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A301F0089F;
	Sat,  7 Nov 2026 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064260;
	bh=moOwTBqWI/bPQv9OlLL1IWUd17OIAxVO/ZyVxYLm2Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dq1rWkm0StErBXmZX6Gp2mmy8TX5KPkUEfhiGhFxPSeNXnjnwZajjWZ8ZA3XhhsIT
	 YCHNzVHvBP2FCVCmotPL0M49i4WrL2r2aDnxvze1hzt+wVOHOBLY+oJXOvyUPLdX7I
	 s7MiggcAQLjhuHnc+GyBh53hwTGNVFBjZkcCqs1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hitesh Patel <hitesh@ebytelogic.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0360/1257] media: qcom: camss: vfe: Fix VFE reset while another line is streaming
Date: Sat,  7 Nov 2026 08:44:16 -0500
Message-ID: <20261107134949.364506618@linuxfoundation.org>
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
index 319d191589884..55c0a0ee398fe 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -808,7 +808,7 @@ int vfe_put_output(struct vfe_line *line)
 	return 0;
 }
 
-static int vfe_disable_output(struct vfe_line *line)
+static void vfe_disable_output(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
 	struct vfe_output *output = &line->output;
@@ -820,8 +820,6 @@ static int vfe_disable_output(struct vfe_line *line)
 		vfe->res->hw_ops->vfe_wm_stop(vfe, output->wm_idx[i]);
 	output->gen2.active_num = 0;
 	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	return vfe_reset(vfe);
 }
 
 /*
@@ -833,21 +831,19 @@ static int vfe_disable_output(struct vfe_line *line)
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



