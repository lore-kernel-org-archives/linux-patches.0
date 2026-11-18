Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029565;
	b=KHd/eXpbU/+8fdpRJUq/TSgSF7TjvEWfd735D1nx0DiaIJ0jexlSF+B2gGzlxpX/H8QP
	 Pg0fhftKePn8338RS51t3PhntQ1MBhZumRqgtcTzTBiP2Z/Flz8ytIYn152QTjfIFJ21X
	 RhhOyDsictsnXoxLeCaYUz5183CrpyU/9ao1eGZEwXFYnOlGvyXFM/3kBdE2fmPWr+Sms
	 dcRHANf+qnHLo9y1Be7zTd8RaN+sw3/EtlGeRBF/ZbMLiehTWf8lqOHbrbDJTYCplLs3z
	 hdp2ItnA77Tp8ziNvFmHmfc6qGmIAqL4rG9ySLFBz9wTgN1PZ6XpT6Z2wWGvdh6sAJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a+BkyliejM/ZlDnjOkhMBhMnt1X+NE8TFsxf21B3MsE=;
	b=coLpOBwrf+kjesq6Qp/gU0uJv46xSVycwjukVPcVxibIzmyKHxl/2kZ3XC3KnHN0h6L3
	 oHj9JrWwdvl/DztPTIZ0pVfPPMC1LvTAwe4dOkl8sYGzRZB10X+hfXzMLca0gMIS+2YTX
	 y2MecBiWMJ20Lp0rIPYV+BkIZOc3l4g6FqIBNU8iFAEShg9mvC4k/EJO4Z4EWRfTCetNm
	 6SgIkozwDnvwRUbr+CL8RQidk15AM+drJDZkp3Ao2OHLSA5hlL+aN3c/d8T9TrGe2v52G
	 hUBIcDWXjUDGU3fbMercjKNcaA/suJQ89WGnQxZ16GM0/uIenRqegcpVz3+vd/nlCLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRoltOC7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B2D606A31C;
	Wed, 18 Nov 2026 19:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dRoltOC7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9217B1F000C4;
	Wed, 18 Nov 2026 19:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029565;
	bh=a+BkyliejM/ZlDnjOkhMBhMnt1X+NE8TFsxf21B3MsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dRoltOC7zHejfL2OwCxaxCqYblz3DJ2KicO0odQZ4aAzaZokj7CUlPZngOFirIh1/
	 n91T6c5BPVagXLfalh9SQL5d8JEunXNKj/vnOLuDQWpmWmQrFqY5tODCH0i+af4TM5
	 AyyW4+Lsgs7PUjT4MS6dPAkwuwOdHGWPiaM0+RyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0395/1756] fs/ntfs3: zero frame pages on read error
Date: Wed, 18 Nov 2026 15:42:02 +0100
Message-ID: <20261118150024.477884513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit a32e893a077a4b0d3b04c86cb7f69e354a187995 ]

ni_read_frame() marks every frame page uptodate at the 'out:' label
regardless of the return value. The pages come from ntfs_lock_new_page()
and are not zeroed, and several error paths reach 'out:' before anything
is written to them (e.g. a failed decompress_lznt()/decompress_lzx_xpress()
on a corrupted chunk, or an allocation failure).

A page marked uptodate is served directly from the page cache, so a later
read() of the file returns the uninitialized page contents to userspace.
On a crafted compressed image this leaks kernel memory, including pointers.

Zero each page on the error path before marking it uptodate. The success
path is unchanged.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 5b38d31bb13f2..014dcf2e50422 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2760,6 +2760,8 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
+		if (err)
+			clear_highpage(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



