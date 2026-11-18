Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050526;
	b=FCJI8Kyn8I1lx+9i7e3ByM9EjyV+CQX14vCrKGOyM0mrY4smuQ6E9o1MWqV5UM5GUWQN
	 vVjGh85n+FMwA0FR1UMMBYM7wKPU0P4nZ8U8v6wch93xPxQf3na86CC6khXS1rgB/OmJV
	 KMwChjkeiEXQtMs1X4qNRgLkRsDHihaCMLCuWdSHu80Htzk1NUIZ8fXAI/gPyQkilcV0L
	 VMr3KTigyW7eaMIEIJfqCa7W+Vj7S8yMUREdhYLVJL423gFI3F8bA/UsJ9T4b96EAsDUk
	 8TQG9Gme/xPsoj9Mxd30mpLri0anWdj0vhViskRIP860eHQ3hVK/pDy4kdLUuq6CGhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hsqG3pxl0c5um5I9vJCgkgnqthCjaeF1nHQ2uT3qv6o=;
	b=UIFm6sOPWw4payh1305SK9M0iXJABWPbHLnR8N3KWrJF5McrGx8rS/TQWxRm/6qRdmso
	 1To5qAz1KRhCQi1xaGQ+lSUvPflEfgdyuVYmFV/CeSy5wUPE+FA4BwU0p/s6+Dshsd+eP
	 PtuvhnsBywbJgi4llFR8zXW9HCfNHQCqRiDpy4x5ageL/XpK2inGgKNbAy3PYlMN73RUk
	 G4lzHJeVVUMHTMZkJ/bXgJLaUsr4eyn3Btdods8FvvWP67OqaMGT1IN25nWuzHgpC740M
	 m3itxXEXPsH01QV6S7tqBlrCkaPrkHZCkp4urZC7wkNc99EfZjWR241z48OcNg0f3fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8qzXO3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75011606A320;
	Thu, 19 Nov 2026 01:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8qzXO3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11B71F000C4;
	Thu, 19 Nov 2026 01:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050526;
	bh=hsqG3pxl0c5um5I9vJCgkgnqthCjaeF1nHQ2uT3qv6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8qzXO3gARtwNaclZyet+JMxVc60wvSclTOAXRKXVp5JjFzqC3Db5n31RXgcHIzJZ
	 mfLU0/hkPxnDauJJpUnOvFXp2pFrljjGwUTKjpp1UbE5EXF+W/12EhlOKXGSTx3x7n
	 1iSbkipk03tOqXS62/FUhLg/+VTeXJLNjp+nu/WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2712/2857] selftests/net: tcp_mmap: remove unused -k option and keepflag
Date: Wed, 18 Nov 2026 16:02:26 +0100
Message-ID: <20261118150339.264973862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



