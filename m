Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060673;
	b=3YDC91t22rlX3/l+9YR8lfECSzz1No5eN82aTXJv7S9KOf5+1osWDK7iczur+Qc9EwiA
	 hOdbwmTrCgea9evF9cRSnk5XFwFDFKEGUP3a9lHBh714M5KlN7X56yMQdUgZFyX8rfOHp
	 FhJVXgeEPJhaGw+gAiSUekNKCCXirbYEprqMBSEO3TFc5rrb8vC4yX7OPhLJebiz3Pvlw
	 SLCBXeTTA7VAGzJ9KCV9xKmRiHcFD3amP1xY8ab+j7KW7HffnSvb7JwYTttUiw8x+1DJ5
	 O2AihB0VWrzX+U3OIxegkwTKBNe1/Q7UZnIH+B0VJcr1MGV8hJS8/HtEvvUazmJBJQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nk9RnmoaDkl3dT2/k04cRPI9UP9excW78vJ9z7dwGpE=;
	b=XI5zi/JhniasmuEtW01Q2ppXPncyQG8VB8zvlRomI6QKJ9s7YloyRoBqw+K+CQxpncyt
	 A4AZpxIC/hlMPAaVPxOz1cHrzH3B5u7fbMGOgaBUwUlpWHv0/79k4VFFjYCXSsZdupsF9
	 RGnbsTOJnDC1cw6R28VXK9tUZb85uTAfcC3riMSxri2VHja/Zx7P99linC11gNiWNFhmS
	 kZ9Qny2dS2235xdbzS3kBs/hPUEWhpsBgeLnpl/aibM+B35lGgtljTtZNHjZZbVTRSrs/
	 Bf92kAMWfw53Lcgn+1rNPBMrRjDIKpmFk67Z7nASa0Wgwclxy0oyuTcpOCraw2R30FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIwes00s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22D0606A326;
	Sat,  7 Nov 2026 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIwes00s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D02E1F0089F;
	Sat,  7 Nov 2026 14:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060672;
	bh=Nk9RnmoaDkl3dT2/k04cRPI9UP9excW78vJ9z7dwGpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIwes00sPw/crErNTTKTM+RvZLCbSWu3XW12nRxQHLJjJOGsgYpnJWR75m8NPyVwo
	 oNQG7WtG2rnNgMR5JlgHNNorrxFV3YdxQMTfrnz5fnn8K/Ly95y3AhpUevhqV1JgvW
	 KinCq5IMiBpSyi2+Yh0NR8fFmKZ1rnjBTzrzR/j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0081/1536] soc: qcom: socinfo: Add SoC ID for SDM850
Date: Sat,  7 Nov 2026 08:34:57 -0500
Message-ID: <20261107134959.949366367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 743af1d6a8b4bfa62dd01b5c2d81b1c62ea597f7 ]

Recognize the SDM850 SoC.

Signed-off-by: David Heidelberg <david@ixit.cz>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260627-sda850-v2-2-44bf46ade42e@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 416cf447630f4..b766c1b318dfe 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -351,6 +351,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(IPQ8078) },
 	{ qcom_board_id(SDM636) },
 	{ qcom_board_id(SDA636) },
+	{ qcom_board_id(SDM850) },
 	{ qcom_board_id(SDM632) },
 	{ qcom_board_id(SDA632) },
 	{ qcom_board_id(SDA450) },
-- 
2.53.0



