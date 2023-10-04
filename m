Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226301D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DAEC433C9;
	Wed,  4 Oct 2023 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442560;
	bh=jvpqTKkDJWZoUOg57E9aOuEOdTR2Q6zIj0xGXQU19wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4ortsd5M4NRwjhDQBWNjin1OH7AE8acsJ3NfUDsVz+kI2fwnvunI0NeIq6bxEtyL
	 Rp5QIX/sDZrEmgVpejBM0hcgcCQbUHfnIxR2K5BKOXCvZgbAbShnoBle0HrYwbeB/h
	 NisPfQZPOj2mWYXpELE5yk5HcuwuSXQxTfoh2ATc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/183] NFS/pNFS: Report EINVAL errors from connect() to the server
Date: Wed,  4 Oct 2023 19:53:54 +0200
Message-ID: <20231004175204.123220988@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit dd7d7ee3ba2a70d12d02defb478790cf57d5b87b ]

With IPv6, connect() can occasionally return EINVAL if a route is
unavailable. If this happens during I/O to a data server, we want to
report it using LAYOUTERROR as an inability to connect.

Fixes: dd52128afdde ("NFSv4.1/pnfs Ensure flexfiles reports all connection related errors")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index ceef75b4d2494..4269df0f0ffa5 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1238,6 +1238,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -EPFNOSUPPORT:
 		case -EPROTONOSUPPORT:
 		case -EOPNOTSUPP:
+		case -EINVAL:
 		case -ECONNREFUSED:
 		case -ECONNRESET:
 		case -EHOSTDOWN:
-- 
2.40.1



