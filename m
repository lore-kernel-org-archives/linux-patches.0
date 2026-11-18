Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062041;
	b=4DMpfYmzYAnFLf2s7qCnGnkgVs/WzJTiGe9EvxJ4WxBtlRuxzo0RcX1P+42ey3xqPSi1
	 HkagDzVM6pad1xHGknGmPUEo4MFlDVyBOfHymbAXFAahxW48/vyp0xKAjVY7klND8OPtu
	 kdRYcK0EX7J8i+x+svUk6UQE9raEtJLS0765z0uq2PQdyTflXu5gCti3XN62f3LDAOR6P
	 UBS6aUB5hqkAfWDRhf/hjkTjfs7fmupmZzb/Uadu2pMFZemgoH+98nuvOATkPS8sEaYvf
	 2J5ugDtSrGJBJWOYk4byUGGGy+EPh8xYaA/tgfM6GkjKEi2bJpVO4e6pQCZ/9pBohOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aUdM8Xfx+rDk4Iyfkm6uWJL2JpKTcGekvNBNCEZJC+A=;
	b=VnJOcFG8JAu0/wmuPFEwBNRVHCh2sMUr/ntN94YPFinQb8Yied0aHc6/RjMRnhHlCQut
	 CIItb546TRGVMNwfTKlI4Toaou8rdEMfI8IdtWnj9YrSNzkpfux0tozMhdt5taAchiN0A
	 1fCfIhBAKz7IgFRBQ0JSrrKL7Cqb9QQNqolyE8RF5grWQfT5xFjNXhqEmwsx4Tgalec/B
	 1Axxgy2ZcwTV9hujy+MnBzGyeyUl9DeDG5SlboshikGYV+Lh6uXobqx+SLCcnWBily3uh
	 1hsNbceVi0Jnvnocm+GR9yKKR95kR2w9owTKjFxY4TivOHeu/IMjGvnVwbm/TrL2e6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVxczYiL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A031606A320;
	Thu, 19 Nov 2026 04:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVxczYiL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82D31F000C4;
	Thu, 19 Nov 2026 04:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062041;
	bh=aUdM8Xfx+rDk4Iyfkm6uWJL2JpKTcGekvNBNCEZJC+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVxczYiLRwyZNS4k2HViiZwhweMbU+jdL1HvC+w9G/0K4r/ZZiJPgDepMD+8oblsX
	 r5RtYlFisYaxK5lQ34AmpkCR4jxgOi5F8VzjKq3FFQi3ojXraowuv7DHhNQAoHpERS
	 1dYN5WXqcCoFS2f+f1t7p0pnvmODOhpLodKVwbSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coco Li <lixiaoyan@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1767/1848] selftests/net: Add SHA256 computation over data sent in tcp_mmap
Date: Wed, 18 Nov 2026 16:03:25 +0100
Message-ID: <20261118150033.382612198@linuxfoundation.org>
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

From: Xiaoyan Li <lixiaoyan@google.com>

[ Upstream commit 5c5945dc695c54f2b55a934a10b6c4e220f9c140 ]

Add option to compute and send SHA256 over data sent (-i).

This is to ensure the correctness of data received.
Data is randomly populated from /dev/urandom.

Tested:
./tcp_mmap -s -z -i
./tcp_mmap -z -H $ADDR -i
SHA256 is correct

./tcp_mmap -s -i
./tcp_mmap -H $ADDR -i
SHA256 is correct

Signed-off-by: Coco Li <lixiaoyan@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230321081202.2370275-2-lixiaoyan@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 5536d5553f27 ("selftests/net: tcp_mmap: remove unused -k option and keepflag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/Makefile   |   2 +-
 tools/testing/selftests/net/tcp_mmap.c | 102 ++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index ef352477cac6b..48e403c56cc34 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -39,5 +39,5 @@ KSFT_KHDR_INSTALL := 1
 include ../lib.mk
 
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
-$(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
+$(OUTPUT)/tcp_mmap: LDLIBS += -lpthread -lcrypto
 $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 00f837c9bc6c4..51d48229c18cd 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -66,11 +66,16 @@
 #include <poll.h>
 #include <linux/tcp.h>
 #include <assert.h>
+#include <openssl/pem.h>
 
 #ifndef MSG_ZEROCOPY
 #define MSG_ZEROCOPY    0x4000000
 #endif
 
+#ifndef min
+#define min(a, b)  ((a) < (b) ? (a) : (b))
+#endif
+
 #define FILE_SZ (1ULL << 35)
 static int cfg_family = AF_INET6;
 static socklen_t cfg_alen = sizeof(struct sockaddr_in6);
@@ -81,12 +86,14 @@ static int sndbuf; /* Default: autotuning.  Can be set with -w <integer> option
 static int zflg; /* zero copy option. (MSG_ZEROCOPY for sender, mmap() for receiver */
 static int xflg; /* hash received data (simple xor) (-h option) */
 static int keepflag; /* -k option: receiver shall keep all received file in memory (no munmap() calls) */
+static int integrity; /* -i option: sender and receiver compute sha256 over the data.*/
 
 static size_t chunk_size  = 512*1024;
 
 static size_t map_align;
 
 unsigned long htotal;
+unsigned int digest_len;
 
 static inline void prefetch(const void *x)
 {
@@ -147,12 +154,14 @@ static void *mmap_large_buffer(size_t need, size_t *allocated)
 
 void *child_thread(void *arg)
 {
+	unsigned char digest[SHA256_DIGEST_LENGTH];
 	unsigned long total_mmap = 0, total = 0;
 	struct tcp_zerocopy_receive zc;
+	unsigned char *buffer = NULL;
 	unsigned long delta_usec;
+	EVP_MD_CTX *ctx = NULL;
 	int flags = MAP_SHARED;
 	struct timeval t0, t1;
-	char *buffer = NULL;
 	void *raddr = NULL;
 	void *addr = NULL;
 	double throughput;
@@ -179,6 +188,14 @@ void *child_thread(void *arg)
 			addr = ALIGN_PTR_UP(raddr, map_align);
 		}
 	}
+	if (integrity) {
+		ctx = EVP_MD_CTX_new();
+		if (!ctx) {
+			perror("cannot enable SHA computing");
+			goto error;
+		}
+		EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
+	}
 	while (1) {
 		struct pollfd pfd = { .fd = fd, .events = POLLIN, };
 		int sub;
@@ -190,7 +207,7 @@ void *child_thread(void *arg)
 
 			memset(&zc, 0, sizeof(zc));
 			zc.address = (__u64)((unsigned long)addr);
-			zc.length = chunk_size;
+			zc.length = min(chunk_size, FILE_SZ - lu);
 
 			res = getsockopt(fd, IPPROTO_TCP, TCP_ZEROCOPY_RECEIVE,
 					 &zc, &zc_len);
@@ -199,6 +216,8 @@ void *child_thread(void *arg)
 
 			if (zc.length) {
 				assert(zc.length <= chunk_size);
+				if (integrity)
+					EVP_DigestUpdate(ctx, addr, zc.length);
 				total_mmap += zc.length;
 				if (xflg)
 					hash_zone(addr, zc.length);
@@ -210,22 +229,30 @@ void *child_thread(void *arg)
 			}
 			if (zc.recv_skip_hint) {
 				assert(zc.recv_skip_hint <= chunk_size);
-				lu = read(fd, buffer, zc.recv_skip_hint);
+				lu = read(fd, buffer, min(zc.recv_skip_hint,
+							  FILE_SZ - total));
 				if (lu > 0) {
+					if (integrity)
+						EVP_DigestUpdate(ctx, buffer, lu);
 					if (xflg)
 						hash_zone(buffer, lu);
 					total += lu;
 				}
+				if (lu == 0)
+					goto end;
 			}
 			continue;
 		}
 		sub = 0;
 		while (sub < chunk_size) {
-			lu = read(fd, buffer + sub, chunk_size - sub);
+			lu = read(fd, buffer + sub, min(chunk_size - sub,
+							FILE_SZ - total));
 			if (lu == 0)
 				goto end;
 			if (lu < 0)
 				break;
+			if (integrity)
+				EVP_DigestUpdate(ctx, buffer + sub, lu);
 			if (xflg)
 				hash_zone(buffer + sub, lu);
 			total += lu;
@@ -236,6 +263,20 @@ void *child_thread(void *arg)
 	gettimeofday(&t1, NULL);
 	delta_usec = (t1.tv_sec - t0.tv_sec) * 1000000 + t1.tv_usec - t0.tv_usec;
 
+	if (integrity) {
+		fcntl(fd, F_SETFL, 0);
+		EVP_DigestFinal_ex(ctx, digest, &digest_len);
+		lu = read(fd, buffer, SHA256_DIGEST_LENGTH);
+		if (lu != SHA256_DIGEST_LENGTH)
+			perror("Error: Cannot read SHA256\n");
+
+		if (memcmp(digest, buffer,
+			   SHA256_DIGEST_LENGTH))
+			fprintf(stderr, "Error: SHA256 of the data is not right\n");
+		else
+			printf("\nSHA256 is correct\n");
+	}
+
 	throughput = 0;
 	if (delta_usec)
 		throughput = total * 8.0 / (double)delta_usec / 1000.0;
@@ -367,19 +408,38 @@ static unsigned long default_huge_page_size(void)
 	return hps;
 }
 
+static void randomize(void *target, size_t count)
+{
+	static int urandom = -1;
+	ssize_t got;
+
+	urandom = open("/dev/urandom", O_RDONLY);
+	if (urandom < 0) {
+		perror("open /dev/urandom");
+		exit(1);
+	}
+	got = read(urandom, target, count);
+	if (got != count) {
+		perror("read /dev/urandom");
+		exit(1);
+	}
+}
+
 int main(int argc, char *argv[])
 {
+	unsigned char digest[SHA256_DIGEST_LENGTH];
 	struct sockaddr_storage listenaddr, addr;
 	unsigned int max_pacing_rate = 0;
+	EVP_MD_CTX *ctx = NULL;
+	unsigned char *buffer;
 	uint64_t total = 0;
 	char *host = NULL;
 	int fd, c, on = 1;
 	size_t buffer_sz;
-	char *buffer;
 	int sflg = 0;
 	int mss = 0;
 
-	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:C:a:")) != -1) {
+	while ((c = getopt(argc, argv, "46p:svr:w:H:zxkP:M:C:a:i")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = PF_INET;
@@ -425,6 +485,9 @@ int main(int argc, char *argv[])
 		case 'a':
 			map_align = atol(optarg);
 			break;
+		case 'i':
+			integrity = 1;
+			break;
 		default:
 			exit(1);
 		}
@@ -467,7 +530,7 @@ int main(int argc, char *argv[])
 	}
 
 	buffer = mmap_large_buffer(chunk_size, &buffer_sz);
-	if (buffer == (char *)-1) {
+	if (buffer == (unsigned char *)-1) {
 		perror("mmap");
 		exit(1);
 	}
@@ -500,17 +563,34 @@ int main(int argc, char *argv[])
 		perror("setsockopt SO_ZEROCOPY, (-z option disabled)");
 		zflg = 0;
 	}
+	if (integrity) {
+		randomize(buffer, buffer_sz);
+		ctx = EVP_MD_CTX_new();
+		if (!ctx) {
+			perror("cannot enable SHA computing");
+			exit(1);
+		}
+		EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
+	}
 	while (total < FILE_SZ) {
+		size_t offset = total % chunk_size;
 		int64_t wr = FILE_SZ - total;
 
-		if (wr > chunk_size)
-			wr = chunk_size;
-		/* Note : we just want to fill the pipe with 0 bytes */
-		wr = send(fd, buffer, (size_t)wr, zflg ? MSG_ZEROCOPY : 0);
+		if (wr > chunk_size - offset)
+			wr = chunk_size - offset;
+		/* Note : we just want to fill the pipe with random bytes */
+		wr = send(fd, buffer + offset,
+			  (size_t)wr, zflg ? MSG_ZEROCOPY : 0);
 		if (wr <= 0)
 			break;
+		if (integrity)
+			EVP_DigestUpdate(ctx, buffer + offset, wr);
 		total += wr;
 	}
+	if (integrity && total == FILE_SZ) {
+		EVP_DigestFinal_ex(ctx, digest, &digest_len);
+		send(fd, digest, (size_t)SHA256_DIGEST_LENGTH, 0);
+	}
 	close(fd);
 	munmap(buffer, buffer_sz);
 	return 0;
-- 
2.53.0



