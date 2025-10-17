Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BD4330B2F;
	Fri, 17 Oct 2025 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715779; cv=none; b=kV2cDNX8g86ybg22wm/ZgwSNmgs/wpwq0R/2Ww8edIKwLZXrz2J3EvpshKmbkIGiD9qQGzcsR7zbfUBHHCsYvfzpFxRjFqRxo8fTpqwiF0j0yMgv0SonEvk+hlTIZtXoEZ/+LHtaQnc1hiwliENjPW0TPZHdf+pAXZ+f4xTxM0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715779; c=relaxed/simple;
	bh=DbkgfVLqIx1AB+XMdUYTP+pvfMIg55Sg1gaavzNJXTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCy8vLIbhKT5vO8nUZy7qgqelLOwGc2TMlPSs2RIASbvYNOKN5kyJr5ixmnhqYV3G3YqgPhA3OjomDT9FoEXWk+SujxgHh3ZnzlCEcFZu7f5xf4MA3LKPJULIn+jRotZyeIWRcv3o6rk1FrkkIyy6+zUEWat9g0yipIcthJ/lr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lci5EnPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lci5EnPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE05C113D0;
	Fri, 17 Oct 2025 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715779;
	bh=DbkgfVLqIx1AB+XMdUYTP+pvfMIg55Sg1gaavzNJXTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lci5EnPQqB/lPPNleQHyhoNecr2tL4P60gh8EYxlr1DEwsLRmJj4HJ5CIuJ/eygSo
	 S44tK5b01rXcOXwOifrIGtry/bkvt28/Il7OQ2EY3B1X80B7J7o6y3C0//s5om+A27
	 f2WX9IzbojKFPfu9Sxe0ynakKNSSD9EHNf+/EwBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 333/371] media: iris: Update vbuf flags before v4l2_m2m_buf_done
Date: Fri, 17 Oct 2025 16:55:08 +0200
Message-ID: <20251017145214.127491658@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 8a432174ac263fb9dd93d232b99c84e430e6d6b5 upstream.

Update the vbuf flags appropriately in error cases before calling
v4l2_m2m_buf_done(). Previously, the flag update was skippied in error
scenario, which could result in incorrect state reporting for buffers.

Fixes: 17f2a485ca67 ("media: iris: implement vb2 ops for buf_queue and firmware response")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_buffer.c b/drivers/media/platform/qcom/iris/iris_buffer.c
index 23cac5d13129..38548ee4749e 100644
--- a/drivers/media/platform/qcom/iris/iris_buffer.c
+++ b/drivers/media/platform/qcom/iris/iris_buffer.c
@@ -651,6 +651,8 @@ int iris_vb2_buffer_done(struct iris_inst *inst, struct iris_buffer *buf)
 
 	vb2 = &vbuf->vb2_buf;
 
+	vbuf->flags |= buf->flags;
+
 	if (buf->flags & V4L2_BUF_FLAG_ERROR) {
 		state = VB2_BUF_STATE_ERROR;
 		vb2_set_plane_payload(vb2, 0, 0);
@@ -659,8 +661,6 @@ int iris_vb2_buffer_done(struct iris_inst *inst, struct iris_buffer *buf)
 		return 0;
 	}
 
-	vbuf->flags |= buf->flags;
-
 	if (V4L2_TYPE_IS_CAPTURE(type)) {
 		vb2_set_plane_payload(vb2, 0, buf->data_size);
 		vbuf->sequence = inst->sequence_cap++;
-- 
2.51.0



