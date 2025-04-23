Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193892F2E;
	Wed, 23 Apr 2025 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420440; cv=none; b=BtbT0m4PlzyOrWVIKpMx70FBcXn08c9kESr3qTxh2hyxjvUmp/ZVlcarRZoqmP0vNqnar00d93X/3pCet/anjbsr8aswDxB3hwfaiTite3WTnM5d/CWM6r4AL4KXGhm5w23/HErg2Y8UfhnUE1y/iU8j/ZanTZsR7HYg8MD5sPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420440; c=relaxed/simple;
	bh=TTaK6q5EEKpXxM4utosuN2WqrmMIQgmBdjCTmdPyQsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DN0Wvr7eQOTlXdL75yERWg3DBZA88b51b3vnXLlaZXRyudlBhtdus6qhdpwHFwNn2S3qc/Pm3nTXeCq404j63IBhD2lPM88d1j+pFd/Wh9GWImE1toPV77+11jWO3WlmAo1gfNAqC+syJ98HiWGTXlOwQsAAltEF2j0VZM+KwCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlMjqfO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlMjqfO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E97C4CEE2;
	Wed, 23 Apr 2025 15:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420439;
	bh=TTaK6q5EEKpXxM4utosuN2WqrmMIQgmBdjCTmdPyQsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlMjqfO1UQmiU2KypxwhVsHLqxrK9cdGDcelC8l0aiXkWUjy8Ruk5jHPgYQdVGywz
	 p8iExnX8a7OXNK0R7/r6xZ56v/mzbOPY5iN3arYYfoBjNSkoKnJZWqJTEogDXn0LJP
	 AVU90JmH6O6biWShbKxowQ7p8K9hGMPpL5ePogmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Saba kareem <syed.sabakareem@amd.com>,
	Reiner <Reiner.Proels@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/393] ASoC: amd: yc: update quirk data for new Lenovo model
Date: Wed, 23 Apr 2025 16:39:21 +0200
Message-ID: <20250423142645.990524694@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Syed Saba kareem <syed.sabakareem@amd.com>

[ Upstream commit 5a4dd520ef8a94ecf81ac77b90d6a03e91c100a9 ]

Update Quirk data for new Lenovo model 83J2 for YC platform.

Signed-off-by: Syed Saba kareem <syed.sabakareem@amd.com>
Link: https://patch.msgid.link/20250321122507.190193-1-syed.sabakareem@amd.com
Reported-by: Reiner <Reiner.Proels@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219887
Tested-by: Reiner <Reiner.Proels@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2536bd3d59464..622df58a96942 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -339,6 +339,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83J2"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



