Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021654;
	b=QyzdfC2qiTiyF8RN4ATUZVjyq9r0hlDDFO0LK8v4lMPIQYY/8r2qrnQFnB1uuU8hxm5H
	 1tOcBTjmUUSNt3Is3PshIcpKxhJJiFhzsNVsWVnwmf9Y6/02myt5d10kzbip36md1tpar
	 RonQoybseTlBc3uobqQw40vhT2yFPai/AVXKIGlZyUpC3Ab3IoWJzbr7xJxDRDS4tGgaQ
	 gFrDODRBklIOlCw8OYF9FnHkdSMLw+TzWhtiZ4b2iz0YWdAXnmoEdn531AUV8DK7UsWFZ
	 tQib6JxY97t9JWoo8w+mFlfC6zeJcZvtkXGypUKKc9pJucevHlTB2yY+QkHXkmPN7Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gcEo3DGVXspYLIKOzwyVQ9tIvnCJiUryVX+URZrQKhg=;
	b=3NNVZ3iCM3aFHjUG1sVGkOQV73PbDLC8u2A3hgsIudUtkV/M6sO9AJA/873U3Q8rTl7W
	 sartpkq9bipTtX0727iTDjATZN9gxZ97ETQIIxRFuE14ARwxxGONgcUX0VBYxFt7NRsJX
	 7wd2X/Jc49R3bef00/E8RBoERGWSB6msrlwmowEm6h9BZscn/qN/BD1f/LB02srOhHSWD
	 tuvtLQ11x1bmMLJh6Rf9myAQtWR3OES9/dcU9qXV3L4CW3pfB/HYm2VLsxLTtCZvbBGkB
	 z2bcL/CZMFrJzXPS22XRk3FLQJqy8+BvcGnq+5JKkndUH5PKly4egzWyYBX4UPWG43g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jw9GpO55;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B5A606A325;
	Wed, 18 Nov 2026 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jw9GpO55
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F951F000C6;
	Wed, 18 Nov 2026 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021654;
	bh=gcEo3DGVXspYLIKOzwyVQ9tIvnCJiUryVX+URZrQKhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jw9GpO55ablOx58JELsRu8TbgOq+44OnxMx8/c/r/zh6eIHQnIrAT3IR0St1BHS6Y
	 PyhKJ1qRDnrInRRfp6RrHBLLwxMZatdr4HL9NGW9IU3STEcKjZi4edDrCAq3upbO5d
	 4CGZDpiWMSp5rWEpJo9LTpAyUP6xYkRYrzKwkLOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2384/2651] selftests/net: tcp_mmap: remove unused -k option and keepflag
Date: Wed, 18 Nov 2026 16:00:24 +0100
Message-ID: <20261118150411.259245805@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 487ae659a1f18..86241bed7f086 100644
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



