Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9257F245012;
	Tue, 26 Aug 2025 11:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207400; cv=none; b=MzIm/nxbpBRxzHbsgG1sQ+9CqwTAZkAYnZxgKrt+L/8aprWNpAqt4cb4axTYNZ5Z0BJ/KSAECMnfrmFHDV+fmA6NjyF2maxrR2VQ5RQ/yRn+MjH6J6lDgTpydL1T/UNfq4aJFvJDROCyco0s9ZSg49FqQuv23E8Ag5MHuixHWTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207400; c=relaxed/simple;
	bh=d50SzxnAb4GPmi8J/YYKiq7EXYDu8yLO1zxiPEPGdUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAteRK7Hxu7tr4OnAabCSgkFjrxYRxO7VsB0k8YzKVoxfeya4NFftdqqwi405hfjy4uu14vEFWFMsT038VzQrQwdSx8QTKRzEjXKw3dTRCW0Pmhy1a4Zq62AGG3BMLnTLjITuAjYlRHKqG0wykkALNSIjDy+3GF0ue+wID4/N4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwP+LMt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwP+LMt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1CAC4CEF1;
	Tue, 26 Aug 2025 11:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207400;
	bh=d50SzxnAb4GPmi8J/YYKiq7EXYDu8yLO1zxiPEPGdUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwP+LMt5S5pMI4R/2tG46mGuBlgmeAl/IbsOV08kZxyFpKXuxCEm/Z227RT1bdnXE
	 B0E4n7X/nQtgmkLMH2q5Ol7n9FJkJNUMIF844HBj+edBuHtiAJiwyHxv9TCv7iLKZw
	 oMznxNuq0QD85oKfRoUHkCI96WuASMWONr2RnNJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 167/457] media: iris: Remove unnecessary re-initialization of flush completion
Date: Tue, 26 Aug 2025 13:07:31 +0200
Message-ID: <20250826110941.503440285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit b7a898184e74a8261c34f1265139ac1799ee4e1c upstream.

Currently, The flush completion signal is being re-initialized even
though no response is expected during a sequence change.

Simplify the code by removing re-initialization of flush completion
signal as it is redundant.

Cc: stable@vger.kernel.org
Fixes: 84e17adae3e3 ("media: iris: add support for dynamic resolution change")
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
index aaad32a70b9e..c8c0aa23536b 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
@@ -201,7 +201,6 @@ static void iris_hfi_gen1_event_seq_changed(struct iris_inst *inst,
 	iris_hfi_gen1_read_changed_params(inst, pkt);
 
 	if (inst->state != IRIS_INST_ERROR && !(inst->sub_state & IRIS_INST_SUB_FIRST_IPSC)) {
-		reinit_completion(&inst->flush_completion);
 
 		flush_pkt.shdr.hdr.size = sizeof(struct hfi_session_flush_pkt);
 		flush_pkt.shdr.hdr.pkt_type = HFI_CMD_SESSION_FLUSH;
-- 
2.50.1



