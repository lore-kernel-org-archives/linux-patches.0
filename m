Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BBB6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C49C43395;
	Sun, 17 Sep 2023 20:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980892;
	bh=PlaRBJoHxK04U5o4Val+ENM/Hp93mTlXYIg6VswTs8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=no2IY+y1+UGvmDDUDnlo4IIBJ/RkMyD+R5jr4Q0sVbYlNcfWEucIgLAEJFoB2hWQp
	 CcPLfzTojv/AKA/YWKSKnHrfQj47P1aZZTdrVlqxbGjTNtdW75XV9Y1gpZ3LMKV42q
	 lNBBrJdDrGf/y1QS/jUZtxy3DSHTJdLa23pgHMNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 038/219] cifs: update desired access while requesting for directory lease
Date: Sun, 17 Sep 2023 21:12:45 +0200
Message-ID: <20230917191042.371130357@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Bharath SM <bharathsm@microsoft.com>

commit b6d44d42313baa45a81ce9b299aeee2ccf3d0ee1 upstream.

We read and cache directory contents when we get directory
lease, so we should ask for read permission to read contents
of directory.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -218,7 +218,7 @@ int open_cached_dir(unsigned int xid, st
 		.tcon = tcon,
 		.path = path,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
-		.desired_access = FILE_READ_ATTRIBUTES,
+		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.fid = pfid,
 	};


