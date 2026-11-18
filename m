Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023096;
	b=d5NSJKmj+S1FIbRWEK6Nnbk2HZYHsGkKgyez/iAYF+3Mn5Han4z20X15wPNYmPGu+Y5P
	 xWcfkKBjEoZ+isrD0ZZ7q2Wc3HvXdJ44sW934I1qr0jppkYOb3fJ4oKaYCJjw2UxuOypu
	 g1r+d5rLmUo3R+kk/FxJHL+nNnhDkp8B2OpkdNSvcSTHXMN2ilYEB2sm7oFcwGrI4d7fs
	 twQQuzrciYlL1D2ZiYee51srEcQCrDqaFT65tl7V9wJvLxgUjwOBJ9b8+/X6JCoHzTCxJ
	 A20ibA004DNqG9InkMaZtTVydKLbYWxOI+PmfTHks3c9iU/YZ3KTUrsXe24KVlz5NpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5BiG5VcTOZMFLEJT+FxJxRartzVpCs+AjCO2vx3h02Y=;
	b=LBjPUG2VI4SlaTtiJpxwqON/95J+p5IShR1lasU+u04DvNM4ekvaH0u6ZBjHd2YmZxOk
	 EvYXjNUEHz6hzM5gMkOqvHPZEOr9OUjsHFosK4zCI3nsBA8XtBc4X9MKqYCIom5JVMJYp
	 fVgCZ2KD6KxpPUDuR6L3HI6CfWf5rx2pdJ9BM1CATQHt0+k7diTrntAe/r4I2Ap/udBqP
	 RvvkOCazVdBQSsWMiR4/ZqVMiKrjSsdyD3j1XKkUi/KEBmz2QB53yEDDrPGI9wbkP3+C9
	 GXZXs24iuogMDydFgk39sQ6aJsJerQIPFwBWCuT9CvjeU1+nDWkZMldncEk0/UH6mPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g4KfTJ6M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18A1606A31C;
	Wed, 18 Nov 2026 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g4KfTJ6M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2C81F000C4;
	Wed, 18 Nov 2026 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023095;
	bh=5BiG5VcTOZMFLEJT+FxJxRartzVpCs+AjCO2vx3h02Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4KfTJ6MINnikRG5CYTFpPNO6hHDurYqWXb3LZ+r43rSroh9kCO3UelYjtaU7nKbJ
	 m/TysUvFeHN0borcpUJ7N1ssebsWXecY3zslwlb4bTOJXJtFmDBkEm8sgzIJO+h9xQ
	 qlrUQWBveuOl4qApmcN5upVo5t0/lV5k8FeTVfjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0240/2151] selftests/bpf: make cmdline_contains stricter
Date: Wed, 18 Nov 2026 15:32:55 +0100
Message-ID: <20261118150130.517731609@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



