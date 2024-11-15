Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A9D185924;
	Fri, 15 Nov 2024 06:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653537; cv=none; b=F+MdXYcDNyDErdTmnKvgDniCk1xTBu1gjcn9BkUPyt10J21/JWdbhEhDRttoG4kl6lT86ZDsbUmfRG1iTKmlJFPq26JfyA7MjZq7sR735R0NC63vO9XJqV33X6kUAlpxrr+B6Eq5NkIZ/kT+qaDgDtEOTmJ3GqV/6WZB2pgj9jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653537; c=relaxed/simple;
	bh=G/9xzk4OpXgjNPEG5yqRBAZCK7EA5/ke6+uJaShUnkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADXbcIFjNtxlFlKXFct57d1SaUl3wt0RTR8wb8G1Q6/LCt1IMsb2+Eq7/g44JxEhzm2tcvt35CeTiLLDxI29RHgd6pULu/bbopeuWH+Nuef4/C/aDIKsbp2dphk2RhyEIyRPP+qnzuIwL1UEIEYizOoEEK6KCT9YkDqVRHLd7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fELU3Upc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fELU3Upc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F24C4CECF;
	Fri, 15 Nov 2024 06:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653537;
	bh=G/9xzk4OpXgjNPEG5yqRBAZCK7EA5/ke6+uJaShUnkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fELU3UpcmRmYFIeqxzVFDjtM5GFjJCKy0fZ6HAgxKQWIvyDMgfMShq8XFh849EkgW
	 POu4UVbVGqlMc3fXnhQoItvt25mqjeMjAHX1s8Eh1hIhgi4CeThooWcG7KOyUyhh5T
	 6bUaR2ZZsaoqt9HWwMOcoVJH6BCy801bbceejCec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 35/48] ASoC: rt722-sdca: increase clk_stop_timeout to fix clock stop issue
Date: Fri, 15 Nov 2024 07:38:24 +0100
Message-ID: <20241115063724.232559854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 038fa6ddf5d22694f61ff7a7a53c8887c6b08c45 ]

clk_stop_timeout should be increased to 900ms to fix clock stop issue.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/cd26275d9fc54374a18dc016755cb72d@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index 32578a212642e..91314327d9eee 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -253,7 +253,7 @@ static int rt722_sdca_read_prop(struct sdw_slave *slave)
 	}
 
 	/* set the timeout values */
-	prop->clk_stop_timeout = 200;
+	prop->clk_stop_timeout = 900;
 
 	/* wake-up event */
 	prop->wake_capable = 1;
-- 
2.43.0



