Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4BB2374E;
	Tue, 14 May 2024 11:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687345; cv=none; b=eHiJgaUYDeMGu+N6GX0ljUvWjPeg79IH8xlDVbcQ5K6prEUMsc108d5o/brTcLSw8lXXOumGxv7P4wMYxeXhts3j3L9UskGNoASIYsM+yPxDfCph1l5F8nXSL77CJeYJFkgZ2OBBwhBYcwA/dy8nzq7zC4B3czx6ZQMxFDQL9Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687345; c=relaxed/simple;
	bh=+pUaLWml6QQ8jEih6dnfNg7S9lqyboeBr1cxCZC9FkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRpw/2Mrb/Xy0N6caWLd4L1V8lbeHccMbK22iKl6/B+UJlz2ovLqtl46Siwp8I692ST8vpDudgPXzvvtGdoZKlmRtG5Hebaz3odxSo0aXQDH9GFr/Y9/u7nezcrfEepfsJgHF/EDLE63ifLtRO3rOVNH2TM/5mrhwDXCuhqNk5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8axyGmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8axyGmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CE5C2BD10;
	Tue, 14 May 2024 11:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687345;
	bh=+pUaLWml6QQ8jEih6dnfNg7S9lqyboeBr1cxCZC9FkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8axyGmcUu7kMi9tOyXjNoxv4xKhiZAslsFSWQAndiVWqr7zFV9tqX5WhY95rzjDd
	 6Axz0BXB24bPWw1z1PNgfBkaGQZco1WwNHKYLHqY9jlWjO1PbOSQwy/9iRh6JVTMRx
	 9SYBRoCFhJgB6nUIDgF/8ZXCgHzMvmRmxRebNHCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/111] fs/9p: translate O_TRUNC into OTRUNC
Date: Tue, 14 May 2024 12:20:03 +0200
Message-ID: <20240514100959.605765520@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 88ca5015f987e..4ffb0750c79b9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -177,6 +177,9 @@ int v9fs_uflags2omode(int uflags, int extended)
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



