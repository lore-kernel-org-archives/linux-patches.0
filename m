Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA03F198A3E;
	Thu,  5 Sep 2024 09:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529972; cv=none; b=rNVH/XlvvTOhOCVUx50LtG5lp8q+GTlljcQ50aDSfJau4MYk0PEqLp3IgZfjVnm9Cw/Drw9WZU/VI1vTd7PpbVogba4OdFE6deuoc1niQv6CwcuT0yJUNLDtdvIwPUhOqDxMQ0iJXfNzzRZE9FqnKyQ3GOEvmr8h+4AuKQecFqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529972; c=relaxed/simple;
	bh=M4suhzXjy8WJb3iDtECSMmcoVuIaBWgZ3fMksLUc314=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvNxSThhmVZMPm3Dawg15AYzqOpqoexQoH48eGClxcnSUaB8xWVtmLbFyuXrUBFGAhxbnzpl4Rf6LTqPggQf+9U9Z2QMRIQZorR+hi249hERWwPmUSUjHoLcWigvqeiG8+RtjKXKvuLnu9mCKnpG8rPRub6fcgnhKqNE7yILVWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHNRQ4j9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHNRQ4j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4E5C4CEC4;
	Thu,  5 Sep 2024 09:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529971;
	bh=M4suhzXjy8WJb3iDtECSMmcoVuIaBWgZ3fMksLUc314=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHNRQ4j9UvzNUPwOQstM0tS7A9CKbEjmwqqei+150TLSiGv8mGuLYCc0kx8GDRl7v
	 MRJkEJDLlD99kNvaWLKBSUwgyzTTsjpJL7eegx2ntJdmnHWn3bWvDdqHBsOZLZWs5n
	 Z3XsohtBqn2xFQaxJZ5Hz3x3b28ZI307Vd+jZyDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Ancona <brunoanconasala@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/132] ASoC: amd: yc: Support mic on HP 14-em0002la
Date: Thu,  5 Sep 2024 11:40:02 +0200
Message-ID: <20240905093722.829938905@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Bruno Ancona <brunoanconasala@gmail.com>

[ Upstream commit c118478665f467e57d06b2354de65974b246b82b ]

Add support for the internal microphone for HP 14-em0002la laptop using
a quirk entry.

Signed-off-by: Bruno Ancona <brunoanconasala@gmail.com>
Link: https://patch.msgid.link/20240729045032.223230-1-brunoanconasala@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d597e59863ee3..e933d07614527 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -430,6 +430,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A3E"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8B27"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



