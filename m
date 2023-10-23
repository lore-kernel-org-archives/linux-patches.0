Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7D114A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Av9OHNSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6047EC433C8;
	Mon, 23 Oct 2023 11:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059549;
	bh=1MN5W0z9MLKZkUeHXT4VAfj/3MxcCa0/mhf2HznJ9TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Av9OHNSoqzjLF2HZVx7qdUkltAb+YXuT9g/yFWFCAJdHYgVFJnxqPL91OCOuaQ+PR
	 VVYQU7hMbUQVVv2GAyt0bS9QMHUepcp3jG6CYRJehRX5v5CGehzMr98BhPUaXUdjpq
	 shKcVz1HlZT0enDnJ1AO5t2w7L9mYF4bGDbmfivI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 215/241] ASoC: cs35l56: Fix illegal use of init_completion()
Date: Mon, 23 Oct 2023 12:56:41 +0200
Message-ID: <20231023104839.092559189@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit af5fd122d7bd739a2b66405f6e8ab92557279325 ]

Fix cs35l56_patch() to call reinit_completion() to reinitialize
the completion object.

It was incorrectly using init_completion().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Link: https://lore.kernel.org/r/20231006164405.253796-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 7e241908b5f16..4d7ccf682647e 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -879,7 +879,7 @@ static void cs35l56_patch(struct cs35l56_private *cs35l56)
 
 	mutex_lock(&cs35l56->irq_lock);
 
-	init_completion(&cs35l56->init_completion);
+	reinit_completion(&cs35l56->init_completion);
 
 	cs35l56_system_reset(cs35l56);
 
-- 
2.42.0



