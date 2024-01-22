Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E667E8F;
	Tue, 23 Jan 2024 02:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975316; cv=none; b=DFN0NcTrm9uqomLzyhLFF8yXRep+wR23zKPgZwlEUXruTwkEqTKxnHT6T4q+P+70zLJquL/hwaGt4FWKLbB5aUF6UPnLWzrIeH+5g+1cghL2DVtNlpvptttqZuEZxtY6xdhgpf5p9GBj/8LN18dOh26MMiN8dcpg2ReawWny+XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975316; c=relaxed/simple;
	bh=3VG1jWRolnm1RHX6fDs1mQ3+g8/cm8grpUwSBd0VssI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ0xwFiqCMB9yRDPFYIPTaj22/AERmr1X0BkywuW4I6sqLhIA7/0ugPNbSqHa+2nQ5R5DENNEwU3FV2vUJglqLU+HaoIqoDc+AAPlKEb+gN61XcqJbX+3orErKP5QD900EwkeaxMO9fKmTPPz/RQ3lwgNBpII3ynHAcM64nxIyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUkPARVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUkPARVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4651CC433C7;
	Tue, 23 Jan 2024 02:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975316;
	bh=3VG1jWRolnm1RHX6fDs1mQ3+g8/cm8grpUwSBd0VssI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUkPARVc/OTpeYnoifr5r1oQBhQ6INh8PDGLOLBdKmE2zOt+d9/BcJgRoBOkT70dz
	 FVvoo9SG3uW6+gpFFmi4OEUvq4PAEt9Dm4UkY+6W9r7lkw9rKgUyq2uzkUEnVAkQgN
	 6+fMknsL6b4ovAVk/1fN3AzCAVAzj8Wbmda30MUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/583] ASoC: SOF: topology: Use partial match for disconnecting DAI link and DAI widget
Date: Mon, 22 Jan 2024 15:55:08 -0800
Message-ID: <20240122235819.874155323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 2f03970198d6438d95b96f69041254bd39aafed0 ]

We use partial match for connecting DAI link and DAI widget. We need to
use partial match for disconnecting, too.

Fixes: fe88788779fc ("ASoC: SOF: topology: Use partial match for connecting DAI link and DAI widget")
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231204214713.208951-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 37ec671a2d76..7133ec13322b 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -1134,7 +1134,7 @@ static void sof_disconnect_dai_widget(struct snd_soc_component *scomp,
 	list_for_each_entry(rtd, &card->rtd_list, list) {
 		/* does stream match DAI link ? */
 		if (!rtd->dai_link->stream_name ||
-		    strcmp(sname, rtd->dai_link->stream_name))
+		    !strstr(rtd->dai_link->stream_name, sname))
 			continue;
 
 		for_each_rtd_cpu_dais(rtd, i, cpu_dai)
-- 
2.43.0



