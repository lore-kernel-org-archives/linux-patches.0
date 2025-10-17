Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D628A330B04;
	Fri, 17 Oct 2025 15:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715791; cv=none; b=s7U+Ah7VovJeq7aNspgjdlW8YoZF1WQ7NbGpauygTxGzApW0F7R3a0VIK9D2Mh3lTWZVhAToEgJTJ9PEWlGK2vjohEEzhFU2xVUzFJzjbTGuYm/CISiEhXuFQ2UDPpxNkVfG9gIvQaQw6/WoSb6Cce7IRgnNHBYTlc3p4gwP5nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715791; c=relaxed/simple;
	bh=dib6tAuKu4wS+x37ZT9c016cVyi42HeUihF0DXzCCTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmGiDrqLNKrQZCxh1h7hDWy1V7gAlElS37o2ZKHKRxDY5HHYOgG58sFfGby91DIDwAbtPWqLtCIVk0c/oX1ux2T/CWVCf4mdphlA2e+HfyzIhaCgt3qReLAzVPFdqeOay36Th+SST53nRCE2yNkjgiGW2kWe/duanBfeE14OCNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRTbzuX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRTbzuX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC00C4CEE7;
	Fri, 17 Oct 2025 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715791;
	bh=dib6tAuKu4wS+x37ZT9c016cVyi42HeUihF0DXzCCTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRTbzuX0sNO1iXqdyER0WYUv9x8sP/sj104Nn1cKfD+qeOz3NgfV4hGSW5mLQeiKm
	 o2M2Tj2RmzCCN/tOPGkZMILY3GR/fnlbUgTKZ101OVK96Hs7csTjyImzIA6ieOxmq0
	 PfruMHw1jG4/W0YWKNyrAjPuf09C7BwycAQZdqw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.17 337/371] media: iris: Allow stop on firmware only if start was issued.
Date: Fri, 17 Oct 2025 16:55:12 +0200
Message-ID: <20251017145214.275771195@linuxfoundation.org>
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

commit 56a2d85ee8f9b994e5cd17039133218c57c5902b upstream.

For HFI Gen1, the instances substate is changed to LOAD_RESOURCES only
when a START command is issues to the firmware. If STOP is called
without a prior START, the firmware may reject the command and throw
some erros.
Handle this by adding a substate check before issuing STOP command to
the firmware.

Fixes: 11712ce70f8e ("media: iris: implement vb2 streaming ops")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
index 3e41c8cb620e..a3461ccf170a 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -202,7 +202,7 @@ static int iris_hfi_gen1_session_stop(struct iris_inst *inst, u32 plane)
 			inst->flush_responses_pending++;
 			ret = iris_wait_for_session_response(inst, true);
 		}
-	} else {
+	} else if (inst->sub_state & IRIS_INST_SUB_LOAD_RESOURCES) {
 		reinit_completion(&inst->completion);
 		iris_hfi_gen1_packet_session_cmd(inst, &pkt, HFI_CMD_SESSION_STOP);
 		ret = iris_hfi_queue_cmd_write(core, &pkt, pkt.shdr.hdr.size);
-- 
2.51.0



