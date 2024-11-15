Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984D53BBEB;
	Fri, 15 Nov 2024 06:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652900; cv=none; b=ZiGJjNj4dKb2W3EcGUhc8j69MH8NvpzKd5I8oic0fm0KH3vcunZGN/owyCQKtW9DKjaolZpG6YxPxg2GJbphLPUWrmzSPsK0n/sTFCoGERwSLy/Uv+iWjbERtbTCFKEIrp4rMTp3K4h+GLlUDtEH0gEMOiOCEebgIAutP2RC4QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652900; c=relaxed/simple;
	bh=RZAl89LyPbS6FTe7+Mxqyp4OkaS9Z5zrbWDQQfxf+c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AteEHmG4Day+pjxXcX6p0Ls3y64x6RcvNHZhXgjTI+Vln476fndbmzHThsAaQh6vOznQ6iDD1aeBWG1CE2DeY7h8I/+0F7OLYxo0Js7okRqhE26IevcaWUNqAqvF81trd/oS97bvPDiiUYz70EIauo8oIVMiommCagHTvJdUf/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUi3rQX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUi3rQX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09765C4CECF;
	Fri, 15 Nov 2024 06:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652900;
	bh=RZAl89LyPbS6FTe7+Mxqyp4OkaS9Z5zrbWDQQfxf+c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUi3rQX2dd5K0skLt90UV4hvLRECXY9hb6U8+tqvC4RXzOPBqKEeHojlLVaP8Xprn
	 D73Qo+HQfoKO81O9GwdjVntWmpYZD33KrPzm+WlslBZSBgJM+AjlNv8Ci59mqPxVYj
	 QOqbnYcvC6Dk/QQ8Ntn6hVpMlyGTWzZL5aguwY0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yann Sionneau <ysionneau@kalrayinc.com>,
	Julian Vetter <jvetter@kalrayinc.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/52] sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML
Date: Fri, 15 Nov 2024 07:38:01 +0100
Message-ID: <20241115063724.586434860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Vetter <jvetter@kalrayinc.com>

[ Upstream commit ad6639f143a0b42d7fb110ad14f5949f7c218890 ]

When building for the UM arch and neither INDIRECT_IOMEM=y, nor
HAS_IOMEM=y is selected, it will fall back to the implementations from
asm-generic/io.h for IO memcpy. But these fall-back functions just do a
memcpy. So, instead of depending on UML, add dependency on 'HAS_IOMEM ||
INDIRECT_IOMEM'.

Reviewed-by: Yann Sionneau <ysionneau@kalrayinc.com>
Signed-off-by: Julian Vetter <jvetter@kalrayinc.com>
Link: https://patch.msgid.link/20241010124601.700528-1-jvetter@kalrayinc.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/Kconfig b/sound/Kconfig
index 76febc37862de..be30a24daaf1c 100644
--- a/sound/Kconfig
+++ b/sound/Kconfig
@@ -1,6 +1,6 @@
 menuconfig SOUND
 	tristate "Sound card support"
-	depends on HAS_IOMEM || UML
+	depends on HAS_IOMEM || INDIRECT_IOMEM
 	help
 	  If you have a sound card in your computer, i.e. if it can say more
 	  than an occasional beep, say Y.
-- 
2.43.0



