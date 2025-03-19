Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDFD1D88C3;
	Wed, 19 Mar 2025 14:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394926; cv=none; b=JiaebKbz+nEP7bNQoENqhzAFHS2cXGEYxd7oqKZHzg5iaiibFQT5VASCkjWMJmLhM8porlD8X12iJ9u/gD16VHPdkaC8UuMLtm3NupK3AnQyyVsintGL/eYcuUcvNtyV5fggsimFswe6u3cxX7drGg48cMuoyhpaC+6OF/V2JaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394926; c=relaxed/simple;
	bh=pWsxl5rWtly8gUQrhddc1ycejo1K8oDRKB9dOoYccak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpJcWLqm2lJkcfSgP56f3HeysrlzCymkhtfX41ofzfyxLLaSURtuRFjKPVz9u3pofuP+CuN1CsXpcmOMsOB7rgZERHoOk7b+oNIs2UubsREwjTgwlAZTRmDYX2T8cCUI116FYd1edjtZucznv0AK5ywFfIYd/umhaXP4qWEyfw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7F1+5qL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7F1+5qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F7AC4CEE4;
	Wed, 19 Mar 2025 14:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394926;
	bh=pWsxl5rWtly8gUQrhddc1ycejo1K8oDRKB9dOoYccak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7F1+5qLgtBr/wDhaPPAhv8h1zpdrMmhr47p9EhVEBioFan9QtCVUGSGYqpaV2aN+
	 5VLt11SG21ZnsFl9Om2pYilYuJPotWx+opmeKh1/XG0dRsZhV7nMHAzQs7V1NNUASm
	 oJH79/iQ4IO8fPMuZMsmLjBlRGM2TC+N3mKjBCAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 138/241] ASoC: dapm-graph: set fill colour of turned on nodes
Date: Wed, 19 Mar 2025 07:30:08 -0700
Message-ID: <20250319143031.139071753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit d31babd7e304d3b800d36ff74be6739405b985f2 ]

Some tools like KGraphViewer interpret the "ON" nodes not having an
explicitly set fill colour as them being entirely black, which obscures
the text on them and looks funny. In fact, I thought they were off for
the longest time. Comparing to the output of the `dot` tool, I assume
they are supposed to be white.

Instead of speclawyering over who's in the wrong and must immediately
atone for their wickedness at the altar of RFC2119, just be explicit
about it, set the fillcolor to white, and nobody gets confused.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20250221-dapm-graph-node-colour-v1-1-514ed0aa7069@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sound/dapm-graph | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/sound/dapm-graph b/tools/sound/dapm-graph
index f14bdfedee8f1..b6196ee5065a4 100755
--- a/tools/sound/dapm-graph
+++ b/tools/sound/dapm-graph
@@ -10,7 +10,7 @@ set -eu
 
 STYLE_COMPONENT_ON="color=dodgerblue;style=bold"
 STYLE_COMPONENT_OFF="color=gray40;style=filled;fillcolor=gray90"
-STYLE_NODE_ON="shape=box,style=bold,color=green4"
+STYLE_NODE_ON="shape=box,style=bold,color=green4,fillcolor=white"
 STYLE_NODE_OFF="shape=box,style=filled,color=gray30,fillcolor=gray95"
 
 # Print usage and exit
-- 
2.39.5



