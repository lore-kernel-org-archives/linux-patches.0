Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029120;
	b=3cjJ+CELNscPJkbTNhI6XActImckIk8b7H+j1pxAkYR9K+brFRoj6NWTtafAvscDczsE
	 cHGJ4GOy1zHc2A16R3RDfNoRt9Pj+cxs4uCDzhsQLEDMcIo4d3A8tOF6sFv7AGqChqvW2
	 KYV+g0aefE9sWJkPtjhNC/XoJhxgo+hlySi9pJUvUir5gPwhMVPfeXG+p9kS2BxWmlpTp
	 cp5LXqdeUt2FH1Nkrspsya6cwV/VfLgfX9DPkMb5IZCZRqRXadtaIHZxQ/5foMIO8hYne
	 JhrXG/MYFd+4EopoK1XDgpHZScC2Uo6ogWALTQLsn1DMIF5vVeaUEEGk/cf1uRLODXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1y6P/1kngmiSlonOWiYpxTlGhqN51u35kkQ5qOQCC2o=;
	b=hO3TX6NtQCRc8XWRiRivoEtx1fkh0Xi6rblv2fxhLgMmi0gAvvJIzDBAkZ8OQ7/qwnY3
	 cP1h0UILWQ70ORQbA4YtEsb0mt2TDM7c/Sf3LdUnn7UwDxZWDvLy6OLCWmCXnBz0RFN0H
	 U+DFMZtv+5A3cJNT6X2bs8Hu9K1jkK+rxRhvXLVoLGKK4YhY6jydA+CJj+dgEodaqxsG4
	 KmgfYbHvCN07GHmeTadLurPltyUMuAxc8vLACqY3WeDP9RqJNz0UWM7ILLc8MgjMd3LfP
	 OAeDNuTjgkqnLnfLEPWHUjXrF1TnF+F0XQTrxxTekORSjCu2KE3tH/ue9CGUubPvHpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvQQHurJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856FC606A31C;
	Wed, 18 Nov 2026 19:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NvQQHurJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E201F000C4;
	Wed, 18 Nov 2026 19:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029120;
	bh=1y6P/1kngmiSlonOWiYpxTlGhqN51u35kkQ5qOQCC2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvQQHurJz/hBL77H4EiERHn/P3PrlSHRYgQMVoJOcYtqtTDIu0eL9WZ8GyGYJqAoz
	 GpauNkxBR+znabwukdsmMNzUsrWnItBKfDa2gsPoHYXafRodDy+AyhJCf17v5jZwhb
	 Nb77AoX+DuBNZcPSBT0h2doa9IPkgUr9kzxE1uYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0237/1756] selftests/bpf: make cmdline_contains stricter
Date: Wed, 18 Nov 2026 15:39:24 +0100
Message-ID: <20261118150017.701514715@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3aa9ee80a55e4..2b97d40660867 100644
--- a/tools/testing/selftests/bpf/unpriv_helpers.c
+++ b/tools/testing/selftests/bpf/unpriv_helpers.c
@@ -71,8 +71,8 @@ static int config_contains(const char *pat)
 
 static bool cmdline_contains(const char *pat)
 {
+	int fd, cnt, ret = false;
 	char cmdline[4096], *c;
-	int fd, ret = false;
 
 	fd = open("/proc/cmdline", O_RDONLY);
 	if (fd < 0) {
@@ -80,14 +80,15 @@ static bool cmdline_contains(const char *pat)
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



