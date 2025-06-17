Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B8F1E8332;
	Tue, 17 Jun 2025 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174990; cv=none; b=Y418C1HojLLtZm7e58MpQosivFUtDf3c92vFX1fUIasy3d9anT6tHVuqf/k1gABN+LaPBw8dle55L+oKBGGAm80nxUi2oZb3sp6eduMMrL7Y2tirzLeWb7Njq5lIkipBBH/MJRJ4vQuJPaAybAIt1zOwtAV20IY+K39uv4Bo/fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174990; c=relaxed/simple;
	bh=qF73YeAfV+iYpLTnLZgZzJOpelM3ZGDkJcCQhgm9RY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vpg24DLf270FGZAeDqQCyv/Ryrcw13L8AQOp1FZRlsAaqWY4XGlULQ2HlaFD9VqQr1jTbFjhA5olOno29Z584l4MFLzlmSJRoVIwfPhlcjyCraTDPxG7VUp8seVZdPdNAzso59ufAHZdML5yeebKz3TSTbg0f/bSeArdKv3v56M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uch4srJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uch4srJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F05C4CEE3;
	Tue, 17 Jun 2025 15:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174990;
	bh=qF73YeAfV+iYpLTnLZgZzJOpelM3ZGDkJcCQhgm9RY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uch4srJ31mJHx/CzphqfBo/xOIhaJHvJ4lhX/nOtPzfdLZ2UdqY188KwvD4wlI8a7
	 uDevt+d48ly/d1J34FDVHIvnPbFKLOHiMMF9nW6WSq3cvHcxcz7WJzvvB0zZW6JjOU
	 2iZDs6X/Jjksuh/iYCn69Ks4pWsmB3vo5+77cWH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/512] m68k: mac: Fix macintosh_config for Mac II
Date: Tue, 17 Jun 2025 17:20:48 +0200
Message-ID: <20250617152422.901120057@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 52ae3f5da7e5adbe3d1319573b55dac470abb83c ]

When booted on my Mac II, the kernel prints this:

    Detected Macintosh model: 6
    Apple Macintosh Unknown

The catch-all entry ("Unknown") is mac_data_table[0] which is only needed
in the unlikely event that the bootinfo model ID can't be matched.
When model ID is 6, the search should begin and end at mac_data_table[1].
Fix the off-by-one error that causes this problem.

Cc: Joshua Thompson <funaho@jurai.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/d0f30a551064ca4810b1c48d5a90954be80634a9.1745453246.git.fthain@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/mac/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index e324410ef239c..d26c7f4f8c360 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -793,7 +793,7 @@ static void __init mac_identify(void)
 	}
 
 	macintosh_config = mac_data_table;
-	for (m = macintosh_config; m->ident != -1; m++) {
+	for (m = &mac_data_table[1]; m->ident != -1; m++) {
 		if (m->ident == model) {
 			macintosh_config = m;
 			break;
-- 
2.39.5



