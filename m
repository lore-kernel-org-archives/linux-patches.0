Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055768;
	b=cGdWUEhJ91826TfMQFT1D262bEETN76cSgx7l6jIt0NnvufnlT0XZaS9FIe1LuMLB3Mm
	 YgoX57TamlqDnPVszn8ws8qyb7cBN1/f2xw7eEzu9M5ApWJOkULVyntgu1l3pTjoeRJiZ
	 yxCOVhVlAM/vahfbmebJS6vdLVD3UVaKEjgOqoGzESBdwfN0lmQSZFBB5SiPVF2v/HVfx
	 eD7MXG3W4uzv3y7QpThkQ7dBtnsajc9tSIt1fmfjaCB6/jSuhAtHdZhUUWq5qsDRqaFy2
	 P3o/0XDS2q6V7QQkaScEwJf1Sc27HkNQRNyPqC8l35I8Y+72t95z3muRc7wWLZA4H/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NTqjAROE5RuiGhC0MN3JKypU+PsNf3mimcYnssWMXkM=;
	b=rkHpA5yR3+iq162zf46El1EvlH7+jAIhmlHjzrG6aQfHtMNiCW/yaV4WZWgq/yLPa7lr
	 arXTonw4bNrHsmaeMbMV2LFfVDWGkLrfhiyja5sYSahCDIDDnb3+L78h2/dCkZccApEo/
	 cG2z7BTopiPkAkur78wR8tzi1t8RAqCse0FklHhDnITPlj9WeGIWzgsf1Zfvw/TZMVhiO
	 6gPvQDj/UqAveDT8mIqASF/4Rhbcjpcmx+ewZy5tM0iU3UrAcVsgsaVHc5Qo2OZ53kIXX
	 TRorhnq3m8OHGWhvVxwcvR6IYDugOMZPpMi/f6qeo8Ge1o9dxzJJPrYa2hjRQaRY/bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLb4JkTN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B2560A2605;
	Thu, 19 Nov 2026 02:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLb4JkTN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672D61F000C4;
	Thu, 19 Nov 2026 02:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055767;
	bh=NTqjAROE5RuiGhC0MN3JKypU+PsNf3mimcYnssWMXkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLb4JkTNZ8BgfxwRowm7mPSFwY1lf/uP5/B85kqq/tnWqpyMGmvJFKEKQFx8tzLNf
	 65wgtMmYUYOCaYE0+eQoRxGJ3U2CyL3GMRdZXDA+bd6jqxOgYrglycJGL3XIrhLl1V
	 fm3+cHh7s6HgpvgUM/mIAYmgh7QIpTZgsum7JihI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1749/2214] NFS: filelayout: calculate dense stripe width in 64 bits
Date: Wed, 18 Nov 2026 15:57:05 +0100
Message-ID: <20261118150121.567628061@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c760e835edde3..483aedf790846 100644
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



