Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13913234994;
	Sun,  7 Jun 2026 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826831; cv=none; b=fowpthPtvOrV3UHsmdkx14NXtjdnk/IPajqIOK6G5EgzKq4ZYCBx996Ta65OCmyzBbkFiLHn+OcVQgfhiJK8nmzldrr84nL86X2JSYOaB1xFMwEg+NLnG9zkYEUJgZcA3Mh0Dzb3MiriUIIiTOOvqv7WlpGgrFuIAiHqJwfb7eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826831; c=relaxed/simple;
	bh=LVb5PkXYrjyEBwjd9J38VSw/glzOY5jjrS50+ZrniQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFDj4maUyh0DJO4rbOvkqufMrr65BbY5YxrYbGcSK4ThQNcia4ElkDQjoXRtzs3Sntc6+mVxrFjtItDHB9cz6zFTTjXPZMRvGOAdDqzwkYzOFICJlfd0xaZwpFkbyXNxPQM2vgydewcPu1Q3uz56ZaM1HyBEgqDm8lqMMa+dzYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpVscCQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpVscCQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F651F00893;
	Sun,  7 Jun 2026 10:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826830;
	bh=KN05UH7sdHj+GGkiyosjZum4cls9B6N1y2OnPqx7z2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpVscCQ4pdx4uMokOEWBC3F/Kt1uPk51ryZzpNpDW7PwQWqVrJCAR5M9fGlHY5gay
	 6b1f18LClTp9KRsd1Fcz7DS9/RZcyKy63z1FrYMwGo1PnVgy4wdKrByvrK4OSGWOeG
	 lA2Q08r3FtYkeFsQDglj5MnSpCIqHr+R804qBd+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Kai <lukace97@outlook.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/315] HID: remove duplicate hid_warn_ratelimited definition
Date: Sun,  7 Jun 2026 11:56:39 +0200
Message-ID: <20260607095727.951400287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Liu Kai <lukace97@outlook.com>

[ Upstream commit dd2147375a8fe7c5bc3f1f1b1d3a9567c26faefa ]

The hid_warn_ratelimited macro is defined twice in include/linux/hid.h:
- first one added by commit 4051ead99888 ("HID: rate-limit hid_warn to
  prevent log flooding")
- second one added by commit 1d64624243af ("HID: core: Add
  printk_ratelimited variants to hid_warn() etc")).

The second definition is correctly grouped with other ratelimited macros.
Remove the duplicate definition.

Fixes: 1d64624243af ("HID: core: Add printk_ratelimited variants to hid_warn() etc")
Signed-off-by: Liu Kai <lukace97@outlook.com>
[bentiss: edited commit message]
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 204ada8d12e5c8..29561887bea8c0 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1276,8 +1276,6 @@ void hid_quirks_exit(__u16 bus);
 	dev_notice(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_warn(hid, fmt, ...)				\
 	dev_warn(&(hid)->dev, fmt, ##__VA_ARGS__)
-#define hid_warn_ratelimited(hid, fmt, ...)				\
-	dev_warn_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_info(hid, fmt, ...)				\
 	dev_info(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_dbg(hid, fmt, ...)				\
-- 
2.53.0



