Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7B168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94804C433A1;
	Mon,  8 May 2023 11:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545460;
	bh=zWFI4s0PmmdFO8Z4Ni1S6t/Oqf7D+R2Wp59QUWdY/lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjCm1MbB3rVSmpjWQJch2XKFhHVc479SIfjx1MaZsQFUX3zcO1Jej/qkzbV+23myi
	 Q0wlXirq51sUuLKlTfvP5detOgu9KxyAfI717yq/HAKNUjc4AN39NW6f4Q3Ppi9IYB
	 SBvFdyQcZXEOnIjn8vWTC2Q+kmqLpgnmSC8/rCpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 047/371] ksmbd: fix NULL pointer dereference in smb2_get_info_filesystem()
Date: Mon,  8 May 2023 11:44:08 +0200
Message-Id: <20230508094813.929243828@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 3ac00a2ab69b34189942afa9e862d5170cdcb018 upstream.

If share is , share->path is NULL and it cause NULL pointer
dereference issue.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20479
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4879,6 +4879,9 @@ static int smb2_get_info_filesystem(stru
 	int rc = 0, len;
 	int fs_infoclass_size = 0;
 
+	if (!share->path)
+		return -EIO;
+
 	rc = kern_path(share->path, LOOKUP_NO_SYMLINKS, &path);
 	if (rc) {
 		pr_err("cannot create vfs path\n");


