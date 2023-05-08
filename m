Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AE9168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA65EC433EF;
	Mon,  8 May 2023 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541368;
	bh=umZwhx9moBd5VhiNpykp4gODR1Hew9NqKztJDGBaYKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kU9Wd5N2GHVx+OxvLydgkInN7kft4cA/uY2MkpBtDQJlKZ5vCHU/icjW3lCXDAfY8
	 zGZ/g62N3+BldN22vQvjKgXqg97mUZvFCsawXhJfp0qa0PirpADkI979lTWL261Szl
	 uSmt/RJ5Hh5VkYYskVOTDuHT7gjYyzOeDz8McOH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.2 092/663] ksmbd: fix NULL pointer dereference in smb2_get_info_filesystem()
Date: Mon,  8 May 2023 11:38:38 +0200
Message-Id: <20230508094431.442700852@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
@@ -4915,6 +4915,9 @@ static int smb2_get_info_filesystem(stru
 	int rc = 0, len;
 	int fs_infoclass_size = 0;
 
+	if (!share->path)
+		return -EIO;
+
 	rc = kern_path(share->path, LOOKUP_NO_SYMLINKS, &path);
 	if (rc) {
 		pr_err("cannot create vfs path\n");


