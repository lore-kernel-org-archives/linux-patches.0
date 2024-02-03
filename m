Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FB2125BC;
	Sat,  3 Feb 2024 04:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933623; cv=none; b=prTvVMRTw9RrV9Wfa7l6KCyeIo/dCEnIjb3v7rZ4qMOiBeeQ/ERirMzfiR8jcNFHMgPIuQlUCapD9OPQf+82pIXEW0SZhA1zfzZp9m6Vm1fqRZrGGwHVxZ9eBkkmPi3GHGUqSh4OWYiVFF2ftR5VeOoGpdU1hToQ4eRe9r8Bqcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933623; c=relaxed/simple;
	bh=jZ+IORVVzVb+kSMDnOFFjIoJekM+8DH0zjf6Ec76G7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmSCnQZDeWsmImSo+4Cys2JlVp5vOOg1NNXCva8ZPW5kcTXi/6HtvIQmV/YZtf2EmiR2MElZN+XavuwGq2V8e8rt60aJMH6NkrMN/BURynKi718rY4kC430MqgC1IAPdh8t65Cq6B5ZA7hAMLQmHm7TkSX9ZAVPUUKNv2SY2f3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJNP+T/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJNP+T/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC25DC433F1;
	Sat,  3 Feb 2024 04:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933623;
	bh=jZ+IORVVzVb+kSMDnOFFjIoJekM+8DH0zjf6Ec76G7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJNP+T/QolwC83xQSzYDIO+vfnzSExqtJx/LrmsKRIGqG6JsWqs0Oao8mnzGVgDNw
	 aQkOPWnwdifvsh5hWQC6sr3HWNzpOjK8XN9Csyi/nUwou7SHnvBEVxDo4iw12g3osF
	 d0gxnKAOr0sUVXdI5JK+PfK2bzKGBDdv4K2KOLxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/322] drm/msm/dpu: fix writeback programming for YUV cases
Date: Fri,  2 Feb 2024 20:04:56 -0800
Message-ID: <20240203035405.668278131@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 79caf2f2202b9eaad3a5a726e4b33807f67d0f1b ]

For YUV cases, setting the required format bits was missed
out in the register programming. Lets fix it now in preparation
of adding YUV formats support for writeback.

changes in v2:
    - dropped the fixes tag as its not a fix but adding
      new functionality

Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/571814/
Link: https://lore.kernel.org/r/20231212205254.12422-4-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
index ebc416400382..0aa598b355e9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_wb.c
@@ -86,6 +86,9 @@ static void dpu_hw_wb_setup_format(struct dpu_hw_wb *ctx,
 			dst_format |= BIT(14); /* DST_ALPHA_X */
 	}
 
+	if (DPU_FORMAT_IS_YUV(fmt))
+		dst_format |= BIT(15);
+
 	pattern = (fmt->element[3] << 24) |
 		(fmt->element[2] << 16) |
 		(fmt->element[1] << 8)  |
-- 
2.43.0



