Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032805;
	b=r6G/2qeHd4c1JteI49U38bZRTsgy3xRAgHhfo+ymd1hmy3zgEUoCHbwcX/YfzAQFBkqi
	 PlhYApz3hdKc/YC29d7xDmdbAg/DMk+KEhCZh/VBMTIeLSgc2LBajsfn1trluAq9JZR7G
	 +pLjgkX043IphDjRi0Cso9KG0moRq6QpbMW5clYOSDiabgNQU30sf8JrOydvLfehv//Wh
	 wtv9t8Hgzb+818jJJE6DjAoZAgwfdD4p7uyDtn67aJt9g8zHik8FNRPu5acq2wXXqXTcl
	 e3KpBxlJnHzlhJjbhPYRPlb48b5LNz7M4oGDoe2GW2Sv5pMM0qnXakIQu3xqosxDYXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Kw2KjkJy7S9YRzHS09fL325LIVgMlU7g6oHQkNT2LU=;
	b=0Llk/DL3Ah/DW72Z6YAdH5Mq7CnzRn6K08Kcju8UTfasExccshH809faQ5YsC6Rbkwu4
	 dmuNAGUBFy1tboTzSG6raf8JVnZ01EHvkOKe+1w1gg7fjkHxZiT2DNra/8P2nn5lEUix8
	 PtsI6wMmpFZa6KYi80UEHnxoIhjZec7OZazb4yjzuM9o3nFBf+gt0zVfJ9X0BWYom8+tT
	 BJzyrKTEpJYgi3Fmzsjg3nJ8m1Y7q+3VTCPzJtrSw8Hst4uoHdrd11eSVInF/c7Y3xSlF
	 uZSa3y03CgXim1YudR6/oCjT9lQrRfWN+AsvO/zp3Ia5O3EOF44iQiBFg7MWH5aqh7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AX+neKFA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD51460A2601;
	Wed, 18 Nov 2026 20:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AX+neKFA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFA31F000C6;
	Wed, 18 Nov 2026 20:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032805;
	bh=0Kw2KjkJy7S9YRzHS09fL325LIVgMlU7g6oHQkNT2LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AX+neKFAOmEhWeVgviWsNoWen4iesaZVxnSoWOrG7TNn+tb1jI2rXO/6dKhdqbjPc
	 9XRdOpz+hHB+Ah1I9x1omDR79/Y/DXbngqGbVDlFgqhX5l2gVai505AmN9v5fGqTdk
	 N1mulhUPHnlkjT8m+4x0g1g7jiRtXtqJalaC5ORI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1541/1756] selftests/net: tcp_mmap: remove unused -k option and keepflag
Date: Wed, 18 Nov 2026 16:01:08 +0100
Message-ID: <20261118150110.286903517@linuxfoundation.org>
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

From: Greg Thelen <gthelen@google.com>

[ Upstream commit 5536d5553f274c8baa77c44854c9091657213970 ]

Commit aacb0c2e524c ("selftests: net: tcp_mmap must use
TCP_ZEROCOPY_RECEIVE") removed the only read of keepflag in child_thread(),
leaving the file-scope keepflag variable set by the -k option in main() but
never read. This triggers a Clang 23 warning:

  tcp_mmap.c:91:12: error: variable 'keepflag' set but not used
  [-Werror,-Wunused-but-set-global]

Remove the unused keepflag variable and the dead -k getopt option.

Fixes: aacb0c2e524c ("selftests: net: tcp_mmap must use TCP_ZEROCOPY_RECEIVE")
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261021152658.2618709-1-gthelen@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_mmap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 2544ae35d07a8..c57d606a19353 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -85,7 +85,6 @@ static int rcvbuf; /* Default: autotuning.  Can be set with -r <integer> option
 static int sndbuf; /* Default: autotuning.  Can be set with -w <integer> option */
 static int zflg; /* zero copy option. (MSG_ZEROCOPY for sender, mmap() for receiver */
 static int xflg; /* hash received data (simple xor) (-h option) */
-static int keepflag; /* -k option: receiver shall keep all received file in memory (no munmap() calls) */
 static int integrity; /* -i option: sender and receiver compute sha256 over the data.*/
 
 static size_t chunk_size  = 512*1024;
@@ -456,7 +455,7 @@ int main(int argc, char *argv[])
 	int sflg = 0;
 	int mss = 0;
 
-	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:C:a:i")) != -1) {
+	while ((c = getopt(argc, argv, "46p:svr:w:H:zxP:M:C:a:i")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = PF_INET;
@@ -490,9 +489,6 @@ int main(int argc, char *argv[])
 		case 'x':
 			xflg = 1;
 			break;
-		case 'k':
-			keepflag = 1;
-			break;
 		case 'P':
 			max_pacing_rate = atoi(optarg) ;
 			break;
-- 
2.53.0



