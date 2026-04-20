Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B01341AD6;
	Mon, 20 Apr 2026 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700098; cv=none; b=FGLRarhWm0kkYD/0J7wgknC3QY0crPVbHUDpsYsW1L7iKDWS8QeFPwPnJrFsTMrn8kfII51uhVm8Dj+JmmlrWJVisSk9z5NayAY8DCLPVZqSuijhLQEQhp9pUvd3/KO0vfs+K9Qz/2I2PSKnrLv/Ne5+LSa4NGr1hcIk9r4gM8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700098; c=relaxed/simple;
	bh=ePjjkC861CG8LrSVln48WRq7MSGcBjHwi8VBo4C5j5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAND2xvsWFvmwoHBDHjzczXRMK47dPCxaYZrOKoUBBU7am+ee25Aq6XmH+EwW6s3DvfgtixkcDAvBf8D+7KPM93jtBAN6kgSIfio3uibkFUnHGHDtOrbj8lBMQd/owShER+hJDz9PLNkb48QwVhMLlnFEA5/FYjhm7Gxv82sXkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sm0of1/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sm0of1/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEAFC19425;
	Mon, 20 Apr 2026 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700098;
	bh=ePjjkC861CG8LrSVln48WRq7MSGcBjHwi8VBo4C5j5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sm0of1/iHSYWudIfHz7UEO4p6ozGgunj6PmLv5Dwgv6Y1vWC44Js2yAth/Q1e+k7M
	 58MDaQLl4cQcv/StrE6nqGKa6VSRYXlchubMvwhva4N0Exc1UMO9w1P0pM9kv4VTLr
	 HWmJ+BrgvIQAKuGVrPwfyNMuXe30V0TL1D+g1lac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gilson=20Marquato=20J=C3=BAnior?= <gilsonmandalogo@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 034/220] ASoC: amd: yc: Add DMI entry for HP Laptop 15-fc0xxx
Date: Mon, 20 Apr 2026 17:39:35 +0200
Message-ID: <20260420153935.264096321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>

[ Upstream commit 8ec017cf31299c4b6287ebe27afe81c986aeef88 ]

The HP Laptop 15-fc0xxx (subsystem ID 0x103c8dc9) has an internal
DMIC connected to the AMD ACP6x audio coprocessor. Add a DMI quirk
entry so the internal microphone is properly detected on this model.

Tested on HP Laptop 15-fc0237ns with Fedora 43 (kernel 6.19.9).

Signed-off-by: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>
Link: https://patch.msgid.link/20260330-hp-15-fc0xxx-dmic-v2-v1-1-6dd6f53a1917@hotmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 6f1c105ca77e3..4c0acdad13ea1 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,13 @@ static struct snd_soc_card acp6x_card = {
 };
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15-fc0xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



