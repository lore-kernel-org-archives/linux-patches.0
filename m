Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F9E513567;
	Wed, 30 Sep 2026 16:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784701; cv=none; b=R7Rn/65WGGzcbdwo7czhwH/9SOb8qulI9Bg1lLECpzt98ATHCtWSQuH1lOaWeujYPB/vr/oxff78k0MSuuslllEZ4bd69uxtlXHakZmDa3fxLWvi/SmSSB1ft1j9oMeti/aP5kB8P5iCBGjlHRXjudYikeV8Dg0w0xFy92AwpLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784701; c=relaxed/simple;
	bh=AY2o5J5Yu8Py/Cf6/wXLq2jItRq3zkKApHUHla92X7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVThgEI7golrPCcysY2HRktiIzm08JbSEdkO3dN3yb++tsmb0LWmbXlJyc3yxGqQVK+CEcQ0jg0sTofjZROGhnvEDgG5wPociJAX7uFhRbynzg46yl8VquG5uEbsU4RZOXzvcocSIOJW9eoABLXGCT21mmvekase7ENsfNtFIQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muL5A+uX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muL5A+uX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E834E1F00899;
	Wed, 30 Sep 2026 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784694;
	bh=b6XX1AgDINa8Oc3EK2LehCJDwkQ1nsdA/SnyFwqwgaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muL5A+uXFFTP75QXzPZc7J2vGm7juA1w6AKGOsWhCVoEpwW1JHG1Dg+xXfMjvUgtf
	 ZzBWGHBOMe4JIvZGd+r6anrii/NsqW+HDvzmYjRuMO1jiOu4FlxRlq/tbLPe9Z4GbN
	 7p0lvwaVbwERVz82kTf1C94pKBLrTnPqD09w03zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jetha Chan <jethachan@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 244/982] ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table
Date: Wed, 30 Sep 2026 17:16:20 +0200
Message-ID: <20260930152422.035457815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jetha Chan <jethachan@gmail.com>

[ Upstream commit e782d687d2f5bf8b8113dc48ba22cca4b472c252 ]

The Alienware m15 R7 AMD exposes an ACP6x DMIC path, but its DMI
product name is not present in the Yellow Carp ACP quirk table. As a
result, the ACP machine driver does not enable the DMIC card on this
system.

Add the DMI product name for this machine. With this quirk applied, the
kernel reports:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI

and ALSA exposes the ACP DMIC capture device:

  card 3: acp6x
  device 0: DMIC capture dmic-hifi-0

Tested on an Alienware m15 R7 AMD with product SKU 0B59.

Link: https://jethachan.net/dev/2026/03/21/fixing-internal-microphone-alienware-linux.html
Assisted-by: OpenAI-Codex:gpt-5.5
Signed-off-by: Jetha Chan <jethachan@gmail.com>
Link: https://patch.msgid.link/20260630003328.15675-1-jethachan@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index d2ad98dbebf14..afbf1edbeeb5b 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -395,6 +395,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83J3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m15 R7 AMD"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



