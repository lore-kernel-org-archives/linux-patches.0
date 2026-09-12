Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2AD36B924;
	Sat, 12 Sep 2026 08:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200250; cv=none; b=dE1/hKQnCZo6TC8eR92E2BMwQnVPGY71Aq1wzKptIERdd6zAOx1nR3DmDg3PNf1dDbauRhQndejyWh30xJIw/JSvo6+2SF2xASvDE/P7a7WmRDIDKN4YOGjo5SDv75pQ9OjIzc64E8hvgUaxyXmilc1le+fuPH44Ku6QBHD+IKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200250; c=relaxed/simple;
	bh=AzM+g3KAcuwn2iqzAAKI4ppO3Dso3P4HZZKnAMwhzrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h27toxr6u5T/J1uEolXQTh0ypgLwbJDbBE0R/02+sG4xzhDfxQhQmEPaUPEvYApE/2MUJziLvE/byW34nxlLETTml+/KXNtRXicT1bJhkWgJgOwU0bdYXRyLiKa4da2Y6wJOYPRfr64HGvwb+Gp25B+LghleXc/LkFUO7usO+L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNt8/lEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNt8/lEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14EF1F00893;
	Sat, 12 Sep 2026 08:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200248;
	bh=HpBdj0mYEmEoEUSNidxqrY8Vdonb07f+51AVdCtA7/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNt8/lEpx9lsFN+F/tJaxTcqZHh3m/v256i/UUwo6UNjFK2q36uWDsRsP+zdi2iGi
	 K/k0tUBtKVet0vCuH6Kx47DJnutdRAHZXQBIecgdV/2hexqdh5flGYLBgJhO7HSNTv
	 dhnEOC3DfNQbuigjDBZWqrTMph4t6uOvg51I59+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0751/1815] media: qcom: iris: Fix bitmask test in iris_allow_cmd()
Date: Sat, 12 Sep 2026 08:41:41 +0200
Message-ID: <20260912065706.536688621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

[ Upstream commit 0ac05c4d9f1fa25d0692fb154de36bd3baf2e7ce ]

iris_allow_cmd() incorrectly checks a sub‑state flag using a logical
equality comparison. Since sub_state is a bitmask, this allows STOP to
pass when IRIS_INST_SUB_DRAIN is set alongside other bits, violating the
intended drain semantics. Fix this by using a proper bitmask test.

Fixes: d09100763bed ("media: iris: add support for drain sequence")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_state.c b/drivers/media/platform/qcom/iris/iris_state.c
index e991f34916ec6..5552725c614ea 100644
--- a/drivers/media/platform/qcom/iris/iris_state.c
+++ b/drivers/media/platform/qcom/iris/iris_state.c
@@ -269,7 +269,7 @@ bool iris_allow_cmd(struct iris_inst *inst, u32 cmd)
 				return true;
 	} else if (cmd == V4L2_DEC_CMD_STOP || cmd == V4L2_ENC_CMD_STOP) {
 		if (vb2_is_streaming(src_q))
-			if (inst->sub_state != IRIS_INST_SUB_DRAIN)
+			if (!(inst->sub_state & IRIS_INST_SUB_DRAIN))
 				return true;
 	}
 
-- 
2.53.0



