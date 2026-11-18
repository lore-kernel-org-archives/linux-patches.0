Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039119;
	b=NqrUbit7oRVmInj7A6pRoLpnuqYRfJSOUJ5puBr+oLN2pq9Yyrrw57g1eIo9J1qXSZJS
	 84Ncz9+s4nRE7JUR9oyhN+cPhBMPp3lL+wEfIvqkDv8h6SIpyV0iQBRO/R9nEBvlY1UxE
	 buP6wj7wDJffWsSh1+uMHRqiAipZOfHXq4CB7O9WezM+xWPHcUksbY/hvbH/+ER/B4kAZ
	 n91w6tdVHhdoAhsa3fFXkZVhmiz/VLMbNH5JXhCCPnvM8AwJMtzf2mSpwFpxCMHqn5IMB
	 9cGs9cGlO595KflTvIEWngQYkw/O3f535AvJcKTTVOMblvU4o9aLwzd5Yb3iVBJECfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=feX03ha1PLCqHKM6VFt+YfqclY6cIh92P1UWJcQrh00=;
	b=j1cI9iufuYUPgYSgsIEkA7L3ts/Icq3jZhz8yj6C13uFxNbKfXxL2GXrmzbrT1Qhrn84
	 k6wvVeMCbVo3Sruq7OwNbc9WEGls2MZVLh05Yr4dgGuassXiWofnMj3I4W/QcRr5CdTWX
	 Iw0BHvapyaRQTdmMHIdfMuWHN0d3OaNe1eo10zX44VQUceLTcUXkkrwTO69flaj0AECkM
	 OqFZydfJNRMgdd4aMsdOLGvy6VhEYmSnNE71+F59lAbu90WhWciiRMkFuh38110YYRotg
	 wPR0WZm7weu0BbRtV5ZpAvxad+IEhE5BnI5TF+XskDoth1NfPcIG4qoXfrcwXzFiyeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTa2nCcR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C42606A31C;
	Wed, 18 Nov 2026 21:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FTa2nCcR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15021F000C4;
	Wed, 18 Nov 2026 21:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039119;
	bh=feX03ha1PLCqHKM6VFt+YfqclY6cIh92P1UWJcQrh00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTa2nCcR3kq8tuAOMwRyHIsYDw8ArJQj0uRt6E0PM154YK3d5kXrWmJ5RHI/oWGMG
	 9edlyYavKxGs907+OkOVeo4t4EmyAES3gnGnpjWVIgHdLpHsnCialO6fUZ0ceGpSWi
	 xcAvdmOhyURoTAUrlAJjhxcp5G56GU2b0Tk7WFXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1986/3318] bpftool: Fix spurious batch file read error
Date: Wed, 18 Nov 2026 15:43:28 +0100
Message-ID: <20261118150421.646716978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a0536528dfde2..be60478b4692d 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -354,7 +354,11 @@ static int do_batch(int argc, char **argv)
 
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
@@ -455,16 +459,6 @@ int main(int argc, char **argv)
 
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



