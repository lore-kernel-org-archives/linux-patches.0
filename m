Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51C41DE4FA;
	Tue,  8 Oct 2024 12:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391251; cv=none; b=QeI3s45UcM1hXMF0t5TNrOipU2N/hMx8XwY7+0a5tvwprahgL1TFoTqxNa0etEklwwCEYJ6KH+4Dvbw2bEaF7epv0a9HvGV297nZpAy1SiKSkd+kThR/V0ZSFsvibjna0I+QrKzIQPJQaPaYsOC/dxxpz7W/ABildXhgucvja1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391251; c=relaxed/simple;
	bh=nfMKLV2fopPBn3BoxE8A0HVFSNHNsF3m3qTwJGeHjQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SYzcQjkAa4zJ00H5//fLd0AF1mcBC6L1cJ5dkcKzhajsgEWsW1g3M2mveMMoZlnZQ8hl9/6rj+hCrKYIuad/aSxgZbpklhQ90N+Nj7I4acHRLmyWaOJ6r/dh51DwKYILE+GAGMV3AAi8elitYp/irHnyV+adRBNYnSD+YHMfl7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0MaRv92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0MaRv92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27940C4CECD;
	Tue,  8 Oct 2024 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391251;
	bh=nfMKLV2fopPBn3BoxE8A0HVFSNHNsF3m3qTwJGeHjQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0MaRv92kWJscB98E+tZfBXp65lfpbYEVJGOxxCbXjTk/Jh9zlC3AkoOEze6fyFbV
	 ho5h5c+kaqHEPlD+SOAklzSTY5rV+hHu/pF4l7QBWXJN9x50tli5h61bRLNX3jFa6w
	 1zu+MWllsbxheNFNEnevO0xVX7MLI1aCRgb9/gmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 055/558] ASoC: topology: Fix incorrect addressing assignments
Date: Tue,  8 Oct 2024 14:01:25 +0200
Message-ID: <20241008115704.385093423@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 85109780543b5100aba1d0842b6a7c3142be74d2 ]

The variable 'kc' is handled in the function
soc_tplg_control_dbytes_create(), and 'kc->private_value'
is assigned to 'sbe', so In the function soc_tplg_dbytes_create(),
the right 'sbe' should be 'kc.private_value', the same logical error
in the function soc_tplg_dmixer_create(), thus fix them.

Fixes: 0867278200f7 ("ASoC: topology: Unify code for creating standalone and widget bytes control")
Fixes: 4654ca7cc8d6 ("ASoC: topology: Unify code for creating standalone and widget mixer control")
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://patch.msgid.link/20240914081608.3514-1-tangbin@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index af5d42b57be7e..3d82570293b29 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -889,7 +889,7 @@ static int soc_tplg_dbytes_create(struct soc_tplg *tplg, size_t size)
 		return ret;
 
 	/* register dynamic object */
-	sbe = (struct soc_bytes_ext *)&kc.private_value;
+	sbe = (struct soc_bytes_ext *)kc.private_value;
 
 	INIT_LIST_HEAD(&sbe->dobj.list);
 	sbe->dobj.type = SND_SOC_DOBJ_BYTES;
@@ -923,7 +923,7 @@ static int soc_tplg_dmixer_create(struct soc_tplg *tplg, size_t size)
 		return ret;
 
 	/* register dynamic object */
-	sm = (struct soc_mixer_control *)&kc.private_value;
+	sm = (struct soc_mixer_control *)kc.private_value;
 
 	INIT_LIST_HEAD(&sm->dobj.list);
 	sm->dobj.type = SND_SOC_DOBJ_MIXER;
-- 
2.43.0



