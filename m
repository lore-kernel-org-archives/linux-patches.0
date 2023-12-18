Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B527E4FF75;
	Mon, 18 Dec 2023 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtXa3C/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CE2C433C7;
	Mon, 18 Dec 2023 14:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908163;
	bh=aek0FyIL/3M3tOxqTn4gHF8FntMWPm7o8UR/1Gn4C/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtXa3C/jUiKYYNu5JvW5C2O36YaX58TywbBJfEZgwOYPiBO3DkXcxlPTAjpCsTxm6
	 /CelYMx/E06g5620NVLrFpE9ZDFCVVreDAMIMu+qjthMGr7kYX2rrGwDbqfS33XBs4
	 RqDFFVjeOkthCKZMG5YbHongTPEvq9x+MS5eVWVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 076/166] ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE
Date: Mon, 18 Dec 2023 14:50:42 +0100
Message-ID: <20231218135108.441133278@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 13736654481198e519059d4a2e2e3b20fa9fdb3e upstream.

MS confirm that "AISi" name of SMB2_CREATE_ALLOCATION_SIZE in MS-SMB2
specification is a typo. cifs/ksmbd have been using this wrong name from
MS-SMB2. It should be "AlSi". Also It will cause problem when running
smb2.create.open test in smbtorture against ksmbd.

Cc: stable@vger.kernel.org
Fixes: 12197a7fdda9 ("Clarify SMB2/SMB3 create context and add missing ones")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/common/smb2pdu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1120,7 +1120,7 @@ struct smb2_change_notify_rsp {
 #define SMB2_CREATE_SD_BUFFER			"SecD" /* security descriptor */
 #define SMB2_CREATE_DURABLE_HANDLE_REQUEST	"DHnQ"
 #define SMB2_CREATE_DURABLE_HANDLE_RECONNECT	"DHnC"
-#define SMB2_CREATE_ALLOCATION_SIZE		"AISi"
+#define SMB2_CREATE_ALLOCATION_SIZE		"AlSi"
 #define SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST "MxAc"
 #define SMB2_CREATE_TIMEWARP_REQUEST		"TWrp"
 #define SMB2_CREATE_QUERY_ON_DISK_ID		"QFid"


