Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0C0227599;
	Tue, 26 Aug 2025 11:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207387; cv=none; b=SuB/ImiGxztccCHh1woBjeyhedx8jetg+rhW4y20Z7EMa0+j2CJxPFQnVQ3L8zPlqIYUXBEy7kNwnARa0qdU8wXFlz14hk4WSLwTvKcRPpbZkZWt6TPAuPN8oFhYDEfnPs+t+6JsFsshcZW32gHUPqSDkhLIEPS+o39PTPadHkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207387; c=relaxed/simple;
	bh=402AmNbzrSa6vseN8isNuLbtky5TZr+AdgWnAyi0pXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKNxi7MbX8ynsV6wJj28HRhRORdE0TjKHJtmQO9+vgdOrcqxYHyYPhloF/hDOsRi+TYju/DKjaLE6Ab0xzMyzdUb2eUnmAyxA746tVXV/WHYnRpvPTe0uhOpMFPebUbo0tLm4HmBisBzJB4AxsgTpYWiobUIeBYjRsOmR6mDyI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTRNXsnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTRNXsnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257A1C4CEF1;
	Tue, 26 Aug 2025 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207387;
	bh=402AmNbzrSa6vseN8isNuLbtky5TZr+AdgWnAyi0pXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTRNXsnmbaEFBW8T1dAu4BxZpBnkUpIGubYtbSJrPsBjUH20cgDvZ1pHscxiPD/1k
	 qVLhZuldwb3D4i8kUQrvw3XiD7LPlYbCLnSMgptXMrJjzPUo/ATNb6VlCm3SDWozFN
	 f73gZjUniWpLEMh30FG2wmvmAUDyWKsaqNQBr/WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 163/457] media: iris: Skip flush on first sequence change
Date: Tue, 26 Aug 2025 13:07:27 +0200
Message-ID: <20250826110941.404142476@linuxfoundation.org>
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

commit 1e27e9ffce59ac41cde71673d74eb368a533cdb2 upstream.

Add a condition to skip the flush operation during the first sequence
change event. At this point, the capture queue is not streaming, making
the flush unnecessary.

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
 drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
index 271e14469223..aaad32a70b9e 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
@@ -200,7 +200,7 @@ static void iris_hfi_gen1_event_seq_changed(struct iris_inst *inst,
 
 	iris_hfi_gen1_read_changed_params(inst, pkt);
 
-	if (inst->state != IRIS_INST_ERROR) {
+	if (inst->state != IRIS_INST_ERROR && !(inst->sub_state & IRIS_INST_SUB_FIRST_IPSC)) {
 		reinit_completion(&inst->flush_completion);
 
 		flush_pkt.shdr.hdr.size = sizeof(struct hfi_session_flush_pkt);
-- 
2.50.1



