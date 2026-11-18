Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056800;
	b=teqJqAX4cw9CIZqFug+783oeJaYgSr8lbcjwEdRWk+gdEaKIPBmv1yU/Wi/I/RETovGa
	 p7Jho2jhbeUmMA4dlc51NiJICdlngwKmcBrtbR0XC1a07M6DLFQiiVYgqCuvkhKTIKW2v
	 molsxrMSVB+G7W9uythnvddVt0UDXd/fDpwbmZd0ncM4fb7w+DP/DLZVKhdt19sxk5NRM
	 0n+MBLKn6pRGoEY7AmthqxFlew9wzerSJN1CVEWbBYb52J3YOtZ+DP0imfzE6lm6nfvsM
	 2S0xs9q8T33fzAUr88svv3wYp/jZbJWfGT+vfevmGLeo5ANjInxbXlk/RaGFcUvSuhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QzPcWeyuzuTtyfT8Kbz5Asw4WKVErsX+BeXw5JNZCoE=;
	b=m9FnNnHydTR6DGoAonX4DJ/ljm9WnAD5BFK+kbaM8/f9WMabKW8ddfc2OyUxgWfqwhY6
	 hvNjjMPqtIYOS5J3sFIwKQt6omJFNjjj8uWAK+avl8GBl70Gh0Myo8QxeuZ2PkcfaIeGO
	 aRWhS5/Bl1RYtF/vdKlSmTK9XDDaEs2m63ytAfUsOqrQlf0Ax1Cr7ZCgmg47qWh7jJjwU
	 uQPYNZG18hThv6bTBrWgYVzGpMLOMdEJ49JrNWZ1l8tEl4lXzPbN7JFXbeerAEzxl4F3F
	 f8Ryt5KhQV+sAGrxCphyazycPv98tHuycEuDk//qmvbJyclLrK/BM63MddSL19afeVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFBGchNe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8E2606A325;
	Thu, 19 Nov 2026 02:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFBGchNe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930D11F000C4;
	Thu, 19 Nov 2026 02:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056800;
	bh=QzPcWeyuzuTtyfT8Kbz5Asw4WKVErsX+BeXw5JNZCoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFBGchNerQP4XE0VQdT7PmnWOjxRLpJObkVIDQzREjsahSN5Kv9yEgF+xBMQeuDY+
	 +/o7LPxE/2b4s7XV5GIKAZ5Xj3NNWktOkOcLKTO/yD44CInThPD0qCFRyJqr1eZqjk
	 N0KXRr1njjlLhS/RHWMCjQtmeyJ93jKQsAIrC74E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2116/2214] selftests/net: tcp_mmap: remove unused -k option and keepflag
Date: Wed, 18 Nov 2026 16:03:12 +0100
Message-ID: <20261118150135.246453531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



