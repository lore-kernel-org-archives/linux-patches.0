Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774801419B4;
	Tue, 27 Feb 2024 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041807; cv=none; b=aLbLMPHA0dws1GNUpBTjVKuSHNrbhOJBOlkU7zr6mSYu5if3DlY7SRE2JISj6qmZSo697Boq/28YSmxgzSPvs5fVT7/Ar+3zgtZaZoLFSietciQ/GNK9aRtNUNa+r5pWj+dU0xFkRFwWpgObGWRcC7YgsQo2HfUZ5UUDOMQo6ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041807; c=relaxed/simple;
	bh=hMkpYx+xLaCGvM4agDqjCyK9AoRUWRb3nG+HzJBkb2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdFrBjPpy5kZ+Ujx62Q5okvrnWoLNTnk5HR6QeC9Xd+B7BFUx8Mym1dCV+L6vmCX81i0LSfVHwpX9mK+QRadY8go5S3Hr8OPRoO7UNQp5GiXgjU3xtpncOkT9nefBUov8p+v8M3eUnU+caQF5XNWB7OpgJES6fAF8hfWUAnoMqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T97gX/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T97gX/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075B6C433F1;
	Tue, 27 Feb 2024 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041807;
	bh=hMkpYx+xLaCGvM4agDqjCyK9AoRUWRb3nG+HzJBkb2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T97gX/AmLiXZ7hQnsiK7TARzimwjh08BnEbmG07F2sJFpagr2XwRrjEIB4FyXpJl
	 /t82+hFOxLjiP4wreGnJ/Io0RmefB56N+8mvTdxBc/VmDjyeinTaWE2MKgc/rESrOH
	 LEj8wL5VFuuzEbHqla+sJMfoCQos2ibCLJfR8mO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/299] fs/ntfs3: Fix detected field-spanning write (size 8) of single field "le->name"
Date: Tue, 27 Feb 2024 14:23:08 +0100
Message-ID: <20240227131628.411665827@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit d155617006ebc172a80d3eb013c4b867f9a8ada4 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 86aecbb01a92f..13e96fc63dae5 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -523,7 +523,7 @@ struct ATTR_LIST_ENTRY {
 	__le64 vcn;		// 0x08: Starting VCN of this attribute.
 	struct MFT_REF ref;	// 0x10: MFT record number with attribute.
 	__le16 id;		// 0x18: struct ATTRIB ID.
-	__le16 name[3];		// 0x1A: Just to align. To get real name can use bNameOffset.
+	__le16 name[];		// 0x1A: Just to align. To get real name can use name_off.
 
 }; // sizeof(0x20)
 
-- 
2.43.0



