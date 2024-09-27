Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1046417B515;
	Fri, 27 Sep 2024 12:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440059; cv=none; b=mRXeeJDeUtsXcZxt66h8tY6yGR0HscrTd32p0syfx668rl14ctNw22LlJzaW0GQsA9c6PYWNyGe+P27aNsqm5OeE12XLI4WzqKsnufBY9UAduC6QqKLPxbrl9/WsbUIE3T+TJ9ZHQVcCtYFOlZEgiec1IlYWC/m255RSiKzHd6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440059; c=relaxed/simple;
	bh=rzrcdOROPjP9biAtQjl6S2mwAIVuwAK12EVA4CMuTus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgyAfm/9HYlKg69GfKCSmq+HkiRZOYF0/FqoDKJlxVctOpEHvRcpOg2HOfrLSlyaUicbccWbxfudH+ZBrXInXBh5Gl5t310F3hAW3LtLRNcn2UMvyNS3qEGnV0rP0GEMZewHrY5vBfMU3+017HOs86pXcT6n3R0N2fLH9vF7Tf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7m0vmt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7m0vmt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9205DC4CEC4;
	Fri, 27 Sep 2024 12:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440058;
	bh=rzrcdOROPjP9biAtQjl6S2mwAIVuwAK12EVA4CMuTus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7m0vmt4ObdjEugCTAAgii8jN8mcdP7fGoO6EywsTnb7nSuXZ6ySKxFed5lPFO0+h
	 TWwMGH/qf+7ZwHZCm+OaZAG0mqSCXAjLcSkH44BWeA0rHs25FkLJ2RUkByNC8GU5A+
	 FqZVuzIhlNL284F9Yw6Zk525MVkQ/xoeUfXoQwCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 03/58] ASoC: allow module autoloading for table db1200_pids
Date: Fri, 27 Sep 2024 14:23:05 +0200
Message-ID: <20240927121718.922515437@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 0e9fdab1e8df490354562187cdbb8dec643eae2c ]

Add MODULE_DEVICE_TABLE(), so modules could be properly
autoloaded based on the alias from platform_device_id table.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://patch.msgid.link/20240821061955.2273782-2-lihongbo22@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/au1x/db1200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/au1x/db1200.c b/sound/soc/au1x/db1200.c
index 83a75a38705b4..81abe2e184024 100644
--- a/sound/soc/au1x/db1200.c
+++ b/sound/soc/au1x/db1200.c
@@ -44,6 +44,7 @@ static const struct platform_device_id db1200_pids[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(platform, db1200_pids);
 
 /*-------------------------  AC97 PART  ---------------------------*/
 
-- 
2.43.0



