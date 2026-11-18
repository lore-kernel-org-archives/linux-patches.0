Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024890;
	b=AXvzbe/hNUXpkmmFoBJA2UHiurWGQ4umSh4WtX8/utKSyO27j6Ce/5nHEq2f5U9uf81W
	 dgaafQRUDsO598MLxVquOiFmmgpTx16fAdHfl2RixYNdkhjUGnXuIA7WeoKDbdnDCZTNP
	 YsEl6yC/Xo+fTFx3DkCpr8YAytxmh1mv3XCX/B8MTxyU/DGWXTKBWPRjxJpubgHmGiIp0
	 A1rAUL4z0q5TNJeqBjrrYKs4U9VFLJnN/hDO4exDG0sjg0G/9J7ebwrUdlzZL7zYwnhH2
	 lQz2cWlSWdbjEmigILqMmie9nAGonkMK0NhoiPH9Y+h5PDdk04SW9CO+9mLQmId17CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tA09o3TektbYwWI97qaDjYaoelp03+PneQn6S+QUGHA=;
	b=DHr0DYGjr5xUHj4pwm7DraqBQIO1HjvgUeCfGu+OW1Xo8NsQVZ5WnSZ8r5j1eIrMPFIN
	 bvs3KEYR5nTph6+gdAf+9D1GDnZyD6WkPi4udFU9frLgJa9xDsX4Jd4lemNrsWrJO95Lc
	 hn47xdyJ2mlcmQ93XHMAissg360SaVkj5ApyhjLYtXiTcgmiYxSsNnbcqkVmuUwWK4q/q
	 3ezaY7+Wa5pEOzg/WY7t5Oodz9zqTVfJJxehZdOjRFO7xcUQ9AXbxtaHf6VdUwEDkIk3q
	 uS47f/XEnTUV0VDOOWHvvaNvy7czi6ObcaDE12XwHws6G+NxC9oW+FmHQmIogScUAnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r19pd5m9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124C5606A31C;
	Wed, 18 Nov 2026 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r19pd5m9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C4F1F000C5;
	Wed, 18 Nov 2026 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024889;
	bh=tA09o3TektbYwWI97qaDjYaoelp03+PneQn6S+QUGHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r19pd5m95QKS3worQBu9QF3JlM5TtY4jAtN5xphuzDX/3KvX7QMc23lSAL0w5DcR6
	 zjwXc7LXQo83b393DGHII/K9mAJRyqgW5mLZ+HYNUpAPvqNatBAxzNzYPBKFcAg2tR
	 u26TfVBxkZ9osfPqIzI/ITF2hVsBgJ/USLMPNMSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0868/2151] media: iris: reject open() when the session limit is reached
Date: Wed, 18 Nov 2026 15:43:23 +0100
Message-ID: <20261118150153.826165045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 397ebadcbc219f6c20d11c0378d8cb7695d015c2 ]

iris_add_session() silently skips adding the instance to core->instances
once max_session_count is reached, but returns void, so iris_open()
continues as if it succeeded and hands a file descriptor back to
userspace. As the instance is not on core->instances, firmware responses
for it are dropped and every subsequent ioctl times out.

Make iris_add_session() return an error when the limit is reached and
fail iris_open() accordingly, freeing the partially initialised instance.

Fixes: 38fc8beaba55 ("media: iris: implement reqbuf ioctl with vb2_queue_setup")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vidc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index b916e8c8a6456..2ebccd9455cf3 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -39,21 +39,23 @@ static void iris_v4l2_fh_deinit(struct iris_inst *inst, struct file *filp)
 	v4l2_fh_exit(&inst->fh);
 }
 
-static void iris_add_session(struct iris_inst *inst)
+static int iris_add_session(struct iris_inst *inst)
 {
 	struct iris_core *core = inst->core;
 	struct iris_inst *iter;
 	u32 count = 0;
 
-	mutex_lock(&core->lock);
+	guard(mutex)(&core->lock);
 
 	list_for_each_entry(iter, &core->instances, list)
 		count++;
 
-	if (count < core->iris_platform_data->max_session_count)
-		list_add_tail(&inst->list, &core->instances);
+	if (count >= core->iris_platform_data->max_session_count)
+		return -EBUSY;
 
-	mutex_unlock(&core->lock);
+	list_add_tail(&inst->list, &core->instances);
+
+	return 0;
 }
 
 static void iris_remove_session(struct iris_inst *inst)
@@ -202,12 +204,17 @@ int iris_open(struct file *filp)
 	if (ret)
 		goto fail_m2m_ctx_release;
 
-	iris_add_session(inst);
+	ret = iris_add_session(inst);
+	if (ret)
+		goto fail_inst_deinit;
 
 	inst->fh.m2m_ctx = inst->m2m_ctx;
 
 	return 0;
 
+fail_inst_deinit:
+	kfree(inst->fmt_src);
+	kfree(inst->fmt_dst);
 fail_m2m_ctx_release:
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 fail_m2m_release:
-- 
2.53.0



