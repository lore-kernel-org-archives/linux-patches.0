Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D513B29C;
	Tue, 27 Feb 2024 14:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043302; cv=none; b=az5nLM2uUWpO5wqcaoS8aLR54X/7zyaTAT/kwyOJcTQ894yD7mQlpPxmzMBJndAUn+ZCNhV+d001HNaOlUGCqWWZR3/Zfb6JkDJz7ijnEI2S35Wgf0qJWUzolGKx8hmvWKJMKIYFMUTO6T9xJO5gnHTl4A68KeODltWqTWof2QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043302; c=relaxed/simple;
	bh=4RF/qpEtES2YChpc2CDdQiAUMRQVluEH4NzQfL7T0lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgzfKjcm8IgWtGexQP8WRwJtO9otYqd8Rf2U2bHS87Orh5Yi0kDU2mKuAs8rVIZVxKWvXoKGnE21a4K/AtQwWYCGOOAMd1gf8LNxFbq5PaTfW/uUDToOrQFZUTxrJFSAz+iKu14Ula2aIS+nqxWf487FWWkDTVKbPJhgVzC2H7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPLphNbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPLphNbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65523C433C7;
	Tue, 27 Feb 2024 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043301;
	bh=4RF/qpEtES2YChpc2CDdQiAUMRQVluEH4NzQfL7T0lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPLphNbAPcqlNXqxBOpkDt8tATJAiWN/r7mThq3qCtf//WQ8EXciYR94oPsdslemM
	 m17o2ofp49getP3UE49+BNOQ0wiffCXnRaDVi6nt7355H+ueXm8zkWHRgQINYc2G7L
	 upI5CgRqZHYYrBd6VVah9IEB1/kMsexB4qi5SR0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/195] fs/ntfs3: Fix detected field-spanning write (size 8) of single field "le->name"
Date: Tue, 27 Feb 2024 14:25:19 +0100
Message-ID: <20240227131612.422985249@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d155617006ebc172a80d3eb013c4b867f9a8ada4 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 0f38d558169a1..8b580515b1d6e 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -517,7 +517,7 @@ struct ATTR_LIST_ENTRY {
 	__le64 vcn;		// 0x08: Starting VCN of this attribute.
 	struct MFT_REF ref;	// 0x10: MFT record number with attribute.
 	__le16 id;		// 0x18: struct ATTRIB ID.
-	__le16 name[3];		// 0x1A: Just to align. To get real name can use bNameOffset.
+	__le16 name[];		// 0x1A: Just to align. To get real name can use name_off.
 
 }; // sizeof(0x20)
 
-- 
2.43.0



