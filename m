Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521EF2F37;
	Tue,  8 Jul 2025 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993611; cv=none; b=qRLKUbe36QUfPm9Gi/HjT0olm7xLfaCD4jxVUF/zx5mYXV8hl4HJSEpZbq/ylzbNhZXyA2yr/mgTMZpvDb4Xsq8dFc1rdjLW5XnI60iEBlAyxV8LQxq4+ogoSxAiRnYI9/egqA8hEvW/7Anl8GtLLXjVMjhsrRHvp2TWHQBLkfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993611; c=relaxed/simple;
	bh=TUapS6L4JL1Wl84IaBf8c/u/IiLRhJxkQqVO/hmV5RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI6tb+8E7VtOai6LoqPDPxM0Pm0gjaQsHOLwHeRPye1tPYj1m50TRcaQtFQ4XvKVXPPgFyJPtiRCBeLDlizQu0vhDA8HeZQmDB39dHfxGub5w/5Vw8r4J4BD9Vq7M7XOX95ug3IMKzZthahnrqPFUy5uFFl0d5UzfKC0KQ+kHUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLxTteyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLxTteyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE45C4CEED;
	Tue,  8 Jul 2025 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993611;
	bh=TUapS6L4JL1Wl84IaBf8c/u/IiLRhJxkQqVO/hmV5RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLxTteyHhSCLlKxwdWrMCLWbkqEGVhhZhKwnl/HdDfzrAnNgVvRWO98yuq+HFIKKN
	 a7pAYQnmKKviAtaDLmRtYOuAfklhNAEjLhRjFxh1tWOG6RZxlBtj3rzRRdlOvfP3gX
	 9qTDibHBEe7Tc72MYnJLhbYzBr+HS+Erq/UgCUUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raven Black <ravenblack@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 132/178] ASoC: amd: yc: update quirk data for HP Victus
Date: Tue,  8 Jul 2025 18:22:49 +0200
Message-ID: <20250708162240.014148896@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raven Black <ravenblack@gmail.com>

[ Upstream commit 13b86ea92ebf0fa587fbadfb8a60ca2e9993203f ]

Make the internal microphone work on HP Victus laptops.

Signed-off-by: Raven Black <ravenblack@gmail.com>
Link: https://patch.msgid.link/20250613-support-hp-victus-microphone-v1-1-bebc4c3a2041@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4f8481c6802b1..723cb7bc12851 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -521,6 +521,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb2xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



