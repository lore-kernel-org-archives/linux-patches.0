Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211075;
	b=NeRIqlg0hTT3CobCMeZHhtuP6CBSOLfNHMlsl9WKeUG9alpCg3DY8OsfFz7q+20wOsjo
	 E7NnbVum3UTFcJs5qX/MV+GagTLZs0R4iGyucyMtdMYjjimxe8WHvKLFJH5TOv7L3Wz0s
	 EhCTA2Vj0UA1wYdKpHcqev7a73y6qcgWb6Aknk5XyeEZqDtuNebyc7Hvg14SJqig1JUX5
	 a7IOeUnPcdZzlyy3x41dlzVbzHP2n6WbHL8YlCKCxa+LLFYAOPfp/jTr3ZXxkurDa/Gu1
	 re1LJ/szJn7EjPb/AG+e7U2/d71rYTsARUwXMRM5FisdOLJD71c2iZ0ToGSLR9QMgoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bmUTDtsD6ZqDDvuoKsZ3qKGepYcOo2eWbVmg/DGYjOo=;
	b=ouZIGrt4Fj0CuFFW88Sq/GSqM1W2f97ihHdEC1kbM1lcgQ+DMabC42xUUEbpJuuRwwxI
	 wmM3PJHQd+wkiFNMQ1uB2E4mXVCCEv7d5BEPvRr421RsyZDnvZt5oJFTuWXYq9iUELPHS
	 wuWNTuYYYZMifbjNWjyWj9YhCcDjncf+LPaBjDmq6b4pV0GNh7bzQ2vZb5jOjfOAGhAVZ
	 mXkOuKYM2RJircrTVe8Xebt3+fS4OfKZYUXIVecxl9lY5WTWDiEigu9+Rlvd5ayFqWFx1
	 grIIU5X/sZ6Qhte5t9G6lm3Y/ared+JTNpfFGWu00HZW5iNT76EMLmuanT5yzG2INRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIqpPuyO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511D360A263D;
	Wed, 28 Oct 2026 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIqpPuyO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919F71F01825;
	Wed, 28 Oct 2026 18:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211075;
	bh=bmUTDtsD6ZqDDvuoKsZ3qKGepYcOo2eWbVmg/DGYjOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIqpPuyOYZL3/rqZM4ANLjuKh1S0Uo/Sc1wUlauwTkbuzO18KTUA3MDo1fxLX33rL
	 DBcjhkXTx+Zklvihku9xeddvhA+rEb3xKdKkVG7rUPTewvs3Abk5inBcfzyuOiZdiB
	 ttnxGzlqfU+CVsONOTNfg7Q5WqszE0OSMUsJnz2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 250/571] thunderbolt: Reject oversized XDomain properties responses
Date: Wed, 28 Oct 2026 17:56:37 +0100
Message-ID: <20261028170013.936085129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -353,6 +353,10 @@ static int tb_xdp_properties_request(str
 
 		len += sizeof(res->hdr.xd_hdr) / 4;
 		len -= sizeof(*res) / 4;
+		if (len > TB_XDP_PROPERTIES_MAX_DATA_LENGTH) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		if (res->offset != req.offset) {
 			ret = -EINVAL;


