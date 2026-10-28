Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214689;
	b=r1arzarNsQN0ew8JuXwzRdwu7o6zYCQlSHz0Ly2vCZTXMy5LNZ6eKDMqIag726BDEiEw
	 0/j3hnel4EuH87+6B4pwJ7oNPOtFdyev9iB9RKojPCAkyIPT3prm2se7E3fh+qNkMpliD
	 xGHJ4YyXJIDNBMiM9hqWNP1VUc/C8CI9IbRt2r/lnI4OegNUmgB7RpBY1FRGyQTsbp9rL
	 9odj26KzBCq0V2UTZQ8Uk0cNPKPmVRhm2PGI7Te5bvV4jUTzTCTNO9p5yHxLVgR3DstBV
	 xTn67zJWjBt4MdVFXNrmytZo3va362GauEXCHyQoUu6+NtGesvE/qnww/2cozW/L3bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=msqzkoxy28q5UhBK8OqJKiAPro8etIW8in2tUEQ0iz0=;
	b=1O66Y2jvAyAmyzOJZadjhom1Kjpg4iUXV1Uzr4TXtZd92fOy0GDwzHifyHrBkhVfhBi1
	 aWbebCF9RflUPeMdSFADeiwn8rBtRQqCLz1CipvcxeAhpYB0BCa+Jl1YkFr3DKu4uyPve
	 YcgeDQZZHFpFGxkOSZyZZPkzBkYa5k9NkA6OkNeJuMW80H1c5EVWBxIBEFtQLFDCfzZH9
	 CQvmecMhvf+ivIMGApo6OM3KrwzCEqAPZA0UVaCeSu5WOOUWM8kmnFcFmk4Xc2ueln1qU
	 RvE2sBqtg7OI4+mXdX6WJc4jxSoDrVEwpLIUNfs8ebID+o1ZwGK0cd9Hu44XDTjnoIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZCqkzUb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93C2606B7FD;
	Wed, 28 Oct 2026 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZCqkzUb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465761F01828;
	Wed, 28 Oct 2026 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214688;
	bh=msqzkoxy28q5UhBK8OqJKiAPro8etIW8in2tUEQ0iz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZCqkzUbg4xyv3ad9uP4iihGjICnODxm3jM3GxQMYTzBCv9MVYw7S1JhX5j5w8fHz
	 NOq/FTYPDjDDfo3cp/Hqc+w/6MoD5a5aCMb595fJwFwrihigr+kZUqmSKmq0dBV0u4
	 E9mXC5UuC5daBdaF8Ec8BBePfY1zLqVL9tljFahY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0945/1887] ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION
Date: Wed, 28 Oct 2026 17:50:41 +0100
Message-ID: <20261028170520.913852094@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3a64125730cabc34fccfbc230c2667c2e14f7308 ]

Use sb->s_uuid for a proper volume identifier as the primary choice.
For filesystems that do not provide a UUID, fall back to stfs.f_fsid
obtained from vfs_statfs().

Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b05a9488aaa4d..21f90efc6783c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5119,7 +5119,6 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 				    struct smb2_query_info_req *req,
 				    struct smb2_query_info_rsp *rsp)
 {
-	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *share = work->tcon->share_conf;
 	int fsinfoclass = 0;
@@ -5249,10 +5248,13 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info = (struct object_id_info *)(rsp->Buffer);
 
-		if (!user_guest(sess->user))
-			memcpy(info->objid, user_passkey(sess->user), 16);
-		else
-			memset(info->objid, 0, 16);
+		if (!uuid_is_null(&path.mnt->mnt_sb->s_uuid))
+			memcpy(info->objid, path.mnt->mnt_sb->s_uuid.b,
+					sizeof(path.mnt->mnt_sb->s_uuid));
+		else {
+			memset(info->objid, 0, sizeof(info->objid));
+			memcpy(info->objid, &stfs.f_fsid, sizeof(stfs.f_fsid));
+		}
 
 		info->extended_info.magic = cpu_to_le32(EXTENDED_INFO_MAGIC);
 		info->extended_info.version = cpu_to_le32(1);
-- 
2.53.0



