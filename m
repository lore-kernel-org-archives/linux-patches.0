Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571BE3C3C;
	Fri, 27 Sep 2024 12:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440320; cv=none; b=JIXX4TJq3dGIW847WY2M7jprZaV5RqGTQfzeerIkSQISGuO2ABLPld3WfCD+OjWuFd9KYWLbM+5hk0xjjzDqPaTxqiG6RFR6JKrlmHO8zVVHLk+hl69sTNiZBpTrzO/6RYM7HIcuI22efsLt3ORnLg7pbQdg8o/g9oqPWwd3v/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440320; c=relaxed/simple;
	bh=paDKt4nxJ/q58iVkAPCRExbIynYfRWNCHgInse419t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SArNXLxIaAQ8Ja/cydihs6eztTb2dMu/ADMrBjnBjRA6d+s22Zuf76Cpdhy52YrrlTcBRuGsWnkWHjnjUYPyGRIT0BpiSslaqK5YKrMz3u7+J2o35uj8IxjwrCQi8mOrX+uEew1C/Cln5vyRiW3SLA31zLAAddAlg32c4eikRqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMzgqP/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMzgqP/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D898FC4CEC4;
	Fri, 27 Sep 2024 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440320;
	bh=paDKt4nxJ/q58iVkAPCRExbIynYfRWNCHgInse419t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMzgqP/Vjsa8kM+GDUqXlFNnjoy1z57LrFKqRjZ9Kvgs9mGSSnZ1dOaba3LoWdlrN
	 fEPUJXqjIo5VxBzjh0smFx61wjjCGzRQ9Ao96ChVbBQ03hx59J3zsb83I5tmOFGn1+
	 lDx+yAD/56A/qU7EmjV9S2I1jBvYhqJbToOm5zLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/73] ASoC: allow module autoloading for table board_ids
Date: Fri, 27 Sep 2024 14:23:14 +0200
Message-ID: <20240927121720.032384058@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongbo Li <lihongbo22@huawei.com>

[ Upstream commit 5f7c98b7519a3a847d9182bd99d57ea250032ca1 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly
autoloaded based on the alias from platform_device_id table.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://patch.msgid.link/20240821061955.2273782-3-lihongbo22@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sof-mach.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sof-mach.c b/sound/soc/amd/acp/acp-sof-mach.c
index 972600d271586..c594af432b3ee 100644
--- a/sound/soc/amd/acp/acp-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sof-mach.c
@@ -152,6 +152,8 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
+
 static struct platform_driver acp_asoc_audio = {
 	.driver = {
 		.name = "sof_mach",
-- 
2.43.0



