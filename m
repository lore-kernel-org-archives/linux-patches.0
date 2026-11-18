Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021813;
	b=C5Vge1p62SXM2Yuq+ue6mdrgZitSvrDG45GJNXCy+t72zsrakc3iu0EbCMT+YeSOqyb2
	 fKdPEVOR1lNHTCaSukpO6l/ZEUOrkUtKHDeaSBGhKN5HeR3HwCVlUM4DN5LoI4d8qllyx
	 oVHRSNCb/0NQ8Q6FhEXJ1CH0XiaMrMYcMQDlIWtVsFy8dw91LXsEOHrtcyn/Er5HAQRBA
	 kZcjOdzwHjHWFy+HcjXNQaHkPwn366NRXZ+topLYBURMDTtb+gpvbP1YxYBhEj52b1Pb2
	 7SePuJ/rlfYaeYJ+2OUi9byoUETF5Rytjl3fXS65BvUsfQW75MMEGrqMVbUUtQyHNEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OaVyPb25zg3B9RjvyiB1E4ZToJWYBLfg6FX7j5LTvyU=;
	b=qkCysvsu+jwud0WxdnQ6IAz7by2cK/glih/ST+oxZwMJl4MEbUuMHol1xTAo83ocNKOl
	 Aln+z8AaDThyUOuQPI1hyBDemf6nzUJfn5+xpSAZDT+Ff6dxEuQenRNOYjxRzxlyJatpj
	 qjFjo1t7gykg1w2CeMl6ZXUBYl7pc9mOh+tRdJlYcGDUN/vmUwLrkaJYdDC06E8FJhARd
	 DU7uYpEa9+Bf507O9+PhSDJWycCJrWCroMlnwkcZL90BDJ+xzZgRBjZPNkW83rZqrzOSa
	 VDeSy9DHJIT58LOIRdYzHbtujVoN1fwmWFUfk0aZAoOtE/vGkWK5wMF3U/v1ULszAQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDU04WvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC75606A334;
	Wed, 18 Nov 2026 17:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDU04WvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219631F000C4;
	Wed, 18 Nov 2026 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021813;
	bh=OaVyPb25zg3B9RjvyiB1E4ZToJWYBLfg6FX7j5LTvyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDU04WvRCnuzKoGtD6duT4oBtwvQ+qPjVSKf9XcAbTdVUECWKeHS9bpEY7wLeolqm
	 t7wFHYG8FvQ3Dd4YTCSH6Sn077rutcj0tBeah9WPMxKuh1I9FNWDDWx+4b1BCZlhIG
	 AOvjI32/lj9W4rXUK5BQwWqMM41jMhktSwZHgKsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Ravi Hothi <ravi.hothi@oss.qualcomm.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2439/2651] ASoC: codecs: wsa883x: Fix VI sense port channel count
Date: Wed, 18 Nov 2026 16:01:19 +0100
Message-ID: <20261118150412.982492470@linuxfoundation.org>
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

From: Ravi Hothi <ravi.hothi@oss.qualcomm.com>

[ Upstream commit 9728b328d7adf228d5f691d0ec43bb7a6d07e44b ]

The VI sense port carries both the voltage and the current sense data
of the speaker, but it is described with max_ch = 1 and, since commit
ed3b274abc40 ("ASoC: codecs: wsa883x: Correct VI sense channel mask"),
a channel mask of 0x1, so only half of the V/I pair is transferred.

Describe the port as two channels and set the channel mask back to 0x3.

Fixes: ed3b274abc40 ("ASoC: codecs: wsa883x: Correct VI sense channel mask")
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Ravi Hothi <ravi.hothi@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20261023171316.819857-8-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index b09ee3db7ed58..17d8babc6123b 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -552,7 +552,7 @@ static struct sdw_dpn_prop wsa_sink_dpn_prop[WSA883X_MAX_SWR_PORTS] = {
 		.num = WSA883X_PORT_VISENSE + 1,
 		.type = SDW_DPN_SIMPLE,
 		.min_ch = 1,
-		.max_ch = 1,
+		.max_ch = 2,
 		.simple_ch_prep_sm = true,
 		.read_only_wordlength = true,
 	}
@@ -573,7 +573,7 @@ static const struct sdw_port_config wsa883x_pconfig[WSA883X_MAX_SWR_PORTS] = {
 	},
 	[WSA883X_PORT_VISENSE] = {
 		.num = WSA883X_PORT_VISENSE + 1,
-		.ch_mask = 0x1,
+		.ch_mask = 0x3,
 	},
 };
 
-- 
2.53.0



