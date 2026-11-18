Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027834;
	b=jDxCVPonX8HcbO2GgL8IydWdCbd8PuTAn3gt0VeW4qi82Mi4uEXScnTh0W4oAAIJKTH+
	 lmoTCTPXV+mmZ2LvyQamYCbN8R3Uux03/zQlN/4f2CSJMf1y8jxQykYsrbqP/w6aIPx6B
	 wuA3qcoznycvAVlMzVRYu8bfMuURXKGnuWlNMhgYTl6cjHU7i51x2PH6qufMTI/4QmFmA
	 Wj+HkehJDvhJ2Fnx+HlWO7oHJrIMnqjE5Wxs715gWutWcLcdoSfa3DI/cwkiXynwXcASX
	 W2CgQYAjLh2tukX6PTUP3xY84RADbnmq2vWPhMei6dvnP9ugv3IzNXGCnHfafSvahlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzB8WNQLOocd6bVLOxOcJjWgD5yNIp0aREfShIYk+3U=;
	b=mxb1h8W1EoMxJzPBjtEPYUY0BgtTGBAIB/9Jr1SFCOamTNCPVhM7cUNQebUSOqqkngv5
	 rJOxPB8thsol1lOwM1DuNeRrsR3RvK5w8epsgoPaeRy/DXHwSJ4erHnBKqsQnAhOqykUE
	 ODQc23jMf2BFr6mPLCH2pgs20q2YczNGpuzcM9gG/51KRBdkStApynmoVEQptvlKzFujA
	 mkwcBJ8ZbHsTL0k8oPDMbdtTgcQZfl+zItDR/Jq4Q911QMXW+7h9lrELK8QdsgIEXt+Wt
	 Dve5b39biFS8hftaIFi2vIgT3qK++UL+tMTtWGbmiS8zS2MyMJmvX7c9aFxjtP0yoXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuLojHlJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C27606A325;
	Wed, 18 Nov 2026 18:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BuLojHlJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D4C1F000CB;
	Wed, 18 Nov 2026 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027834;
	bh=OzB8WNQLOocd6bVLOxOcJjWgD5yNIp0aREfShIYk+3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuLojHlJ8zFIrNNvFnnrqfGctZyHsIWz5Wj9qScmdZKMCIgmEx3uCeWIhw+Dbr8OT
	 zMVNMkAMJA+HDXlgAGUVWp+Z6NAQgqDDNtRLf/I5GmFVeimjHgdP/EjasDCiaVtSOL
	 iFQERRIbeD8M7nWdvVwa9AwSPgz9KZCtdaesSX8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Greg Thelen <gthelen@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1930/2151] selftests/net: tcp_mmap: remove unused -k option and keepflag
Date: Wed, 18 Nov 2026 16:01:05 +0100
Message-ID: <20261118150232.086761118@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



