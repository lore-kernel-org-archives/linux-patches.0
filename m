Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCD218EB7;
	Fri,  5 Jan 2024 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKQkMv4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A0BC433C8;
	Fri,  5 Jan 2024 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465741;
	bh=M5fDICDFIedbnj9T5RGP635sMabx1hEVik/Ksieyk0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKQkMv4p4iW4dfyaPOYoCTjHBN3cYzdUdcayBNriWSoV/3OYx1ODXIm69hvLywlzC
	 BWfKvsQhMBf/Kk7xhVYcI+tYFeB8tj79vrXMzTraHx18Fz8bRlEd4IKtluftpuGzma
	 lK8H76yRy4bvuG8a7q9Tzc2Q0/TvhkcyMhd1lo4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/47] ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE
Date: Fri,  5 Jan 2024 15:38:49 +0100
Message-ID: <20240105143815.625700584@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 13736654481198e519059d4a2e2e3b20fa9fdb3e ]

MS confirm that "AISi" name of SMB2_CREATE_ALLOCATION_SIZE in MS-SMB2
specification is a typo. cifs/ksmbd have been using this wrong name from
MS-SMB2. It should be "AlSi". Also It will cause problem when running
smb2.create.open test in smbtorture against ksmbd.

Cc: stable@vger.kernel.org
Fixes: 12197a7fdda9 ("Clarify SMB2/SMB3 create context and add missing ones")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 739556e385be8..297f5e455a348 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -651,7 +651,7 @@ struct smb2_tree_disconnect_rsp {
 #define SMB2_CREATE_SD_BUFFER			"SecD" /* security descriptor */
 #define SMB2_CREATE_DURABLE_HANDLE_REQUEST	"DHnQ"
 #define SMB2_CREATE_DURABLE_HANDLE_RECONNECT	"DHnC"
-#define SMB2_CREATE_ALLOCATION_SIZE		"AISi"
+#define SMB2_CREATE_ALLOCATION_SIZE		"AlSi"
 #define SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST "MxAc"
 #define SMB2_CREATE_TIMEWARP_REQUEST		"TWrp"
 #define SMB2_CREATE_QUERY_ON_DISK_ID		"QFid"
-- 
2.43.0



