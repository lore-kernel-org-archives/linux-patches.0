Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CC414EC58;
	Tue, 23 Jul 2024 18:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760036; cv=none; b=Z5/vbqaaOzZMYaUuUoTDPYuY6SrP1D02KvAubGrdQnpWixcsVeNEKLDIhs3adlaYIVFJpkfoJCIZlqzFmecLvt+axL0j1NsYNkxIBIOXaqgeO1BPznHRiT1T56/NjMirTFWSHH3gUo7a4aOqBrloS5ZT+9sPRL/ZKvSAcBc1ZaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760036; c=relaxed/simple;
	bh=1wcc7Yaz3nkReryr6/LwF6DbfniYTtnTcRdVlaVaXT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTOokhSVh+XKXHOs7aICS6wtgx44ZasB/kJi5InMKe4+slMgW+1G0W8oMJAQUoWaPLnARuoO+ya65QimvJdmBLAdKGukc1rzwg0OYUzW+CLu1cmG+Q1X6CRiKRNs1YcNNnQUPrqVcoTCOhBPbF0emAHif85G901O+X40PMxCOM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMJmjeUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMJmjeUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3185C4AF0B;
	Tue, 23 Jul 2024 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760036;
	bh=1wcc7Yaz3nkReryr6/LwF6DbfniYTtnTcRdVlaVaXT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMJmjeUUYsfHQA8iIOTAUnq0CA2/xMNqhTeg3pNJ2JaOOE/FSqtxxFmKj5m1WG7Ox
	 rTRinv9id+dJAIbpEyhwm1BEcuHYTPDfhXua5/wWPSYAO2OX3tP1UekF9eEueQsc2+
	 TQAqeo41NvSIM9GD4ymr3e9Bfc56B+1QA2jLmkd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 082/163] drm/amdgpu: init TA fw for psp v14
Date: Tue, 23 Jul 2024 20:23:31 +0200
Message-ID: <20240723180146.640330533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Likun Gao <Likun.Gao@amd.com>

[ Upstream commit ed5a4484f074aa2bfb1dad99ff3628ea8da4acdc ]

Add support to init TA firmware for psp v14.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v14_0.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
index 78a95f8f370be..238abd98072ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v14_0.c
@@ -32,7 +32,9 @@
 #include "mp/mp_14_0_2_sh_mask.h"
 
 MODULE_FIRMWARE("amdgpu/psp_14_0_2_sos.bin");
+MODULE_FIRMWARE("amdgpu/psp_14_0_2_ta.bin");
 MODULE_FIRMWARE("amdgpu/psp_14_0_3_sos.bin");
+MODULE_FIRMWARE("amdgpu/psp_14_0_3_ta.bin");
 
 /* For large FW files the time to complete can be very long */
 #define USBC_PD_POLLING_LIMIT_S 240
@@ -64,6 +66,9 @@ static int psp_v14_0_init_microcode(struct psp_context *psp)
 	case IP_VERSION(14, 0, 2):
 	case IP_VERSION(14, 0, 3):
 		err = psp_init_sos_microcode(psp, ucode_prefix);
+		if (err)
+			return err;
+		err = psp_init_ta_microcode(psp, ucode_prefix);
 		if (err)
 			return err;
 		break;
-- 
2.43.0



