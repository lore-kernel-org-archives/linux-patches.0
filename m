Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A8168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71919C433EF;
	Mon,  8 May 2023 11:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543871;
	bh=6yR5Z+EGk/B1HC7LgkXjujE6RStwzKtAcPraqrof/J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8CMU8oB+H0n7iSKpjA2lJQq+ejydgwJNpP+a6E0mA3cjzJLavJhUpp3eZ8VLHUPf
	 6B7dK5bAxspPa4NA9aNODvp+p9V0zgoDaBK/OKQrrLy1JSCN5Du5sBuduXeOCgYKiy
	 i9Jkou5NW8FZD0s/Kfwniil5+6Owg7t5ojhAki68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 229/694] perf/arm-cmn: Move overlapping wp_combine field
Date: Mon,  8 May 2023 11:41:04 +0200
Message-Id: <20230508094439.800980759@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

[ Upstream commit f87e9114b5e590c2c6658ca21d7b714ca240bdd0 ]

As eventid field was expanded to support new mesh versions, it started to
overlap with wp_combine field. Move wp_combine to fix the issue.

Fixes: 23760a014417 ("perf/arm-cmn: Add CMN-700 support")
Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20230301175540.19891-1-ilkka@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index c9689861be3fa..9f2edc28d16ef 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -166,7 +166,7 @@
 #define CMN_EVENT_BYNODEID(event)	FIELD_GET(CMN_CONFIG_BYNODEID, (event)->attr.config)
 #define CMN_EVENT_NODEID(event)		FIELD_GET(CMN_CONFIG_NODEID, (event)->attr.config)
 
-#define CMN_CONFIG_WP_COMBINE		GENMASK_ULL(27, 24)
+#define CMN_CONFIG_WP_COMBINE		GENMASK_ULL(30, 27)
 #define CMN_CONFIG_WP_DEV_SEL		GENMASK_ULL(50, 48)
 #define CMN_CONFIG_WP_CHN_SEL		GENMASK_ULL(55, 51)
 /* Note that we don't yet support the tertiary match group on newer IPs */
-- 
2.39.2



