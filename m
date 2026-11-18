Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053544;
	b=F4qxR0vYCC5+0WkhUzvzytpj6qqeMep/wzE4MoLxw5UrY/KSoHV8xe9Bo4NDx1ialZw2
	 rkMIArqmnY+Ni7J01r988+ebKhPK7e2faWRSeS5Yixw2v3jSiVHZKpQqKbUcm1h1zj0Hc
	 bphoNW2DkLhayR5UGPi4IexGGNXB2OQIlZv1W1VmEF8euWsSUjwUFeRh/OU6n9wk7PcJv
	 Cvh/21iKpEdKjECVtmJEAq5Ppa8zkqeWPNn0YFyOGSACZzqOEHVS+0/pn2L2Kjm5GEKu8
	 QvtFCYFiq/GAyrSisS5IRTzzajiMPZLgNBZkj+2F3tGdPJheryZQA5OoWrmCueSAVIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ua8OnEERqJyFjL/QGGd+Q4CQw+al6yREzMcgO+v67d0=;
	b=jex2PgEqLOTGw4hqWpU2LsDwagMNz9V97aB+z8dSxFqvScNLPOYwCYBxWGoXm/MkEtHq
	 5cROsSyDOeamBVckLZZBMdgXPb7q/6Q32kgIa3x5lRwgdeWvlFXxW8eo1YiHJcz/wpcv6
	 d3fOCn/nQCEWZF3TkQa3ikCTAIqNjk3AGP0WlS0aQt6Isu+e0CaK+VNp9W4X5sHQ5OmN0
	 z+rADhyiFAF/lNr7X+oo005zCsSyK7D6pcyDWRVViYJjZwQN/HRabYHfI/krFUm9po9WJ
	 GfJePeaqslP0VrV0SuX1FSmkNkKP/LNwUfR7Cvw3AI+R/SPC2ORciVIQFUhwkEWreBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hwpfle/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8146606A320;
	Thu, 19 Nov 2026 01:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hwpfle/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E4B1F000C4;
	Thu, 19 Nov 2026 01:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053544;
	bh=ua8OnEERqJyFjL/QGGd+Q4CQw+al6yREzMcgO+v67d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hwpfle/NadP1JDEoWm8PIpbTo/3UjjsEEPbWJ4K9lMbJJGesT2jFQsuCqI/UtioFq
	 I7ixpfw4SQeYvRuL3Z3RA2WHCrt0AWHx7Emm2rmtMEHS09YlfCnl7v5duuY22JX5qs
	 GpD8RUa5IuvvMLnsv5W2nqQPhg5K1KW0vIwZc/2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0957/2214] udf: Avoid invalid LVID used on mount
Date: Wed, 18 Nov 2026 15:43:53 +0100
Message-ID: <20261118150050.592205518@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit c8f1140cb82dc843e72697dc6f8c7ee1acce5d28 ]

udf_load_logicalvolint() loads logical volume integrity descriptors.
Since there can be multiple blocks with LVIDs, we verify the contents of
only the last (prevailing) LVID found. However if we fail to load the
last LVID (either due to IO error or because it's checksum fails to
match), we never perform the verification of validity of the LVID we are
going to use. If such LVID contains invalid data, we can hit
out-of-bounds access or similar issues. Fix the problem by verifying
each LVID we are potentially going to accept.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: a61fb39759d7 ("udf: Make sure there's enough space for LVID implementation use field")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index afdc0f50a5f00..f9fe3f950de85 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1575,6 +1575,20 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	return ret;
 }
 
+static bool udf_lvid_valid(struct super_block *sb,
+			   struct logicalVolIntegrityDesc *lvid)
+{
+	u32 parts, impuselen;
+
+	parts = le32_to_cpu(lvid->numOfPartitions);
+	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
+	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
+	    2 * parts * sizeof(u32) > sb->s_blocksize)
+		return false;
+	return true;
+}
+
 /*
  * Find the prevailing Logical Volume Integrity Descriptor.
  */
@@ -1585,7 +1599,6 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct logicalVolIntegrityDesc *lvid;
 	int indirections = 0;
-	u32 parts, impuselen;
 
 	while (++indirections <= UDF_MAX_LVID_NESTING) {
 		final_bh = NULL;
@@ -1607,32 +1620,27 @@ static void udf_load_logicalvolint(struct super_block *sb, struct kernel_extent_
 		if (!final_bh)
 			return;
 
-		brelse(sbi->s_lvid_bh);
-		sbi->s_lvid_bh = final_bh;
-
 		lvid = (struct logicalVolIntegrityDesc *)final_bh->b_data;
+		if (udf_lvid_valid(sb, lvid)) {
+			brelse(sbi->s_lvid_bh);
+			sbi->s_lvid_bh = final_bh;
+		} else {
+			udf_warn(sb, "Corrupted LVID (parts=%u, impuselen=%u), "
+				 "ignoring.\n",
+				 le32_to_cpu(lvid->numOfPartitions),
+				 le32_to_cpu(lvid->lengthOfImpUse));
+		}
+
 		if (lvid->nextIntegrityExt.extLength == 0)
-			goto check;
+			return;
 
 		loc = leea_to_cpu(lvid->nextIntegrityExt);
 	}
 
 	udf_warn(sb, "Too many LVID indirections (max %u), ignoring.\n",
 		UDF_MAX_LVID_NESTING);
-out_err:
 	brelse(sbi->s_lvid_bh);
 	sbi->s_lvid_bh = NULL;
-	return;
-check:
-	parts = le32_to_cpu(lvid->numOfPartitions);
-	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
-	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
-	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
-	    2 * parts * sizeof(u32) > sb->s_blocksize) {
-		udf_warn(sb, "Corrupted LVID (parts=%u, impuselen=%u), "
-			 "ignoring.\n", parts, impuselen);
-		goto out_err;
-	}
 }
 
 /*
-- 
2.53.0



