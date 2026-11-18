Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023771;
	b=TmqVHhLDBAf3/YN+n0NOXvhI2rG4GtASnag0DmZKfp3hjhzHc5khzmxN/vT3MlqvSesa
	 eS0ENBvFaICFU1YNRFW3V6iRS7qIK1cunEKnIbb009gcDzKx5mk10HG9MY+1boZHV4uIK
	 VrsqhIht140v01XrWVEMUJgH+q7muVY8KOPTPaNBKsjk/E5LlJPpeeKtWBzo0ng2svEcY
	 nhqwuFcCKCF5WPsHGEwq5kiln0usIQ3aF9o/8NDZNrPFiJR2yrFjHptcOGpJpPecAPSqr
	 HTpIy+T44JIZf8SCccIIurjf27Idr+QI1+FAH570g9IUGZXdbyZfEVwbA1onR/H1KWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YZI+PP+HyPYGhN9gPFytTbkic4ZV10L96ObOFVSgWW0=;
	b=KfLpBQ3xK/zwryD2c7eZuvjJWX0LZaI1mG25iGKVuqgmXvl9aWjJ4IqY0cOecSRXMBZw
	 Q5FkSQXeQu0QVAzbgZFiEBYa2Z/zGHSk+MhdObgXiDJOVK/d2ey/0zOrgRCXiGdPGLhrk
	 qKAKFXA4X4s1K+MBiVz0d/P89qUCNUPL5LGpiC+4BtpoeRb047Ozrwk/+aY3+CFFSgufq
	 YrSewqPWqtuxKkdvxggsTl9BPQ3m9XLkIT9yxb0h9Wa5eUJIW8TjGWS7x8vwkSjmngPsk
	 M0NISQ3nqj/0qmeDhLv6DsNy1ONjdU/z3DPwfdbsG8yeXsDW2rqG8j4CptTOPkIV5NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drKRhwXv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906DE606A31C;
	Wed, 18 Nov 2026 17:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drKRhwXv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900E21F000C4;
	Wed, 18 Nov 2026 17:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023771;
	bh=YZI+PP+HyPYGhN9gPFytTbkic4ZV10L96ObOFVSgWW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drKRhwXvXMfX49QSg3Hlhkif8Wezv4AYfBPNxEf+NvoVPNcWprz64VfeyKf0/WSGM
	 XwJ8ZiLOyTbIoE12TrS+UC+k7qxAmUY4A1PLPz+pd9H7mYxe1sYAucyo88cMnO7zaC
	 3M3937jbCb0s0vGfRBKDFblm6MVufCEo/as/4cuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0489/2151] ASoC: SOF: amd: fix amd_sof_acp_remove() teardown ordering
Date: Wed, 18 Nov 2026 15:37:04 +0100
Message-ID: <20261118150139.865240849@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit db2167f2e3f72db64d01356cc9f2924d32fd5a51 ]

Call free_irq() before amd_sof_sdw_exit() in amd_sof_acp_remove().
amd_sof_sdw_exit() sets adata->sdw to NULL; if an IRQ fires between
that point and the subsequent free_irq(), acp_irq_handler() may
dereference the now-NULL pdev[] pointer, causing a use-after-free.

Fixes: d948218424bf ("ASoC: SOF: amd: add code for invoking soundwire manager helper functions")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260910132251.1171943-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index f615b8d1c8020..df43c6000a063 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -949,12 +949,12 @@ void amd_sof_acp_remove(struct snd_sof_dev *sdev)
 {
 	struct acp_dev_data *adata = sdev->pdata->hw_pdata;
 
-	if (adata->sdw)
-		amd_sof_sdw_exit(sdev);
-
 	if (sdev->ipc_irq)
 		free_irq(sdev->ipc_irq, sdev);
 
+	if (adata->sdw)
+		amd_sof_sdw_exit(sdev);
+
 	if (adata->dmic_dev)
 		platform_device_unregister(adata->dmic_dev);
 
-- 
2.53.0



