Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017828;
	b=M3XMJ6lA6mlSzXa/m8ADrjdyS/ivxdtjnCTA79xaAqRzL+45JwvfQHtRUN6TpX4TkldM
	 DzBkB1dNjVSMpjmOOlk9FUpruflLBtBy83BAcrH7g5YVNMhsfrU6UUNd14pr1i/Sa0VB5
	 PhHpGJsaD8UGUUMA6jvZlr0HD121IDlp8GqJT8A8GZrs6IWbm4LtbpzpET2ghCZ5X9rvj
	 dmW8HHC/3dCkgkg2vKOghG9OeA44pK19jIjrgqek/X3MTHTOCycghXiVDO1yEyszh4W+D
	 zmCv8cLPc7DXzDGdbSgIvs7rKkkSN5+fvq2uncMlQ/U4KkkIsT38szQ5UlaxRmYCLHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GNn1sX6YnmF4p1mBKvHfGtzLZa7DLv6azxNk9FsaqrQ=;
	b=ZFc+ZiyAIMIuoJd+p1OLrnk0a8h4QdmJB4ipaZiAvURr7FprIFeKmBFyD37MEQzm1JGS
	 LwOGyxctltsGRHvdYFG97hgpByvf+ojTmGfYfb9cq3QvW4XoGY+jA7tke28aaoPycbpl+
	 6iOqtQ36Krwrn5UJYcWbvkT3PPER/cIwPUBSGRTso6fnkwCt0xRT4iXo6/rjlbkXGIowh
	 cKn7CKUQg0fHcMB6OJ1EaRWVO9Es3bbn9IXdRibkFu1Sovz9fwgoU42Nx+CcTyy1orPmY
	 x68dGZD6HbCp4cubOgIzdBRiKKAjYphHZrdNjldZmRPzk1V4VHNzaNpO6cv1R+a0H4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsDOHYis;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253D6606A31C;
	Wed, 18 Nov 2026 16:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsDOHYis
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778FC1F000C7;
	Wed, 18 Nov 2026 16:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017828;
	bh=GNn1sX6YnmF4p1mBKvHfGtzLZa7DLv6azxNk9FsaqrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsDOHYisVzg2uk5A4zAIgLkTxLMytd5I7fSo57Ghat26O7UvmG1IhLtvuwqrSC4mP
	 6ge2V7/ySlouMdCulxHhk0f8jvUNJKwe0Ho7l4H9LClOnuyy0wd1Qe1g6HfTAV44MJ
	 nhXJPu+dvYexsLwPmg23wLIUd73eg4suxcvOtXeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1023/2651] media: iris: reject open() when the session limit is reached
Date: Wed, 18 Nov 2026 15:37:43 +0100
Message-ID: <20261118150324.776186438@linuxfoundation.org>
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
index 2dff38053532f..afec4a1ff163f 100644
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
@@ -203,12 +205,17 @@ int iris_open(struct file *filp)
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



