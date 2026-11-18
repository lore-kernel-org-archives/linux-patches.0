Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015576;
	b=C9St05/drhCHaM1ZW0eNlbjtAFIsTUZwr6AVWcJ3O12poKcQ6aiBjyWrwxQE0BxqYIxg
	 Un/X1xjnrh9CwPgDJL3KLNxt22Mr6rjrpQMA30HX188MuNidxaP/gmflV3S2NXVejsbfW
	 Bv+tKJGlcfgbjguymzuk4bP+/vUVkWw4sYKSvfJUORDTTyyP62M4iquLCYq/LO+wDzsVo
	 L5zvpKilDEDzHiuZq6rkyLnDURlNAeSXR4lZ82z7+fYUQwh/cOq7kBMjgj7cgTZbgtgno
	 ZZPlbivQMEAYmPnTpqeDEyvdOcB8AFwxYUUSoY4MV1MXaNkXwkt2E80TOzokSmWU3cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IJc0c5owzlIYIcvGFNLS+kziBeYSzLH68tk7fmBmiHU=;
	b=q8P2ooZNCGozl49RLfuUndt4Xo8ZBwO1Se4LIuqKjrT0a1U+whSPaFqB/jJfUylvW1bb
	 fCA4Zc8GmOWV9TYnU4fUtC+U27tsYX48NYXG252qIIOsbi2S0aisIbNbgMe/3VWgQmbDD
	 6GWCqLycvPkpyXgiuUC+kTq2khWu/E4zz85UHBbGALLrrPedXjnNSu+X5BA11zMna3rEv
	 cOF64eXutDATSZNmPhEnfOVA84zZRiSdC4EeXaxXjabmWgpRoUfMv2nJMc/mqeuOex4NQ
	 q/7D8UyQnAP5FHrsGXsycQKnzPmaN88PJYf+FHvFpcjrs7mYi/LyecGrHNAIBM4Gf5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzJ16It5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6DB606A31C;
	Wed, 18 Nov 2026 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzJ16It5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2833A1F000C6;
	Wed, 18 Nov 2026 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015576;
	bh=IJc0c5owzlIYIcvGFNLS+kziBeYSzLH68tk7fmBmiHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzJ16It5ROSbG0L88Kkhse+3+0QS8EQc68jVjG/PnHlaEKKIJQTnPEz8Du3HgAThh
	 wl99ws2JoynTD5cqU21Ky74PEMP3zsKkO8tufTStLgYFZt4Qap7eY7WKrjAIB9c29+
	 oxCc90XYvzQRcMufcot3MYxxcMtdW9blQK5QEE0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0223/2651] selftests/bpf: make cmdline_contains stricter
Date: Wed, 18 Nov 2026 15:24:23 +0100
Message-ID: <20261118150255.896316976@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>

[ Upstream commit 040ef1f8b02e57b78081581d490ceec04ef5f7c0 ]

cmdline_contains is used by BPF selftests to check the presence of
specific kernel commandline parameters, but it currently suffers from
two issues:
- the read commandline isn't NULL terminated right after the read data
  but only at the end of the buffer, leaving uninitialized bytes that
  are then possibly tokenized
- the comparison of found tokens is done based on the size of found
  token. This could lead to too-short-but-matching tokens to wrongly
  match the search pattern.

Enforce stricter checks in cmdline_contains to avoid accidental matches.

Fixes: 399f6185a1c0 ("selftests/bpf: Fix selftests broken by mitigations=off")
Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Link: https://lore.kernel.org/r/20260903-kasan-v9-6-2407fe99255a@bootlin.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/unpriv_helpers.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/unpriv_helpers.c b/tools/testing/selftests/bpf/unpriv_helpers.c
index f997d7ec8fd08..9dadcacaef0c6 100644
--- a/tools/testing/selftests/bpf/unpriv_helpers.c
+++ b/tools/testing/selftests/bpf/unpriv_helpers.c
@@ -72,8 +72,8 @@ static int config_contains(const char *pat)
 
 static bool cmdline_contains(const char *pat)
 {
+	int fd, cnt, ret = false;
 	char cmdline[4096], *c;
-	int fd, ret = false;
 
 	fd = open("/proc/cmdline", O_RDONLY);
 	if (fd < 0) {
@@ -81,14 +81,15 @@ static bool cmdline_contains(const char *pat)
 		return false;
 	}
 
-	if (read(fd, cmdline, sizeof(cmdline) - 1) < 0) {
+	cnt = read(fd, cmdline, sizeof(cmdline) - 1);
+	if (cnt < 0) {
 		perror("read /proc/cmdline");
 		goto out;
 	}
 
-	cmdline[sizeof(cmdline) - 1] = '\0';
+	cmdline[cnt] = '\0';
 	for (c = strtok(cmdline, " \n"); c; c = strtok(NULL, " \n")) {
-		if (strncmp(c, pat, strlen(c)))
+		if (strcmp(c, pat))
 			continue;
 		ret = true;
 		break;
-- 
2.53.0



