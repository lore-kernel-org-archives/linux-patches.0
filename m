Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212422;
	b=aXd9NnQ00DXFzv3hmv8P0Q8YDwtUbZC4s0WddfggLXBWkNhC7cMuExWj9RHdS6GYK+57
	 EJAGEX3v5Qynth7OPRonFzMkC4O2c+sZvz9DsPa1A0Hu7dkAzSKMbZS2G+BZAMiSKG0TD
	 H16/o06CqnIfVroCWfnD5E1Qdr72JKWA/qq4ee6dYa670wuGODsZ6+AVa3V4fjST1e8U+
	 bOIo/RY1UVGh8neuPEFBn7/sV33mbxZ4rK91L7U77+1oKrRwj7hekr5PFC4onKfgJxRT1
	 ZDZrp3JE2dRF+FMn3uPznRYViUJcR7fTP5LEUtXELPEc7U5NSFkc5aqwjwGhxZxlo/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pahqQX2t69qmM9BoaetSXRQsvFxKwnPRfN+sdjhO6xg=;
	b=k26TCb++VynnRVULPmCS35F05UBMg787GEK/QcSsFMc8hvJBXV7HZoBgjRuxafAMtZjq
	 x9mabvmhDv+W0TveN70GGGR+on/WcM2V4KQdNzKk66DH+5mlLQWDR7bEag1OL01e4tM3f
	 vlbv6SH+CJVqlKNp2SuCdJPjKil/8Cvtl59m8Qo5GHEInTaJj9bG4ae1IZKZZNJYaB0GZ
	 3AM0AGMQMLgDRByZd8pj4XM8qlUTN6cgNnVbp1tj1hzLVhl918PBvFYDPhzkYfuQ6kXXd
	 iU/1gy55OspW0Q55yOQbnvcgjfXct4rHCfXPqlEyz546Y4DS+SNguHrTJnrbmrB286Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1LZBHS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DC1606A32E;
	Wed, 28 Oct 2026 18:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C1LZBHS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A541F031E6;
	Wed, 28 Oct 2026 18:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212421;
	bh=pahqQX2t69qmM9BoaetSXRQsvFxKwnPRfN+sdjhO6xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1LZBHS7IkGoj3e5xUP9Psr08/ZeR3oO3845t0nqxYpIBvH+ZSrqCJe5WCIZrHySh
	 sR2FK1hzJKkeu1Atv2Uw5z0tgfA0CeUhTh8rUR3z4+CqC0kGcWidpxu9qzZcjIvbfz
	 hHcseu7MhtkTY50ipMVu0b42LbR940hYgeonwp+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0147/1887] smb3: make query_on_disk_id open context consistent and move to common code
Date: Wed, 28 Oct 2026 17:37:23 +0100
Message-ID: <20261028170502.580990261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 1149c8467ddebfb6bb9aab37830f70a49cab7085 ]

cifs and ksmbd were using a slightly different version of the query_on_disk_id
struct which could be confusing. Use the ksmbd version of this struct, and
move it to common code.

Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 67f4c1c6a1b5 ("smb: client: fix create context out-of-bounds reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c |  2 +-
 fs/smb/client/smb2pdu.h |  9 ---------
 fs/smb/common/smb2pdu.h | 11 +++++++++++
 fs/smb/server/smb2pdu.h |  8 --------
 4 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e23060ed57da3..5aa5db211997a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2179,7 +2179,7 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 static void
 parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
 {
-	struct create_on_disk_id *pdisk_id = (struct create_on_disk_id *)cc;
+	struct create_disk_id_rsp *pdisk_id = (struct create_disk_id_rsp *)cc;
 
 	cifs_dbg(FYI, "parse query id context 0x%llx 0x%llx\n",
 		pdisk_id->DiskFileId, pdisk_id->VolumeId);
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index d12ca9c7e62bc..2c2a2177b553c 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -170,15 +170,6 @@ struct durable_reconnect_context_v2 {
 	__le32 Flags; /* see above DHANDLE_FLAG_PERSISTENT */
 } __packed;
 
-/* See MS-SMB2 2.2.14.2.9 */
-struct create_on_disk_id {
-	struct create_context ccontext;
-	__u8   Name[8];
-	__le64 DiskFileId;
-	__le64 VolumeId;
-	__u32  Reserved[4];
-} __packed;
-
 /* See MS-SMB2 2.2.14.2.12 */
 struct durable_reconnect_context_v2_rsp {
 	__le32 Timeout;
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 7d69a2a1d3ba4..430b65512228f 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1240,6 +1240,7 @@ struct create_posix {
 
 #define SMB2_LEASE_KEY_SIZE			16
 
+/* See MS-SMB2 2.2.13.2.8 */
 struct lease_context {
 	__u8 LeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le32 LeaseState;
@@ -1247,6 +1248,7 @@ struct lease_context {
 	__le64 LeaseDuration;
 } __packed;
 
+/* See MS-SMB2 2.2.13.2.10 */
 struct lease_context_v2 {
 	__u8 LeaseKey[SMB2_LEASE_KEY_SIZE];
 	__le32 LeaseState;
@@ -1270,6 +1272,15 @@ struct create_lease_v2 {
 	__u8   Pad[4];
 } __packed;
 
+/* See MS-SMB2 2.2.14.2.9 */
+struct create_disk_id_rsp {
+	struct create_context ccontext;
+	__u8   Name[8];
+	__le64 DiskFileId;
+	__le64 VolumeId;
+	__u8  Reserved[16];
+} __packed;
+
 /* See MS-SMB2 2.2.31 and 2.2.32 */
 struct smb2_ioctl_req {
 	struct smb2_hdr hdr;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 6011fca980456..7518aa42f11ed 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -146,14 +146,6 @@ struct create_mxac_rsp {
 	__le32 MaximalAccess;
 } __packed;
 
-struct create_disk_id_rsp {
-	struct create_context ccontext;
-	__u8   Name[8];
-	__le64 DiskFileId;
-	__le64 VolumeId;
-	__u8  Reserved[16];
-} __packed;
-
 /* equivalent of the contents of SMB3.1.1 POSIX open context response */
 struct create_posix_rsp {
 	struct create_context ccontext;
-- 
2.53.0



