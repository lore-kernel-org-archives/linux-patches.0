Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016421;
	b=mTMhjpEWd+4nyOgfoWd5qqhL0k1SD9POT+VmDmtTnXc2RZpCenFQAsCoJpqtyZ0/ubzU
	 XCImPw+PXzgk6b+seTJ+a/Vo3Y+o25VJVlSQ+LxFGrZDkt7zumOT/0/TCK8d6evpQzbN5
	 /rIrHBDkJu03ObApKfHA1qpik20xFzroyfaedGWVVGOsoTkGgXR+mmZ1hvuvWsWXENQM/
	 czxUc7HZNrPqlpcWXL/QwS/tnq7YI7NA+Tja1FYXkVy/EUnHNONpT1dtqk1NL3IZ+n2p4
	 cl4Qf19FSEgAZHiq2H5lYhFJHMbYiEnSfdiyrhLCKeDoUmoH7x0Aj3JIdt9KMHUJ+uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZJbpcJ5Cx07wSjUL8N3O1/Xj8ZwiuwzcukOOlKfNTGQ=;
	b=MPq6VJrZEhzSKnNql70ZCGsQ+Q1kbaFSAlddugX1YiJvfPzTuhSRircN8l0ekhuy3jKp
	 UWBz/Pq8k2tbmI9z+CvCwbjLP/ZJzlvmQEBIIarNLlktjBC9eiytqJcggIhi1mqbrILtP
	 trstGvDJHgFdXwuwwMiBto4SR5gjyLoI9Lgcqy8TQN0XuUCo4efVb/ZlHjrJzpbnVV/bQ
	 JlSxq2VxbLCrV6HUNUNt9ENNzL6FY7eXxXJCgkZPqbtIXRg8AfMW2eE4utJSdJOWfKlAw
	 g6NjmhOkUsEpJBMG9Kxx1bDNDVaNjAGj6DUz8irw/wrzVzNLiTqIJfcECpPDVUKVwKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwY1gVEu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F99260A2605;
	Wed, 18 Nov 2026 15:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwY1gVEu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA75B1F000C4;
	Wed, 18 Nov 2026 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016421;
	bh=ZJbpcJ5Cx07wSjUL8N3O1/Xj8ZwiuwzcukOOlKfNTGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwY1gVEuA0PVJ5OUS3H92YKGYDw7MNXAzjM0qlm8xfT1/8bdR5WFmzMi7bT39xFbL
	 uz/dXrMS98FAGBIXE2zoCu9/edId8Ux/rwSyBzsHiMqc/Giwza+uipuysLU6pq97B9
	 h0KehHS+99z7OuI+OZrLmDaLK6UP3wbXHd87S8TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0524/2651] ASoC: SOF: amd: fix amd_sof_acp_probe() error unwind ordering
Date: Wed, 18 Nov 2026 15:29:24 +0100
Message-ID: <20261118150306.609541169@linuxfoundation.org>
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

[ Upstream commit b6aaef8ca8c305170de83e621c7e16d56731312a ]

Call amd_sof_sdw_exit() after free_irq() in the free_ipc_irq error
label of amd_sof_acp_probe(). Without this, an IRQ that fires between
sdw context teardown and free_irq() can dereference freed SoundWire
resources.

Fixes: d948218424bf ("ASoC: SOF: amd: add code for invoking soundwire manager helper functions")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260910132251.1171943-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index e4cdb74c075db..5570f3d1348dd 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -1038,6 +1038,8 @@ int amd_sof_acp_probe(struct snd_sof_dev *sdev)
 
 free_ipc_irq:
 	free_irq(sdev->ipc_irq, sdev);
+	if (adata->sdw)
+		amd_sof_sdw_exit(sdev);
 unregister_dev:
 	platform_device_unregister(adata->dmic_dev);
 	return ret;
-- 
2.53.0



