Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8701B46C4BC;
	Tue, 21 Jul 2026 19:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663759; cv=none; b=EMEnD8L6ZX6gSTXF2WTBTUFUv0AJGifEGl7cx6KjxJLG92FbANvSTpBANtA8Sze7SpkGjvFno4F0LdfiQqhyod/PqwMIWYUfSQUR8watqj4VKOgtXol2qOAUaox+cSh45lN1KQ50ykIjHAza6+Te0n8opeAD6Xr/CZ1BH1Y9EsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663759; c=relaxed/simple;
	bh=ZagSIavY30RxMvSqJb3XCq5/xS11yhxeCBYPJ/IKHFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOHkPKwxu9JLpCPuBtj3dMjQ2GThpGXPZGdodKMtGmVycrseUID9oRyl4MThYvZcgjHLGUzggBZs4OzKafRKXdF6Vc6ymtw/1PQVqhJngUiVb4qBIAVZQOlsRO9kIrRdzJca3ghb6hzvb1EFeoUQWSSrLdXFjSzMy8nSRk8DcI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr3JH7IH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr3JH7IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5A81F000E9;
	Tue, 21 Jul 2026 19:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663758;
	bh=RM83wc+EcGqvxXIplROb0Dbff8mrbLWRpdo/QxRkxVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wr3JH7IH4H/91v8NooA4WNgF0ckDtztsQOJ8lvccaYNsUuL4I4QDP5icmfTG6MamL
	 l4VONGpToxPR48gyUIA+6vGgDfc1F5rCRzCY/cLQQgTMIokQkr0YyPtaRXb8zjzkR6
	 P7H50G+pI/QKgV5HjWJQdjO4fK+i6p4rmaEmEhVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 0944/1276] mtd: rawnand: fix condition in nand_select_target()
Date: Tue, 21 Jul 2026 17:23:07 +0200
Message-ID: <20260721152507.158963122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@rulkc.org>

commit 8507c2cc9e4fa402401819f44d1e8a5ef4d11d8b upstream.

'cs' here must be in range [0:nanddev_ntargets[.

Cc: stable@vger.kernel.org
Fixes: 32813e288414 ("mtd: rawnand: Get rid of chip->numchips")
Signed-off-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -174,7 +174,7 @@ void nand_select_target(struct nand_chip
 	 * cs should always lie between 0 and nanddev_ntargets(), when that's
 	 * not the case it's a bug and the caller should be fixed.
 	 */
-	if (WARN_ON(cs > nanddev_ntargets(&chip->base)))
+	if (WARN_ON(cs >= nanddev_ntargets(&chip->base)))
 		return;
 
 	chip->cur_cs = cs;


