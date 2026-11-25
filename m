Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624716;
	b=vuFbXHsudqEQwYgD8gZ6gJhMNFerX/m6310Xjh5E3MB92XR2OjLtGr77aGmXKKHX+uXQ
	 wz7okG48mQ6geuRO8A1071TyN8qFoq1wQQv1qxxspiXPCYkaA93kWaYuEe0RFvo7b/i+o
	 jKfHd9LrUvzTLCssWo4SScxAP5+fkay6BZlz9TvWGLD/NWAuKsihZ8HrCh2IZJ84Ll21L
	 xKztKH9Gw9kDij6Z2EUCLB968/9R5ZdimurgVoPvaPn/lXT8vGXksYJ8eCU8C9BQRz3AW
	 00T0dsZHYqwWSgldXiZPgDHq4vDvZnM5BYlJl9jp1Heosv5Ruog/MNDeD+s4n4tZMwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gsHjIQuyC7QdqgZXCIanIqK274lqZOoTBLtnx+LU9R0=;
	b=gost9IVL9lcQVXbBeECOUutgw13R/Ce+l9AGPM+nZGpan8FXi8GQDBC4BCd8qkj6vHQ4
	 YjoJcrKV9zv4r3QZl6bay3hrE6u4r8tp9L+INca28TU1A0PEBOmr9svfnmxwoklUiJyZC
	 sViLd1EPjvjBJwIcNmM6YlxN0vnuzr2ekV7QlL+2rENTTn8tm98syyfCtRVhsek7Iyc6+
	 oa5au3r4Fr+fqmTEfwDGi57vQ9zhpTyh68ns72nqTadcZEbD5Pj6xE7gC4II3l7BVE5GB
	 kNXo0eXqrfS65zGiKNcIdzrMLlvTrJTDFy0dWz7mKYfBJlTNTHvMrRbro24ep3oMoNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAqLKma5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A4D606A33B;
	Wed, 25 Nov 2026 16:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAqLKma5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512561F000D0;
	Wed, 25 Nov 2026 16:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624715;
	bh=gsHjIQuyC7QdqgZXCIanIqK274lqZOoTBLtnx+LU9R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAqLKma5HvVOMAyKS8qYDuycs90BDL8WNUULGILeAWPHKESwn7w5a//Ex0dB69xoL
	 Zi0C6nTt0nRG/amkJ8AtRfp4UKKJS8f8Alyf88dLGZigBlY+hYdm239zKyNGvtqwl+
	 K7uIhLvaN1QnCwAy3i0V7h+jtigeYQdgSPGFAmUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/816] ASoC: SOF: amd: remove else condition in resume sequence
Date: Wed, 25 Nov 2026 15:30:33 +0100
Message-ID: <20261125143855.803934690@linuxfoundation.org>
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

[ Upstream commit e46da64f333ede33adc3a1903821a73ed6c018a6 ]

Else condition is not required after break/return statement.
Remove else condition in resume callback.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20250502154445.3008598-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 34ea81a7f284 ("ASoC: SOF: amd: guard adata->sdw dereferences with NULL check in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 35eb23d2a056d..7f8ee9f356452 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -649,9 +649,9 @@ int amd_sof_acp_resume(struct snd_sof_dev *sdev)
 			return ret;
 		}
 		return acp_memory_init(sdev);
-	} else {
-		return acp_dsp_reset(sdev);
 	}
+
+	return acp_dsp_reset(sdev);
 }
 EXPORT_SYMBOL_NS(amd_sof_acp_resume, SND_SOC_SOF_AMD_COMMON);
 
-- 
2.53.0



