Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042216;
	b=TjjJ9b0XKTKz6/DFX9FzctgWA2NzUAFmO5dL/klfFmj7QkekbZmMjo/saQ3dziuI6AdR
	 dMzlbkgVG//7aw415g0a2qRCuEc/U67bv8sWh5Ze+gxmtET+vzuR+HdRQ9fSjMy790XAv
	 StRirYji24Hm9W3bBAb92ORwBd9UPAfCvcIOJ6S8GQmJfOZ24Mtbam1JgdqMvMaBachI/
	 +nf7vz1iOlilNqZK0PmgGUabrH24oltoLXRRuoJCBjbuHFTwenT27lMaqOiAQ5uMudVoZ
	 yuC9osUvqtIvRoqYAMKJ24X1z+0/QIxAak3golDqho88A+KKvF9PPpjZOasGFkkXghA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=W50gIAR9qDeMNvKKa4sh8V3ul21tCmhX2BMTF0z8M2w=;
	b=Zl42/zVPbg5nxpV7K0eHpLgTgL/RDx+/WhLCHTZODhX1XnyErni6syOYgHl0XRbrp3Gb
	 2H00J0WYMnZMtOhki1n7aAvq/eh+ONQOwEkyGYgQC3/XiQTvwHBQxidgDaAsuytNG2szv
	 wP3ivBB+ncuj9XShfZ28FKxgckIlGCao+w0fSOLSfbZkq5538RGzTvCtKde21cEfINi2B
	 Jmg+HhrdaVHk6OiTnTRe4UKXVAGLYfq6K0Y8zM+0MNsReC2hHSE0qnPeX35YqOmm/WL/b
	 Ns/TUVRxiB9aZ/HxBk4bS006RY8e3JDxXBYYLhi3yKvN5VK1iH7Fts5KSgatLjkKUGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odGmxtWF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35814606A320;
	Wed, 18 Nov 2026 22:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odGmxtWF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A891F000C4;
	Wed, 18 Nov 2026 22:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042216;
	bh=W50gIAR9qDeMNvKKa4sh8V3ul21tCmhX2BMTF0z8M2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odGmxtWFHuWrM8el6VeaAWqGlb12Rgtb8hzSIcxMu971QUzowP++40JDjD6h8kkG6
	 GOa7+V8C+HydMQHaHaSrwKufMQ2uX3JLBIaRO9dfd1ONQB7e85stGpA+NAzdBuegN+
	 8mKoBxGhq1geu2enXwa6Pq8yEdxsr8M5pFQUFMLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3091/3318] cifs: Update description about ACL permissions
Date: Wed, 18 Nov 2026 16:01:53 +0100
Message-ID: <20261118150452.763897489@linuxfoundation.org>
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

[ Upstream commit a46221fcdd40a29eb08900221797ad63d0271118 ]

There are some incorrect information about individual SMB permission
constants like WRITE_DAC can change ownership, or incomplete information to
distinguish between ACL types (discretionary vs system) and there is
completely missing information how permissions apply for directory objects
and what is meaning of GENERIC_* bits.

Also there is missing constant for MAXIMUM_ALLOWED permission.

Fix and extend description of all SMB permission constants to match the
reality, how the reference Windows SMB / NTFS implementation handles them.

Links to official Microsoft documentation related to permissions:
https://learn.microsoft.com/en-us/windows/win32/fileio/file-access-rights-constants
https://learn.microsoft.com/en-us/windows/win32/secauthz/access-mask
https://learn.microsoft.com/en-us/windows/win32/secauthz/standard-access-rights
https://learn.microsoft.com/en-us/windows/win32/secauthz/generic-access-rights
https://learn.microsoft.com/en-us/windows/win32/api/winternl/nf-winternl-ntcreatefile
https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/nf-ntifs-ntcreatefile

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: bb0326a58060 ("ksmbd: report IPv4 and IPv6 addresses independently in iface query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifspdu.h | 82 ++++++++++++++++++++++++++++++-----------
 1 file changed, 61 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 44aeb19ee5b76..c606195d39ccc 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -190,42 +190,82 @@
  */
 
 #define FILE_READ_DATA        0x00000001  /* Data can be read from the file   */
+					  /* or directory child entries can   */
+					  /* be listed together with the      */
+					  /* associated child attributes      */
+					  /* (so the FILE_READ_ATTRIBUTES on  */
+					  /* the child entry is not needed)   */
 #define FILE_WRITE_DATA       0x00000002  /* Data can be written to the file  */
+					  /* or new file can be created in    */
+					  /* the directory                    */
 #define FILE_APPEND_DATA      0x00000004  /* Data can be appended to the file */
+					  /* (for non-local files over SMB it */
+					  /* is same as FILE_WRITE_DATA)      */
+					  /* or new subdirectory can be       */
+					  /* created in the directory         */
 #define FILE_READ_EA          0x00000008  /* Extended attributes associated   */
 					  /* with the file can be read        */
 #define FILE_WRITE_EA         0x00000010  /* Extended attributes associated   */
 					  /* with the file can be written     */
 #define FILE_EXECUTE          0x00000020  /*Data can be read into memory from */
 					  /* the file using system paging I/O */
-#define FILE_DELETE_CHILD     0x00000040
+					  /* for executing the file / script  */
+					  /* or right to traverse directory   */
+					  /* (but by default all users have   */
+					  /* directory bypass traverse        */
+					  /* privilege and do not need this   */
+					  /* permission on directories at all)*/
+#define FILE_DELETE_CHILD     0x00000040  /* Child entry can be deleted from  */
+					  /* the directory (so the DELETE on  */
+					  /* the child entry is not needed)   */
 #define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes associated with the   */
-					  /* file can be read                 */
+					  /* file or directory can be read    */
 #define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes associated with the   */
-					  /* file can be written              */
-#define DELETE                0x00010000  /* The file can be deleted          */
-#define READ_CONTROL          0x00020000  /* The access control list and      */
-					  /* ownership associated with the    */
-					  /* file can be read                 */
-#define WRITE_DAC             0x00040000  /* The access control list and      */
-					  /* ownership associated with the    */
-					  /* file can be written.             */
+					  /* file or directory can be written */
+#define DELETE                0x00010000  /* The file or dir can be deleted   */
+#define READ_CONTROL          0x00020000  /* The discretionary access control */
+					  /* list and ownership associated    */
+					  /* with the file or dir can be read */
+#define WRITE_DAC             0x00040000  /* The discretionary access control */
+					  /* list associated with the file or */
+					  /* directory can be written         */
 #define WRITE_OWNER           0x00080000  /* Ownership information associated */
-					  /* with the file can be written     */
+					  /* with the file/dir can be written */
 #define SYNCHRONIZE           0x00100000  /* The file handle can waited on to */
 					  /* synchronize with the completion  */
 					  /* of an input/output request       */
 #define SYSTEM_SECURITY       0x01000000  /* The system access control list   */
-					  /* can be read and changed          */
-#define GENERIC_ALL           0x10000000
-#define GENERIC_EXECUTE       0x20000000
-#define GENERIC_WRITE         0x40000000
-#define GENERIC_READ          0x80000000
-					 /* In summary - Relevant file       */
-					 /* access flags from CIFS are       */
-					 /* file_read_data, file_write_data  */
-					 /* file_execute, file_read_attributes*/
-					 /* write_dac, and delete.           */
+					  /* associated with the file or      */
+					  /* directory can be read or written */
+					  /* (cannot be in DACL, can in SACL) */
+#define MAXIMUM_ALLOWED       0x02000000  /* Maximal subset of GENERIC_ALL    */
+					  /* permissions which can be granted */
+					  /* (cannot be in DACL nor SACL)     */
+#define GENERIC_ALL           0x10000000  /* Same as: GENERIC_EXECUTE |       */
+					  /*          GENERIC_WRITE |         */
+					  /*          GENERIC_READ |          */
+					  /*          FILE_DELETE_CHILD |     */
+					  /*          DELETE |                */
+					  /*          WRITE_DAC |             */
+					  /*          WRITE_OWNER             */
+					  /* So GENERIC_ALL contains all bits */
+					  /* mentioned above except these two */
+					  /* SYSTEM_SECURITY  MAXIMUM_ALLOWED */
+#define GENERIC_EXECUTE       0x20000000  /* Same as: FILE_EXECUTE |          */
+					  /*          FILE_READ_ATTRIBUTES |  */
+					  /*          READ_CONTROL |          */
+					  /*          SYNCHRONIZE             */
+#define GENERIC_WRITE         0x40000000  /* Same as: FILE_WRITE_DATA |       */
+					  /*          FILE_APPEND_DATA |      */
+					  /*          FILE_WRITE_EA |         */
+					  /*          FILE_WRITE_ATTRIBUTES | */
+					  /*          READ_CONTROL |          */
+					  /*          SYNCHRONIZE             */
+#define GENERIC_READ          0x80000000  /* Same as: FILE_READ_DATA |        */
+					  /*          FILE_READ_EA |          */
+					  /*          FILE_READ_ATTRIBUTES |  */
+					  /*          READ_CONTROL |          */
+					  /*          SYNCHRONIZE             */
 
 #define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_READ_ATTRIBUTES)
 #define FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
-- 
2.53.0



