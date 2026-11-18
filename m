Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062046;
	b=I7w815YZXINyXR2NCvddfKNLRqC504NcKXMey0T5b6jbJ6qtnnT6La/ird1LaHRNqxoV
	 VDTzH1OwQ4XCgykp/AYWo1stXEWLvEGCtcesFh0yEcHFAYTd43XowaGp5uWtvsB5vQXUH
	 utoeFA8/ZveDEitc7Hg/n7KOtjB0NsZcx27SQnXynxrUTEzTonBytcKMJp2b/g2aj3pGo
	 n5O0YsIGzPHuYIKke8gRSP06Pwe5b2D+JFaoDsqp+9omkFJIJKgkOtlkxpi8c+j3oFHAD
	 HTTE1C5vfyKBzEweD0LXO1Sgu60wfqyRWQPFzxgSMqxc5Ic0d6W9Pbo57JtotGkAhRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A2WhXrAEZ13jsbk1yxhqvr9UTQtIXLyjy51Odei7jj0=;
	b=faGUbVu6LlzyfoJNMAqmDog60OzljlHHDm/GUJReWeQZ1a/QIpJpDs6bogcUrIrKoqfd
	 56Qrg8pUdrFdTJud7vpsQ1icsRpSp8aa58DESARBlLPXFSZMZDBQvKk8c5AS+17Qynxnz
	 dcl/8p1C47P5Gwb89x6jUQO3FH3ldWLd4Ym2o1YJSGSiGJ6r2NEUMMcFQANRvB977ej+z
	 DGnRHVgNPDuv0HiNXT13mvQygULRg/OBNLCBonjhUA0rlOTBZfjN2GSzIz/nCm5/Xzsj9
	 zzkH9+8gQo0/6dARa3TNpQnKSrgOVj9ebCvoP2e6MGWFhMnucvOajFuT1plcGjCArEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VmG6D+OR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BE5606A32A;
	Thu, 19 Nov 2026 04:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VmG6D+OR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1321F000C4;
	Thu, 19 Nov 2026 04:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062046;
	bh=A2WhXrAEZ13jsbk1yxhqvr9UTQtIXLyjy51Odei7jj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmG6D+ORkkKbM8u+s8bvv4yg8Quec+6JSmNKqdq9ubLlD7duHaS9iBGdmhdFjmVYa
	 X7/c3T+Ln02+kcZWfaLlqdGAWGY0GxHSc465hDW1H+d31dWJz1kcXfdQXxW/T+I5SK
	 +3hN3Bayb2TM4emlFWkabCnZEp1Uq5szfL0c+iZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1768/1848] selftests/net: tcp_mmap: remove unused -k option and keepflag
Date: Wed, 18 Nov 2026 16:03:26 +0100
Message-ID: <20261118150033.422810196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 51d48229c18cd..457a7d969cb1b 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -85,7 +85,6 @@ static int rcvbuf; /* Default: autotuning.  Can be set with -r <integer> option
 static int sndbuf; /* Default: autotuning.  Can be set with -w <integer> option */
 static int zflg; /* zero copy option. (MSG_ZEROCOPY for sender, mmap() for receiver */
 static int xflg; /* hash received data (simple xor) (-h option) */
-static int keepflag; /* -k option: receiver shall keep all received file in memory (no munmap() calls) */
 static int integrity; /* -i option: sender and receiver compute sha256 over the data.*/
 
 static size_t chunk_size  = 512*1024;
@@ -439,7 +438,7 @@ int main(int argc, char *argv[])
 	int sflg = 0;
 	int mss = 0;
 
-	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:C:a:i")) != -1) {
+	while ((c = getopt(argc, argv, "46p:svr:w:H:zxP:M:C:a:i")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = PF_INET;
@@ -473,9 +472,6 @@ int main(int argc, char *argv[])
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



