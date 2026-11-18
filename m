Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021217;
	b=GO0+OzQfeV1uJud53LIlCnSgW/UjcbdYqGqzuEfje/HshmE4/iEjzIOAkXYikMbllmO3
	 XJuhtVu6cybcLLEI3tYGXTysrUUqKQFw2fbv10l47I+yXbhieglEfDEcrcysKqKtBO8jb
	 qx+Xm8tzc1p2KlolEp4jC7hsQk5JNaq87uUnMwuZ4FiJ4FDUz8cmjgiOaj8KABBA20BOE
	 KkQhXM83Cnl76WZv2oQGtmiAeSaWYzCNssIt3lHe1464ynjVtNigNH8XJ4ozwM+7uYoND
	 QoRvYUo+n3HmQynSmoBKoLQr4PBH69on6oNeUkOAELZQ10oM6c6QcjYW1KyBK0m8T5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KEkzvXpLR3ZjHKxlaQJM6wPp7UOD86OmSymra9tZf/U=;
	b=OWNB/LZATdRiutqM5zFLUyFOPbaQzhOKKPj0SWIniLONmPZFxlu2TxjsEME/9gT0acxt
	 GYdMa7F5VGNU2ITr0dNRGlDPrhEyyxxsLmn6L/8PjOt/KqAj4l58q36YWvLO4nea5jPP+
	 VzlUWblgm4uUKxKgqeeO2ySKLgJvO9zSIJrBgy2NugM/jN/3Lgx7CCRy6ZGtXFCjQtTEz
	 OmDMUgKBV0TEmAZ1cOHomnGqZthlpF/5VM2KpJ2lu/ouuUSmFOAZjmnt1tjAZ6nBtw6Xj
	 Ky6yu3mr8xl74AdJ6KYmopkZVNrWny9lUgRAyte5xQxxnRgpHQPRig1slNk/due9miQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2LoiODl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238F6606A320;
	Wed, 18 Nov 2026 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G2LoiODl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8851F000C4;
	Wed, 18 Nov 2026 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021217;
	bh=KEkzvXpLR3ZjHKxlaQJM6wPp7UOD86OmSymra9tZf/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2LoiODlJ0pgIhjUJl+OV76k/d2WgoFAMCU0XxeE3x6Gn2op74FV5YogQM9TdOWsh
	 fwuKHV6KyMCpfJ3Y9508Kw3RX7UuHSNElhoikWqsPx0qyKlScbtP1H85AbzcLTrODN
	 aR461eu3dZbhIeBu6JZ88xf/lu8MuMvp1kMDR4JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2226/2651] ntfs: widen the sub-block offsets in ntfs_decompress()
Date: Wed, 18 Nov 2026 15:57:46 +0100
Message-ID: <20261118150405.692972283@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit d45f99f816c9e40cf89b93b90396b1503eda1e47 ]

ntfs_decompress() tracks where the current sub-block starts and ends
inside the destination page with two u16s:

	u16 do_sb_start;
	u16 do_sb_end;
	...
	do_sb_start = *dest_ofs;
	do_sb_end = do_sb_start + NTFS_SB_SIZE;

*dest_ofs is an int page offset masked with ~PAGE_MASK, and
NTFS_SB_SIZE is 0x1000, so do_sb_end needs PAGE_SIZE + 0xfff of range.
That exceeds u16 once PAGE_SIZE reaches 0x10000: the last sub-block of a
page starts at 0xf000 and do_sb_end wraps from 0x10000 to 0.

The zero-fill that pads a short sub-block then computes a negative
length:

	if (dp_addr < dp_sb_end) {
		int nr_bytes = do_sb_end - *dest_ofs;

		memset(dp_addr, 0, nr_bytes);

A sub-block made only of symbol tokens reaches this without consulting
do_sb_end on the way, because that path just does

	*dp_addr++ = *cb++;
	++*dest_ofs;

and is bounded by dp_addr against dp_sb_end.  With do_sb_start at 0xf000
and eight literal bytes emitted, nr_bytes is -61448 and the memset()
runs for 18446744073709490168 bytes.

Getting there is cheap: fifteen sub-blocks of eleven bytes each advance
*dest_ofs to 0xf000, since the same zero-fill pads each of them out to
0x1000 while do_sb_end is still exact, and the sixteenth one triggers
the wrap.  A compression block is 0x10000 bytes with 4 KiB clusters and
the fixed compression unit of 4, so all sixteen fit with room to spare.

Phrase tokens are bounded against do_sb_end and so return -EOVERFLOW
instead, and the

	if (*dest_index == dest_max_index && do_sb_end > dest_max_ofs)

check at the top of the sub-block stops firing for the same reason.

Use int for both, matching *dest_ofs and dest_max_ofs.  The narrow type
came in with the original import and survived the removal and revert of
the driver.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/compress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 075b57fc1de61..82c7c7d290737 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -182,8 +182,8 @@ static int ntfs_decompress(struct page *dest_pages[], int completed_pages[],
 	u8 *dp_addr;		/* Current pointer into dp. */
 	u8 *dp_sb_start;	/* Start of current sub-block in dp. */
 	u8 *dp_sb_end;		/* End of current sb in dp (dp_sb_start + NTFS_SB_SIZE). */
-	u16 do_sb_start;	/* @dest_ofs when starting this sub-block. */
-	u16 do_sb_end;		/* @dest_ofs of end of this sb (do_sb_start + NTFS_SB_SIZE). */
+	int do_sb_start;	/* @dest_ofs when starting this sub-block. */
+	int do_sb_end;		/* @dest_ofs of end of this sb (do_sb_start + NTFS_SB_SIZE). */
 
 	/* Variables for tag and token parsing. */
 	u8 tag;			/* Current tag. */
-- 
2.53.0



