Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017825;
	b=0wBDMlEphqJ6jYa1cqnQuKbQesiLXAD8hFDRFSvBHXpEcPtivpL0kMWwx5v5t02yWe+3
	 +OIDvHsW8leB3v+CiWKzsgV/j6WTJ2wXuMGg2jzUiDkWFgBYzfvHt8nUlS74S7Yz7w33X
	 jY4ENIP45LxpY/Au/ugt+6rjQN7R/mLZ05Ti82JEq4Hf+iYrZTltgzydIhBSY5h1GmF4k
	 o6UkqQjQTLj1agV2AL0/I/LX5b/1DbmlnJqrmMc8HgDtP50WBn3gYX6nmNofDwrzv/5Em
	 CBQE/lAu5UKMli5BgakAlH4RT3O6eDC5GAC8TSbrmNEDA5LWVzFUOpz4VsqjwHVMHDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xooch0IKFM3oAfxSQax4CDDk0984Po4ukj+gAjE2KYY=;
	b=GGQ/TpVVwqnQb4V2TLWInQC+YDV1c5L3WPTkWKRHlQ3OXsWCEbPnma8+6YfId3ghMY7M
	 cOIa18+hLdQbLEydyVsyXT5wTg80lXSmjKKLvLqHVQHsmzIld5vlqNSwUejWv+09KyJet
	 la/qcLjZFAbsav7O02g2/7UkHYzpUrd93R05okCd0mSTs0ZhXeU1/96jwWuFuZYa3f39y
	 DDPwLUjftJI3cq8liWbdJ+9x+JPkc+6nnUip2kJ0G8N2KRdUcnd5xfASrUFXZzbUkOLpQ
	 wFnzYHJcfdXA42cWcRai2C2wWrttM0OyItgnlT6pw1+tYTOCGGJkIEgBuRtGA2rNA6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5Bsv8bf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDC1606A337;
	Wed, 18 Nov 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5Bsv8bf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB2A1F000C7;
	Wed, 18 Nov 2026 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017825;
	bh=Xooch0IKFM3oAfxSQax4CDDk0984Po4ukj+gAjE2KYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5Bsv8bfFIpe7w6ovXXcFWhsdzU/MiYpS4bwVQjaXmNSuVHl3jMkOea3vtFj2fuwv
	 fXakM+/Kj0/joYo9OUu7FkU3pEFY9ykosnsNbeYf6H7A3JNNKnQtU/ZCvn4yFQsbIw
	 7oLAdtOOMXl4rdzfunjFFsLS8W2+C0tfPp/2cfXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1022/2651] media: iris: guard against a NULL hfi_sys_ops in the interrupt handler
Date: Wed, 18 Nov 2026 15:37:42 +0100
Message-ID: <20261118150324.735115951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 95f9e9fc9336ca4e8fb4ff0a76ddbde2f60bdb09 ]

core->hfi_sys_ops is populated only during core bring-up, once the
firmware generation has been detected. iris_vpu_power_on() enables
interrupts earlier than that, so an interrupt (for instance a spurious
one) that fires in this window makes iris_hfi_isr_handler()
unconditionally dereference a NULL core->hfi_sys_ops and panic.

Skip the response handler when hfi_sys_ops has not been set up yet; the
interrupt is still acknowledged and the line re-enabled.

Fixes: d8a6a63372b8 ("media: qcom: iris: merge hfi_response_ops and hfi_command_ops")
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_common.c b/drivers/media/platform/qcom/iris/iris_hfi_common.c
index 8769ec61f1176..42fc854d4c054 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_common.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_common.c
@@ -109,7 +109,8 @@ irqreturn_t iris_hfi_isr_handler(int irq, void *data)
 	iris_vpu_clear_interrupt(core);
 	mutex_unlock(&core->lock);
 
-	core->hfi_sys_ops->sys_hfi_response_handler(core);
+	if (core->hfi_sys_ops)
+		core->hfi_sys_ops->sys_hfi_response_handler(core);
 
 	if (!iris_vpu_watchdog(core, core->intr_status))
 		enable_irq(irq);
-- 
2.53.0



