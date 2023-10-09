Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A511946D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTmKZmGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12757C433C9;
	Mon,  9 Oct 2023 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857290;
	bh=EH05vGOIRCQjwVkxqv6JaifPO7BaRP03W06rzXCowvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTmKZmGbpBemBJSt4abpuIJPHhQHHC5RXPa8zT0lp+vigUUuSurzyx/+FpdmjiSov
	 x01zomWN8D7Y2OzErfqo8NkKuPOqeoV1Z4Wf8B+146KssysRW1ihietj0oyChjVha4
	 0bdesV1WtoWL96BY6Z1C0tXMGw0Iw1j5nAHEiP+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luosili <rootlab@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 161/163] ksmbd: fix uaf in smb20_oplock_break_ack
Date: Mon,  9 Oct 2023 15:02:05 +0200
Message-ID: <20231009130128.448565245@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: luosili <rootlab@huawei.com>

commit c69813471a1ec081a0b9bf0c6bd7e8afd818afce upstream.

drop reference after use opinfo.

Signed-off-by: luosili <rootlab@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8036,10 +8036,10 @@ static void smb20_oplock_break_ack(struc
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


