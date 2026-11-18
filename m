Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058945;
	b=wJ7uETLC3erkLb+z4tsmdZ+svPMHPnQXG7nkC3crl67sCg1IWJgpwhlzcWJHARcoLoRS
	 AV4xrtYLvp0fbR3r6lN0mEpTqEVaGhORPxRh1D4Oo4592SF0MswbMhS/Y2GAJ2PrfuGN2
	 t1I5Ho9bg+aRFH5Pl7sroNYePki/7hozPm5Y99o9P+aQM2dIFmGmr6CP8ASJ6/obgU+Vh
	 eQfvSq21tgJmP+iqbC8vXMlYuyCdD0btDiAqOYmsM6lX5DhmeGmpjgjW7z1LFbjPc58Nw
	 vntMTMfMFR8llxcF8NWX/s574uoU9QhWm0INh54Jm4CPE8Zegk5u2zRFkYXFDrZmchQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=73WCUWkiQIhprnQs6vCDWKEM/jIX6jlIVYS84hI9nso=;
	b=RUItDrYLippTIs7nJkJdzZjHja7seBfWCvLqcjzrFgjVpiB1UayJ4+DP0Ha6uqodoxTL
	 N8UHRorDX+ptO/x3UKDK6qOM/kTQZ9+AkkNt/eEm2hwJdzQekfDqfj1GAwxhL/gR8YfSa
	 wVOmpO5yuzP630wo3tMLxyo4u58SGmLt5cpflt5lgoY28zISUSW9IcDeAlUAXeRj4sX0Q
	 QcD2J3ZOGjy9+59CmjhV5M3dOXOkbN0sSckVlc67vMZJS/9CgW8c4rwt91+43wOHpVU/O
	 u7CxQrAEd4KaLXaICUYH+pk02lsNAkfbxG9jpA15FWYA7AYaEOx7MLoLY0Mka6XZSIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEkd0kb6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5447606A325;
	Thu, 19 Nov 2026 03:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEkd0kb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9BB1F000C4;
	Thu, 19 Nov 2026 03:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058945;
	bh=73WCUWkiQIhprnQs6vCDWKEM/jIX6jlIVYS84hI9nso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEkd0kb6VvBYb2Unx8OKvZF0U18omK8UYrsf9dbJ8oSOVNmFIfdMJbfOT3DJNA/QS
	 kHT7eeNOq0lvIm6Gs3f5eYxezRuK/KUx8t/ug7mLo6xCFQ68gdEHZsglj7BIl/mWCF
	 6YyM8MiyBFRAvtShNBD/SQtxC0DRRUV1M053LWJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0625/1848] xfs: check for buffer overruns when examining local/remote xattr entries
Date: Wed, 18 Nov 2026 15:44:23 +0100
Message-ID: <20261118145941.613722170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 91c41f9524906a8ebd2ae68c98a07b4bd5255ddb ]

LOLLM noticed that the xattr scrub and repair code can walk off the end
of the buffer if the xattr entry record starts so close to the end of
the buffer that there's not even space for the entry structure itself.
Strengthen the bounds checking here.

Cc: stable@vger.kernel.org # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: adapted checks to the combined void xchk_xattr_entry() function, omitting the upstream repair changes ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 558f44ccb13fe..3947fb3deb140 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -276,6 +276,12 @@ xchk_xattr_entry(
 	/* Check the name information. */
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+		name_end = (char *)lentry + offsetof(typeof(*lentry), nameval[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
+
 		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
@@ -283,6 +289,12 @@ xchk_xattr_entry(
 			xchk_da_set_corrupt(ds, level);
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+		name_end = (char *)rentry + offsetof(typeof(*rentry), name[0]);
+		if (name_end > buf_end) {
+			xchk_da_set_corrupt(ds, level);
+			return;
+		}
+
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)
-- 
2.53.0



