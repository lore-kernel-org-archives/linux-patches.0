Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054027;
	b=XWyOKQm5CsWi4uIvNZiMCdyi9H6NatsMRAtEs1emTlsqLyQnNC6giRU9foVwapTr87PR
	 CKvyzuiFZ6c2W3VP/D1JPedra+QLOSONWoZQF1Zq7OqD/quRFqb23TUxafX6avIu6aElf
	 0UDiUMRdq++eSo+H/FVDH1aOdbjJXdJehY9d5nnkGGTEiwu1axXfZio9yOjPSHPKKcC7s
	 6hTKGb0X00eBRKQzhAC4/VCsCEUFZwaocepx0jgxARubOgFMX/PKIEPyfT/NQfaZK+WR0
	 ethPSMdZa5s5chhUgTIoz7AkRDlmVK44+oIIH1OLlJE1mSA6H6N+a5iRLUoVhPoa4Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MYRnc9GOQPn66ZVGCj3o1JjqrSU19HS82IlpxW9nTII=;
	b=W5Oj7BCNCmX8bLkj0Sm2iGyXdHIORYawKahPjVnn9OuE6vUX1QaXnoIiQR1ZPml0E2bU
	 dO2b5W59jHKAEwxTA0WtCYyEwPg0j3U6vomb9u4oFnAuQoPmOrUrsG34C8ZMFynqbGb/5
	 njbtZLVlr9yWHG9eM+uqUIuM6rwvHlXuTvlmpWkA5AXegksNFhq1NbdQrF0/9C6iCFt6u
	 2Fx5U3UUh5dNYdTiS/M6CUGNKNDefLA7pfs+B4oWsL2L68sh/H9N0lVlCza3bR1H6dfB1
	 pKZQMMaW81K16ulR7mjnBbHnWoM+MPZxb4IyhcoFiaqpZMdAQ5v1xrM/KXspv8KrPVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QW1j2Hn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BB2606A325;
	Thu, 19 Nov 2026 02:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QW1j2Hn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9661F000C4;
	Thu, 19 Nov 2026 02:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054027;
	bh=MYRnc9GOQPn66ZVGCj3o1JjqrSU19HS82IlpxW9nTII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QW1j2Hn9mn5GaosmfD+Dr+hRh8Snp71W1EHJX8br8EXzFg7XfECLtZ/YOvrF6xqZa
	 fALqSlD9kASVzs73VXdJS4YWUde/jfKb0QBLLk0Uo3bVhdFW2FaYiYmLLodMu5j+kO
	 aujG6b+F66gWeHet0p6sh8GVn4uOF0KYelLV1iD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1129/2214] media: qcom: camss: Move vfe_disable into a common routine where applicable
Date: Wed, 18 Nov 2026 15:46:45 +0100
Message-ID: <20261118150057.228793817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 90cc4555730bfd0fc6af5c8a5a81d80bfce4cff7 ]

We can move vfe_disable() into a common routine in the core VFE file
provided we make wm_stop() a VFE specific callback.

The callback is required to capture the case where VFE 17x currently isn't
VC enabled where as VFE 480 is.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Omit the VFE 480 conversion because that backend is absent. Include
the upstream reset-error propagation in vfe_disable() so the
follow-up reset-ordering fix applies cleanly.

Stable-dep-of: e5d4b0e69a40 ("media: qcom: camss: vfe: Fix VFE reset while another line is streaming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/camss/camss-vfe-170.c | 40 +----------------
 drivers/media/platform/qcom/camss/camss-vfe.c | 43 +++++++++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe.h |  9 ++++
 3 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index e2ca0aec3a697..3c678b6de8203 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -499,22 +499,6 @@ static int vfe_enable_output(struct vfe_line *line)
 	return 0;
 }
 
-static void vfe_disable_output(struct vfe_line *line)
-{
-	struct vfe_device *vfe = to_vfe(line);
-	struct vfe_output *output = &line->output;
-	unsigned long flags;
-	unsigned int i;
-
-	spin_lock_irqsave(&vfe->output_lock, flags);
-	for (i = 0; i < output->wm_num; i++)
-		vfe_wm_stop(vfe, output->wm_idx[i]);
-	output->gen2.active_num = 0;
-	spin_unlock_irqrestore(&vfe->output_lock, flags);
-
-	vfe_reset(vfe);
-}
-
 /*
  * vfe_enable - Enable streaming on VFE line
  * @line: VFE line
@@ -560,29 +544,6 @@ static int vfe_enable(struct vfe_line *line)
 	return ret;
 }
 
-/*
- * vfe_disable - Disable streaming on VFE line
- * @line: VFE line
- *
- * Return 0 on success or a negative error code otherwise
- */
-static int vfe_disable(struct vfe_line *line)
-{
-	struct vfe_device *vfe = to_vfe(line);
-
-	vfe_disable_output(line);
-
-	vfe_put_output(line);
-
-	mutex_lock(&vfe->stream_lock);
-
-	vfe->stream_count--;
-
-	mutex_unlock(&vfe->stream_lock);
-
-	return 0;
-}
-
 /*
  * vfe_isr_sof - Process start of frame interrupt
  * @vfe: VFE Device
@@ -759,4 +720,5 @@ const struct vfe_hw_ops vfe_ops_170 = {
 	.vfe_enable = vfe_enable,
 	.vfe_halt = vfe_halt,
 	.violation_read = vfe_violation_read,
+	.vfe_wm_stop = vfe_wm_stop,
 };
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index ce8c53f07ea70..41c63eec091e1 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -405,6 +405,49 @@ int vfe_put_output(struct vfe_line *line)
 	return 0;
 }
 
+static int vfe_disable_output(struct vfe_line *line)
+{
+	struct vfe_device *vfe = to_vfe(line);
+	struct vfe_output *output = &line->output;
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&vfe->output_lock, flags);
+	for (i = 0; i < output->wm_num; i++)
+		vfe->ops->vfe_wm_stop(vfe, output->wm_idx[i]);
+	output->gen2.active_num = 0;
+	spin_unlock_irqrestore(&vfe->output_lock, flags);
+
+	return vfe_reset(vfe);
+}
+
+/*
+ * vfe_disable - Disable streaming on VFE line
+ * @line: VFE line
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+int vfe_disable(struct vfe_line *line)
+{
+	struct vfe_device *vfe = to_vfe(line);
+	int ret;
+
+	ret = vfe_disable_output(line);
+	if (ret)
+		goto error;
+
+	vfe_put_output(line);
+
+	mutex_lock(&vfe->stream_lock);
+
+	vfe->stream_count--;
+
+	mutex_unlock(&vfe->stream_lock);
+
+error:
+	return ret;
+}
+
 /**
  * vfe_isr_comp_done() - Process composite image done interrupt
  * @vfe: VFE Device
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index f166d176cb771..28a4c69d96c94 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -116,6 +116,7 @@ struct vfe_hw_ops {
 	int (*vfe_enable)(struct vfe_line *line);
 	int (*vfe_halt)(struct vfe_device *vfe);
 	void (*violation_read)(struct vfe_device *vfe);
+	void (*vfe_wm_stop)(struct vfe_device *vfe, u8 wm);
 };
 
 struct vfe_isr_ops {
@@ -197,6 +198,14 @@ int vfe_reserve_wm(struct vfe_device *vfe, enum vfe_line_id line_id);
  */
 int vfe_reset(struct vfe_device *vfe);
 
+/*
+ * vfe_disable - Disable streaming on VFE line
+ * @line: VFE line
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+int vfe_disable(struct vfe_line *line);
+
 extern const struct vfe_hw_ops vfe_ops_4_1;
 extern const struct vfe_hw_ops vfe_ops_4_7;
 extern const struct vfe_hw_ops vfe_ops_4_8;
-- 
2.53.0



