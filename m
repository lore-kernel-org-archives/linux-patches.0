Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E22541A508;
	Sat, 12 Sep 2026 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208550; cv=none; b=laSqSs50Rx01QBZmS+f4N3poolHv4KMU8shZG803N+LPJDLCx9xqPDGGliPq/1weB1vd1+pum5AdyIHpRadfs7rEHDIUquHrXlxbzkAFf5efwX0SZ3iCgnkjHjLwWHkFUSCJTWgqJfD6S68WbMTBpWqTVS/GoY60ioD+otJo304=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208550; c=relaxed/simple;
	bh=N+hb7w+DzWWZqmE67yE5pk74+2Alt0eqH9/oymfsN9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EaoatvJi7OA+IffLVBvxd7ppt1reg4qOMr6ZPiFYtdhvpCeI1av7TENSA67fFpu5dbRAdvpuN/78i4AjVTwrs8W9FraovO44Sxf0LlENSViONm5OGQP65xXPqUfU7t8FpnIg6b/o9SDxhH74i+liyS1sKH2spvoMnONfCQsv9jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2UrqUnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2UrqUnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2751F00898;
	Sat, 12 Sep 2026 10:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208544;
	bh=JOmLbkXal3Cp/gzGxdJYjOYsz1vcoZRnhqDLeiwNJjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2UrqUnnFDaA4gbQ1Dd/EOQG2B/dJNn4tk3T8xMUvedyTesZlellAb/+5uevQ4C2a
	 TkYBsxF4zZPlq765/GfbqAYWUM1K5V1ydcozsdAAbQSej5Vrzq9lyrxXqw/+UuDIns
	 iCB+PTHa+qOe0CNry7Q4J0VBxoHOh+/dHd5O+pOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0637/1518] media: qcom: iris: Fix bitmask test in iris_allow_cmd()
Date: Sat, 12 Sep 2026 08:46:46 +0200
Message-ID: <20260912065637.841126450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



