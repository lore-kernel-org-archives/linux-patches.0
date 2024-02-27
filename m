Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0061616423;
	Tue, 27 Feb 2024 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042611; cv=none; b=N+xMvYyxDEWZXFzCxZFA0UAEoeycz7aOXLrbCKlmzvUr3lZ9jZzKfCCmFou7RurJVksSf9ybQWWmnd8ckLofYU59PCAZEY8Wrccddgmnre+QtqL8boB7LwSz/ZLOgy9j7t88Yjr66sFr3HilFsk1STTT8A3yWDRnMWAhRgg6qI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042611; c=relaxed/simple;
	bh=3bXI/B5L6JsblrB3TItLm8Rq7FzUgLAkIZkwh5hyWMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQvVJdoiZMES550gQdGYSe8A9jhj/QuaN3CsXlhk31E4TDGGLN5tvPpLwOykd0oeO9j5hrxxCDXu+RfrHzPUBXs43387SrylECVc4/jlLSfMm8uwX6ocE6nm2cS2kjzBL5OvZ4B9u9CFMTTkAqAoLM9rAZLEvfRxnH1lLtD1Hf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb6KV6/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb6KV6/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FD6C43390;
	Tue, 27 Feb 2024 14:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042610;
	bh=3bXI/B5L6JsblrB3TItLm8Rq7FzUgLAkIZkwh5hyWMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vb6KV6/ul+4xppunKRBqO2iG38YUUj2RDzx+pnQUmpiR88MTkS+3l2L7YPHMjcn8I
	 K9lHUGEgjwi4gfuoQMbr2zYW6kZgPzlhCo/FzS12S3lCx4kXHeClvy4x4+UpUTH7Ek
	 DhLEhroM/rbzTQ/LqOEoWKsCz9aDgVnBwu2P5hqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/245] fs/ntfs3: Fix detected field-spanning write (size 8) of single field "le->name"
Date: Tue, 27 Feb 2024 14:24:04 +0100
Message-ID: <20240227131616.944497143@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



