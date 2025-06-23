Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A902505A9;
	Mon, 23 Jun 2025 13:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686030; cv=none; b=cky1TfCPPZSZou/C++ATPrCrTBQ2TABKE++6UZ6DyV8fr6A36cn+2LHwq7TfElLyxo5rDHh7oBO1020YAf5MQFE/7rECz/zQMdfXEBsLhBBpsiz2LwTP0npyi9ki4Apn7Lc/aenzcJ+nH/PQtOynC+We4WiILtA1A63XVZI2MbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686030; c=relaxed/simple;
	bh=c5bi00J6FtDT+uJDKYFR68++gZc1ajE0zrNxAmMeSyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnaMAPLZ25VEnW/0HIlWBOYditRJM6qh426moZHuJrqj+UT2xJIsiniEizt+A0lCB8Zecqeb/jS7wCiwVvov+m0Xi3LBR7N3OJCKRcGpXlXMU3yvhYggqliu+EmGtkAaPMi+bm+/IGnFaXFFqLpdvvOgSJoyrhEQWxxyc95V4rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NErXqmGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NErXqmGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD870C4CEEA;
	Mon, 23 Jun 2025 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686030;
	bh=c5bi00J6FtDT+uJDKYFR68++gZc1ajE0zrNxAmMeSyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NErXqmGEYStZf7X1t9vJr2jsvuaqZGCoX7XNMovIkSbMrHDBBrvZSv97xwrQN/II+
	 QLduuPKN/sVnJ+mvVc+nW2kr8Pb55xFvyyuzWK49GyrZ3TyKZALwRDA38tVrc8Z1bc
	 M11NYP5yci553jftQUOJk8HuXHmx5OIv4DCBobvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Thompson <funaho@jurai.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/508] m68k: mac: Fix macintosh_config for Mac II
Date: Mon, 23 Jun 2025 15:01:29 +0200
Message-ID: <20250623130646.328304724@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 382f656c29eae..9f5603e01a688 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -801,7 +801,7 @@ static void __init mac_identify(void)
 	}
 
 	macintosh_config = mac_data_table;
-	for (m = macintosh_config; m->ident != -1; m++) {
+	for (m = &mac_data_table[1]; m->ident != -1; m++) {
 		if (m->ident == model) {
 			macintosh_config = m;
 			break;
-- 
2.39.5



