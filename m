Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022935;
	b=qrSriT9F49FehAzYKbD6zz7VNhklfultYEL3DmoGUR6KzsqkqDao5SB0BjIrjQsy4Ch1
	 fMMBRZTCuFOp4QD8CKcz2rnaAGEEMLFbUB7fD1cDM6nAv4sQmwWlNiOZqVH1YIxPpppvU
	 p4HRRbzEA+cJmLdGeeOGTZSk5JstO6fr9y7znKJ9BOFmsjzQKPICCF5wJaY3I0U7b5Up+
	 ksyvEdcfYCdisaTsu3ELcXqITYTUtuTOng4NrkuRRD+0N7Gob37iTQ7xlmKTUz8p5IcyQ
	 /djA1/wBbfqAYc8+LiVFAa1uISE6OvVXW7bfbpncefbRm175zd0LvBWi4UMHPU9ugqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uzV1LmiI51nGp45+Pe7GGLar8WIqY7Arn8ebPVNG1yU=;
	b=DDMbRdF/lmDkpGBwarXWP8ndIkjQI6YiugSMej35ZzOYIG72tUHQWatQCeFkq6GsHUKR
	 Ls2sI+L3XV+5yu0W7sztdnmluffH/VBU6PJ9Yj6ebuAUFSIT0Td0HsG3Z025UF8ER/YDh
	 nIvdKAn6v4q9Wkr0qH7yvoj5cGFmtavPgRp2hUh5u5s8zvL3cxeNpZE3xhftyq0XeoVpv
	 xgbz/iDaKDStZPsk2utvAwO8WHY88UgMWm8/pDbR76UI3jK3ZgmOCQcdIVsb4IBqHbiRT
	 bGuqvsFa51FmcQYqtX5ll/5kVedXHh04mKy+rk7y8Lxr9pqblaZrn7oMexoAddxJk5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoDLcNlN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E753C606A758;
	Wed, 18 Nov 2026 17:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoDLcNlN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ACC1F000C4;
	Wed, 18 Nov 2026 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022934;
	bh=uzV1LmiI51nGp45+Pe7GGLar8WIqY7Arn8ebPVNG1yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UoDLcNlNl9U4CpV6oXH7QvT/ZF5Fs4bh+XbF4BhZXhGuKOv5oRxvxobugXstSp0cg
	 OzMtA9bxsz3DDC3U3TY0Zg9XFcDDGzuI7uQ7FRhD/B6xWlnCgk7w0yqp1cJrVKQ3X5
	 +KU5HgBsejKaAir4HxgS00vvmEceC+lITOVb0z1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0143/2151] bpftool: Fix spurious batch file read error
Date: Wed, 18 Nov 2026 15:31:18 +0100
Message-ID: <20261118150126.983012254@linuxfoundation.org>
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
index a829a6a49037a..429376d1f5446 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -358,7 +358,11 @@ static int do_batch(int argc, char **argv)
 
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
@@ -460,16 +464,6 @@ int main(int argc, char **argv)
 
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



