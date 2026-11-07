Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061357;
	b=UhBnEImqH8xUeiKi7bMUGVbBVGw1eBnnbNA7/W3MHtIVAcGUuRd/m/e9CcXJoprWE7z3
	 EUKTNPn0LWp+N7tI8dTDmSR6c6mR4EQ9PNI3vMTuxEYPHJ9Kv40IwJc/TLNzFq9yvtSrl
	 tEa5EKHNmx9JUpEJAQvt2vEUec0OovvwGwYRZng7SnHKbLVCd0qqWdowQtYSAVIUMOS4O
	 IXlX3SS8KpOwWzydpbp5qxB4scn3QLEhgZPv15bhDpccGx+YWANgTLGxWuS7U9OPfdro7
	 JXI5QEdvsrltioHGxSNKN+TYhbTbRDLvDEW3o4cZjHhbpWftIe1Mc1kg+VYx4681AEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCLdRpat9GvTbqq1x5/NEoiwIPW/RA3oIB4enqDtUpU=;
	b=4DZLF9MX829lXzenYbqj8yhX/wj6Xg80OgIATFDR8FwIZjRDr7/1VlEGVE9i5136w8Yg
	 P4ssLKrpVfreCkJ/1hT2qfrwkp96EVjGb+Qz6g1/7oXD/GalTEsy4CbPhz4ysG0AeQnvg
	 FaJNRAsaxa4ChkZM8r8ScN+zYwvnVoGd47FwzMZMNlTBwgCeklgzvNhgf+lttWWJm+Q9m
	 GK8o8Uu51vHQxVjWXSxIXwbJvoWhKf5nZY+VUZ1N6I30A3gT1u2k8d9sC9wu/g7Xguu8r
	 FYeQyDW4kTBit13soImC48Tv89I1l6MEn0lNnRVlIROMpmAa411oPiBgqe3wEbb/NSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+Xo1y7N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450EA606A326;
	Sat,  7 Nov 2026 14:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r+Xo1y7N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19591F0089F;
	Sat,  7 Nov 2026 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061356;
	bh=aCLdRpat9GvTbqq1x5/NEoiwIPW/RA3oIB4enqDtUpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+Xo1y7NoN0WvTGbXhSowwdB4Q2BmVphR8lIQivLgN4JT6H0OatyY9XCMJpSVYesI
	 9JpkYRS7OZs3nCXIkMe2KnQxXF9EyYTqwlpwLkX3QQKMtHneNXOyWjhIPu+V0cBjOl
	 T1SmycqcaOo3GRdkFw/rIZhhct9i2wZfDTXEJTow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0456/1536] media: chips-media: wave5: Resume device before setting EOS flag
Date: Sat,  7 Nov 2026 08:41:12 -0500
Message-ID: <20261107135010.334883623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

[ Upstream commit a52e6f7923c17a672135b485ffd96fbd72f46267 ]

Setting the EOS flag talks to the firmware via send_firmware_command(),
which accesses VPU registers. Both the STREAMOFF path
(wave5_vpu_dec_job_abort()) and the V4L2_DEC_CMD_STOP path
(wave5_vpu_dec_stop()) can run while the device is runtime suspended, so
those register accesses hit powered-down hardware and the SoC raises an
asynchronous SError, panicking the kernel:

  SError Interrupt on CPU3, code 0x00000000bf000000 -- SError
   send_firmware_command+0x2c/0x160 [wave5]
   wave5_vpu_dec_set_bitstream_flag+0x6c/0x80 [wave5]
   wave5_vpu_dec_update_bitstream_buffer+0x80/0xec [wave5]
   wave5_vpu_dec_job_abort+0x44/0xa0 [wave5]
   v4l2_m2m_cancel_job+0x110/0x19c [v4l2_mem2mem]
   v4l2_m2m_streamoff+0x24/0x140 [v4l2_mem2mem]

Resume the device with pm_runtime_resume_and_get() around the EOS
firmware command and release it with pm_runtime_put_autosuspend(),
matching the runtime PM handling already done in
wave5_vpu_dec_device_run().

Fixes: 9707a6254a8a ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Guarded the pm_runtime_put_autosuspend() calls on a successful pm_runtime_resume_and_get() and added the missing pm_runtime.h include, instead of putting unconditionally as upstream does. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../chips-media/wave5/wave5-vpu-dec.c         | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index 19510a363724e..a4c859cbcafdc 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 #include "wave5-helper.h"
 
 #define VPU_DEC_DEV_NAME "C&M Wave5 VPU decoder"
@@ -853,6 +854,7 @@ static int wave5_vpu_dec_s_selection(struct file *file, void *fh, struct v4l2_se
 static int wave5_vpu_dec_stop(struct vpu_instance *inst)
 {
 	int ret = 0;
+	int pm_ret;
 	unsigned long flags;
 	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
 
@@ -869,7 +871,16 @@ static int wave5_vpu_dec_stop(struct vpu_instance *inst)
 		 * calls do not block on a mutex while inside this spinlock.
 		 */
 		spin_unlock_irqrestore(&inst->state_spinlock, flags);
+		/*
+		 * V4L2_DEC_CMD_STOP can arrive while the device is runtime
+		 * suspended (e.g. on pipeline teardown). Setting the EOS flag
+		 * accesses VPU registers via send_firmware_command(), so the
+		 * device must be resumed first to avoid an asynchronous SError.
+		 */
+		pm_ret = pm_runtime_resume_and_get(inst->dev->dev);
 		ret = wave5_vpu_dec_set_eos_on_firmware(inst);
+		if (!pm_ret)
+			pm_runtime_put_autosuspend(inst->dev->dev);
 		if (ret)
 			return ret;
 
@@ -1781,15 +1792,28 @@ static void wave5_vpu_dec_job_abort(void *priv)
 {
 	struct vpu_instance *inst = priv;
 	int ret;
+	int pm_ret;
 
 	ret = switch_state(inst, VPU_INST_STATE_STOP);
 	if (ret)
 		return;
 
+	/*
+	 * job_abort() runs from the STREAMOFF path and may be called while the
+	 * device is runtime suspended. Setting the EOS flag talks to the
+	 * firmware (send_firmware_command() accesses VPU registers), so the
+	 * device must be resumed first; otherwise the register access faults
+	 * with an asynchronous SError.
+	 */
+	pm_ret = pm_runtime_resume_and_get(inst->dev->dev);
+
 	ret = wave5_vpu_dec_set_eos_on_firmware(inst);
 	if (ret)
 		dev_warn(inst->dev->dev,
 			 "Setting EOS for the bitstream, fail: %d\n", ret);
+
+	if (!pm_ret)
+		pm_runtime_put_autosuspend(inst->dev->dev);
 }
 
 static int wave5_vpu_dec_job_ready(void *priv)
-- 
2.53.0



