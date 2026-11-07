Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061704;
	b=mm7iagykfhjn9cooHYPmC8URwirzp1uIv97IVxZHGv7Fi2EuZCRjIB8OBU7XWL5W91ea
	 QV9gtCXMq85mK+1nOo/rq+n1nWtRdA8M8B4SN8gbyGWQXvbKyoTNM/Hq9xoretc5zLdKL
	 fU5B8MY/EGzkzxm90zZmJaGs/Sdu6u0n14U54nCVVLNS/PVKz1jNnf4YQOtLaOCc67bKj
	 8AL7nACtuReUeheqeUfN+tUQn94BeH5qwM7JtJarg0lYfvu+ubLULkm0IbJE9/VTuFCLQ
	 6ZesMp8YDUkimNX1bfdaSyBxnb1ySEwcAtkTaHvdkmMGEQyAkQujImuRnxcb/+a1M7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vTCrr3mgLbyg4dUDrnWD54RobbXVjUiESBnmdj7p4Dg=;
	b=y8J/NYWmVpSIMogggDGGZxY6OKtytzvYO92Gz6ibDNJNnRTJxOdyupO+RpsvM8LUAZCZ
	 O7D62DVZKPpIxR3FtXuRPMGkWlwDVqPrBokV/zkBNNTDSOu+tneh47K6TSI1eoj2uVest
	 iT4HjsDiZfzh40yW6fBRPp5IercaIlzVNecYuh33wnx2uQ8PwSyPGnRuc6dAasQDYkO3Z
	 0RVVWvuv2hlYsx6phpLGfQ6Wirx2gu/MZdCMajOmlOfyl2Wlquy7cbHDzzfA1xEdP6rve
	 g5bVs8GPryfo1Yf86xKxqC9pbFD44UIOhylY7SD7N6NahbzwnMSbLUWErxoMoNrX+Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5yScNpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B57606A32D;
	Sat,  7 Nov 2026 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5yScNpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1081F0089F;
	Sat,  7 Nov 2026 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061703;
	bh=vTCrr3mgLbyg4dUDrnWD54RobbXVjUiESBnmdj7p4Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5yScNpQkbcfFC679Qhj3KaG7PzTclC5UrjqoMO/CNG5XiWsF6S6uRbsogtWVpHT5
	 R5e8mTdVck4sjmJC6ep5wA/0bWk0CTYeSIieZYrcb2zfYC+IfVTYeEHmiRFmragGGd
	 gfe1wBNW8NGzgGYIQlklFtfOH5lM04N3wDYMHUeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.12 0753/1536] pNFS: Fix CB_NOTIFY_DEVICEID CHANGE to consume ndc_immediate
Date: Sat,  7 Nov 2026 08:46:09 -0500
Message-ID: <20261107135018.680561084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit a0cb76dc3b2919af8257fc08b4f9a79a35442483 upstream.

decode_devicenotify_args() gated the trailing ndc_immediate on
cbd_layout_type rather than cbd_notify_type, so the flag was never
consumed and a multi-item cnda_changes<> misaligned after the first
entry.

Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback_xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -316,7 +316,7 @@ __be32 decode_devicenotify_args(struct s
 		memcpy(dev->cbd_dev_id.data, p, NFS4_DEVICEID4_SIZE);
 		p += XDR_QUADLEN(NFS4_DEVICEID4_SIZE);
 
-		if (dev->cbd_layout_type == NOTIFY_DEVICEID4_CHANGE) {
+		if (dev->cbd_notify_type == NOTIFY_DEVICEID4_CHANGE) {
 			p = xdr_inline_decode(xdr, sizeof(uint32_t));
 			if (unlikely(p == NULL)) {
 				status = htonl(NFS4ERR_BADXDR);


