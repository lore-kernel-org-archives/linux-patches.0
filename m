Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095328BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B5BC433EF;
	Tue, 28 Mar 2023 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015811;
	bh=fU+/5WrZwYJwMCKb6EdYeKNx4M1eiPsjd7FUh0LOzqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnWhyYBNmlWsEIAUviMRDed5HgC4dHLEERsYbiOkIMBtQGU7lI/Z/7zkYmPwN4Qsj
	 sirAH2aZMZsXYkWV+zT60JsCPg1Gj1m3SSfT+Fm6ZzYrPiTFKHAhjHkAQErcUqahzX
	 QQWDY6kG398DmMVrvCmnLyQYBkFivi3DEl9YV8GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 153/224] cifs: empty interface list when server doesnt support query interfaces
Date: Tue, 28 Mar 2023 16:42:29 +0200
Message-Id: <20230328142623.754940691@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

commit 896cd316b841053f6df95ab77b5f1322c16a8e18 upstream.

When querying server interfaces returns -EOPNOTSUPP,
clear the list of interfaces. Assumption is that multichannel
would be disabled too.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -717,7 +717,7 @@ SMB3_request_interfaces(const unsigned i
 	if (rc == -EOPNOTSUPP) {
 		cifs_dbg(FYI,
 			 "server does not support query network interfaces\n");
-		goto out;
+		ret_data_len = 0;
 	} else if (rc != 0) {
 		cifs_tcon_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
 		goto out;


