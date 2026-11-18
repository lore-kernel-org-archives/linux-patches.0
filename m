Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028864;
	b=xhET/OeKe1UmT2ixeOO/7hp5wejIJsObjO1wJiwbmcgta91e13WkfUPZO4GheHDGI41e
	 ewCT8yf+lTpUqXllLiz+Fk8DudfRpDNy9uXEzQQL/PcBIod+uIC1325SJbc49/UfWGQST
	 hu2TT+9iV1F+/Yh4TD/hWfYsfo1qxMt2CT3UGCpibRCIuErKXqGgbwqZ+5aXc9glFli3i
	 XT8VuGl+vCtWjP6Y2lQymhceSwHpTfFhe5x/puOmwoiDebsITdZglhvHz4uZJATauEYf+
	 27rUNpvnwZjMT2BIpd/SYts94Os8wqyO5FOi/EwfECkr81iSiNwn2nWYzYhN6SwpZ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GmpHdXMELlALRWuJop8nB0IetK8MkSZsAMNXszYm5EY=;
	b=hTa2D5t64EKAXAImehru+lwe4MNdhX4/+tEmt4a+MiPobUJeggjE/xufXZq9LxDjpqkX
	 q84qf/tB6KOPwwImzPw/9MVxkTU8znoMwuai1NDJUZWBy+CzD9lLOOve3DhbnkwZPWO8Q
	 uAUO4v9cfVtLQEW2KR4s9rKQoGiPIYp2hypzarn4tj4PMb3BdwXrJBnwVba2IQAugctX7
	 WK8K/x8KO8G3Inq5p8OoZgtmJ+Lc2Ne6MXYl6LQBhl2eUyKf72a2jLKm8Qu/IjGScTuPC
	 5acvwaDqbOSFqwxhioXQZfoQy0zLE53ROey4YTDOc3XTSPMUPIjOJ3jZfQ9NajsiqeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmBIW8GL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C4C606A32A;
	Wed, 18 Nov 2026 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmBIW8GL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C1B1F000C4;
	Wed, 18 Nov 2026 19:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028863;
	bh=GmpHdXMELlALRWuJop8nB0IetK8MkSZsAMNXszYm5EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmBIW8GL+hB82WHg8CpRNm5IU1AWN/1gy3XH1kTR88AisrNiv20Xjq3j/cTm2VWGY
	 D54xd+ryt1+SWmN8V2AC4p43GrKutaqZr0mAVt236E5ATxgYA/sSzJzAkjjKwQykOk
	 3EdIddf5VdI7rYcS36OvJ7NZz2ktNlox/nI5XAp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0145/1756] bpftool: Fix spurious batch file read error
Date: Wed, 18 Nov 2026 15:37:52 +0100
Message-ID: <20261118150013.920589941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



