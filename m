Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034691;
	b=bp0/hJ9MdKRlAQ8w8APhRUzO4pEL7JjZJ1Hz7QOLX2oa0PumOILNL3SFqucULGFZ+BdI
	 D1HTM5teB6CrpXVax1Qt2PuBiZuGmRdFtgQ+B+PDuZ/R/zB94Iol6tSWlTX/+LGO3ZJkg
	 QWmidOGWQeFgdjSXmiG7nvK4JKxAMNN4lqO6JSEmv7Z0d8qz85sondf4kHBR9EWhLpT8W
	 jBJkHydcePKaTBlLGh1RSOA6x0c77w/fyrF2TfSnIvUiMy5uX9Q3B/+FFdj+13iSTrEan
	 IRageYf3UF/eN3A2Xs5IImHcInjUJ8W2ZujJcp4OCTDaPKpSkBGCpJuH4A49GQoVSQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=C18V+nmI8aR3JOFuxgwb/OAH1SKOe/A/v0FYSPXvqCw=;
	b=3pbQMbcuDN5QZfeFxu47y+3/WLh35LuHUbP3yUF6RgWwnFrsZZdS9oqQGftJw5QvxViM
	 +vwyGXK1IvVvKOHz8ZZr655nbxklqCs01py2rqaVVTbeLcdDQ4hP6gOIFk1T7sQmflj3B
	 ZKaV1MBdohcOGV7RMpEUbYhY+y+2o6RaMRVD16a/1FF6BzQkYYnTOqWBa4PgyjNd8gzkB
	 wCc+Ge14D2eSMiIoGfp4gUP29ihuRJdAmsuoCy0VsnV5L+o3VONGr8cHkvkdv5tKZqdsf
	 vyhH2Uh8St3pzMlXVGn+RMd4Y9CAvxebkCxfvvVSUEtVEwQ+XVHCZTuJkCHUCSqWfvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2a5Wnnj2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F7E606A31C;
	Wed, 18 Nov 2026 20:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2a5Wnnj2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A923B1F000C4;
	Wed, 18 Nov 2026 20:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034691;
	bh=C18V+nmI8aR3JOFuxgwb/OAH1SKOe/A/v0FYSPXvqCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2a5Wnnj2A6wDIvu+pWiwnfCW1n3A7BciUZADrezvajOziY1teRPCvxn6PSyh1t+Bo
	 Q1p84ax3bHP57RDBQnfDkGj+d+1S0Fcq7MfoCmI+uCxTIOKAnEN8peqnUEYTKJ45cW
	 Vm1btC1vndHCmKsTI/v/1IMblcQtvhULsult7Ljw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0459/3318] cifs: Remove duplicate struct reparse_symlink_data and SYMLINK_FLAG_RELATIVE
Date: Wed, 18 Nov 2026 15:18:01 +0100
Message-ID: <20261118150330.593509881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 2948f0d4db40d839db2c1d141121c2e4e12a6faa ]

In file common/smb2pdu.h is defined struct reparse_symlink_data_buffer
which is same as struct reparse_symlink_data and is used in the whole code.
So remove duplicate struct reparse_symlink_data from client/cifspdu.h.

In file common/smb2pdu.h is defined also SYMLINK_FLAG_RELATIVE constant, so
remove duplication from client/cifspdu.h.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 65d5dbdc089b ("smb: client: fix file type corruption in posix_reparse_to_fattr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifspdu.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index f4cfb082dfd14..1a2a01d74e26a 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1483,22 +1483,6 @@ struct file_notify_information {
 	__u8  FileName[];
 } __attribute__((packed));
 
-/* For IO_REPARSE_TAG_SYMLINK */
-struct reparse_symlink_data {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le16	SubstituteNameOffset;
-	__le16	SubstituteNameLength;
-	__le16	PrintNameOffset;
-	__le16	PrintNameLength;
-	__le32	Flags;
-	char	PathBuffer[];
-} __attribute__((packed));
-
-/* Flag above */
-#define SYMLINK_FLAG_RELATIVE 0x00000001
-
 /* For IO_REPARSE_TAG_NFS */
 #define NFS_SPECFILE_LNK	0x00000000014B4E4C
 #define NFS_SPECFILE_CHR	0x0000000000524843
-- 
2.53.0



