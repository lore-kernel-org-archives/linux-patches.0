Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590792;
	b=Le2yT0hcEgiRs6Idw1q4ElTLklzlAPKFyQ5RWWR11Eb+8COdP3Y/q/3qXm6hQVIPqeL/
	 PlhY34mFqmGwzo+CtkR0hyuHGn0vvDuvhBd8Gzk8ZIdkTF8SqsZJnQnfN4bVbgTQGbeEd
	 tCli2O7MHgLfAMuBmeAVRGWjNC0i1i09I35cMZ1fRycf1haSAtEX++36jz0Jwf4R7WHoE
	 d1oJA/HYAHS6rTvTItYXqWNVL+tIYqU7xdL5YLnvqABfDFXeD4iyzqKhmiUDIyvmsC+R3
	 Fsg+eaOYHyecjr6Xd3hE2df4QNWVDTwKokzjQ6DM/Igz0P/83QjXXO2dk250ns8XlhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H93L4WqAuaeukrBJVhoUS7lrApzkVon7gHMJgrVfeuk=;
	b=iHbACj6//lUbqEFNTpGGVAdxKwS8tq637Y3LAWtV/hUlz1CfDFm4akSI8q5H7fZdo4cI
	 MjkcV6DLgeHoDH00UK9Otg6xkq4k7BEzHEbs6BaKt41i4YXP2UHPr+tK+yd6OysUCbRDH
	 HG86DN3u3wjfIZ13dr075P3am4pWYFnLwl5xNuUECXHydberex3MrJxjtOeh1gePWnorV
	 b1SXSjmJ+NmbcgNamUNtSBou0H8H4C9A1bmJNi6ueLricZPywgogXeEC2jWdpcb4nOPlq
	 5URCDhBGtnrNbdEVqunFV0jjeMhD0oR8+T02D9lqVuWAR6nWHO5Z+I+HE3Oym69BMMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OI/bUZsU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92245607D2CD;
	Fri, 13 Nov 2026 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OI/bUZsU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA2F1F000C6;
	Fri, 13 Nov 2026 17:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590792;
	bh=H93L4WqAuaeukrBJVhoUS7lrApzkVon7gHMJgrVfeuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OI/bUZsUtO1vvBCeFm4dP+db5xYFjz3fGQzCcA+1XWXL6mdk4+Axv9oL+dUy3DBHs
	 olwjyR1wPInY66JQq/dUYQi0XO8ujGszV4hzJqtxfFulBXXZNKYXiI0r+YLJ33VwlW
	 giKx0NYdlmndV8HHjvfI8erwX7x25D8GYBgB/XcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianluca Balboni <gianluca.balboni06@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 684/686] ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx
Date: Fri, 13 Nov 2026 10:53:37 -0500
Message-ID: <20261113153844.803785273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianluca Balboni <gianluca.balboni06@gmail.com>

[ Upstream commit 1e73257dff33ff851af60d5bb00d73893a8b6dc8 ]

The HP OmniBook 3 Laptop 16-by0xxx (board ID 8EE3) has an internal DMIC
connected to the AMD ACP6x audio coprocessor. The BIOS does not set the
AcpDmicConnected _DSD property or the _WOV method, and the board is missing
from yc_acp_quirk_table[], so acp6x_probe() returns -ENODEV and no DMIC
capture device is registered.

Add a DMI quirk entry for this model to enable ACP DMIC support.

Cc: stable@vger.kernel.org
Signed-off-by: Gianluca Balboni <gianluca.balboni06@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261031102136.24600-1-gianluca.balboni06@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: adjusted insertion context to follow the 8BD6 board entry instead of 8DC2 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 209ac43f9e31e..f7507446494b1 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -682,6 +682,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8BD6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE3"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



