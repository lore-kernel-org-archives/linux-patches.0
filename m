Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BF71A5BA
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FLsotOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBF1C433C8;
	Mon,  9 Oct 2023 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858042;
	bh=aJdlbLip+vneYTsEz8avz7r+Wp416gWt+77vG2yymcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FLsotOjg9RQTqzzVDGFuUtOTIGNIq+YhHKI1QJFwI7KfNtArM6n0TxlbcVLyku3M
	 yjPWcZdP9ikcGJ0aEaZDwA09Dn5uR698xuPP9Z3nCtFmP9Hs27c/vvr1gfjw32NYwv
	 q9eQ1A5e7ZuMAhnAkapUbVieiEXLhzdUqY38P4Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luosili <rootlab@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 74/75] ksmbd: fix uaf in smb20_oplock_break_ack
Date: Mon,  9 Oct 2023 15:02:36 +0200
Message-ID: <20231009130113.878598425@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

From: luosili <rootlab@huawei.com>

commit c69813471a1ec081a0b9bf0c6bd7e8afd818afce upstream.

drop reference after use opinfo.

Signed-off-by: luosili <rootlab@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8058,10 +8058,10 @@ static void smb20_oplock_break_ack(struc
 		goto err_out;
 	}
 
-	opinfo_put(opinfo);
-	ksmbd_fd_put(work, fp);
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
+	opinfo_put(opinfo);
+	ksmbd_fd_put(work, fp);
 
 	rsp->StructureSize = cpu_to_le16(24);
 	rsp->OplockLevel = rsp_oplevel;


