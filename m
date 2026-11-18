Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017833;
	b=5ANA/P1VWEYum7zfuN8WV1rld4bFJbCVDAHlStWiXayzqoC0mwfJc/E3ZGm2/rRk3grq
	 MwPj9YxkDHbvI4PFE6kyf+nXxlLxSgINXCULXJ6Q+zx5FYKhvZIHLyRllv01fGHTMyDJs
	 dYBbYIq7D3RFIjnqq6gzNhfNHTNoMtlmM+5E7+JDn8jMtJBSptyODBPBKzoM6r2Tj2dIF
	 P4lnRCxYi9tlnI/DgLasYKTJ92BgsKdrcfDTPJIxKcS3AYi8NTUloIZJlcfZiM6EHk3Jq
	 ieeXpG4db5si4JVXwCjXxHqJwWDuElHBEhcRYCPUq8SFIk2F8+97cUIReaAjHA/A2Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1B0Gyd+ZPWSSEbdNP65ww6FT7HVeAANBcbZjmbm9Hg=;
	b=Hk3tTvTO4BxoEagG4oR/uXRk22ftiF44vx4NUufM0P0ROThdjw6TVLMHzqSLqGbT2s7t
	 zzUaPRvdLNzwjp1WG75KyVroZBN/0GUJYJ/109FcdhVrQtrXkd6ITtR6mXfzT0hz8OUTX
	 TFt2VAz4GFvNUD8ZR0PRPNCWO021BumcnMEqMIjy/5nbW0SirdfCRTk4HxvBdvZeG3nEy
	 Teb4vJtU2shgTarK2/iylU34NZ2Xt/IVIhn+KzcMRSGr/vihBUDyaS72rTqmliNODjYNj
	 hGhnwOZTiIzTz38Dg9Cy6PEhLaUDkBZI2FOAA0tI53TyRFZCkqH1FO1Wc8Hby9Thgug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trfQBf9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1337606A31C;
	Wed, 18 Nov 2026 16:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trfQBf9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E8E1F000C4;
	Wed, 18 Nov 2026 16:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017833;
	bh=U1B0Gyd+ZPWSSEbdNP65ww6FT7HVeAANBcbZjmbm9Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trfQBf9Dg7pfVhourgIBn/i5TGyXv+fuQylBC0wxSsH0T1ICIOVOBbTVaUnnEQFWc
	 XXx1+cPf2AOlmuebAYhDzAIHmbu9ZNH4BM3vHKSC2O0nmNYyuKYpv66gFys6wcsVuW
	 LbKoyCbOx/F3GkAvbPhOlu3QTX4DDj2JQNKAFavo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Sachin Kumar Garg <sachin.garg@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1025/2651] media: iris: cache work mode after computing it in iris_set_stage
Date: Wed, 18 Nov 2026 15:37:45 +0100
Message-ID: <20261118150324.850778327@linuxfoundation.org>
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

From: Sachin Kumar Garg <sachin.garg@oss.qualcomm.com>

[ Upstream commit 1237888922a71897326495f848766412fb74307c ]

iris_set_stage() computes work_mode and sends it to firmware but
never updates inst->fw_caps[STAGE].value, leaving the cached STAGE
value stale. iris_vpu_enc_bin_size() and
iris_vpu3x_vpu4x_calculate_frequency() read this cached value, so a
stale default causes them to miscalculate buffer size and clock
frequency for sessions actually running in a different stage than
the cached one.

Update inst->fw_caps[cap_id].value with the computed work_mode
before sending it to firmware, keeping the cache consistent with
what is actually configured.

Fixes: 3a19d7b9e08b ("media: iris: implement set properties to firmware during streamon")
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Sachin Kumar Garg <sachin.garg@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_ctrls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/iris/iris_ctrls.c b/drivers/media/platform/qcom/iris/iris_ctrls.c
index bf17d310eac08..232be0cb7fa07 100644
--- a/drivers/media/platform/qcom/iris/iris_ctrls.c
+++ b/drivers/media/platform/qcom/iris/iris_ctrls.c
@@ -525,6 +525,8 @@ int iris_set_stage(struct iris_inst *inst, enum platform_inst_fw_cap_type cap_id
 			work_mode = STAGE_1;
 	}
 
+	inst->fw_caps[cap_id].value = work_mode;
+
 	return hfi_ops->session_set_property(inst, hfi_id,
 					     HFI_HOST_FLAGS_NONE,
 					     iris_get_port_info(inst, cap_id),
-- 
2.53.0



