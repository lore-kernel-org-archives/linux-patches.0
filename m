Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625116;
	b=r6JU4SfUyf1tPg3RN91P0HAbfWZtx5JWlD42AxD5uRNek8vYgRoKpWb88Pc2ZggBzqDc
	 jYAfPon/3XngkOAAcz9n4LpqPTxfvJNtFiKN4CeULR26qCmxCZ3iELSfwOS7YkimdaB4x
	 iJgOx6ZMVP2MpuZU7LCNOjYliwlAdEyh9B3kEOIEyRhQDPq3OzT/U3BaRQc4SUa8105lw
	 jI/RGh5RZZ19EUzJKL8zlnqjucSbiROAAauoLW7ghUbf4ud7qBRiqE3qS7d9CjIqpu0Gr
	 HEIJLAqtD0yiTLIkW1f9ESDMkifDEGyfOh05yeR5aVyReWZ1IwAbnNC/XWbcMN9J0Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bYnbfVhffaRAyG4+5T2T+Hw7KUbNu5O6YS2Zxwq+eAA=;
	b=SD9fV3rW4CQC7nI+QV7PBLAyyBcUSKTSHcFSFWkRpXoi4W6fBvbsBeSyCEMn52gEk6o3
	 5hx6YcbuVBZL5MiG69fVhm6LfuFtysWgrd6IuC3Co0fULh82jC85NWsaID4s1VsQWu13R
	 1HZJYVVve6d/8YKCkXppd/aBDdKfM+Aprp0hs1n8XqebT6/MZScFJnqsJ/bC54X2ByBKd
	 F0FzWOqDv7PHFfVb6K1qPftTt4RjL0TndxpMXv11pRj/NfK8HLdMlB1dVNRy2E9XoYmEj
	 nbjV13Mkq1ICxNaynlLrhtMSKRFYVZUbc92R8rPsaGhbgCT41VcusHEHp+Tsg9oESTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCBXNxzO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C03606A330;
	Wed, 25 Nov 2026 16:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCBXNxzO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2041F000C0;
	Wed, 25 Nov 2026 16:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625116;
	bh=bYnbfVhffaRAyG4+5T2T+Hw7KUbNu5O6YS2Zxwq+eAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCBXNxzO1U0fU8cq7oydPk2jHhll4Q1rpqAi2uZ3Dz6NMp8OpXWB1k43DxcXqjShb
	 stpaBvzAPsOQ+wCHATK8itlwi3NEqybC8745hlQUSQT26nLLw+X7TXbw7BXEpc25Ni
	 EqHk0Bd6ZSNy16lzhATnTGTkpB221/1xPBEU4b0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/816] ASoC: SOF: amd: fix amd_sof_acp_probe() error unwind ordering
Date: Wed, 25 Nov 2026 15:32:38 +0100
Message-ID: <20261125143858.683599433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit b6aaef8ca8c305170de83e621c7e16d56731312a ]

Call amd_sof_sdw_exit() after free_irq() in the free_ipc_irq error
label of amd_sof_acp_probe(). Without this, an IRQ that fires between
sdw context teardown and free_irq() can dereference freed SoundWire
resources.

Fixes: d948218424bf ("ASoC: SOF: amd: add code for invoking soundwire manager helper functions")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260910132251.1171943-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Moved the amd_sof_sdw_exit() call after free_irq() in the probe error path, with context adjusted for the extra free_smn_dev label in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 919c7bc98bf2b..3de1c700a5a9e 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -955,6 +955,8 @@ int amd_sof_acp_probe(struct snd_sof_dev *sdev)
 
 free_ipc_irq:
 	free_irq(sdev->ipc_irq, sdev);
+	if (adata->sdw)
+		amd_sof_sdw_exit(sdev);
 free_smn_dev:
 	pci_dev_put(adata->smn_dev);
 unregister_dev:
-- 
2.53.0



