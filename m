Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF887248886;
	Wed, 25 Feb 2026 01:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983712; cv=none; b=UQOSmvVAK63QCnrRbhPEmMVjyLL0UccW4hZ6Ww6VncA1nnNHOHBg1BANS27+iWENb8GNEXbe7o/GEkbfL/W9vcn9skmOC++GZ3BFnMypxDGZ6XgYk3742yQPyrFQDJukEcdQ9PzAwcVbbgSPHmYByPnwvPdHpcu/i6YauE+k6p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983712; c=relaxed/simple;
	bh=e0fhrkZWtvEdea8e3S2freFTjFSIKKhLXW2HnzFPJmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is/rR6UDHySDPoJjbpomK3uHM+fm0iYohXktrHT96ihm7e+I2E1XXXDqKMe0v/vE/0NdxuIImJWNTokC22Q6+3cNe1HP+mmMoFQ4eCbQi19mD/W/N89JblWiNJL4tW3I550huNfcDbMK8UwIajhH+ItS21xossZBBbpCDajvJe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCbJWCUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCbJWCUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9F5C116D0;
	Wed, 25 Feb 2026 01:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983712;
	bh=e0fhrkZWtvEdea8e3S2freFTjFSIKKhLXW2HnzFPJmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCbJWCUROeaMRGwAnKOKCwGH5v183Na6q2AXy5KZreXBkbRJUq5/pcuk7ZW9mgRLu
	 flqlcGPUU1hso0jPeGikVenHxfs7L3ho77jK6xoXwiySpvQc08C29Bx3fA+yn2tjzt
	 hI3dGyyqn8eFgAHQ/8kq4FR5cw7ztwjcUbZ6TYm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/641] fs: add <linux/init_task.h> for init_fs
Date: Tue, 24 Feb 2026 17:15:37 -0800
Message-ID: <20260225012349.216549582@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 589cff4975afe1a4eaaa1d961652f50b1628d78d ]

The init_fs symbol is defined in <linux/init_task.h> but was
not included in fs/fs_struct.c so fix by adding the include.

Fixes the following sparse warning:
fs/fs_struct.c:150:18: warning: symbol 'init_fs' was not declared. Should it be static?

Fixes: 3e93cd671813e ("Take fs_struct handling to new file")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260108115856.238027-1-ben.dooks@codethink.co.uk
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_struct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index 28be762ac1c63..a0b40ad5e7423 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -6,6 +6,7 @@
 #include <linux/path.h>
 #include <linux/slab.h>
 #include <linux/fs_struct.h>
+#include <linux/init_task.h>
 #include "internal.h"
 
 /*
-- 
2.51.0



