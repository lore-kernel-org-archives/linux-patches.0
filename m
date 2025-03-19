Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215021DDC01;
	Wed, 19 Mar 2025 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395115; cv=none; b=rGyL/dmbWMp6SwiNP8vW25tV3rHPZqZ+woMbI22EPwefkbZVVilgqmBCM6OrHeI4hB/Tjr9jfabT573+Rjtrf5Fj53CpXrvRJuhQxM4FW+iGKm1WhRsOQInLUMY7C0+LtKgGCxyr4Op2wUJR7v2Gl+/SxZjSj2rcblk9XkwMODc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395115; c=relaxed/simple;
	bh=G5RhAinuUW1355JjmnRAl3T2XfnyQ07tIqYACKpSZCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qf2bMPY4EtARML8QbA3F/RmT/pa3c3xOruo7QjgvN+OQgUWgexJ/erGLHeBLF3eBeYuGbyJWytzdob8xs0pEqOjxLprFC3c5xsXMqqrfe4lCn/wSkPxrdbx2/87MMmiyamOFiangy4uOLpaE0CRlnb1YnRCJvxr6I4pRI/BEftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzS++Rkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzS++Rkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C5EC4CEE4;
	Wed, 19 Mar 2025 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395115;
	bh=G5RhAinuUW1355JjmnRAl3T2XfnyQ07tIqYACKpSZCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzS++RkzrZAUTxeSw+sopCRjObsHXax9EgXnQ+hcn0xBcvvHi02po5hm3SyajX0cV
	 LDtu6FmgeyMaSrNFVkotlrASSK+4g81nM1PmIBOlKUBI/oPTAb9zohempSai8n3L3m
	 AWmhwDgVtrkL7e6avu3rXVcd5HrEjWuIn9dtUJr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/231] ASoC: dapm-graph: set fill colour of turned on nodes
Date: Wed, 19 Mar 2025 07:30:25 -0700
Message-ID: <20250319143030.096558533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



