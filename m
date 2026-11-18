Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015182;
	b=sFAkhYuyO11Mw/uGDK9/SZnM1DfCLV09Gi70kAUfobNlWUiKTzbMN/6a7BLKm+0wQiyY
	 CE30NVPZiFK59LTt3piitaTfPACFrOorB9kU25KX0GMhzJcEmA6nIWc2oWDZ7ceJkxZ5b
	 fWEUQI+ZlEvoao3xtts6uvKPtzPDADEZ9wAVHXHEZOoRIYzRpGDWrCANQFmK5MCQGZuk9
	 KsSGIhach77Oln+bCcTyg8Q5UcufPfqBCF8Rn/Jp0GfSYrgIISJdhf8IBiUP/6pwShdKE
	 c7hPTPPk6PL9Bywl6Ky5BKOG5ugq15xwiB3QUgzXjxogFayZdc59wo0ELmNlq3jzNTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7rhfV4FCYu4RYPOwbv47HZ3L2ko8RDqOtl0QFciKmlg=;
	b=xl2NKQq6GK/XoLtz1hncfEz7bsc0TsoCLMQRNRDMvl+obxkNFCoeuzpikwnWXkFXageX
	 mhJYoiedSqTqaEnx1iD412qSAtqYFFGtzzuwDHACYM26lN7OZOEHgg8czW7M0ngia47NH
	 ORQsmAyjsyqmhrsQarRW2FmOhOE+ZAUIFNlrdFqOUYM817eAnomD1DN7zo0dPWuDtTUXZ
	 k2Ov7vZVsEJDeGXfmJ2LQoGrxjD+lcCXcEP0911gS9jBQ11EYkVRs8lgax7ZBG+K53a5g
	 NASH1ddf/tQ0v0LYnbnu157sg4WLgPnsMd1SzHjs3iuRzChzFLvRdtDSMHu/AWNXQNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRIi3wrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C8A606A333;
	Wed, 18 Nov 2026 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRIi3wrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950581F000D3;
	Wed, 18 Nov 2026 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015182;
	bh=7rhfV4FCYu4RYPOwbv47HZ3L2ko8RDqOtl0QFciKmlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRIi3wrk1K7BRksCOXRIoW4Uy72cAb1lmjAdj/7NY/NHM7SOp9pM9KPd8wesyj5Hl
	 H4Byt8plHUGB867jbsFIm14FbIK7xPEoszC22KKKNj7ITxHjPoYhN416IDKNzPhFkd
	 r/NK0PbtO3jCycyvZSRfVU+dceaU9S9/N/aTLv90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0083/2651] bpftool: Fix spurious batch file read error
Date: Wed, 18 Nov 2026 15:22:03 +0100
Message-ID: <20261118150250.903584091@linuxfoundation.org>
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

From: Yuan Chen <chenyuan_fl@163.com>

[ Upstream commit 713c02b59e21840f623a3e31c43d967026c75181 ]

do_batch() checks errno after the read loop to detect read failures,
but fgets() does not clear errno on success, so a stale errno left by
a previously executed command (e.g. map dump's EBADF from a double
close) makes bpftool report a batch file read failure and exit with an
error even though every command succeeded.

Clear errno before each fgets() call, so the post-loop check only
sees the outcome of the last read: zero on success or EOF, E2BIG for
an overlong line, and a genuine errno when fgets() fails.

Since errno is now reset before every read in batch mode, drop the
USE_LIBCAP errno reset in main() that existed only to keep errno clean
for the batch mode.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260824092657.1789956-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/main.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index c91e1a6e1a1ec..7a0c214f08a0e 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -365,7 +365,11 @@ static int do_batch(int argc, char **argv)
 
 	if (json_output)
 		jsonw_start_array(json_wtr);
-	while (fgets(buf, sizeof(buf), fp)) {
+	for (;;) {
+		errno = 0;
+		if (!fgets(buf, sizeof(buf), fp))
+			break;
+
 		cp = strchr(buf, '#');
 		if (cp)
 			*cp = '\0';
@@ -467,16 +471,6 @@ int main(int argc, char **argv)
 
 	setlinebuf(stdout);
 
-#ifdef USE_LIBCAP
-	/* Libcap < 2.63 hooks before main() to compute the number of
-	 * capabilities of the running kernel, and doing so it calls prctl()
-	 * which may fail and set errno to non-zero.
-	 * Let's reset errno to make sure this does not interfere with the
-	 * batch mode.
-	 */
-	errno = 0;
-#endif
-
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
-- 
2.53.0



