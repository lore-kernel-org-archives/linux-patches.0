Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208764;
	b=PVE71C9z1/MWkuNsT3Ozo+FE/aXPAqipGD+KqojFwiKwe4DTI9C56LYn698TmfIkqXbi
	 Z8Vc0tsPVdi7F7XhnQzucbMncZ/x1gjSGgZvqDqL/iG4eufyWlNwiSI1R3Jtv7ByV36N9
	 llZqYrA+YgcH6j0OWCvRTwIT9CwURRnLuLFiWTXtISizX0U5rPL1VZo+3uQkkzp27TjGz
	 vzWZm5cKhDjRrFaJpTs8tyLP1b5u1gpUzKpHlyyoiw+oTXgk0uShmY7rj00ziCdpYY4NB
	 bw85opfi2iwY07xwJ1KcxWuYyKoMfZ4nLxy0/djqZVcN34EFBe4b8km/dzz3/CVPIig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GgTJir1Bmpg9e9LJz/UcmP+f1k4nc2VcYzg+yEZup5k=;
	b=2KVrB9driZ/+ES3js3wiLpcY9d1os/bQLY/DPj8GrLv9OQKf2eohbgIRNKVYnrHZbaAs
	 kVyIB6Q8+NMbShanNgA5fA1w8ceuiUbQPmvIT5QC6SmdVGx0vEed4kl3JyvpwcJmZ2wNx
	 SQ7PWGbkf9w4iMsFTZuU2UBJAhM9dq+lpxLy3SDKg/3afnKiQ/XOQXTkVJA6h66KbAF4Q
	 hCcOTi8iIV3BWwK63Xvr2sCHAEn+tqIpewJggGDa5wC0loFvgiBMUJKR/wInU6NyWY57N
	 Nbdr/AT6sQ2koNXDcWhGVv8IwaV0V1YmwcpUQF4FroyV7ZrvnyLF4rlZz8Cg4jRTijQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt9FIOdP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3C1606A31A;
	Wed, 28 Oct 2026 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qt9FIOdP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA981F01825;
	Wed, 28 Oct 2026 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208764;
	bh=GgTJir1Bmpg9e9LJz/UcmP+f1k4nc2VcYzg+yEZup5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qt9FIOdPJ+12LgdSMHiBiTJ5IkDI4xFAW7xQdz6rjRFzVzjyfa5eReU9skVEsH3Om
	 clwUJE6AXpcKm9yK88T5Dsk1ORcgu/WRj1yBTGs41FBW2ENCZDYzPx9H+MIuQjvqLh
	 johIKFgKw6XjTH9p+g0CvaILySelVLKa05pyXBMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 232/516] thunderbolt: Reject oversized XDomain properties responses
Date: Wed, 28 Oct 2026 17:56:24 +0100
Message-ID: <20261028170009.001104371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit 80756e263846ab694984e749e8c626897331438f upstream.

tb_xdp_properties_request() allocates room for 45 data dwords in its
252-byte response buffer.  The XDomain length field is six bits wide,
however, and a malicious peer can set it to 63.  After the fixed response
fields are subtracted, the driver treats this as 48 data dwords.

Commit 322e93448d90 ("thunderbolt: Clamp XDomain response data copy to
allocation size") only bounds the copy against data_len.  If data_len is
at least 48, memcpy() reads 192 bytes from the 180-byte res->data array,
causing a 12-byte heap out-of-bounds read.  Commit 4db2bd2ed478
("thunderbolt: Limit XDomain response copy to actual frame size") limits
the earlier copy but does not constrain this header-derived length.

Reject response data lengths that exceed the allocated source buffer
before copying them into the assembled property block.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -338,6 +338,10 @@ static int tb_xdp_properties_request(str
 
 		len += sizeof(res->hdr.xd_hdr) / 4;
 		len -= sizeof(*res) / 4;
+		if (len > TB_XDP_PROPERTIES_MAX_DATA_LENGTH) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		if (res->offset != req.offset) {
 			ret = -EINVAL;


