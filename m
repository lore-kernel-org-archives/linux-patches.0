Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015149;
	b=LlY8qVxf2Og57CR28X5xFHT6pbLyNF62hLXnnBJoMi0KEuukoXH9BUUc3KcXpFU/I7vf
	 iDFsNGDVb5QnVgMBm8d2H76V/BPc5frnPwCGw/Y3a0wdlCjDDnHjd8nNWrl9zXdUAjK0/
	 UtXYlLEqZ3RJbh22b0x0h/yAQ1tPS+oBl2JrUBMYWdltCbt4n264i8RHqljD32KdhmLqz
	 OaBuVOiHl4aAipa/5epOZYes/qzgqEx3pLOPE7yLrR5EmQAt9KgpIbcUwMYj7bsPk6l02
	 1D/FCVGhJLUM+49HvvXJXWv7z/YH1OZoyH3L26TEU3QCt9k8OdFnjddf0SD9115qdvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5CbqIAKTjPsj6pi5g0UEhcLo60WohYrKWcig0RR17rY=;
	b=ZPQueyh1xULfHoZuz0nlu2gy+2wzLIfX36jN05w6uj6buUwZoDG2lePsVvxVD9+0kBEP
	 32x8KeGMQchK69TLXTUKicRS1+lxKx/fHkxpthbRuTrhiGDzXMZCICox1dSLF2Qb4C+Ok
	 P0O6dQ+goo56rAVTBEzOMJStyA77lUCiPX/HFn4vjkS/EDWCPUFnLyZPQnkA5inY/KJ0n
	 LmPsCjIwfWA0jJqAUpHcM5A9prwEl2MvqfFLMYgbfOAnDFjqHIEHi4f3f4vcs+jvpvjvC
	 J1xmEF7tTB0iPZJPweEOr5Vuhk5mVD60h/ULJAXFAchGCndhKd/s6yuo1IgoAg91G/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9Q+rY9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5311D606A31C;
	Wed, 18 Nov 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9Q+rY9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E941F000C5;
	Wed, 18 Nov 2026 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015149;
	bh=5CbqIAKTjPsj6pi5g0UEhcLo60WohYrKWcig0RR17rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9Q+rY9+AkIaW/sOt0s8AyUBNr5Xs1R3NLPfNxvkzMsQR5rmkjiawHn/HGF4TRfEa
	 Fz2iZk0IAL39WtaZOTNx5+MHVuf2sEQMhK3s6sf8E3BVUWF/yFiGWIum3L6yYd3x0m
	 xagdVPX19c+wZdV48HhgN0w3nPMoITiqe0bIAPW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Darren Carreras <carrerasdarren@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0068/2651] libbpf: Avoid overflow in BTF.ext bounds check
Date: Wed, 18 Nov 2026 15:21:48 +0100
Message-ID: <20261118150250.387403582@linuxfoundation.org>
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

From: Darren Carreras <carrerasdarren@gmail.com>

[ Upstream commit e40f61a31688898e7cf81e91074a42f805883e4d ]

A malformed BTF.ext subsection length in an ELF input can wrap the
pointer addition used by btf_ext_parse_sec_info() on 32-bit builds. The
wrapped pointer passes the bounds check and parsing then reads beyond the
copied BTF.ext data.

Ensure the header fits in the copied data, then validate the subsection
offset and length with subtraction before forming its pointer.

Fixes: ae4ab4b4117d ("btf: expose API to work with raw btf_ext data")
Closes: https://issues.oss-fuzz.com/issues/477315119
Signed-off-by: Darren Carreras <carrerasdarren@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260813-b4-libbpf-v6-send-20260813-v6-1-56be61c52758@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 8417de92d0282..c783359977b46 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3364,7 +3364,7 @@ static int btf_ext_parse_sec_info(struct btf_ext *btf_ext,
 {
 	const struct btf_ext_info_sec *sinfo;
 	struct btf_ext_info *ext_info;
-	__u32 info_left, record_size;
+	__u32 data_left, info_left, record_size;
 	size_t sec_cnt = 0;
 	void *info;
 
@@ -3377,16 +3377,20 @@ static int btf_ext_parse_sec_info(struct btf_ext *btf_ext,
 		return -EINVAL;
 	}
 
-	/* The start of the info sec (including the __u32 record_size). */
-	info = btf_ext->data + btf_ext->hdr->hdr_len + ext_sec->off;
-	info_left = ext_sec->len;
+	if (btf_ext->hdr->hdr_len > btf_ext->data_size)
+		return -EINVAL;
 
-	if (btf_ext->data + btf_ext->data_size < info + ext_sec->len) {
+	data_left = btf_ext->data_size - btf_ext->hdr->hdr_len;
+	if (ext_sec->off > data_left || ext_sec->len > data_left - ext_sec->off) {
 		pr_debug("%s section (off:%u len:%u) is beyond the end of the ELF section .BTF.ext\n",
 			 ext_sec->desc, ext_sec->off, ext_sec->len);
 		return -EINVAL;
 	}
 
+	/* The start of the info sec (including the __u32 record_size). */
+	info = btf_ext->data + btf_ext->hdr->hdr_len + ext_sec->off;
+	info_left = ext_sec->len;
+
 	/* At least a record size */
 	if (info_left < sizeof(__u32)) {
 		pr_debug(".BTF.ext %s record size not found\n", ext_sec->desc);
-- 
2.53.0



