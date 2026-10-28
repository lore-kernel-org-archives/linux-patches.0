Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212953;
	b=vUU8adms3p5fcRPHERCoC7BHJBiLrYNWapIMVPF6983eFlcP4KOkTCq01q6IKCgp8Uzh
	 v71swMrF3CcVQ3HBA07QZ7C97bxhCmNWeyohPOzNOlqbZNPE/cB8eqoS5yOR+49FfTCYk
	 IfbfWohhkfV0cGZ3R0Ovhj4LP6tsa2vnvYmtmKYcUEJJSRjdn4elRjSPGjrZ/xkaYzx++
	 xeLwFDQ8pKgOG6HVNsTDJbiGxcuhkX4gB2+vR6ttm2NA69IvmHGq53G+Uglc/u3PY1LRG
	 bx46Ei5PTL+ADNrXDMnmuaWKPSeKx+7GCyNJQk32eSGJ2aUBl5JPShnJ7Q8Pj6HNyww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f59DN8t7wvUGyjIGwH2pv9w47+O3IwQONaNF48tAcdI=;
	b=IBy15SssBu30n20YRLN8LfqV/RmXPCnNN7A5pkXhWmNFz8LbbDOIlySI2DLFik6Vm//m
	 XLqdVzMXmjS/LYROpbmZAYr/eAjHNvRFkm+j2Ey+ThKHdOnY2LmV00fYPGsdeQUCouCh+
	 I62/6VTm37WdgrRlPG0ohQHy/kwCn7lUHqCIULncF0qsVzncukDmMuu44XaDZFnZThu0a
	 Jcz9iCTshXGIBRVNloTLPe8E+Cf7fyUTVO8fmdSipIBDczDQ7s1rPtktHGvbVlJACGrQW
	 Vgble1/Z+MqmZEe5E2dP2M2tUADUQTRVCEfFWEKAwRqNzikhwAJk4IlzF/U7w/d3nxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAYq6XUA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1906606A325;
	Wed, 28 Oct 2026 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAYq6XUA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03671F031E1;
	Wed, 28 Oct 2026 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212953;
	bh=f59DN8t7wvUGyjIGwH2pv9w47+O3IwQONaNF48tAcdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAYq6XUAtzWLM6m5y17c57eshysV4CQ/ykT+aJkKsaHLtRKItxyKcRSDujt6wVlyJ
	 uUwNp01QXbjzHcGbgtyiGPt3WPd5ZzjddxYT8w9CweIYa/5ujOK6iVG/U7DY0yJqYg
	 UhybPrwEX55IlslKrSvbmooTGLPLT1Vuww6rvdJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zimeng Li <me@lizi.moe>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0298/1887] ASoC: qcom: lpass-cpu: use DAI table index for playback constraints
Date: Wed, 28 Oct 2026 17:39:54 +0100
Message-ID: <20261028170506.011260224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zimeng Li <me@lizi.moe>

commit ca51771c8efde5df05476ac98dd1b2af4e2b149f upstream.

The DAI ID is a hardware port ID and is not necessarily the index of
the corresponding entry in variant->dai_driver.

When configuring a DAI with LPAIF_I2SCTL_MODE_QUAD01, the probe code
currently uses dai_id to index variant->dai_driver. This is incorrect
for platforms where DAI IDs are sparse. For example, the IPQ806x MI2S
DAI has ID 4 while it is the only entry in the DAI driver table. If
that DAI is configured for QUAD01 and probe reaches this branch, the
code writes beyond that single entry via dai_driver[4] instead of
updating the DAI being processed.

Use the loop index i when updating the current DAI's playback channel
constraints, while retaining dai_id for indexing the hardware-port
specific playback SD-line mode array.

This fixes the incorrect DAI table access for platforms where the DAI
ID does not match its position in the driver table.

Fixes: c223f41c1a52 ("ASoC: qcom: Add four speaker support on MI2S secondary")
Cc: stable@vger.kernel.org
Signed-off-by: Zimeng Li <me@lizi.moe>
Assisted-by: LLM-assisted source analysis
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260927010911.51980-1-me@lizi.moe
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -1228,8 +1228,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 		}
 		if (drvdata->mi2s_playback_sd_mode[dai_id] ==
 			LPAIF_I2SCTL_MODE_QUAD01) {
-			variant->dai_driver[dai_id].playback.channels_min = 4;
-			variant->dai_driver[dai_id].playback.channels_max = 4;
+			variant->dai_driver[i].playback.channels_min = 4;
+			variant->dai_driver[i].playback.channels_max = 4;
 		}
 	}
 


