Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC0744CF2C;
	Mon, 20 Apr 2026 13:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691816; cv=none; b=pq52h5v8+0ZgzwUsQsBdGl4BB1HFry5kLYKhF8ouI/FujhIaVVCuWEXhYD/YvVRdk+CQHuimbevQ9+r+UOzadJwHbh2iUHPoHTIAYTScpQU51kH8lVtHAbCIEt8l1ig38ZmZKysFVqyLz73wDaQaj3kpFUistobkvcL5ajevcQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691816; c=relaxed/simple;
	bh=+UMA54GTrRCWN41pZxqPmtq040J7f4wyWQi7kt9MEgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CziwSUMXed3SZGO7gLlxAcUCld40nepP2IWZMRQr3vGa80kMePx9tBioloulGC73ACYTp3tRpvZc0J2PPX+6McShAWdzwrLYyqzHsm3R3TOOowvFpjyJlbtGn+8HhobaQyst9+qsrUhVe+jgkf/oc6QAsHNwCOUJrIzJ9JETzVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuNQWmv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuNQWmv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80414C19425;
	Mon, 20 Apr 2026 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691816;
	bh=+UMA54GTrRCWN41pZxqPmtq040J7f4wyWQi7kt9MEgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuNQWmv+wTRcxl3FytwiArbJWATvnWgriVwWsjnrRzHi7KOtf7+2hevKd6m2y5S6D
	 NegBdTNS5FB4/wn77er1046NRR9ThPkdpoh5htrpTZTw8LmZdWU2VJZedIxyIUeiiT
	 9rc1OjUYLEJv01BUqoGjwZLfqGGAOm/0YZZbLCZW2Ht4LNinUx5unn5BwBOAfbBY55
	 jpqTfhpLPoy5pLWAFZEJH2og0a5ueIO4q42048J+aUOM09IJOWl4Z5EF6wslDndjXE
	 tmFTyg1zk2QWZaw+JcG2RryCeP23xBvsNyj3ClRNYcElDXNqBLv6BFY3Kd+3c/6ZzK
	 n5JAHKOiXsQPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Vijendar.Mukunda@amd.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: amd: yc: Add DMI quirk for Thin A15 B7VF
Date: Mon, 20 Apr 2026 09:20:06 -0400
Message-ID: <20260420132314.1023554-212-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 1f182ec9d7084db7dfdb2372d453c28f0e5c3f0a ]

Add a DMI quirk for the Thin A15 B7VF fixing the issue where
the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220833
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260316080218.2931304-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index c536de1bb94ad..6f1c105ca77e3 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -724,6 +724,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7VE"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0

