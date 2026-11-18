Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035146;
	b=ax1vdHLBJbmlMLNY8Vu+y4Nf+s4ZYLxMyZsqbbvw3VZRQnBjm1zxMSEduR7lo3LCpoBp
	 r3p48E68JU/kXiBR/RNewUGHAs8TsJw6h+NIg98X2eaFNxosDJzMqtihqZxEQ+wENy+kU
	 0vxU4v06hR6R8Wdni63TP8SlXG2x/VnnMTyNVoRKR30U/bfaGzsF4LMRXy9iZkcpis0pQ
	 JXwKNaNa9cJIvKeDJv/xKxdqjKfj/8nDVvFkduojvbgPvBhoCYl8HLd2qxpKoOzpiRQXi
	 nJflEAEjJSiwTu3P73J4TXjqHMVS1K3GraNU/7DLdRRFimxmZOIt9/yTNpj83lAdQjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lzMvfQ/28KGfw2hK1DEmbmPHSoi+4DIGoQySXMCWuU8=;
	b=Rk4lDW5pRI7U3CCpfRJWaCC/vQMGVoG26Hws/itCTclCAbKugoq5IlTlU6cQzbSD0pA9
	 yCl522HTMbCoNzOTLn7D88egtTHF7fgiAB4bkBlyLNVHDEalKFFt4rks4chuQyB84hw9u
	 qG/RQdtNXwCPMPgiQPpjCq+JYE1u3xXuuA1dU73xn2Z/nczgLfvrvG5bggFp08t+A7xCO
	 U8GYhff76llDBTZ1e9OtmQUtIoA3i4gfXLL4vxRd1vc46TYObNN7UH0WmQtFgkkD2nFMz
	 QoQ3FaEUZjVcvqL3IBZo8EwULAdVrp+kgD+wsyfxRSA2DMQ1AV5MVr0eLxzxI121W9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeL7Xb29;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42349606A32A;
	Wed, 18 Nov 2026 20:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yeL7Xb29
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945591F000C7;
	Wed, 18 Nov 2026 20:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035146;
	bh=lzMvfQ/28KGfw2hK1DEmbmPHSoi+4DIGoQySXMCWuU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeL7Xb29LlWBX75IS/jgyMBd281HMnTlMnrmeBAnHMA7uKW9Q5OGcqK6T/I/3GZh4
	 J+IQLFKO6L6SQ3jHnM4TjOm9ngesOTCV2UX0UnSQ2PCsVkb3/L0Z/+mU4wMa0N2DUm
	 v1DFVPmEWpko+Y+vgccTVFGqJ/EvXaWuL0WrQR/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0621/3318] media: imx-jpeg: cancel timeout worker when streaming stops
Date: Wed, 18 Nov 2026 15:20:43 +0100
Message-ID: <20261118150336.462848777@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 78fdfbf117c409273eecbfa7a528ef42358a0e38 upstream.

Each per-fd context ctx owns a delayed_work (ctx->task_timer, callback
mxc_jpeg_device_run_timeout) armed via schedule_delayed_work() at the end
of mxc_jpeg_device_run() to recover a stalled encode/decode job. The only
existing cancellation is cancel_delayed_work() in the frame-done IRQ
handler, which de-queues a pending work item but does not wait for a
callback that has already started, and it only runs when a frame completes.

When the fd is closed while a job is in flight (the frame-done IRQ has not
fired yet), nothing syncs the worker before mxc_jpeg_release() frees ctx
with kfree() after v4l2_m2m_ctx_release(). A queued or executing
mxc_jpeg_device_run_timeout() can then recover ctx through
container_of(&ctx->task_timer) and dereference it (ctx->mxc_jpeg,
slot_data, dev_warn) after ctx has been freed.

Cancel the worker from mxc_jpeg_stop_streaming(). The cancel cannot live
in mxc_jpeg_release(): mxc_jpeg_device_run() arms the timer while holding
only hw_lock, not the mxc_jpeg->lock mutex that release holds, so a cancel
in release could still race a concurrent mxc_jpeg_device_run() that
re-arms the timer afterwards. mxc_jpeg_stop_streaming() instead runs inside
v4l2_m2m_ctx_release() -> vb2_queue_release(), i.e. after
v4l2_m2m_cancel_job() has set TRANS_ABORT and waited for any in-flight job
to finish (so __v4l2_m2m_try_queue() will not queue and v4l2_m2m_try_run()
will not run any further job for this context, which prevents
mxc_jpeg_device_run() from re-arming the timer) and before the m2m context
is freed. cancel_delayed_work_sync() removes a pending work item and waits
for a running callback, so the worker can no longer race with the
subsequent kfree(). The cancel is placed before the buffer-release loop so
a concurrently running timeout callback cannot race with it over the same
buffers. If the frame-done IRQ canceled a still-pending timer, this cancel
is a no-op; if the timeout callback has already started, it waits for the
callback to finish. The same mxc_jpeg_stop_streaming() call is also
reached from VIDIOC_STREAMOFF, which drains the worker early, although
STREAMOFF itself does not free ctx -- the use-after-free arises only
when the fd is later closed.

This bug was found by static analysis.

Fixes: cfed9632ca8e ("media: imx-jpeg: Add a timeout mechanism for each frame")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Ming Qian <ming.qian@oss.nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -1658,6 +1658,8 @@ static void mxc_jpeg_stop_streaming(stru
 
 	dev_dbg(ctx->mxc_jpeg->dev, "Stop streaming ctx=%p", ctx);
 
+	cancel_delayed_work_sync(&ctx->task_timer);
+
 	/* Release all active buffers */
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))


