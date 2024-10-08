Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2E41779B1;
	Tue,  8 Oct 2024 12:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391110; cv=none; b=koOS+Xauauxb9IB9X8/OOV3OsGk1P/M6bqHPK9Np8kO9NQ/QMa/HhdgrDQ+7Yj07u+gFcFd/r4nPbG9mtwSSzO0p4cDLa6tRaAd3DKa0PdOwQYPjXsymOPyKrSHc4TooAVTceDtIrQNfk/e0+IZOkriaaYCBJTyDEU7CupbxjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391110; c=relaxed/simple;
	bh=L70wxhkBc6RCICoHGqi9sxhzWTnuO40w5DvhBaneFPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nzm0lOWLpkeXcm0TxsyASEIXewM7vEftiJt96u7VLKzTsYRqEWfEcSueL+sPCF9kwJm2RipHfGoPDKePSEIJSANlH3ScXDwnM0dnxCzdNh6xaOYO3vZ3BQremfAsxlfVM8E5jYi3h5me/AexS1uHixJw/nsYI0RSRhD+Pm8iHTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtVtTxSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtVtTxSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3133EC4CECD;
	Tue,  8 Oct 2024 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391110;
	bh=L70wxhkBc6RCICoHGqi9sxhzWTnuO40w5DvhBaneFPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtVtTxSx2NmnpucI9g0mmZHpWtiYHRcWmgWFIlRjqj6b86EU/VvytbC6BERtRdPlA
	 xjli1erdNpK5HRgoR+1HFTT3oMmZ8F8jkiVywby+cN/TnsKM9WYjb12DdNvR19Jnt/
	 FDsNzPd2kLcYpTbYMVDTQ3xeoWrT2tUznN3W+eRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 011/558] ksmbd: fix warning: comparison of distinct pointer types lacks a cast
Date: Tue,  8 Oct 2024 14:00:41 +0200
Message-ID: <20241008115702.666015510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 289ebd9afeb94862d96c89217068943f1937df5b ]

smb2pdu.c: In function ‘smb2_open’:
./include/linux/minmax.h:20:28: warning: comparison of distinct
pointer types lacks a cast
   20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                            ^~
./include/linux/minmax.h:26:4: note: in expansion of macro ‘__typecheck’
   26 |   (__typecheck(x, y) && __no_side_effects(x, y))
      |    ^~~~~~~~~~~
./include/linux/minmax.h:36:24: note: in expansion of macro ‘__safe_cmp’
   36 |  __builtin_choose_expr(__safe_cmp(x, y), \
      |                        ^~~~~~~~~~
./include/linux/minmax.h:45:19: note: in expansion of macro ‘__careful_cmp’
   45 | #define min(x, y) __careful_cmp(x, y, <)
      |                   ^~~~~~~~~~~~~
/home/linkinjeon/git/smbd_work/ksmbd/smb2pdu.c:3713:27: note: in
expansion of macro ‘min’
 3713 |     fp->durable_timeout = min(dh_info.timeout,

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 5 +++--
 fs/smb/server/vfs_cache.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8bdc592514188..065adfb985fe2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3531,8 +3531,9 @@ int smb2_open(struct ksmbd_work *work)
 			memcpy(fp->create_guid, dh_info.CreateGuid,
 					SMB2_CREATE_GUID_SIZE);
 			if (dh_info.timeout)
-				fp->durable_timeout = min(dh_info.timeout,
-						DURABLE_HANDLE_MAX_TIMEOUT);
+				fp->durable_timeout =
+					min_t(unsigned int, dh_info.timeout,
+					      DURABLE_HANDLE_MAX_TIMEOUT);
 			else
 				fp->durable_timeout = 60;
 		}
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index b0f6d0f94cb8d..5bbb179736c29 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -100,8 +100,8 @@ struct ksmbd_file {
 	struct list_head		blocked_works;
 	struct list_head		lock_list;
 
-	int				durable_timeout;
-	int				durable_scavenger_timeout;
+	unsigned int			durable_timeout;
+	unsigned int			durable_scavenger_timeout;
 
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
-- 
2.43.0



