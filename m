Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039732;
	b=aL9y7FuQvy8Ai7b2kc0mNrA+w+Irt/WJ/szqq995mN+vjdzRJBWUdIpKoGy0SA71T2mB
	 hmv8WRed45TJZrhKU27G2yojK6fyw2u5fzKqxZAtq8JuwDBik5Z9QORtnzuB/cNZAEEoR
	 Yim60T+pMo0mFeinwvzc227Y2gpVuhCye/MYACrBIpGWBrVInSTuvIMms3ArZURZVTuyO
	 QzDXv4VjB3rbeHYdLYE0kAYrsnnwlvCzqxJYM9qDX2Xdn+69Jg7EynKzJlGoazztS0UzY
	 khLcwzHFD4UKvy2IO5U7UVi3Gw5G9HKWvxfPn32HHqA/nI77G3IgUph9xCT9hGs5NJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gINVyb3e6KVM+7B/9oYh7oJ7CQE4UtFdyHWYeKWTy/8=;
	b=L81C9PCsYC//klVxr7G3U87f/1VZ1Zh7RK9DipAMnl8ujPEcqsdNBC+T8DgR3wUsPngD
	 6cDbrGZq//auJki2lIs8JqaE+Rr9U5G0x7ab90m5nDUdNxs0WOByl7r7Yt+vReNFYnQqq
	 Nd5hURjBmmvtm7nvak46SgA/BrMgOfGw/1BzbxKrcNpvK63RHszHN52F5se+3bwAeYMxe
	 c2ijcoLpn6KBclBTEPVWniNcMIL7usIX+laI0sRYlxb3pt7EekxJL/PehGy62CkIyd9Ch
	 z+yj3BAyKN6QmQ+UExLVRp45tKBGLtPxv5JWECMVKxRXcUfwZLGjHBDRpHgRLjAvl1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqJdzcJ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AB2606A32A;
	Wed, 18 Nov 2026 22:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqJdzcJ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7EF1F000C4;
	Wed, 18 Nov 2026 22:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039731;
	bh=gINVyb3e6KVM+7B/9oYh7oJ7CQE4UtFdyHWYeKWTy/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqJdzcJ2sxb5Ed1uD0sWH+RiP52DoSw71E6ISn1r9v/nZczmGnKKa69wkFi4CMemI
	 g+ivVfGhFT9i6YuHpNDpnBNLqKw5q8QsnoCMM8iZr1SPiY3PRaAN3tgD9i3fPM2jVu
	 wN55CTBDrDap18RL8IUnI8ukND5GqUjPwdkqjBHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2205/3318] ntfs3: Remove calls to set/clear the error flag
Date: Wed, 18 Nov 2026 15:47:07 +0100
Message-ID: <20261118150428.075366960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8e743343c2c94..efe20e6b8d078 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2176,9 +2176,6 @@ int ni_readpage_cmpr(struct ntfs_inode *ni, struct page *page)
 	err = ni_read_frame(ni, frame_vbo, pages, pages_per_frame);
 
 out1:
-	if (err)
-		SetPageError(page);
-
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
 		if (i == idx || !pg)
@@ -2764,7 +2761,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
 		kunmap(pg);
-		ClearPageError(pg);
 		SetPageUptodate(pg);
 	}
 
-- 
2.53.0



