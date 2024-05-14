Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE952762C1;
	Tue, 14 May 2024 11:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686422; cv=none; b=L65yfavh0jE/ueYO43Pc+nkiXR8nj/mPdO4XySpDEavueCY4fp8LlerNJ1wMekoPtf9y5oxCH84iqo6eMBNaG8QlqgrMlNtY09Owv5n9mcyGJ2mRec53xPcqC2IaJlLiOFM3U8AnudOQAqVAbesPhuMgpe+kf3b5RUaaewHKaCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686422; c=relaxed/simple;
	bh=y9twn74ocaN1NZeGhjxCJJr9pwLkQns5HbNEdNVQuYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNjsR4wUORT/W3LosVQY/6kbCGZMJWXyJYT17zoqAKH+x+tqsNQxrJG1w4IjkWSM1zSdZyK2Z5LjZ7PZCMLWhamaG8Hs/a+xTR9Mx6Dcf72Drev59xYfYrd8O0oISrzx3cuyIGSXM+XBXgFOihIxp+wLHtR+rgROesrcDxNKQ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFH9fEP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFH9fEP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714FDC2BD10;
	Tue, 14 May 2024 11:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686421;
	bh=y9twn74ocaN1NZeGhjxCJJr9pwLkQns5HbNEdNVQuYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFH9fEP1tVfCoasKHwarJJwy351/UUBsvj5qE8mS6ELzWwnTbS8Nzi1ghqJOMTkbb
	 Qs/edbnwN0IscVDHzIO2NTmR6gq8gY0DxIAXXB/HucjFRLL+2DLqL9lzD2HiIQD3ET
	 rkiLq7tAgHAQB5xmf0sl6WL7kyyFIo3OfN4EnAlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/236] fs/9p: translate O_TRUNC into OTRUNC
Date: Tue, 14 May 2024 12:18:14 +0200
Message-ID: <20240514101025.379959117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 87de39e70503e04ddb58965520b15eb9efa7eef3 ]

This one hits both 9P2000 and .u as it appears v9fs has never translated
the O_TRUNC flag.

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index a0c5a372dcf62..8f287009545c9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -181,6 +181,9 @@ int v9fs_uflags2omode(int uflags, int extended)
 		break;
 	}
 
+	if (uflags & O_TRUNC)
+		ret |= P9_OTRUNC;
+
 	if (extended) {
 		if (uflags & O_EXCL)
 			ret |= P9_OEXCL;
-- 
2.43.0



