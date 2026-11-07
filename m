Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065060;
	b=VQYVQ09gBFEACfN6yjHHRjzTHBhbcaDoQzJPCuNOgOFFy+VvgHhIeCz3Gp4J6E0bFnnp
	 nduAPPFhEvAnOZZV+niWSGA0TzbMkRPDSzgUhKl40hSp+Dqgu+ga791JlCHeqZb3wfK0V
	 IholrrKlrhr5PUQDuJCFR++QYsGxVyD5hwkem/K2ZLFh+e8XLUMS07dbRhbilBtvDFdGG
	 CJ/eUF0gZtgXjILWldH4vafmTkzGYjiORRNrOqRF3Jxm3uUqqqLJ2qFa1SRj30wqjG7M6
	 XHqLBL6Jd0J6kbBo5Yk6eYJ/6TrKupbO2TH0uQ7p18uLXu6ftkIWAq7vdgpRvWn4Vgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7H1FNBOBdWGyKy1KPe/oGPy25jJz67mhRDKc5/0Gez4=;
	b=2kt+xaKb39CxmuGBjbCADCgcIQknrC1BtOz8V6xC0DYB7DUHBtMoRFiDV4kxPq8VdfGm
	 wCzWf/2owKTIJlbGGNnRJxvCD8VnFoTO0XZBqAWeuOBXyfiizV62nRbdpNCuGBwhRayW5
	 COH40fGbOVQC0U5ZraZdsYNYYD3saq3ZwfohsQ6hDBW0ZTylLIrZh9cjbezDaoBJY9UkR
	 YHJwRvsJ9a4eQ8B4mQ1qkPBlJYJTh1x4jRWWa5b3WfIqbPzrEfpkY03A0599RbQPRinld
	 A4f5lc01FtBjFj5GMu9KhhvYXlUEsrTVhDq6RXbX8Km8TrbyfNLaftQmgRapKnlFvYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJ+OTgZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD83606A32F;
	Sat,  7 Nov 2026 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dJ+OTgZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09341F0089F;
	Sat,  7 Nov 2026 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065060;
	bh=7H1FNBOBdWGyKy1KPe/oGPy25jJz67mhRDKc5/0Gez4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJ+OTgZBoWvAkbP6duwa37NZ7CDk5fHkVnLMRrIiPM86iiFN5h1ZRjvXaC2go1d99
	 LR5UftkehKIRB1l87OIa7r5QwxWYzgF6RSewvfaAcaOfOD/gjp/rO8h6p+MB75zS7a
	 QDHfNl4vgFCYzvuwMRnXO8b35HtPn6bqgwjM1oNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0905/1257] ntfs: read MFT writeback bounds under size_lock
Date: Sat,  7 Nov 2026 08:53:21 -0500
Message-ID: <20261107135004.332788397@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 50ed298b6a4be68cac85801d21a5e25555f64668 ]

Read the MFT inode size and allocated size under the size_lock critical
section before deriving the folio writeback limits. This prevents
writeback from combining an old allocation boundary with a concurrently
updated file size while the MFT is extended.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 4b74494953757..c9ea11198aa64 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2901,9 +2901,17 @@ static int ntfs_write_mft_block(struct folio *folio, struct writeback_control *w
 	struct ntfs_inode *tni;
 	s64 lcn;
 	s64 vcn = ntfs_pidx_to_cluster(vol, folio->index);
-	s64 end_vcn = ntfs_bytes_to_cluster(vol, ni->allocated_size);
+	s64 end_vcn;
 	unsigned int folio_sz;
-	loff_t i_size = i_size_read(vi);
+	loff_t i_size;
+	s64 allocated_size;
+	unsigned long flags;
+
+	read_lock_irqsave(&ni->size_lock, flags);
+	i_size = i_size_read(vi);
+	allocated_size = ni->allocated_size;
+	read_unlock_irqrestore(&ni->size_lock, flags);
+	end_vcn = ntfs_bytes_to_cluster(vol, allocated_size);
 
 	ntfs_debug("Entering for inode 0x%llx, attribute type 0x%x, folio index 0x%lx.",
 			ni->mft_no, ni->type, folio->index);
-- 
2.53.0



