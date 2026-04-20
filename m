Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BFB23BD17;
	Mon, 20 Apr 2026 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701205; cv=none; b=KGvcBkclnUhHkeAgLbnVm6NHUdRdpFSbz1ARVuSjMZOo2UJmgs92S5ui9HQt+1TJGLYk9b5iDlpqX8JEdcoudNXyKklT22QNBLcY62kJHKz65V2EZqtaA+JzfJmMi77dFpR3JisLpK7hJMeIqJ4US0sU9DCV//BiWDplljkm5m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701205; c=relaxed/simple;
	bh=xFYrjNVfo2OH1LbyS7JdSqz7wBHbOse5ivVWhN4Aq8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UhDuZXzVk2fAFU7tvzOSaBzesgjiP2EEAVN/JLodWZxLqjtUpEp70rKH0M+/8oWTc3FDC/5V5XmzHiv6gEWersnQ43eTId409/eWXGNHYCEMUknInHzbhcfa9YVvXLGeHUyuKJQ2o7DeixmkyZObFh/kIHcIcI9aLyMg4DS+yV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1ApIF0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1ApIF0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FB5C19425;
	Mon, 20 Apr 2026 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701204;
	bh=xFYrjNVfo2OH1LbyS7JdSqz7wBHbOse5ivVWhN4Aq8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1ApIF0s3/Vj4ntNnSpan483kMJh4FPgz4jhJ8lr8H8C4/OIkuj9htCcbg0cLP5cz
	 Ha8Tok2Fd3ILxS/NATesMQKFLyFvl0DfQjzLAi1bsTsmj7mJKpjzEWdNCvGcwW+Dtf
	 TmDZReLEqXMZ9FRledLMX9Tne8o+FuTmWLn9kcc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gilson=20Marquato=20J=C3=BAnior?= <gilsonmandalogo@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/162] ASoC: amd: yc: Add DMI entry for HP Laptop 15-fc0xxx
Date: Mon, 20 Apr 2026 17:40:55 +0200
Message-ID: <20260420153927.860792953@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2414c1bba0789..6e41d14e5f3af 100644
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



