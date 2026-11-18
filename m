Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024953;
	b=wEfGpfrLXVhFPDb05oM+OSth29aeCTYZa8GhRPj+p3mK5+IK2UVBvTZ+7JKPlexPDkw0
	 IRAuYNty6D1rdKgmiDRxqDEcds/ju0z33Jdnyi5sF+wfR3OOD+E9eb+4aecw41ltxhdvs
	 uiYHYNm3RTv92W0wNUw7ZroHWcdjOBrIjdfsrGgN5AgeHjhpk6VQD1PGwOcY7BD4CiM/v
	 +a0cPKXcB4CntS1zlPZC+KrU6lxZOhEOWrFOLyWd/3Ltt7ztsV1GGmiD/XMMY7qAtQVeJ
	 GcGCiMca4YmsbEhFiItW5yNWqGUpXd6oBfVNpxWCEIpu3CcwY2AhSVhWbv6QZ7ggyOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MpmUEzMlPXSsEFJW/xxGhRvgGoP6SiDEjcPeRTlI83I=;
	b=IR4vtUCe1QrYJXZC6s9wKrdCgeYgLC9d7tnRW9AKR/+jgMZTpYguwPVZRYoHLCJwq5p/
	 HNwgHCDI1Tr93WD/sdkHJRUS/TECOfNvOg3lghG17bnz4Mi9Yg6gFsciGMfEKTRGmnnDM
	 L+yRY5kaLRG+uqWptWWP+F6QH4XeWjpJ9EErM63tUJQp+2wQ6qpPQSkPu0SEbLtrid3rK
	 lPLuSF7FrxIz6ifXHUXDmDXs86omYZwrZe6vAnGt0r1XpB+olR6jGSCRRpyclRJcse7p7
	 BbdjY9P6SWmj4lc1rsLRE/RS4a4O/t4bBKBTPK8vPw6Wqb6mwx8q1jPuwpeBrXPDfQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LN760I8E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDCB606A330;
	Wed, 18 Nov 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LN760I8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D159F1F000C5;
	Wed, 18 Nov 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024952;
	bh=MpmUEzMlPXSsEFJW/xxGhRvgGoP6SiDEjcPeRTlI83I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LN760I8EOG8dnXAXf/IgbCZDJPiUaL6hX25SX7RUTOM4i7SzsFwciQGfpu72oVqrE
	 MnOmkhYw6eU9EYm7mhpLV8jHYvzlLwQQxXNt7zKweT+nX5QYNtQU0Nl7d9EDv6ieNN
	 l/6zsMwlL/dxeZNonUiC9ngZUxramK2P4vMF0nHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Sachin Kumar Garg <sachin.garg@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0870/2151] media: iris: cache work mode after computing it in iris_set_stage
Date: Wed, 18 Nov 2026 15:43:25 +0100
Message-ID: <20261118150153.896307578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9da050aa1f7ce..20c88e0617126 100644
--- a/drivers/media/platform/qcom/iris/iris_ctrls.c
+++ b/drivers/media/platform/qcom/iris/iris_ctrls.c
@@ -399,6 +399,8 @@ int iris_set_stage(struct iris_inst *inst, enum platform_inst_fw_cap_type cap_id
 			work_mode = STAGE_1;
 	}
 
+	inst->fw_caps[cap_id].value = work_mode;
+
 	return hfi_ops->session_set_property(inst, hfi_id,
 					     HFI_HOST_FLAGS_NONE,
 					     iris_get_port_info(inst, cap_id),
-- 
2.53.0



