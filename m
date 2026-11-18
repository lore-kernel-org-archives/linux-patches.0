Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016541;
	b=aSxEou1g/CkhQS51HDU5q6UeMzOycsyj8NDPN8gieoFtsEYp0sFthOrauZ+rcNCEV0cb
	 r8rw3XxL+311EWT/YZ+cXEBiITIBO55X7PPxn+rvTPZ8tkL2JuvMXUHdnKHdz7ao7YJG5
	 /UCG4yZ+6RhGAfssL2h6HF94PgcdrFO4kYfp+NReew2Fs1TeuA8SQeCwxN7zYrIuEYi/U
	 KvIAOlNViw8E2Go0fDKrrj8UuQH16bRsyMY2M5tJGMzvlbsJw0AeU9YdOnw1hRv2epaqx
	 tPlt6anlZjaGaREg2bynb7+Th52TCFTTnvUZE+p61pw5oQkSCT1PT1c6Hju3u5YUExA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKezhkTZVTPvLlrZzEwddwEjPtvJNqSLMNRLIhodKIU=;
	b=5jknjLRPnfySqWKRO36CRZyqecpSSXThZl6xSr0zB9rzQR/fx4N0bFEpXvVNCOehOHf9
	 XMd6gIOBznhA9mLNAEUgNfxKet2/zKmf8i1DSpsS9I7L7HtPGEessDi+3GoT9kDC8HOYO
	 83hGMQZwPbq4YPimgU1Elof6Wl/UEuujHnb+Yzy1WewvmO5X9eBsMGAZBGCDWfIM2RGqJ
	 /xyXHAAJk2pUGYBzMJS79/29uVmP5VOQjjzpRNXTFbKPhGeIzkSFfiOdnENyRizA2DkJr
	 i0YLWVblRI4o5XfjD3vb3Mk5FTULcXy3vwIXxkK2l4KwTl3EVBlNL/eKu63qCR3AL3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFXf0EfT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C91B606A334;
	Wed, 18 Nov 2026 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rFXf0EfT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4EB1F000C4;
	Wed, 18 Nov 2026 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016541;
	bh=EKezhkTZVTPvLlrZzEwddwEjPtvJNqSLMNRLIhodKIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rFXf0EfTVhI3Oe3dMtbb76aRDPON2YJfzSzp8xdxfptvcxqTiHTKe2z8TW65j3FzO
	 pU3/6JPLMRGH6F0/6ISD/Y77mfhlbKYLytvv9BxD07C7ZG4PqHDL/forHiHKWj2Xy9
	 3YiecfMbFSO0LPjR9HYSxOIT9ZYHGyifj41y6b7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0522/2651] ASoC: SOF: amd: return -EINVAL for unknown PCI revision in acp7x suspend
Date: Wed, 18 Nov 2026 15:29:22 +0100
Message-ID: <20261118150306.538240289@linuxfoundation.org>
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

[ Upstream commit e419e9a6cbfe1d0947dd5ab8dabe9a5ed4b4f572 ]

amd_sof_acp7x_suspend() is registered only for ACP7.B and ACP7.F
platforms. If an unexpected PCI revision reaches the switch statement
the default case previously fell through, leaving ACP_CONTROL
with a stale value (enable=false) before writing ZSC_DSP_CTRL=1.
Return -EINVAL instead to surface the programming error immediately.

Fixes: 1c9646f3180e ("ASoC: SOF: amd: add system and runtime PM ops for ACP7x")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260910132251.1171943-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index f89ad86260b4e..688df7acd2e21 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -1197,7 +1197,8 @@ int amd_sof_acp7x_suspend(struct snd_sof_dev *sdev, u32 target_state)
 		enable = true;
 		break;
 	default:
-		break;
+		dev_err(sdev->dev, "Unexpected PCI revision: 0x%x\n", acp_data->pci_rev);
+		return -EINVAL;
 	}
 	snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP_CONTROL, enable);
 	snd_sof_dsp_write(sdev, ACP_DSP_BAR, ACP7X_ZSC_DSP_CTRL, 1);
-- 
2.53.0



