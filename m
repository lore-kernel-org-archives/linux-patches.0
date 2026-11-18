Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045016;
	b=bvfHlqYaSIC0sFY15F3CCWaHe3A2kpjPtS12mcL3E5h8zHhaqt6eeQ2LIoCMtqWdltWN
	 wSMwJgnA2EuXpZC3z2H0nWkD6AaFWabRR1Jw+LGkP/Dnt/rMfY8kgP7fxRYieOT+qp0lK
	 42HEQFneCRESTt/IFOstGXU+4fjEt0H7OfhGvc1GCoNkl/QZR3orxIxG4XmrIf72DpgDy
	 nyv5ueSwoQgoWTrNeOENV4JIZ+I7A4R12vob0Q4AeTyjq0/sZUu8eDVvDOzYcgLkrgq9G
	 VB39LryviP50xZLwwPs4YyZCGorbHv073II/tVZuW+h8wZbaueWFI0b0MedNOcN51jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JIrCanlmgNzLQ/w/7Hst9zF49+TPmay3QC3CZG85SjA=;
	b=q/CzM4e4otieaEX5tKXx8FQ3DGI6Yw0FGx1z8OHmbvIyq00QkVxcf9tY4snFAjrGYgOe
	 rK7hshcegu+yEjKolVruq2kLrofpyCAfvqdmbzd8sG1wDGXlRL8IhVNSPhb3pKUXY4i63
	 nmTTeVq6V7ciqrryKDP9uQndj8mzeL1BLRWtUMhpyGEbK7j/v06q8UfWLKQg9gdTsTXL8
	 JP9eBv873TPrCiaXb0wVWP8bw6QiRohTdOmlz/FEoXpQWsskZZyqLROZXhyrbz+z2weEw
	 pLOsxZgpLlTALYjm+xD3xELpoupSRjzpgeWNxoJtBuwWRnSNMYKurGuJqyimVHDLa5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZoKR1qnm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC74606A320;
	Wed, 18 Nov 2026 23:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZoKR1qnm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1FE1F000C4;
	Wed, 18 Nov 2026 23:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045015;
	bh=JIrCanlmgNzLQ/w/7Hst9zF49+TPmay3QC3CZG85SjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoKR1qnmSJZMaYlTHYSFm9HX54CoiRof+H++ANjaLq7Gr/pOBrMMFjQMhrh+a6LYh
	 Nqv9rwao7KchYohctGRNeL3yglhN8xB1Oy1EMJhv15/S+xNpBdxqeUg34/eALW8cJI
	 +d1uKLZo9ABZLD97FsFKMdjfrhxeDrES0tF552Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0771/2857] ntfs3: bound index head insertions by buffer capacity
Date: Wed, 18 Nov 2026 15:30:05 +0100
Message-ID: <20261118150229.329469347@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 2f497d23652ff23da07b08cfb4b4a1c2a87f1892 ]

hdr_insert_head() shifts the existing index entries by ins_bytes without
checking that the resulting used size fits within hdr->total. A directory
index root larger than the newly allocated index buffer can therefore make
the memmove write beyond the buffer.

Reject insertions whose size would exceed the index header capacity and
make both split callers unwind the new node when that happens.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: syzbot+45ef5a8d661162757547@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=45ef5a8d661162757547
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 875de16166e63..05e4c2fee712d 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -595,6 +595,8 @@ static const struct NTFS_DE *hdr_insert_head(struct INDEX_HDR *hdr,
 
 	if (!e)
 		return NULL;
+	if (size_add(used, ins_bytes) > le32_to_cpu(hdr->total))
+		return NULL;
 
 	/* Now we just make room for the inserted entries and jam it in. */
 	to_move = used - le32_to_cpu(hdr->de_off);
@@ -1797,7 +1799,10 @@ static int indx_insert_into_root(struct ntfs_index *indx, struct ntfs_inode *ni,
 	}
 
 	/* Copy root entries into new buffer. */
-	hdr_insert_head(hdr, re, to_move);
+	if (!hdr_insert_head(hdr, re, to_move)) {
+		err = -EINVAL;
+		goto out_put_n;
+	}
 
 	/* Update bitmap attribute. */
 	indx_mark_used(indx, ni, new_vbn >> indx->idx2vbn_bits);
@@ -1949,7 +1954,11 @@ indx_insert_into_buffer(struct ntfs_index *indx, struct ntfs_inode *ni,
 	/* Copy all the entries <= sp into the new buffer. */
 	de_t = hdr_first_de(hdr1);
 	to_copy = PtrOffset(de_t, sp);
-	hdr_insert_head(hdr2, de_t, to_copy);
+	if (!hdr_insert_head(hdr2, de_t, to_copy)) {
+		err = -EINVAL;
+		put_indx_node(n2);
+		goto out;
+	}
 
 	/* Remove all entries (sp including) from hdr1. */
 	used = used1 - to_copy - sp_size;
-- 
2.53.0



