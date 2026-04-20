Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2D03396EE;
	Mon, 20 Apr 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700627; cv=none; b=c7sw2Hre/C7NdGrMUMYrpJWaw8zUuKDj0ADr9ds1RPCpXOY+EeVDsxGgQ+ABYowFeyQAJNcBSYe/qLQ0L04ElNsWhTqg8u/gejbnMFaoFUASOo+W19iSemIuqCCKli6mml1HPkXBsc+SJAlUtoavhsxd80sJXR3s7QBmywIbm0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700627; c=relaxed/simple;
	bh=GYD3kh5gvTTMV3e7h2IOpOFvMgSWC9U5zx+g2RkYlLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emeWiayMu4Nm7kKIowCOFnhUyaXKbPljUgZFm8EOK9s/pkflfvIicCXOBkTDMzbXk9cNlg4F2U9KDnM9Y8jhOT4TRd+FcOjVstkl2k0PHDYHxJNWbwGawMrHggaQyRjPtSEDFxFqBNgwGz7ZSB2l6GvC7ZuzrHBbRJ3g7IP0usU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvsPawcR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvsPawcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C48C19425;
	Mon, 20 Apr 2026 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700627;
	bh=GYD3kh5gvTTMV3e7h2IOpOFvMgSWC9U5zx+g2RkYlLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvsPawcRWCFYWjDK8XZ0gjHaBpwKc9sCjmEyq7+Mv7bThRpL8s9MXZ1cGjZEyFR3W
	 KbKFfeBu3Vwu914aiX82aw5M1SPcQ56/lI49gArwDdj+W3XHVcxZ73+OwN2rFoELD/
	 0785qEtDhSYxtWk0nRoxT8KH0YM9WFCeImxcD4W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Dustin L. Howett" <dustin@howett.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/198] ALSA: hda/realtek: add quirk for Framework F111:000F
Date: Mon, 20 Apr 2026 17:40:04 +0200
Message-ID: <20260420153936.523818015@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dustin L. Howett <dustin@howett.net>

[ Upstream commit bac1e57adf08c9ee33e95fb09cd032f330294e70 ]

Similar to commit 7b509910b3ad ("ALSA hda/realtek: Add quirk for
Framework F111:000C") and previous quirks for Framework systems with
Realtek codecs.

000F is another new platform with an ALC285 which needs the same quirk.

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Link: https://patch.msgid.link/20260327-framework-alsa-000f-v1-1-74013aba1c00@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0c975005793e7..e7f7b148b40e5 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7555,6 +7555,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000f, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.53.0



