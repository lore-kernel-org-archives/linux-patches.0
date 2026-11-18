Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042380;
	b=xlQ5kO9EVJhkeijQjKX5x7iWZeYdhKf0dkPkBYB0zzUilZp81XPqTy7/oUbF2O88yRGd
	 +bqrpu5D+ovTzO3+4B8FRh9pYu8VJA4PF3zT90jmWN2iVQuPnN+JCGqv2AWBZn2uH73w4
	 TdIkoRJtyqr3Tx/y7PkuWzxWVWL7yIKgCN+Jr7w7WrWTj6vSxXLwDLJt8nouMblts2Xos
	 Ia3tTZgPd2fi/b61+notR/W3nkyXCuq7IjTLBSWTi6W7LGV2HqjHxYLOIwdYPuf49+6Sg
	 TOW+blpBQfA6mnxjc40X3HNSR9z78zfjIyBJQX2fGpSZQjYmwuWpEwshnY2ZWmbzA5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F42u8oycePZuhhYcMKOv42my+OdDLVR9bI1PamFQ0jc=;
	b=JvbBCg2HeTVP8l6mXa3yG8EppoAgFAVSoqT+MMT0p/TYRTAx3OEifxwKifHwURxozk4W
	 rTIwBF1+Q2n0N8s3JzDz+tdSfYzxx8VErAkAkt1ldSWk5f8DeGO+HWvVKgdkak87RnmuH
	 h5e1ADHpMOWfd2p7wMNzW2wbabZ+HW/6xtupRETdkPzm52NmPnBNVM3DBJt8fXqjZ+c5i
	 oqs9pvOFOSeeBklWyOnRF4u7xHniDPlj+GS1DBvVmkpxvsPR8Via6k1GLZQHOmpSG7tdB
	 y6veMap62g0PVbBtqBs8eHWYb5sJO86J27c0bOU4A/ISJnIS2O5leP6FXOy89gRYjgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPOMVMrX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3787606A320;
	Wed, 18 Nov 2026 22:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPOMVMrX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5734B1F000C4;
	Wed, 18 Nov 2026 22:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042379;
	bh=F42u8oycePZuhhYcMKOv42my+OdDLVR9bI1PamFQ0jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPOMVMrXkzOuP43YQYRIjd3PfdWezbWOaUKd3jYwWU/COwtDGxaw0/P87/2gam2zB
	 zfCVGi2dQdrgL1zcMJ8+sCBp46bQfSLyM0BW0GhPQf6lIkENo8j/IhLnnPBJIKkU97
	 V0UfTs5HPt29hzk4Omi9Zq8qmQ5/HGG1h1c/nCnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3149/3318] selftests/net: tcp_mmap: remove unused -k option and keepflag
Date: Wed, 18 Nov 2026 16:02:51 +0100
Message-ID: <20261118150454.335897387@linuxfoundation.org>
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



