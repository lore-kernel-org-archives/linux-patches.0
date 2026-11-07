Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064254;
	b=eUnF+Cat8dUcDBdgmTESN+ywLUL+J1kiDmjcVpy7/oA9XAMlzwAD3MoSDfBxmn7KzSSl
	 Wy8Bpm9lKcJJA31jID5CUH+tOFvqK+YRG1K5q0qivxYdwlUcN0DbEw5KtdxAYeMRFTnOr
	 Tk4Uc7hKbHATN1gEluymcvPFgKfy1EWWoRSR4GF4pQlGe9IQIiddoNQyPdARzLE2S7fgF
	 AiabYMJ5Y5Zrse9a2DMonBYh3z27wt6cSek4rTfu4e/cYv8byvjI7Zc4XnJe54++j8rTj
	 ccQsH56Vj1ubY3GZnCDFqG9exkndTwNVBJNnMX1yXfYmSo1nhvsSbh8cu7yKM002/Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sdGT4bUoH9vgtdzdN0AcuIKe18fj+yOnEBgHSJ/HPOA=;
	b=cVItmTfkg2yVnmCGM1+Ghzwfqlw5aTe4OBEsE5BC1fmXTGxHuXkxKIZxpXympW4iHWDF
	 QU0i6JBDP8e0b6yabODRkPvXZT9gYyJbuhi7xIOWH3t+APxRRKxXOhfObc5f6LjIPi2Tp
	 IT9gXyOa9vc+IB8rBV2v9/JtxgqVQUiTzuHzzSQ3BCPl17ubBFFJep+CjLNdUQ3qMyGve
	 oR804xpUF9yGtYwZk4d8Bv+h30+qSDSOFzd8uoGreCw0Qy6HIZS1V6429t4JyrWYxs8x9
	 lSn5beujSjKMe+MDPIqXKjkqaUZ0Y0CE4nhi4QvjLTMnlY3jWKTDt0n5v1y7i5833Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQbrAiTP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604DB606A9C6;
	Sat,  7 Nov 2026 15:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQbrAiTP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9771F0089F;
	Sat,  7 Nov 2026 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064254;
	bh=sdGT4bUoH9vgtdzdN0AcuIKe18fj+yOnEBgHSJ/HPOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQbrAiTPiUnDrplkL06YYMRBfSg68HvtBet/oc6Wn49qMaw5o0g3gYN/10dds4TBZ
	 tkm9h8EFM+LvPkFk57S1j+sVAUyIeMt/168Wa9iKpAyS0OlOowyKMUWGptbITiUEHk
	 AFOylS6lhaf2uUPUIXSb0Ft2TMW43mKEpvjALC+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0355/1257] fs/ntfs3: reject an oversized resident attribute on the inline iomap path
Date: Sat,  7 Nov 2026 08:44:11 -0500
Message-ID: <20261107134949.191499805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 456189f9c714dee6716c2a3aad908e63830cac66 ]

attr_data_get_block_locked() maps a resident attribute as a one-page
IOMAP_INLINE extent: it allocates a single page, copies the resident
value into it with memcpy(), and hands that page to ntfs_iomap_begin()
as the inline data.  The copy length is the on-disk resident value
length (res.data_size), and mi_enum_attr() only bounds that length
against the MFT record size.  A corrupted volume with MFT records larger
than a page can therefore present a resident $DATA whose length exceeds
PAGE_SIZE, and the memcpy() then writes past the single destination page.

Impact: reading or writing a resident file on a mounted crafted NTFS
volume whose MFT records are larger than a page overflows the one-page
inline buffer in attr_data_get_block_locked() with attacker-controlled
bytes.

Reject such an attribute in attr_data_get_block_locked(), before the
page is allocated and the copy is made.

Fixes: 099ef9ab9203 ("fs/ntfs3: implement iomap-based file operations")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index b1c315206ffaf..fd2640878e6a5 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1034,6 +1034,21 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
 
 	if (!attr_b->non_res) {
 		u32 data_size = le32_to_cpu(attr_b->res.data_size);
+
+		/*
+		 * A resident attribute is copied into a single page below
+		 * (alloc_page() + memcpy()) and mapped as a one-page
+		 * IOMAP_INLINE extent by ntfs_iomap_begin().  mi_enum_attr()
+		 * only bounds the resident value length against the MFT record
+		 * size, so a corrupted volume whose records are larger than a
+		 * page can report data_size > PAGE_SIZE; copying that many bytes
+		 * would overflow the single destination page.  Reject it.
+		 */
+		if (data_size > PAGE_SIZE) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		*lcn = RESIDENT_LCN;
 		*len = data_size;
 		if (res) {
-- 
2.53.0



