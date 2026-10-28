Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211018;
	b=g+P0XecXjst/OSIjPim3ITSpPRqjwpjXfKyr0M8rh+6kaSLmd0VgDEM7MUr+weUJlmE0
	 Bg6dsBrLZkGnAqFwl+RJqmyQlKqrzfnKacBaTBcSZnwzeVRTlcQOhHtVupOVgEHu4OK0F
	 TLClJmpTDDWdELU4PcJdoaVM9ADOd0zEYt6i1oRYF5AeLgumBNQruHnwdgCWDTW/Jq3nj
	 P5JUN1bGJ8BfRZ+EF+WHMBt777ma3u3BF4fVu2dWVgnIZiLEj/bBH98U5Kcr8K0D8fWCz
	 3TbVb4pbU09siKQRpleumYnZ095nqgRK75ljTtGAVBbrRNZ1Hqk5+UJq/UtlVNxHusA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nw0QWq2dVdhgOCdsYFPytUB1UFu7w0SCphchrLm/iSM=;
	b=z/0zXOh0aZxL3Lp4n+7ngq4fL4X1T/XNJOB2HT0TmcYaygfe2rhzsktqCf5WP5ByAHfA
	 y7UxebTwg/lH5Njq6PRfMcLQhKL65YFdsvityH1cLin7TSEWegwhWXj5oKh1iDGI7mXG9
	 gwjIzKw2JRsCNisZmu4jv33g3E2whdbWzFIcSWwyesh2ZvKPrYRcNlO4YbgtQL3cSktEl
	 tXsaHMPzDW7Qgajf6fG8X0NcWUW7IQyezqfgPxJi6lVCFaykh6AkO8Zu2zxNm/DCknN2I
	 yKN8VWdzA0HR7XWrZDq9/rDZOUJjyeRKmU9g4sapB+aFWG+wgGQt2By2GYA9u/Jm+Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKkPtQR6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97536606A325;
	Wed, 28 Oct 2026 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PKkPtQR6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006651F01828;
	Wed, 28 Oct 2026 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211018;
	bh=Nw0QWq2dVdhgOCdsYFPytUB1UFu7w0SCphchrLm/iSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PKkPtQR6rCQiNfzIj/O8256h9iIz/MhSf2ssR5TPGAoIGmHdibnGMntqNEspW8NJx
	 n05XtdrCKfXkguhWM59JR1TpWIlWATwSgq4RmhYnGWXptJEcCFqP2bRsKktxguSS9l
	 0FarDVqb+UoPLn6j2cBLMw+Tbhk8lnkutXZ6fhso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zimeng Li <me@lizi.moe>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 223/571] ASoC: qcom: lpass-cpu: use DAI table index for playback constraints
Date: Wed, 28 Oct 2026 17:56:10 +0100
Message-ID: <20261028170013.292706092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -967,8 +967,8 @@ int asoc_qcom_lpass_cpu_platform_probe(s
 		}
 		if (drvdata->mi2s_playback_sd_mode[dai_id] ==
 			LPAIF_I2SCTL_MODE_QUAD01) {
-			variant->dai_driver[dai_id].playback.channels_min = 4;
-			variant->dai_driver[dai_id].playback.channels_max = 4;
+			variant->dai_driver[i].playback.channels_min = 4;
+			variant->dai_driver[i].playback.channels_max = 4;
 		}
 	}
 


