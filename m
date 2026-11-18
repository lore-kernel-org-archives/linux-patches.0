Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056797;
	b=SMsaNc6Q4cqUehpJ0bajOHEX3nbVhHELaOiECYfc/F9CTIf/fyhvj+QXdB2qS28sgPz8
	 XaS9yAjTzJpzgcXU8oGwMDdLs10oiqGghcoSJydvEHErYgb8eJAutth/csq9oErVDsPJJ
	 yQwVOw3vA4UvyzfDrYsIbnwAWVrFD0KPlXeZ8+W/3ufzL2Q63R1cf8nFqn/bQGU8ixR0X
	 tMQGa1oUvIyueR7MG2nHRXMMUhAVLRG/nNpF8o/hrgv2LKM9BacspzV2lWQkLyYC8TF2W
	 osB8yuJab27nkNC7e68QKgS+N4WYAunL7rfQTpkknjFme/nr3bH+B8+KTtg4K5QOVBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxnyHOCWMxhi9OB8mHX50K/+MVyKtpG00CmC1qDgGtE=;
	b=sIljF8qNuFG6HOMV57ASJo8U16K265k1nwGN2yLPIYRNkWbA/gqZSmW3a8gunNjQ/AUg
	 UHe284atpKvT/0o32W8FkzhPuHg+goRavITDaATqwY1ne1ogVMaCrQ5EwHd6ggcc4DLoF
	 UD4HjsuofQfaPFr74sr0uEhC5coadJHqKBhFQcZdrWU5MwCB77DExgCBhxFjD74j/YD0Y
	 8EGpOpxLGhyAOMkxvHSYwRDwd8XsWB+k9Zzb7R5m++XAzp7veix4h6GBAdbzUzfg7KE71
	 yXHDhoxnJq7368szBGG2YT//YEYtvjUkiUaRsGNBBjyJl6SxHHpsJ2ZcwImzVWJj95A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FREGKkfE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D359606A320;
	Thu, 19 Nov 2026 02:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FREGKkfE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB8F1F000C4;
	Thu, 19 Nov 2026 02:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056797;
	bh=nxnyHOCWMxhi9OB8mHX50K/+MVyKtpG00CmC1qDgGtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FREGKkfEYG17Qg/2fMyzgC/87W5/rUD6rni/2Fif7LVQhDvIvQqMNR1crqL2D5ims
	 bvKYI1BCKQBEtVBVqyWR3egKoIRLDR2OowEaFbHNcyidjMAxvTMwh0Amr5cUkpKsHr
	 AX31hFss1zCnhIRZ39+Vx8gwF2eG2TV4UCBCZzsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coco Li <lixiaoyan@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2115/2214] selftests/net: Add SHA256 computation over data sent in tcp_mmap
Date: Wed, 18 Nov 2026 16:03:11 +0100
Message-ID: <20261118150135.212618309@linuxfoundation.org>
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
index 6a953ec793ced..77297694353b7 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -56,5 +56,5 @@ KSFT_KHDR_INSTALL := 1
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



