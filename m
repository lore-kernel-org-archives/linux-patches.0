Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C55E1779BD;
	Fri, 27 Sep 2024 12:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439917; cv=none; b=XCwd/EPIYlreP6ZyQEAI7Au9/GTc+NNvDndQYchbWFPKj6VTwXZDDB+sYP1cwbM8HWFuEUbuK3t+9/2VKY3sUs4Cf5FhS4qPlkPxer8vge4T7wq217ahUr3IjoPjpWNVovj06smhBykBB8YaLJoutDH6nyT22yzxUseVZhVcwls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439917; c=relaxed/simple;
	bh=3vywFbZsOPiwids/kZUxiDKIzKHchPzHB9MqN5B9wEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4IDDHETIBAW14iKLPKAp9+bjkALEyNfeETtWdKgSaZWJY3gfV3g6wQNo+lVZWq+W60xDpK1YyR2vDYDTcRWxQNMRDl05Fsmg/B7JLCmXRZnDle8rqBFywRliXOJeR5EVO18GEXIDK81BbuMJ135s17wt8QhcL2ncLD6lNisctw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3i65SYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3i65SYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D483C4CEC4;
	Fri, 27 Sep 2024 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439916;
	bh=3vywFbZsOPiwids/kZUxiDKIzKHchPzHB9MqN5B9wEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3i65SYd/nf+Yu4Lrhk02OUHurZP9hbrpcwkCp9gYuAvoDZwpOW3hZyDgTB+alih2
	 kHl3NHThi7+ZV5b3Hac7XOhV3Ls+6HfWAEjzS3zWbZ1s3c5kYTOL/ylt3tf1bWBKvJ
	 4o/6ibVPIPhgzWwGSuUI3RibHs9pRYXcMV/bsa20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbo Li <lihongbo22@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/54] ASoC: allow module autoloading for table board_ids
Date: Fri, 27 Sep 2024 14:22:56 +0200
Message-ID: <20240927121719.897227460@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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
index 354d0fc55299b..0c5254c52b794 100644
--- a/sound/soc/amd/acp/acp-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sof-mach.c
@@ -162,6 +162,8 @@ static const struct platform_device_id board_ids[] = {
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



