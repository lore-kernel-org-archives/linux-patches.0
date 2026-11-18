Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049790;
	b=RcHXH1z/nD553VOQJDidAPPJ/WAtWF7jh8DQu5xK9qlzcDpcDyfxZAc/Dhui+C/C2B/f
	 alnLGWffjL0Ziw3P2lThtchSgjX0ihEVkEFb5K4dl8cp7WvUewSBDHbE+yEwCHKpSOg5Q
	 pOlkQC1EdJE6BNLLHG4p6Ac4/4NJAG3B80hRb7htGOzrvic5VBLO3TYSsWV4/0PQdKhfg
	 uq9nlra96+U6i97x+aWlNmBVGzvbDMbSJzgugAjVIwUwx4Ii3s8HCXqDXYL1/HrLf9ovf
	 2U8B9KeWoSPUFIFe8CToIQkItbJFab2gFLv6T+jiE60yG/dluKF5NGVZOhDFQhKo8yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/YGYcmjuInsi3yHIKRveXSvzc+L+GscvkUSuOZq0dCg=;
	b=2j+3/xSArjbhOMfyyNC/aQzSbBLFqu0nTrDK2g0UIlH/aiyoSA9txcLq6s5QqLKfItzD
	 rYNCsSciyOlOFYtr4Qrshg+wKtfL/sFAtVg0HDa+WzlA8GeIRbPX+5tttZf5Rn/ZmssEj
	 5TMn9eOa4RMQDCsE/PbfhbcTTGvxUs3FdxQJiJuqEDRQuZ7Gk575l9nb9YsyCcuTmn9SY
	 98eDkkLGMJxWKcG+wKwrkZHdUAVgi55zlyPCgAWv/3b3R4evZluoj9Z1vN5ZQt7BH2FVL
	 7nj567j9dsKKcTj4ou9eA5F4aDxPmtGmwbidUaOH/MP5jgUDC1wOa2p2VlGQDtmQEPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpaa8s4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3CB606A325;
	Thu, 19 Nov 2026 00:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpaa8s4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2D51F000C4;
	Thu, 19 Nov 2026 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049790;
	bh=/YGYcmjuInsi3yHIKRveXSvzc+L+GscvkUSuOZq0dCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wpaa8s4+IqAEaiz0mgv4VUK38FgMPzf4D579Qu3lyxZX3n/gAKVb0uED4n8MdGYvS
	 Qfhv8UgBgKeg/ZPkLxpoi4KFQScJ7hVLDCoC6pcReLp4V13YyWzcKG7Ccs+FVCAowy
	 gg8bqPAH0bT8vx0JWZGIKXRpcnpUx5cW+c8rSc5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Andrew Morton <akpm@linux-foundation.org>,
	VEGA <vega@nebusec.ai>,
	Kyungsik Lee <kyungsik.lee@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2450/2857] lib: validate in-memory LZ4 chunk length
Date: Wed, 18 Nov 2026 15:58:04 +0100
Message-ID: <20261118150329.780371727@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 138a84817df01eda67bb23032ab49c23fe2ffc16 ]

We found and validated an issue in lib/decompress_unlz4.c.  The bug is
reachable by a root user through kexec_file_load() with a crafted external
initrd.

unlz4() reads the compressed chunk length from an in-memory initrd and
passes it to LZ4_decompress_safe().  It only checks the chunk length
against the allocation size when the input is filled by a callback.

Reject an in-memory chunk that extends past the remaining input before
calling the LZ4 decoder.  This prevents malformed initrds from making
the decoder read past the mapped archive.

Link: https://lore.kernel.org/59c6555c27aa7ba18ee227f9f02c78d15a37605f.1789219453.git.zhilinz@nebusec.ai
Fixes: e76e1fdfa8f8 ("lib: add support for LZ4-compressed kernel")
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_unlz4.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index e6327391b6b66..80bd4ea40f95b 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -139,6 +139,10 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 		if (!fill) {
 			inp += 4;
 			size -= 4;
+			if (chunksize > size) {
+				error("data corrupted");
+				goto exit_2;
+			}
 		} else {
 			if (chunksize > LZ4_compressBound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
-- 
2.53.0



