Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022864;
	b=uqT5KDGJ5sEtO1dOWZxggZXryrntzmFjRye6PKJpCS6zMMzcF4Y5Nl+MhGVJ9J509av2
	 YHs2Km3/w/oJPNyCkocMg4/dr2hrZza52Ux2Ew8HAiT/BCeIx6pkGUKOkOhrP5wur0/W5
	 aQnL3cBjSYWWJbrPA3swTkgm0VvBefiByTP784qpY0GWv0EiWjanGOQi7bVfPfa26VGDa
	 kdD7yddE9dmTCc0w6bYvUvcd9x3FpLJARmpuuX0E3Rpm9UZzCBS09DOn2KTCuXJjOShwl
	 xRbKLIrwpB9vo+oLmvEDb+G5OzULrZU6aL2RSqWhI7gHH6CBB9u7Xndb1C4ZQ/n4zzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VWjzODGvpDRSWKQ+F+Scl7k2MpCNexb9jF9hhhfInVk=;
	b=J1FXwoKdC0iZHDYaVsL8fdW0SO+WZKJ+fKKFR2NH7/+9GPNkf8EShUFYlrSqV5inwP9x
	 tmkRGLB5JYGV/I1OZ7FxPQ78LkRNUSBE392attDagdrEMoJcGAytkzG7zJWPZ/u+eKDpn
	 rcUfobryafPsoP6jKw4WubhyILSfrQApncBU5i5kTEj6GeGGU9QdXaPi+1T+JqVXAkN06
	 HMm0puwu6yh8kPmVrvtzP/uM+XS9pgoerYwUGonZXNaA4t5Zs5dQ4gJ3/NkltPXDf8nXn
	 K0ayPe52mdV58AEyW2JQikVXhuviKGeU6H5XJmbc2iATndFsHAL+1y9N/t0fq8g2pug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11B+rM4a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A4C606B3FA;
	Wed, 18 Nov 2026 17:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11B+rM4a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A3F1F000C6;
	Wed, 18 Nov 2026 17:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022864;
	bh=VWjzODGvpDRSWKQ+F+Scl7k2MpCNexb9jF9hhhfInVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11B+rM4aOt2A3esTCuJxtVaN6W6a0bHlOfa4BYyC7/6uExut4t7BoJ6H1UsmkqT2A
	 GDhEvVcZ3/gPQ063BBPh/OxZkC7CbZyTXtyUA9HuRdAhCiyRiEZK6aqlw+2BLKADoD
	 JFP5JQfPBBRGpOyGTyTBJbjTzeDwDTMIE5F//GyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <shijianlin11@foxmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0138/2151] bpf: Reject oversized bpf_stream_vprintk output with -E2BIG
Date: Wed, 18 Nov 2026 15:31:13 +0100
Message-ID: <20261118150126.814890296@linuxfoundation.org>
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

From: Jianlin Shi <shijianlin11@foxmail.com>

[ Upstream commit 41c0348f6e65c26df4866d5dc96c57b1995fe36c ]

bstr_printf() returns the would-be length excluding the trailing NUL.
When that value is >= MAX_BPRINTF_BUF the message was truncated, but
bpf_stream_push_str() still tried to allocate with the inflated length
and failed with -ENOMEM. The boundary case of exactly MAX_BPRINTF_BUF
could also copy the trailing NUL into the stream element.

Reject such lengths with -E2BIG before charging stream capacity, and
tighten bpf_stream_elem_alloc() to accept only payloads strictly shorter
than the bprintf buffer.

Fixes: 5ab154f1463a ("bpf: Introduce BPF standard streams")
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
Link: https://lore.kernel.org/r/74387ae5024d7e2996095e97211430285095b525.1787492521.git.shijianlin11@foxmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stream.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/stream.c b/kernel/bpf/stream.c
index 62af66d6ee391..9a65fd2c918c1 100644
--- a/kernel/bpf/stream.c
+++ b/kernel/bpf/stream.c
@@ -165,11 +165,11 @@ static struct bpf_stream_elem *bpf_stream_elem_alloc(int len)
 
 	BUILD_BUG_ON(max_len > BPF_STREAM_PAGE_SZ);
 	/*
-	 * Length denotes the amount of data to be written as part of stream element,
-	 * thus includes '\0' byte. We're capped by how much bpf_bprintf_buffers can
-	 * accomodate, therefore deny allocations that won't fit into them.
+	 * Length is the payload pushed into the stream, excluding the
+	 * trailing NUL of the bprintf buffer. Reject anything that cannot
+	 * fit without copying that NUL into the stream element.
 	 */
-	if (len < 0 || len > max_len)
+	if (len < 0 || len >= max_len)
 		return NULL;
 
 	if (!bpf_stream_page_local_lock(&flags))
@@ -389,6 +389,11 @@ __bpf_kfunc int bpf_stream_vprintk_impl(int stream_id, const char *fmt__str, con
 		return ret;
 
 	ret = bstr_printf(data.buf, MAX_BPRINTF_BUF, fmt__str, data.bin_args);
+	/* Truncation: reject before capacity charge (not -ENOMEM). */
+	if (ret >= MAX_BPRINTF_BUF) {
+		bpf_bprintf_cleanup(&data);
+		return -E2BIG;
+	}
 	/* Exclude NULL byte during push. */
 	ret = bpf_stream_push_str(stream, data.buf, ret);
 	bpf_bprintf_cleanup(&data);
-- 
2.53.0



