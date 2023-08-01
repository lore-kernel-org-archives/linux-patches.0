Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654E61F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F20C433C8;
	Tue,  1 Aug 2023 09:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881779;
	bh=MMaxMew6TxnEmlQh21Et921H/nCAgy1CIQL4Wwiu+mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lG6u5ydDsc5iXdIV8f7/tSx4dKOEjmq4pD3HJg7KM2sbXKLHbb8pj73Fb86rQejfN
	 YI7iS4PEslU9iWwSHZwUQiPVymuX8ydRQa2m3VM1UoenXnbhFUtrc2IQFBEvbPAQ02
	 oubGowNd2zk8uoQms3LXlZ9Ozwoa6StTaGX8srus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/155] cifs: missing directory in MAINTAINERS file
Date: Tue,  1 Aug 2023 11:18:59 +0200
Message-ID: <20230801091911.176249037@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 5dd8ce24667a70bb9f7808f5eec0354bd37290c6 ]

The include/uapi/linux/cifs directory (not just fs/cifs and
fs/smbfs_common) should be included in cifs entry in the
MAINTAINERS file.

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: df9d70c18616 ("cifs: if deferred close is disabled then close files immediately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2bf1ad0fb2a6f..e6b53e76651be 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4666,6 +4666,7 @@ T:	git git://git.samba.org/sfrench/cifs-2.6.git
 F:	Documentation/admin-guide/cifs/
 F:	fs/cifs/
 F:	fs/smbfs_common/
+F:	include/uapi/linux/cifs
 
 COMPACTPCI HOTPLUG CORE
 M:	Scott Murray <scott@spiteful.org>
-- 
2.39.2



