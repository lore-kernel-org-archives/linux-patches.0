Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72DD56C62C;
	Wed,  9 Sep 2026 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962772; cv=none; b=swMoVkHEtg/5Od2lMe7TxEVSmOmKKmL2snfUqLlCbdEINubZG0IX6qx9PUJAJm7TFYQAWV1bvqILZdMW5UjbQTBpPTOWus6GtNsqMveVwe/Fqku9bPgKgH4vBgAYV5hRQQ5Jhad7duYeWOnZSIF/DMbT89i5M8kp1BC7Th16gXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962772; c=relaxed/simple;
	bh=FJn0+cmvNeqYFtxnAIqsbuC9RUNz4wG9EjnJ/MvoJL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D6fOkUW4dWQsVFcktO1XXkY3NZaJv8viJNbKwO/plbLP4nNLHyF/OTDkYevvSb9ZAD0wSOO8wbJ0k1TxMUxaBNIMRpm6msO42HrgqQ2QwUuSS4BxEA7tdWMpXx5xirJQoIbdgCfnZL3ipVaSwa6tRt9AZT+PF4q2JGgv3TZas+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyebHm5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyebHm5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0CF1F00A3A;
	Wed,  9 Sep 2026 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962771;
	bh=zUDi3wfzQugXtm87hRuAdPQxwNooW8dDr/babCBo88Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyebHm5ejopY1HmtWetBKBv0wOYH/Z1IuzK0FpCGDsn+U743JTfBCU52E+xEeJJsI
	 LwI19UAnUuY1w81bwldYyJPXJfiidIPKKPRACk4tu0LRaUi2lcZK9cg2nLw/aawb50
	 RUKKdvlSl/u6dE3NUs+zkvXejb1OrX66tZyXnZBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>
Subject: [PATCH 7.2 406/556] media: qcom: iris: fix state-change debug log printing stale value
Date: Wed,  9 Sep 2026 15:41:26 +0200
Message-ID: <20260909134244.911085996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
 drivers/media/platform/qcom/iris/iris_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/iris/iris_state.c
+++ b/drivers/media/platform/qcom/iris/iris_state.c
@@ -60,9 +60,9 @@ int iris_inst_change_state(struct iris_i
 		return -EINVAL;
 
 change_state:
-	inst->state = request_state;
 	dev_dbg(inst->core->dev, "state changed from %x to %x\n",
 		inst->state, request_state);
+	inst->state = request_state;
 
 	return 0;
 }


