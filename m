Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317B2AF07;
	Mon, 28 Oct 2024 06:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098204; cv=none; b=RYLr610KFwb4GZtslNUF31D5K5vvjGeCnXGHje23ZBXZKUGtAvU+BG5gUwA97Efj5SryFQqdDjhjNvj5sIIVkouJ6ieGdknwy6GSjXtuZUe1Yfw4FsWseo1/1kJatGPam17YAjUnx/FtxWeuxoZZGqB8My8vvjDum1Xbo0O4L+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098204; c=relaxed/simple;
	bh=t9gQCdFhqq6u1yxcHmSHqMDNWBPI0dUHn4wJWsJeS+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7F9jhfPvuVnjxs6RdD/gctLoX7qe9lG6YnbxTSTuWwZo0vmKEr3qUWEvk3JnKNWE2pD4i4M/iVltpgdI7IjDVfQWnciN1zb5cbItRke3MzSzdO6BVAKZTgmHumwJegGfVoOFtRek/T/h3rjzkBAhVmlOgIWukUXUBB8nMCTNcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoGN8Cgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoGN8Cgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5333FC4CEC3;
	Mon, 28 Oct 2024 06:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098204;
	bh=t9gQCdFhqq6u1yxcHmSHqMDNWBPI0dUHn4wJWsJeS+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoGN8CgsTmSgmOjoT7AugGo8WSiiVuQyZmbtQQNxaU4wPQYt/RIYBJS4w/QMup6Sz
	 w+QeD68rs4LDtQg8yxdm3RqT2OEYatEkB2ZTsot27oRl20FK8Ns8qJyXA/QTpxATmu
	 63lnYJO19RBlkrlHgjq4fuF6dEunbuHTyckwTzQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lawrence Glanzman <davidglanzman@yahoo.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 123/261] ASoC: amd: yc: Add quirk for HP Dragonfly pro one
Date: Mon, 28 Oct 2024 07:24:25 +0100
Message-ID: <20241028062315.115343017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

From: David Lawrence Glanzman <davidglanzman@yahoo.com>

[ Upstream commit 84e8d59651879b2ff8499bddbbc9549b7f1a646b ]

Adds a quirk entry to enable the mic on HP Dragonfly pro one laptop

Signed-off-by: David Lawrence Glanzman <davidglanzman@yahoo.com>
Link: https://patch.msgid.link/1249c09bd6bf696b59d087a4f546ae397828656c.camel@yahoo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 06349bf0b6587..ace6328e91e31 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -444,6 +444,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A3E"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8A7F"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



