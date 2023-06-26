Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635E6BA36
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A08C433C8;
	Mon, 26 Jun 2023 18:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804377;
	bh=mmdudRkuSbiUU5LPtsxAkTPhX5voY/Mn+ojKMk7dSZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT7rdmbyQdPnm9RoCMTg0ajtFaCGEUyl9+n/nrz7urK9SYDT8lvVtSS22b14F7Hee
	 2bIelupeltGYHMgeWIYQY0sCURRgVP6D7txkU63V2OsV174iGRA8zwtR/8CPa4U9XR
	 3VDf9FW+SNuq8ESroigZ1ldwuZchhG9fdjrm5w2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/170] smb3: missing null check in SMB2_change_notify
Date: Mon, 26 Jun 2023 20:11:44 +0200
Message-ID: <20230626180806.622508535@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
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
index 537e8679900b8..3ca593cdda76e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3779,7 +3779,7 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 		if (*out_data == NULL) {
 			rc = -ENOMEM;
 			goto cnotify_exit;
-		} else
+		} else if (plen)
 			*plen = le32_to_cpu(smb_rsp->OutputBufferLength);
 	}
 
-- 
2.39.2



