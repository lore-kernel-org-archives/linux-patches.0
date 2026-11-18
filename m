Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033219;
	b=yg2rqPepW3C8IwasCUdVP6lLdXiuFpQ12ZPvlaOyL4a/j3d9uHHXhSjhwjpNV0DtREe4
	 OPqfn7SiGgMEw0QAIrONUkviuHBB1zQ2rSxV3f6p4TmBFE3mDX6N1o1sKLK5jU8srBhxb
	 7DOR5a2Q+GW3bkIkW8lnO3BLL0VheS0MPHwF4EZh+zBX0Tpm/AD4mC7XMiVa1jh28G9j4
	 aklhkTVDkPnKQkBvuWfCeDV0AKMnFOo8bqlWLn4wY8DWBtZPGB7Cy94dGk+JKZpjelBRc
	 OKhfwdFxf3yZDm5f4AK4KCM2IbQ7AZwuE9jQzhxZQJrKgoxagfefrZGIPoJf8J+I4qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VMIh7wEG6D0f4Q/UpZj9xNBpla6A0/xIqtq7Axwzovs=;
	b=39UiToKeHfoTnbu2SKOo8/wU9FzAo8N1d8TXaGeS6GaOPmX5J3AhgI4Ht4kQNscotJ3x
	 IMGH8vgQdul+2Y/CyZg/m2gE1t4kKQP/AKSQODhvLLGF126engyHOUFMTl7ww0VAk6Gyc
	 JDIvJWWtzxQu/jJM0SZi7oQFuNXVwBzzwjliI9fnQBFwFquPqFIBOdPytRDRaja+wgldy
	 QafFJjIR5HtBfhFEFgo8+giuKlwZA4AMYACGPmIcVDfrlLHnN6puP/U8E//tWg7YvVJUb
	 8UR7ukyubCXvs6C+lsNMJlc3QtACYqV2OF7l2V1xIUreRbpVEm8x+uvBJEnU6EJq++Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4CKO4Vx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF7660A2600;
	Wed, 18 Nov 2026 20:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4CKO4Vx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456E31F000C4;
	Wed, 18 Nov 2026 20:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033218;
	bh=VMIh7wEG6D0f4Q/UpZj9xNBpla6A0/xIqtq7Axwzovs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4CKO4VxuwCVa8TAMCYV8OkMwWd1Jb0DTB6Bj2nCv89td/7PPdKXIg+6U5TJqhNYp
	 mS022VJwsOx18xMtj3T0oIv7dPGoB4n+247s+wfUBYDlfrf8tDODZ7web+P1aidn5W
	 qMKgP55Q1E07u1gWTBd/qoC9njwLcMPMLnaW9PxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Nguyen <jamien@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1688/1756] selftests: net: txtimestamp: fix out-of-bounds read in raw UDP checksum
Date: Wed, 18 Nov 2026 16:03:35 +0100
Message-ID: <20261118150116.879808511@linuxfoundation.org>
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

From: Jamie Nguyen <jamien@nvidia.com>

[ Upstream commit 8daacee78b3d2798fcf92398b6dff364eab64466 ]

With -r (SOCK_RAW, IPPROTO_UDP) the test writes only the UDP header and
payload, and the kernel adds the IP header. get_udp_csum() still expects
the IP source and destination addresses to directly precede the UDP
header, and reads 2 * alen bytes before the start of the buffer: 8 bytes
for IPv4, 32 bytes for IPv6.

ASan reports a heap-buffer-overflow for both -4 -r and -6 -r. Without
ASan the read usually goes unnoticed, but it faults when the buffer is
the first chunk in the heap. That happens on Ubuntu 26.04, where the
kselftest runner wraps the test in uutils stdbuf, and txtimestamp.sh
fails with SIGSEGV on every run.

Even without a crash, -r packets were sent with a checksum computed
over unrelated heap memory, so their UDP checksum was invalid.

Build the pseudo-header from the destination address and checksum only
the UDP header and payload. -R and -P already write daddr as both the
source and destination address, so their checksums are unchanged. With
-r the kernel selects the source address, which equals daddr for the
loopback addresses used by txtimestamp.sh.

Fixes: b52354aa068e ("selftests: expand txtimestamp with ipv6 dgram + raw and pf_packet")
Signed-off-by: Jamie Nguyen <jamien@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261027162945.2122306-1-jamien@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/txtimestamp.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
index d626f22f95509..b68e05602047c 100644
--- a/tools/testing/selftests/net/txtimestamp.c
+++ b/tools/testing/selftests/net/txtimestamp.c
@@ -417,19 +417,25 @@ static uint16_t get_ip_csum(const uint16_t *start, int num_words,
 	return ~sum;
 }
 
-static uint16_t get_udp_csum(const struct udphdr *udph, int alen)
+static uint16_t get_udp_csum(const struct udphdr *udph, bool is_ipv4)
 {
-	unsigned long pseudo_sum, csum_len;
-	const void *csum_start = udph;
+	const void *addr = is_ipv4 ? (void *)&daddr.sin_addr : &daddr6.sin6_addr;
+	int alen = is_ipv4 ? sizeof(struct in_addr) : sizeof(struct in6_addr);
+	uint16_t addr16[sizeof(struct in6_addr) / sizeof(uint16_t)];
+	unsigned long pseudo_sum;
+	int i;
 
 	pseudo_sum = htons(IPPROTO_UDP);
 	pseudo_sum += udph->len;
 
-	/* checksum ip(v6) addresses + udp header + payload */
-	csum_start -= alen * 2;
-	csum_len = ntohs(udph->len) + alen * 2;
+	/* pseudo-header source and destination: both are daddr */
+	memcpy(addr16, addr, alen);
+	for (i = 0; i < alen / 2; i++)
+		pseudo_sum += 2 * addr16[i];
 
-	return get_ip_csum(csum_start, csum_len >> 1, pseudo_sum);
+	/* checksum udp header + payload */
+	return get_ip_csum((const uint16_t *)udph, ntohs(udph->len) >> 1,
+			   pseudo_sum);
 }
 
 static int fill_header_ipv4(void *p)
@@ -478,8 +484,7 @@ static void fill_header_udp(void *p, bool is_ipv4)
 	udph->len    = ntohs(sizeof(*udph) + cfg_payload_len);
 	udph->check  = 0;
 
-	udph->check  = get_udp_csum(udph, is_ipv4 ? sizeof(struct in_addr) :
-						    sizeof(struct in6_addr));
+	udph->check  = get_udp_csum(udph, is_ipv4);
 }
 
 static void do_test(int family, unsigned int report_opt)
-- 
2.53.0



