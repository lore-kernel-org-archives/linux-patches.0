Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2347626D4DE;
	Tue, 11 Nov 2025 01:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825052; cv=none; b=earkbfQNvxaG5SCxYIMoKlQ69CjhJNOFczYd+v4Q9Isx/MwnT3b0tkxokY0cui5P3D5u0RCQ1IbV1+Ye7j7WR14O+NowaK7/W7+DZDze3f9R/XaBPqr2LolHcha0aI1xlVtVwXmbsmHG66+KzKzdfHH43EzRoJyUoKOAR6d43zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825052; c=relaxed/simple;
	bh=W6unskgyB+1ZbPyaPaSzQ3n2OufGbK9kP9g4Vbjxu1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eom7uM11NtrbWqmaf+4IhvnoC28fKLpO1bYNYEVAhFfE8kVbLA1zi1tGoFkzi8NXAEdXgWF88dTV2fizmTTlcKlhBBya8fdbK7lf+yFLkmpt7QzShbxbcGoD6PGrG//sO0Z3P0R7cF5l+zbFYTx64YjslksiWQWlyVllSIs/m4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfYFVA0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfYFVA0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B766BC113D0;
	Tue, 11 Nov 2025 01:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825052;
	bh=W6unskgyB+1ZbPyaPaSzQ3n2OufGbK9kP9g4Vbjxu1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfYFVA0EXRho/puepASZfM7xcxZmlM8LfTG8JmBBtNvplSl+Yme1rH8n6KY8A9Axs
	 X+MxCGSSsql5i+1oecx/dmh8nR4fLkquRyaDsPatuxrvCHaoVb2IPdIY90QwS/aVKE
	 /CVyJ+ct5CgFUdKGEzmEduVddhMtQm6VjFuQ12ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Yusuke Goda <yusuke.goda.sx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 640/849] ASoC: renesas: msiof: add .symmetric_xxx on snd_soc_dai_driver
Date: Tue, 11 Nov 2025 09:43:30 +0900
Message-ID: <20251111004551.902602067@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit ab77fa5533e4d1dcfdd2711b9b1e166e4ed57dab ]

MSIOF TX/RX are sharing same clock. Adds .symmetric_xxx flags.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Tested-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Link: https://patch.msgid.link/87a52jyuu6.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/renesas/rcar/msiof.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/renesas/rcar/msiof.c b/sound/soc/renesas/rcar/msiof.c
index 36d31ab8ac6a5..7a9ecc73231a8 100644
--- a/sound/soc/renesas/rcar/msiof.c
+++ b/sound/soc/renesas/rcar/msiof.c
@@ -292,6 +292,9 @@ static struct snd_soc_dai_driver msiof_dai_driver = {
 		.channels_max	= 2,
 	},
 	.ops = &msiof_dai_ops,
+	.symmetric_rate		= 1,
+	.symmetric_channels	= 1,
+	.symmetric_sample_bits	= 1,
 };
 
 static struct snd_pcm_hardware msiof_pcm_hardware = {
-- 
2.51.0



