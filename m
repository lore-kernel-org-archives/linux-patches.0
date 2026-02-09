Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB652DB7B4;
	Mon,  9 Feb 2026 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648468; cv=none; b=cWqXGdRkoOZebTo0HsvojadnfrzuxoSXGwjiYhvrTThlx34GGSt4z+5DYN+scRjt+6wU9ide6eyhbZC16gdF8J0zILNaP/ToUl/J07RkOJEdcEeTj7vY03md3GaUeO6YYgZvNKZLcF0M+hpEihyg/F4wwx/Tvc5ukWP9KIealVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648468; c=relaxed/simple;
	bh=y3lEGcSHHHJRvjgjtliYrLENhv1ikrWk7CqqqcjX7sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKkkeI97EuvSKkfQO9l3clDL4jngNMn3olfj3zGO+pCBT16CfLrylQhnisfct/lzi8FL0/uOFY+humqGhHZEsOtCUvsZR2vxEBEEynC9nBAt4zgqYWXnQc6NxXcVAU39cnVoDvfPQVfO5stjGUgTsPQ8EVDk1N6tDgZURbYi7+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRxKnpKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRxKnpKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCE3C19422;
	Mon,  9 Feb 2026 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648468;
	bh=y3lEGcSHHHJRvjgjtliYrLENhv1ikrWk7CqqqcjX7sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRxKnpKE4NpIjPHEFoatLmsxGD/Ep6xmAw/BV+ewEAOGNQGoX9fSQxzZul0C7+x46
	 tNHvDFW2C+wejkrg9FHdPzOGD1yVPLRge+SLoVJQAvOP3SeCZe4Uqyxe5O9uDYs59V
	 ccNckfWsWg0VRTjSHEsR5Pwa7aQUaYM8uVCicwLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhi Bajahaw <bajahawradhi@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 46/86] ASoC: amd: yc: Fix microphone on ASUS M6500RE
Date: Mon,  9 Feb 2026 15:24:09 +0100
Message-ID: <20260209142306.440640975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Radhi Bajahaw <bajahawradhi@gmail.com>

[ Upstream commit 8e29db1b08808f709231e6fd4c79dcdee5b17a17 ]

Add DMI match for ASUSTeK COMPUTER INC. M6500RE to enable the
internal microphone.

Signed-off-by: Radhi Bajahaw <bajahawradhi@gmail.com>
Link: https://patch.msgid.link/20260112203814.155-1-bajahawradhi@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 00e4ffeb6fb00..b0456be5d921a 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -409,6 +409,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RE"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0



