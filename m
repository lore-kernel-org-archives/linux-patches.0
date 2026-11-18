Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049128;
	b=IPelEhAeAqgFPpZdD919W2xYOvaNH+RUG3BAdWwBfLDmbMDoVlZnJp1MlpsZgRgd5w3C
	 8xSwQneF/E63uGDbyUgCorY0DwRNhSH5Y9+LIB3WwOMyox+YANSVOuvIWTdTDFi4HaXf4
	 fu4EKnD6kyrUJgb9RhJTUjLOW7L6Hb1GWrpOfDHy0erhEo/PnDBhOc2PbU0S8SWEapciE
	 M4IUNp/LY2KDfKECWgEZM3fXcuaXOzggJ3+uxrcOOYIiqA++B9G+o7oXluhs0QakekRRv
	 uTG9M2Iw8v2fM4UvFGEHGufsonmtwJ6DuF/86Z6yAAP8avJRdPxPtfQO6/p7ndZg78g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6vEyt0OiAB6tOYFSwLv+X54jDgB5zvMcq6hIiBwyGLg=;
	b=P/OXO0JCi7i5fh/WkhDkG6hXqRU/ESVMo6o2Y5QibWtaHpyfm0wPBIYRF5BLKDjcCFRg
	 rJXk06qgLwagFzPqYlKb7xF5iMK2yCE1ZfFJEQxkkAR7qyFtSYPS+u7sOi932MMFmU5Lz
	 9PAqqj3DnyZD5EdjCZ24ISbLTE9k1IonOy5w4oMt8B6Ku1o2sDTNP+7SubH8lIlhMfRwk
	 y8ifVCz5d0Awqf991qWtMJLkvX1tW7+7MQCIzRQ9PI3pzuIZEs0gaLPO/aFeDECcJrm28
	 3vcfIEiYqg9yG2et6cLwbJG44eFGGr8hg6Ub71qNygwd9npxNa9K4GxN5HMKcnOqiPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXuygqOX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D2F606A325;
	Thu, 19 Nov 2026 00:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXuygqOX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782921F000C4;
	Thu, 19 Nov 2026 00:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049128;
	bh=6vEyt0OiAB6tOYFSwLv+X54jDgB5zvMcq6hIiBwyGLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXuygqOXaAxUKoUAT2dt18eQu99oF9wseU2JE616qCoOboE4+14h1iS2Vzb65NTov
	 D5kf175WjpTmAMuh/8RiKjC0RzJuxIuDQE8XrPTSLXIA8gECGXt2Xz2+VNKZp372m6
	 GE4bcCX5HK3dcDvGAaRAGbw+qZjs5hTGPdN/52Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2242/2857] NFS: filelayout: calculate dense stripe width in 64 bits
Date: Wed, 18 Nov 2026 15:54:36 +0100
Message-ID: <20261118150322.167208888@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9ba13ef0e3ad033d3ddbaeb740b12d135a88363d ]

filelayout_get_dense_offset() calculates the stripe width from the
stripe unit and count, where both values are provided by the server.
Their product is stored on 32 bits, and can wrap to zero despite
passing individual checks. For example, a 1 GiB stripe unit (0x40000000)
and four stripes (4) cause the following div_u64() to raise a divide
error during the first read through the dense layout.

Update u32 to u64 and use div64_u64() instead of div_u64().
stripe_unit is a u32 and stripe_count is limited to 4096, so the
product cannot overflow a u64.

Fixes: cfe7f4120f8b ("NFSv4.1: filelayout i/o helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index 08c47278aab6f..a9e8170401088 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -55,12 +55,13 @@ static loff_t
 filelayout_get_dense_offset(struct nfs4_filelayout_segment *flseg,
 			    loff_t offset)
 {
-	u32 stripe_width = flseg->stripe_unit * flseg->dsaddr->stripe_count;
+	u64 stripe_width = (u64)flseg->stripe_unit *
+			   flseg->dsaddr->stripe_count;
 	u64 stripe_no;
 	u32 rem;
 
 	offset -= flseg->pattern_offset;
-	stripe_no = div_u64(offset, stripe_width);
+	stripe_no = div64_u64(offset, stripe_width);
 	div_u64_rem(offset, flseg->stripe_unit, &rem);
 
 	return stripe_no * flseg->stripe_unit + rem;
-- 
2.53.0



