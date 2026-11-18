Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020059;
	b=Epa6/hdhlU6gdfnqMQU1i6DrFKBjqW8yzwR/XIxvRbHRNGV158NbwFqSzZiq5DpRwh2s
	 IiOJIsid6sbHLUxegh/iNFXvL8weoEcbWA5WLl4wCtFOJMwSpLpWfGGIfITfrsoDigx8a
	 YLr4jKwp2zsBN4uzP9DQvPds0377gHtc9hyyIJlOPiQ3eL3ivItNgeceLed+FOYYMW3d7
	 Ednt/PQLr9VAFYPDCE9PV91+quaq187Dz9nRCj1RBKrs5Lthlwg/U72ujTsb1Y7UeKifM
	 JEhM9FFiK6lsL/mq8MiikOO+rom5BLNeADlEAj31dHdfsi7Sa5FTJ3kAp1fkaKY4lJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GOy00IkBAhXxmJAnHzKRDCIKh01BUTSmfqt5xoAQaIA=;
	b=QG+XfKRMIcnXv5bnoIWypeYuv4ApIgHULHBcxNkNb/12Da33zx5TOIxpeslWNyboOL+J
	 3Zy/E2qyML8osr1r/X1Ouc3SCeF4jZ/MVQ+OUpo6b7svF16vW4tj/9Y8dxRSWbT2y+XgP
	 jIfOu/Z5YgdXgt8/pmYETIEfJNvBOvBepeL1kb6gY4cDVKFxTpH2IW9HMs6aqobjMHhnu
	 oMJq15Rmb1Hm5TMOOD8xc4aFLz1xC9oh/nQikrhbN+T0m2pdVI0pN6MWUNLpDGG8vR/y/
	 VVJjbEQgpvvgs6Jg3ibv3hTG9/NPmjwEfwlgfxWAzfdoid4Vof34/wijkxt5q+6NO/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnR+NtV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29FC606A33F;
	Wed, 18 Nov 2026 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnR+NtV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1601F000C4;
	Wed, 18 Nov 2026 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020059;
	bh=GOy00IkBAhXxmJAnHzKRDCIKh01BUTSmfqt5xoAQaIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnR+NtV1ODTI0mmPuGzC345xa1COfv5pzXad8DfvXmFI1Bz/lmfcSB2eRO8J3zxLO
	 1YJEuXvOqiHYf8KwcNnSl7hkrsEl+nI0YIps+lG7DQKEal4eQjw0Z/R/Zh7daD86qO
	 UagO1kof2dJx9MbHoOshQKbqvFosGEKm5cWxo5gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Douglas Anderson <dianders@chromium.org>,
	Thorsten Blum <blum@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1817/2651] watchdog/perf: one digit too short in the raw event config copy
Date: Wed, 18 Nov 2026 15:50:57 +0100
Message-ID: <20261118150352.616451165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <brads@mainlining.org>

[ Upstream commit b682d597aa273cad6e99e665e0fd2a7eb8aa2cef ]

Commit 6164be01f179 ("watchdog/perf: optimize bytes copied and remove
manual NUL-termination") swapped strscpy(buf, str, sizeof(buf)) plus a
manual buf[len] = 0 for strscpy(buf, str, len), and that count is one
short.  strscpy() keeps the last byte of the destination for the NUL, so
the config loses its final digit, nmi_watchdog=r300,panic for example ends
up with buf = "30" and arms the raw event with the wrong config.

The empty case falls over too, strscpy() with a zero count writes nothing
at all, so nmi_watchdog=r,1 leaves buf uninitialized and kstrtoull() reads
whatever stack garbage is sitting there.

The old code was safe on both by accident, it filled the whole buffer
first and buf[len] = 0 then stomped the comma position, so the worst you
got was a truncated parse failure.

Pass len + 1 so the copy includes the character the NUL replaces, and
reject len >= sizeof(buf) like it was before the optimization, which also
turns an empty config back into a clean parse failure.

Link: https://lore.kernel.org/20261003110200.3-brads@mainlining.org
Fixes: 6164be01f179 ("watchdog/perf: optimize bytes copied and remove manual NUL-termination")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Thorsten Blum <blum@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog_perf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog_perf.c b/kernel/watchdog_perf.c
index cf05775a96d33..a4f677c16b206 100644
--- a/kernel/watchdog_perf.c
+++ b/kernel/watchdog_perf.c
@@ -301,10 +301,10 @@ void __init hardlockup_config_perf_event(const char *str)
 	} else {
 		unsigned int len = comma - str;
 
-		if (len > sizeof(buf))
+		if (len >= sizeof(buf))
 			return;
 
-		strscpy(buf, str, len);
+		strscpy(buf, str, len + 1);
 		if (kstrtoull(buf, 16, &config))
 			return;
 	}
-- 
2.53.0



