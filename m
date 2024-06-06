Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9ED1C53B1;
	Thu,  6 Jun 2024 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683680; cv=none; b=GrQDP4fNlq9dP6/llqVur/uZMdcogBntY3SV2a8et0jWTe8Tsj4f/St/dZpSlaeOHVb8RSgAQj0fdqHS/0x3/jYjKECebD3z0G0DmHpyudU0YOkrDLVOPSBfZWfQ11MHywCv99zn6j5vHAhr81w3iSE4ER8x8Mbtt2M9H4G7p1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683680; c=relaxed/simple;
	bh=QR6pzWgVXzndOv4aNkF3gS7HnBZFaWxcuFP3uT5cY94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6CdBrv/bvIiBMJfmuxG/90UUOQfagvlq09n6+3/uqajwdjJs7/6nFH4zE/BFr3ODaw51AHTlK4krpVNQoAJG3PyQ0FqVs21Gaje4JvemxVHIVXlGCLSR6Llj2NbK5wmiWc4e4JntRcYAERv/JBOaNicsx0cqF7JhsV5RlR/gBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBfQeY2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBfQeY2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D416C2BD10;
	Thu,  6 Jun 2024 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683680;
	bh=QR6pzWgVXzndOv4aNkF3gS7HnBZFaWxcuFP3uT5cY94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBfQeY2sNi4DowJfXp+cCyV83/SXIk167jochvII1syhlibCASPHPEDolA7XyErok
	 st0nHjX8J9WY8zaWrAysMwPMe7lkiO/PPIe4ov3Cwrw16dLrbLHaJKCLrnYGYFjEfj
	 iriJc6OzKB9yVOjYrVlhP2D5jmzvHPY5kTFUZHeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 581/744] fs/ntfs3: Use variable length array instead of fixed size
Date: Thu,  6 Jun 2024 16:04:13 +0200
Message-ID: <20240606131751.095282046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit 1997cdc3e727526aa5d84b32f7cbb3f56459b7ef ]

Should fix smatch warning:
	ntfs_set_label() error: __builtin_memcpy() 'uni->name' too small (20 vs 256)

Fixes: 4534a70b7056f ("fs/ntfs3: Add headers and misc files")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202401091421.3RJ24Mn3-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index f61f5b3adb03a..b70288cc5f6fa 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -59,7 +59,7 @@ struct GUID {
 struct cpu_str {
 	u8 len;
 	u8 unused;
-	u16 name[10];
+	u16 name[];
 };
 
 struct le_str {
-- 
2.43.0



