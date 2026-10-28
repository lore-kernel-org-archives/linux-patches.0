Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210721;
	b=XKhPqGtEZfjA+SvJmJSrP/oRMRor3La/NJAoVFf+kfk4cpHYVydgjUgeOcNmoOGFb00j
	 tmRvTadvhh7fxKC9Vi+8QD1tz0xQrBk144oFPwJ+rMIeC16u6366mZ072uLDeDtg5kTlY
	 vZAZmNEiuhfSiK44zxZBNFTdt6GPXl7lNFjVvRUgGt8YDTAoXfKZfX4UYhL4cLFpxFgMs
	 0mgkcWYYEKp2mmvk614F6VCPsnTEf3rHs/wRWoSdSZ5dEPhV7C/Q1Pcni7A7D2/gG18z2
	 zQp4ar9OnP6YtDxKi/8nvI3sPZrIKyekAUmPHD29be6qzwbyAwt4h4ZZrscYZG+iX7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bn+lssqX0rXXEK9obJ7Crer4PB0rRD/h1QgaVilpHP0=;
	b=Pj+A77LOBWTZPKeAc9bcH3M4hHXaaVWmHpSfN2vwmDc2L6SamU+uMr4wgX+Ycc87Gkva
	 UZT5TF3oLD5R+MER1qjCKGH5qlKTmCmzdVt4s1Kq030hrEzVkxvwo3tnPR+1J/TU+8D1u
	 CciYTHLCwc/JCH1eYNilcCiaf9xY58OZvbVGKqbswwY85enObYehp871FPBEm8AhSa+RO
	 M5gL1eg3fOvGk1JnzZvxZGO5sKSzwroml3qYnIy0YaW8TmtkTmB5m5RBTdBSMmSCSu/MM
	 Z7x4phayWIwebDNXRzBfeXf5qvWz35ROKYFfXr8lIJOkJWifsTwztXXMG81UrZ5Muug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RUQ0rkut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257F7606A322;
	Wed, 28 Oct 2026 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RUQ0rkut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A10D1F01828;
	Wed, 28 Oct 2026 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210720;
	bh=Bn+lssqX0rXXEK9obJ7Crer4PB0rRD/h1QgaVilpHP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUQ0rkut9kYPzU3eHI+Oy2zyf0EXlbO/LS/tXdtAxxaEEEyyKHLpw77xAcMJ4Qhl3
	 DnXRQIuenPxmABDBrsbmV5niJ20du1YO0fbxzkBJl8SwMcEZESmM0jklNz7D5tY8mm
	 ZyiB6a1iX+Tmx5tmQ96NpqsU2oldEXThEQGlEGKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/571] smb: client: validate POSIX create context length
Date: Wed, 28 Oct 2026 17:54:30 +0100
Message-ID: <20261028170010.936284205@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit fa2e9900dd2a3f5a1e7ef5a8c5e8d435feedbfcc ]

parse_posix_ctxt() reads the fixed nlink, reparse_tag, and mode fields
before checking that the POSIX create context contains them.  A short
context can pass the generic checks and still make these fixed-width
reads run past its declared data.

The current in-tree smb2_open_file() path passes a NULL posix pointer,
so this handler is not reached on the ordinary open path.  Still require
the POSIX data to cover all three fields before reading them because the
helper performs those unguarded reads.  Keep the existing soft-failure
behavior so malformed optional metadata does not fail the open.

Fixes: 69dda3059e7a ("cifs: add SMB2_open() arg to return POSIX data")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Tested-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 372ec3b9deb0f..11fe130a30cbe 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2036,12 +2036,15 @@ static void
 parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info,
 		 struct create_posix_rsp *posix)
 {
-	int sid_len;
 	u8 *beg = (u8 *)cc + le16_to_cpu(cc->DataOffset);
-	u8 *end = beg + le32_to_cpu(cc->DataLength);
+	u32 dlen = le32_to_cpu(cc->DataLength);
+	u8 *end = beg + dlen;
+	int sid_len;
 	u8 *sid;
 
 	memset(posix, 0, sizeof(*posix));
+	if (dlen < 3 * sizeof(__le32))
+		return;
 
 	posix->nlink = get_unaligned_le32(beg);
 	posix->reparse_tag = get_unaligned_le32(beg + 4);
-- 
2.53.0



