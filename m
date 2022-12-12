Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73F828ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237B9C433F0;
	Mon, 12 Dec 2022 13:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851555;
	bh=O7zDITUcGhTFRClUzBYfLgBIZigynA2jGdpwL7I4TVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1d1tBxUxXA8in3K9Wq5aIWjzSE3D5TTCn6PGC/h5UZMHsRhVKBqEFWZpNudShdjAJ
	 jj+C7N+buNKMqCbTQQoJRFNoiYJqP/fnquIZQRW//eywvhT6zennZT8pxtOGqAo3KM
	 ycnp0Th77RW3lYft75amECZLx781sLJ2JKtzsgT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/123] ASoC: soc-pcm: Add NULL check in BE reparenting
Date: Mon, 12 Dec 2022 14:16:28 +0100
Message-Id: <20221212130927.829707652@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit db8f91d424fe0ea6db337aca8bc05908bbce1498 ]

Add NULL check in dpcm_be_reparent API, to handle
kernel NULL pointer dereference error.
The issue occurred in fuzzing test.

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Link: https://lore.kernel.org/r/1669098673-29703-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index f6dc71e8ea87..3b673477f621 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1166,6 +1166,8 @@ static void dpcm_be_reparent(struct snd_soc_pcm_runtime *fe,
 		return;
 
 	be_substream = snd_soc_dpcm_get_substream(be, stream);
+	if (!be_substream)
+		return;
 
 	for_each_dpcm_fe(be, stream, dpcm) {
 		if (dpcm->fe == fe)
-- 
2.35.1



