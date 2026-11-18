Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055062;
	b=uMIabjEBQzKUvZ+TBJ+03qgKeh3PI8Sdhep67buNfVLmF2F3zIYJ5r+YU50PZykc9Eaf
	 wOdJJNLDFnWHiYmu/aJ11LV3EYReYw9eeiyJ0EU14Za+bE1k0A/D4p28t6ZvR88jLIrrA
	 PwX9oB5NHz3LgyUZzh57CgWMiyVSYAZty0Uu6ZTnn5ClqHjvRgKVSF2kcxZSEZVYW5pkA
	 nSQgPFYfgzPMw8HidPqDNOUwkQbC++CrB/Lqf9Q+EsyTYXtsOVhjIrawCb8WlnF3Axg0l
	 P805U2CKw4F+ImMGnTYBCiPZvR96LdI40fi+/ogggHze8qCrUArlkFHlwQBcbyPWuHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e9V+xFb6/g7jobv0tr4HHfKpsPqZ1bWveVleLROLdNU=;
	b=P3RPKTxH4bvwn4hYv139cHLp4oJUUDbOBUu1N7golFXz/foHJUG8AWPdFx8/Nzdb8Pih
	 Soo6YF1v4T/K+i3t3OLCvfXhH4+dlsa3zhC3ejOG03OGjoyaNxLXTrflOV0T/a8ip2vl/
	 FX1OXcYFzcyjNadtEr6sbFjztqn9kB5MFqfTNFcM9CN3ugwFzHZG5bF7TIRtXOQWje2fS
	 h0oQv2kRLDlO7E1u65y5fqTg2++v7fL8+Nr4cEgXb4Bc07RW0PlrtiNFqQ2vq6VLuVzMB
	 uZM7F6X1kny9GcJ4YOUDJ772hWQkFSxkTFiUWYgmwBLuL6ktNwPzvu8Cl0s/qGiolWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZGq+iA8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D68606A320;
	Thu, 19 Nov 2026 02:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZGq+iA8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD951F000C4;
	Thu, 19 Nov 2026 02:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055062;
	bh=e9V+xFb6/g7jobv0tr4HHfKpsPqZ1bWveVleLROLdNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZGq+iA852KYXlstVLaq2LW346gervB09crW27xEkxAAfxwWi3xchKzD4MU1vxBRp
	 cudSOqpOs6T5+ajUUfGWkZHVRMXXeLf79Cc9hCrVtWwPbACK+JaVFxmRoIO/WrxC28
	 tpj4aRr30cOGJx7Kd89FV9P4h+o1udKG3LicYBPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1496/2214] ntfs3: Remove calls to set/clear the error flag
Date: Wed, 18 Nov 2026 15:52:52 +0100
Message-ID: <20261118150111.446833679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 326a6fd9600c52016c3c18c1aeafca2fab254146 ]

Nobody checks the error flag on ntfs3 folios, so stop setting and
clearing it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: a32e893a077a ("fs/ntfs3: zero frame pages on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 2957ba4ee0387..b3dbe21f48409 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2122,9 +2122,6 @@ int ni_readpage_cmpr(struct ntfs_inode *ni, struct page *page)
 	err = ni_read_frame(ni, frame_vbo, pages, pages_per_frame);
 
 out1:
-	if (err)
-		SetPageError(page);
-
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
 		if (i == idx || !pg)
@@ -2708,7 +2705,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
 		kunmap(pg);
-		ClearPageError(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



