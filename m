Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827129;
	b=H8YrOHOwNa8wIJ+QYrxO4e9YJkwlTBweZR4QUBueUruVMqshNVLiKvDuLGIggkMRFvnL
	 fhN0NcyfIgLq+1S1IeqNvjJujtjf18+0CYSqTGLlqVavX3D6L0cEVgV+vMdx9FI0NUt02
	 OZ3tlGRnt5RInfs7+t9W6KlMQwvEB+EpI9xZT8Muc1/XIEqKPm/h3mm8liJqo2qJyeiJ7
	 Oaxr1aWb0/dbhkVAbZTLwETtNjF9qojiaeSA4ZIe+GkOlpFH3dJe5ojzX2qXI3hBhI3Dd
	 yW6Wyfe8j0FK04wwf97/oz87DUBmWMKHQLixLK58DRMMjBNOAFLSkQ3KErmJlqNoGGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K8C4iMmG1lPYmOzGvNPohs+SvgIb1GBxY11pNbWOACc=;
	b=gCYNMdQYIbXIZqi96JgOnc9zZNjhdnVDgpvoe//h6wHVfnoLhhZZ3NSZAqiZiB8oYC6T
	 WfOL3b2msRhoT8ocRcBkYXGlptYu8AWjo2zIWqoEhRKJehSS73H0Isp2N5GRjY3snZd9H
	 EsUkR6i4Hd4Nh5OnV5KPUw8GM5c/csBUbMA0ggsT6eq180Lw11dgvBWM2cbDO1ctzNxA3
	 xL8zK8ogn/ab7K3YieNQfC9nGbvSA3ed5v7iGszjyImQY5/POWoSO20zxQMs8atJ97hvE
	 Q5BUJjG/t7o4a5s+Vd2HvMCjyHfiCMbZXNHxpAHTDXCm6k5/TwrnkTjardQjl1kx5Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpkbsmgM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7D1606A866;
	Wed,  4 Nov 2026 21:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpkbsmgM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95DB1F000C1;
	Wed,  4 Nov 2026 21:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827129;
	bh=K8C4iMmG1lPYmOzGvNPohs+SvgIb1GBxY11pNbWOACc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpkbsmgM7GSMVzncXd9ikvNqccWsWy8sdc6rOz7Cttgr5ga1RDXtBYEGpe/b1X/2o
	 XNzq+3fBKhj2pwriPJNkp674N+TaqqNUmCwEHJWcnK4tOhSJrv0aFIPrp+qMdsykS3
	 xDhF/Wj4gB4bI2y+n9Vbntv00u3swwaI9ocsIf3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eva Crystal <0xiviel@gmail.com>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 7.3 204/547] accel/amdxdna: clear the mailbox channel pointer when starting it fails
Date: Wed,  4 Nov 2026 16:06:28 -0500
Message-ID: <20261104211043.940021547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Eva Crystal <0xiviel@gmail.com>

commit 2117e3d96a4fd1ee13fa28b31494ff5f5db6ccf4 upstream.

aie2_create_context() allocates a mailbox channel, starts it, and on a
failed start frees it again:

	hwctx->priv->mbox_chann = xdna_mailbox_alloc_channel(ndev->mbox);
	...
	ret = xdna_mailbox_start_channel(hwctx->priv->mbox_chann, ...);
	if (ret)
		goto free_channel;
	...
free_channel:
	xdna_mailbox_free_channel(hwctx->priv->mbox_chann);

hwctx->priv->mbox_chann keeps pointing at the freed channel. That
pointer is the driver's own test for whether a hardware context has a
usable channel: aie2_destroy_context() returns early on NULL,
aie2_sched_job_run() refuses to run a job on NULL, and the message
helpers return -ENODEV on NULL. A stale pointer passes all of them.

It matters on the restart path. aie2_hwctx_restart() calls
aie2_create_context() again on a hardware context that is already live,
after aie2_hwctx_stop() has torn its channel down, and the context
survives a failure there: aie2_sched_job_timedout() discards the return
value entirely, and aie2_hwctx_resume() only propagates it. What is
left is a live hardware context holding a freed channel, and every
later user of it takes the non-NULL branch:

  - the next job submitted reaches xdna_mailbox_send_msg() on the freed
    channel, via the !mbox_chann guard in aie2_sched_job_run(),
  - a second command timeout reaches aie2_hwctx_stop() ->
    aie2_destroy_context(),
  - closing the device reaches aie2_hwctx_fini() ->
    aie2_release_resource() -> xrs_release_resource() ->
    aie2_xrs_unload() -> aie2_destroy_context(),

and aie2_destroy_context() then calls xdna_mailbox_stop_channel()
followed by xdna_mailbox_free_channel() on memory that was already
freed: a use-after-free, and a second free of the same channel.

The AIE4 management channel already does this correctly -
aie4_mailbox_start() clears ndev->aie.mgmt_chann right after freeing
it. Do the same here.

The create path itself is not affected: when aie2_xrs_load() fails,
xrs_allocate_resource() removes the solver node without calling
->unload, and aie2_hwctx_init() frees hwctx->priv, so the stale pointer
never outlives the structure holding it.

Starting a channel can fail today without this patch: the ring buffer
sizes firmware reports are rejected unless both are powers of two, and
request_irq() can fail.

Fixes: d5b8b0347fa8 ("accel/amdxdna: Split mailbox channel create function")
Cc: stable@vger.kernel.org
Signed-off-by: Eva Crystal <0xiviel@gmail.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/2fcf0eca215090dbbd95cb86e1bf5076056d3818.1789334558.git.0xiviel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/aie2_message.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/amdxdna/aie2_message.c b/drivers/accel/amdxdna/aie2_message.c
index b4c49259a1a2..f658760c3d48 100644
--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -277,6 +277,7 @@ int aie2_create_context(struct amdxdna_dev_hdl *ndev, struct amdxdna_hwctx *hwct
 
 free_channel:
 	xdna_mailbox_free_channel(hwctx->priv->mbox_chann);
+	hwctx->priv->mbox_chann = NULL;
 del_ctx_req:
 	aie2_destroy_context_req(ndev, hwctx->fw_ctx_id);
 	return ret;
-- 
2.56.0



