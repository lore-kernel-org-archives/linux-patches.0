Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A365158038B;
	Wed,  9 Sep 2026 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964244; cv=none; b=brNbhFIN916KXPVSbIZRlPviy1vj0K3nWV0pAbFmFAj14V4rBETNxfB0EkUFaL3tkv9dHPvI0B6VlYsYdcDJ1ClJgZRwl2sWkfK7UkhcU4a3/yWWN0oaWrF9LDyUVUVJflne58E1+9xD27BviI2bVrY5yUCa7J4tod+ICVzGS0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964244; c=relaxed/simple;
	bh=/Yc6epsN0S4CCU05LbzjPGTnC2hudCFlJDKdMRuHjOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9j7zGaZ3V5hqEhEYW/yj0Ad6Y1OF+5facP1ehDxKLGuuNx1uaEIXZ2Ji8ACV328c+td18ZFHTDcBQAqa/grgeQaZr4G6DLvKtQYotbUs2RKWdeTUjc51MTMKGftpv9JEq7BKfwX+eRj6tVqf1iahjWG6dng1i5p5fHtKmSky9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjfxDUxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjfxDUxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F174A1F00A3A;
	Wed,  9 Sep 2026 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964243;
	bh=9RHJ4x/9vIgsjhz6waV5qfAF94C4v+rPdUV0tx/C/lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjfxDUxhafQVlz48kIK3CMwYkBpXKiTvm+O6IYRyNaA1sE3gpuq6KEmyTvPYYLOg4
	 EkJ+r7dBYlL8ctMQOY2VFwArhezaGPv8Un7CO8asABxabYuxiVZ+TXIdW22TnFFvUY
	 YkCIhUfCrk1SRFU4/zGEz0IKGe31zGCDMMjShPuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 6.18 319/583] media: qcom: iris: fix state-change debug log printing stale value
Date: Wed,  9 Sep 2026 15:40:04 +0200
Message-ID: <20260909134249.055563781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

commit 460d3257a6dffc7f0bf58009daeb7e0b6eb2d9d3 upstream.

The state‑change debug log in iris_inst_change_state() always prints the
same value for the old and new state, rendering it useless for
debugging. This happens because the state is updated before the log is
emitted.

Log the transition before updating the state so the previous value is
preserved, consistent with the existing sub‑state handling.

Fixes: 11712ce70f8e ("media: iris: implement vb2 streaming ops")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_state.c b/drivers/media/platform/qcom/iris/iris_state.c
index d14472414750..e991f34916ec 100644
--- a/drivers/media/platform/qcom/iris/iris_state.c
+++ b/drivers/media/platform/qcom/iris/iris_state.c
@@ -60,9 +60,9 @@ int iris_inst_change_state(struct iris_inst *inst,
 		return -EINVAL;
 
 change_state:
-	inst->state = request_state;
 	dev_dbg(inst->core->dev, "state changed from %x to %x\n",
 		inst->state, request_state);
+	inst->state = request_state;
 
 	return 0;
 }
-- 
2.55.0



