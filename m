Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208463;
	b=c7T5SXtMNJ/h1aqjjCX73HMa2cP47r6Ky9VoGaPAhXWyXXbCn+nuZNUqhvLZVI3tGexP
	 ba9mR+ZrQwW3ptKBYTuGCGT/kjxR/BbgVKPmtyHE4lS2ZotdVykZdHztxMLORDvknSAXw
	 lcuD+hrL6hjuknFzp4Ow5dA1mD0urGz4ErWMGV+i2g5krbMVWbpXffQWYf+HrBSyPYGrg
	 xslTyR4W6ZtgABaBRPRW1CKFopr9fFdOZ9BPvP/aWqMVnEjnGzkIRQOtgZg58HCN843TM
	 SlK7R/cF4saTRyUiQVmvOgf89rXfbXjRE3sOCvd3zV00KAlDTS3dX4jAEO7kYdmXH3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zUg04VutUOUHAZc7CdPn8mpWLnXtdbuvKTOgV9PNJS4=;
	b=wzHR5jgj9v4sbovw0Yzf/IgvbT4fxshpEk22DpCXu+N9ZU1zw5RX/JIir8LD33XpyuKg
	 xmXJjguB3A3nGqML0MRvhZl5kON7zIZClqFPWnOsRD9T06MnAuscHTwPaw3gROvA4p4wW
	 lcOjELEU5a/zR3GjPbmkZD6FOQHoEJGW1cNEkrl/Y04pqTVVWKBKC8VoPx8Nc7XYLaqDb
	 xP97oeXSE4IgT1ol9kDDlYNO/5M9s7+WOyh9rFzKzfpAIiAT7n0iNxwUWKl83Dw+K5nnZ
	 zMctuxBMMUfFyI87SMYwLNae/CoojpYCDf3xL2/3XMsdSUq/MFibT19Wur026Tq6YhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQ9mGnCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98CB606A31C;
	Wed, 28 Oct 2026 17:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQ9mGnCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4D81F01825;
	Wed, 28 Oct 2026 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208462;
	bh=zUg04VutUOUHAZc7CdPn8mpWLnXtdbuvKTOgV9PNJS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQ9mGnCLdpP7MfZ3a80rAtru3yPVqiL6rmaSVuZv0BLlN3YIqXQP6yFYYT42SNRq8
	 3AtfvBpOEIqZ+k3yUHiMc9HwFLgmGaLNBMUrN+77SXM0xmQs26QkpWaUzJDZ+eSBGs
	 cN9Z1eSGKCTiFAxVed9TFvZ4hBpYLeFSIgOZ3obo=
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
Subject: [PATCH 5.10 127/516] smb: client: validate POSIX create context length
Date: Wed, 28 Oct 2026 17:54:39 +0100
Message-ID: <20261028170006.521738448@linuxfoundation.org>
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
index 0205307d0f9cd..3c0c5e1cacbfc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1972,12 +1972,15 @@ static void
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



