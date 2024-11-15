Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375DEEAD0;
	Fri, 15 Nov 2024 06:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653320; cv=none; b=oGyZb6gVggm01pHl3V8bl0fN1ls6iyZ9MqL3R5kBKrveM5zwjbyo154Z0bMdogWClgGR9gJ8Yk04+4SWzY/p41MeHRvDRBTXRL53lxDQlG0W3MWlwO9wCDEk0Izyq3ljr6XMRn1H7lhZAiE4Gjal3W8g4u4kYcd5iNmu/lM74G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653320; c=relaxed/simple;
	bh=QoJHdl3hx+vbDSXRR/9qkCt8IsrinXlLP/s6CmwWzfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1EUSmC2/V4M/GI0h+XzcV092fM0ho7zUVyS8P+amSKA/m+spcZzIia/jF6zvWycfT1hJe1LkI3zK8KK5J4w8bsG00jYLJMxP/nAIf5Sa+maWD7WrJjEWfGMQDbN7wemBhOO+abSak0UvQeKg5ZJlSh6L34D61MtpXRoyU77TwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr5oCvnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr5oCvnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D55AC4CECF;
	Fri, 15 Nov 2024 06:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653318;
	bh=QoJHdl3hx+vbDSXRR/9qkCt8IsrinXlLP/s6CmwWzfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr5oCvnByMMkwBjfXNJhfoi6KspiVDhgYLLXT0P6cXbef63nt0kbN4ceMO9YMiuWA
	 rx5bVPg6vdY/ARtz4x6S2Azat8upX4Kaxm3pk8klOJoP1wvlFXpp7N4ixXfffh48it
	 rawOcasmR+YhSmWLQyrHLSLF177zAYpolB6tFHbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 51/63] ASoC: rt722-sdca: increase clk_stop_timeout to fix clock stop issue
Date: Fri, 15 Nov 2024 07:38:14 +0100
Message-ID: <20241115063727.752754589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 87354bb1564e8..d5c985ff5ac55 100644
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



