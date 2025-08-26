Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5805317332C;
	Tue, 26 Aug 2025 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207443; cv=none; b=ppGz3LL6iqRWt6KjJ5kRrYpGVc0O7VCqVEDMSIJkhTcztBLDoi+yzJs3uk60xccb8xMrrIECBBPnNoK/gFEuUrMuSW1xS64eWv42ubiV1mGHFt75vZkpTbT5mlcw7OFekmxdVxIZZIjlEnTrnmRQ23HQckb67kC/lIBz14/np7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207443; c=relaxed/simple;
	bh=ebRAafDNC6ZFUmsaZK/yiIMn5DSEyqbDJtN/Q7HjNkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnDDmHx1EJJwHSHLyUe03pTNeAFmL69jrBvLpwQrA0FCsW0HoASTBlDuDu7PwKxFsGrgXFWeS5tYKeO+YuzX44zDBQRUG5Ev1dmD7eM4YoepaET43PrQxiYbVmI7Fg8csnuKKwsLQSesgWukxQk84fF5w57oFhojW9QZeF5g+Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+uIIbAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+uIIbAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC704C4CEF4;
	Tue, 26 Aug 2025 11:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207443;
	bh=ebRAafDNC6ZFUmsaZK/yiIMn5DSEyqbDJtN/Q7HjNkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+uIIbAcRQDolOU1TaiKWAipGmkp2WgeETyYrtlPT1ddpIU9LJvJnUAucoPAeweFV
	 aERr8vHGolR8yhEU9vsLTBNyWgRix76/Yif8ZsmyP4ZYc7XDKfqrkt34VKuHnYQf0r
	 9BBpeF/SNfcbpKgklAshAV4kiKM+GATpYC3CqD+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>
Subject: [PATCH 6.16 152/457] media: iris: Avoid updating frame size to firmware during reconfig
Date: Tue, 26 Aug 2025 13:07:16 +0200
Message-ID: <20250826110941.129011120@linuxfoundation.org>
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

commit caf2055487694b6cb52f2ecb161c6c5de660dd72 upstream.

During reconfig, the firmware sends the resolution aligned to 8 bytes.
If the driver sends the same resolution back to the firmware the resolution
will be aligned to 16 bytes not 8.

The alignment mismatch would then subsequently cause the firmware to
send another redundant sequence change event.

Fix this by not setting the resolution property during reconfig.

Cc: stable@vger.kernel.org
Fixes: 3a19d7b9e08b ("media: iris: implement set properties to firmware during streamon")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
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
 drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c |   15 ++++++++-------
 drivers/media/platform/qcom/iris/iris_state.c            |    2 +-
 drivers/media/platform/qcom/iris/iris_state.h            |    1 +
 3 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -546,14 +546,15 @@ static int iris_hfi_gen1_set_resolution(
 	struct hfi_framesize fs;
 	int ret;
 
-	fs.buffer_type = HFI_BUFFER_INPUT;
-	fs.width = inst->fmt_src->fmt.pix_mp.width;
-	fs.height = inst->fmt_src->fmt.pix_mp.height;
-
-	ret = hfi_gen1_set_property(inst, ptype, &fs, sizeof(fs));
-	if (ret)
-		return ret;
+	if (!iris_drc_pending(inst)) {
+		fs.buffer_type = HFI_BUFFER_INPUT;
+		fs.width = inst->fmt_src->fmt.pix_mp.width;
+		fs.height = inst->fmt_src->fmt.pix_mp.height;
 
+		ret = hfi_gen1_set_property(inst, ptype, &fs, sizeof(fs));
+		if (ret)
+			return ret;
+	}
 	fs.buffer_type = HFI_BUFFER_OUTPUT2;
 	fs.width = inst->fmt_dst->fmt.pix_mp.width;
 	fs.height = inst->fmt_dst->fmt.pix_mp.height;
--- a/drivers/media/platform/qcom/iris/iris_state.c
+++ b/drivers/media/platform/qcom/iris/iris_state.c
@@ -245,7 +245,7 @@ int iris_inst_sub_state_change_pause(str
 	return iris_inst_change_sub_state(inst, 0, set_sub_state);
 }
 
-static inline bool iris_drc_pending(struct iris_inst *inst)
+bool iris_drc_pending(struct iris_inst *inst)
 {
 	return inst->sub_state & IRIS_INST_SUB_DRC &&
 		inst->sub_state & IRIS_INST_SUB_DRC_LAST;
--- a/drivers/media/platform/qcom/iris/iris_state.h
+++ b/drivers/media/platform/qcom/iris/iris_state.h
@@ -140,5 +140,6 @@ int iris_inst_sub_state_change_drain_las
 int iris_inst_sub_state_change_drc_last(struct iris_inst *inst);
 int iris_inst_sub_state_change_pause(struct iris_inst *inst, u32 plane);
 bool iris_allow_cmd(struct iris_inst *inst, u32 cmd);
+bool iris_drc_pending(struct iris_inst *inst);
 
 #endif


