Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016419;
	b=hA0gUwYr7Upymekz4Xxe+vxxYV9qldRn713PNMZ+NjFY9h5dZh5Cbhos3Y+S3t9XXrwf
	 /TsEqZclfFVee9Hf/9EuoXrx0DaX03AcILyIq/2vf4H1ry1VPFoikkb/R/N9T43ONORj5
	 b5Et4emDlB/+SC2XPnJVLvCu0uOZ783mGSNsFDLa1XJkmoUAZkkJJGD06BMWwPLcl6QhL
	 rfj14M7CymJF/PdRHO31XgB0HgNsCupKL07INUoIjyPnQwLCM4lAeXOJqgiZkSyh/DZvj
	 p8XT/f3STWYJonYWVI92QIawMmwnJtXoyvw6sErTp9CtycNsVTUk3P5eMAP0XuA5XXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+n3/Q2aNxsAkhb6gCAO2vg/1BwOOAxzhG6ZqH3khh/U=;
	b=g7A4Rm1dtmXBFZK2MFFk3oshEtZq8TlAkAF+JOJTVP/C+dHe3k42+tkoDvKI6rszrO4B
	 ClvPrwuMAOHnJVQ7VjRCtjoN1VfYBSkwxLcctJ/VoIMnlbYY99WX0BtIN/6m39IU3HblI
	 UcdgMbklRen0z9UQmJlBTdIKwcvA6ngPzY8G3h9LCaopO7xEYBte/8ifv8HOUB0R1vODC
	 oaVmwN2ayc0cAZXBJ4W45PxDBnkZM8uepyirKm4fPyDBhxjxAyJ1lDQUFi7CqwsGBWXKP
	 gLvWhs5HlV+A8gqA9uby1+ylWgFdJOSRsjPE6GpGimQbo/wIMJadMjfvOwjqh7Do3ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bY/Zvso/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2055C60A2608;
	Wed, 18 Nov 2026 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bY/Zvso/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310BA1F000C4;
	Wed, 18 Nov 2026 15:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016418;
	bh=+n3/Q2aNxsAkhb6gCAO2vg/1BwOOAxzhG6ZqH3khh/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bY/Zvso/m9lir/GKLASVBtpzerZ6UuOBPWRwpH6edHV0b5cqqMqs5sXEMcBNfVWdw
	 Dc678TvRPvtPTkv2rwO3xe56qCaZ8hJMGdXAT2iG6EOwdp05YD0cpc3K++7LGOoWXH
	 Y9WnLtVdlcJXJbns3RRZ2Rjzcl7lyXgJjq3xxssM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0523/2651] ASoC: SOF: amd: fix amd_sof_acp_remove() teardown ordering
Date: Wed, 18 Nov 2026 15:29:23 +0100
Message-ID: <20261118150306.572917845@linuxfoundation.org>
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
index 688df7acd2e21..e4cdb74c075db 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -1048,12 +1048,12 @@ void amd_sof_acp_remove(struct snd_sof_dev *sdev)
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



