Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E240373BF3;
	Sat, 12 Sep 2026 08:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200256; cv=none; b=Bps1hOeISGEBU/p0kduS9olpt3yhWc7yygxsRhZivSRmLn5YPKRXt6ri1Vuh3qMFjA38cFXInMppCu2u7pgfakPavE2GFwP8Ko3aZmShKmRXX3IspO9exrvBT7UioQ0ggMLroKvf8jwyQVz/MP7RNFSjaavp3+H17UFG6wUJTSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200256; c=relaxed/simple;
	bh=9ngGdscmeuyPU+vC4QA33LPUhg+4ArsZageZXjXhOJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAUwflnzV7zY6guXzCNjaaNINZC4cQPsK8mQGZXlHOBoCAD9rlrXrBW3JbVZjrpj2565GNOzwMjqxKczoelGqYbjWkZuhhtVQncagODbR0yKjm6zbl+uT3Nuv4msudksrlg231caihp7oGk8rY67TUcHFZv8XjN+DZN9J9EsXqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUZCIx6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUZCIx6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBF21F000FF;
	Sat, 12 Sep 2026 08:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200253;
	bh=3cMa0K8jGEPpN/2pMNycTu9GVyK+aJyzX12gN0rRq68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUZCIx6uDxbjWgHCPW413aETy9pJfJrQsXcGgo6qEBgOM72CDtQj71jtDHBpuHNcB
	 wTfNB5zxzkcXj+BB3Qd2b8BX5CSppj17ZpfYZvffre4wFyf/Zg6hUZ3w/z/FFmK5Na
	 AFbsoxHbTj8UhGuN0PP74ZqU3KZPCojdjiQ/UZ/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0752/1815] media: qcom: iris: Remove duplicate HFI_PROP_OPB_ENABLE entry
Date: Sat, 12 Sep 2026 08:41:42 +0200
Message-ID: <20260912065706.560091658@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

[ Upstream commit 727a87c71b4ef794cdf552dae585d6f67be690ee ]

HFI_PROP_OPB_ENABLE/iris_hfi_gen2_set_opb_enable appeared twice in the
dispatch table, causing the property to be sent to firmware twice on every
config-params call.

Fixes: 2af481a459a4 ("media: iris: Define AV1-specific platform capabilities and properties")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
index ca2954f8bd3ad..ee2730c293bcd 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_command.c
@@ -692,7 +692,6 @@ static int iris_hfi_gen2_session_set_config_params(struct iris_inst *inst, u32 p
 		{HFI_PROP_FRAME_RATE,                 iris_hfi_gen2_set_frame_rate             },
 		{HFI_PROP_AV1_FILM_GRAIN_PRESENT,     iris_hfi_gen2_set_film_grain             },
 		{HFI_PROP_AV1_SUPER_BLOCK_ENABLED,    iris_hfi_gen2_set_super_block            },
-		{HFI_PROP_OPB_ENABLE,                 iris_hfi_gen2_set_opb_enable             },
 	};
 
 	if (inst->domain == DECODER) {
-- 
2.53.0



