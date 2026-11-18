Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026554;
	b=IOfq/DrBpjJ1OD9CNZqqVHSUhX0xCbkTfS19w8G5yH09K+bUjukUGI9jcd4UVbZ7YGMW
	 t4xcq8DKsON7abirBNLHrC/m99TBV43LdvS+Oqp5VFl3q1HqVoQWDV5/6To53U0083IA1
	 5+ufAKz1wqB1UutEljFLRunx67YQsdoWJC8LRJ78rHcTr3LPnqrpsfnAtcUEMEnSKFOHx
	 g6vBIHCPHYnjD6Cf3tvqY5+NcSZF0hPyj6FTd5XyrbedZUFAVRK0pQ70kHqaCLaDgxwCO
	 ukfYuyQQ0927NGU64ObzbLBdrE5skU/aEeKgGepzXqOv0wdN/QL1gLFPFZfTYbZl76A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yPUicxVmStb4BDGYV8nT8hgVTT1e6awNg2C82beUkjw=;
	b=FOGRQeCNqCQeRxPCaXjjgYHMc2ziuDsS9yK5nQh0lcQzGQWxij89eSWPqIhHPiD1OlOf
	 Bl2VDK/fQMxZcaDcX4RPdnToW9UlB6PXJN0tqnwXaoic9iRaMNTmsh29uD5vAzLVja/dv
	 4vCyXp2r/RdI4LqMDGBgx//n7FJxUxFPJ+p4GNwaIIbf1yAL2H0XAK6/pJcA6+ugjbVV9
	 TC8ihw7wwvVbMzjvug2nw2OK4KISRxQ75PNIbfgl2T9qwcCvy/YaHmR0c/aQqs0yLwTda
	 33DUiJ+TsJge0c6R92GPu8yIWgyV/EBFAbHdd4akUgW0q5ShVhBnj9NM76Ff0Y9LOKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMifS198;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8119606A31C;
	Wed, 18 Nov 2026 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMifS198
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A03D1F000C4;
	Wed, 18 Nov 2026 18:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026554;
	bh=yPUicxVmStb4BDGYV8nT8hgVTT1e6awNg2C82beUkjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMifS198Glzx8iKfJ1zHjmU6KFdV0XGzMEcbxdubUGCbL1eVXJREYrLuKb8ejdNTX
	 o6dGZUNBhQiamVJzKJ+9Ys7EgE6wR/x1+LY7AqRvXI72KkKUgQjKU8Fn90h4YUPIOq
	 lU3yyMYVSR2ZOiuCmXnSpTnFQSd54X6cNF/uog+s=
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
Subject: [PATCH 6.18 1478/2151] watchdog/perf: one digit too short in the raw event config copy
Date: Wed, 18 Nov 2026 15:53:33 +0100
Message-ID: <20261118150215.729848525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index d3ca70e3c256a..1bfe275dc8a6e 100644
--- a/kernel/watchdog_perf.c
+++ b/kernel/watchdog_perf.c
@@ -295,10 +295,10 @@ void __init hardlockup_config_perf_event(const char *str)
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



