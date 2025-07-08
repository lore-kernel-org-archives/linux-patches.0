Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722971DF74F;
	Tue,  8 Jul 2025 16:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992857; cv=none; b=mXvgSw3dSu4BQqLkoqtFY9fIoCg2OJHgrlcaQCqPwb7ZXOFbJ9PJaHjGt0BdP6uw3CPyXz/39mb1VmJprsvR8Tb5oIx45FZAY9+Ca5SynnBSxJFsquJRJ63Y492r+HAWLLDDulDuWUeRclLPb8JdlyNz3w/VOteTX6c6CwE0SxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992857; c=relaxed/simple;
	bh=dmDO++uOFOYOwQ5jI8Vgs3qQIp8tb0olXgac4tgcrec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzMZYgKNjaloNTSrcFhb3DNFFNu5yuedrefCN6DYEl8HSdMbNDN8nFmO91yr0+PA02Ylmtg25tiOYBc7kpBzu9eCR3YFDJ3XH37m0EMUUkVC69aWkMsMUpCbEkAHcukEsAn84nwasXHj9waQuWI8+PjU5amLjv+suvE0LxVNNRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jREZQY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jREZQY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0358C4CEED;
	Tue,  8 Jul 2025 16:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992857;
	bh=dmDO++uOFOYOwQ5jI8Vgs3qQIp8tb0olXgac4tgcrec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jREZQY8rtXVALCi3BM8n3emLVItcD8np9BhTqC3/QBse2/bMgeZ9GHqO8aKuD5hj
	 ez/Q8k4th+I0LAGz4aT6Ujg8sFCs5eN7oVsS1UpEmMtNH6F13K+qpAcN1ELvwGXuVN
	 ppTHMAh3Xbh/pXty2aumzN9rDHgTWPpObUSxQXBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/232] gfs2: Decode missing glock flags in tracepoints
Date: Tue,  8 Jul 2025 18:21:41 +0200
Message-ID: <20250708162244.190040484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 57882533923ce7842a21b8f5be14de861403dd26 ]

Add a number of glock flags are currently not shown in the text form of
glock tracepoints.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/trace_gfs2.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 8eae8d62a4132..ac8ca485c46fe 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -58,7 +58,12 @@
 	{(1UL << GLF_HAVE_FROZEN_REPLY),	"F" },		\
 	{(1UL << GLF_LRU),			"L" },		\
 	{(1UL << GLF_OBJECT),			"o" },		\
-	{(1UL << GLF_BLOCKING),			"b" })
+	{(1UL << GLF_BLOCKING),			"b" },		\
+	{(1UL << GLF_UNLOCKED),			"x" },		\
+	{(1UL << GLF_INSTANTIATE_NEEDED),	"n" },		\
+	{(1UL << GLF_INSTANTIATE_IN_PROG),	"N" },		\
+	{(1UL << GLF_TRY_TO_EVICT),		"e" },		\
+	{(1UL << GLF_VERIFY_DELETE),		"E" })
 
 #ifndef NUMPTY
 #define NUMPTY
-- 
2.39.5



