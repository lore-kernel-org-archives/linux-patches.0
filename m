Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AABA134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1933CC433C0;
	Mon, 26 Jun 2023 18:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803806;
	bh=UUu1StOTrnywNSnI1ET77NI5c2yanT+lQF7XZliwvy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUnl7Jor5XNSu9UxFK4YDXdZPA0MDWdudLMUZKvWxI2887BNF1eQ0L0EH0SbN6cEe
	 xdH1JIFu110cM/62rLcw2YUwYn+nh6zKb56F5omRjqB77DAI/Ram3NkyHnpg8lKTsa
	 4/6IvuDO29Y/2uds86JP2xbITH5w19Xod2QcYfyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 155/199] smb3: missing null check in SMB2_change_notify
Date: Mon, 26 Jun 2023 20:11:01 +0200
Message-ID: <20230626180812.437516753@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

[ Upstream commit b535cc796a4b4942cd189652588e8d37c1f5925a ]

If plen is null when passed in, we only checked for null
in one of the two places where it could be used. Although
plen is always valid (not null) for current callers of the
SMB2_change_notify function, this change makes it more consistent.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/202305251831.3V1gbbFs-lkp@intel.com/
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 02228a590cd54..a2a95cd113df8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3777,7 +3777,7 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 		if (*out_data == NULL) {
 			rc = -ENOMEM;
 			goto cnotify_exit;
-		} else
+		} else if (plen)
 			*plen = le32_to_cpu(smb_rsp->OutputBufferLength);
 	}
 
-- 
2.39.2



