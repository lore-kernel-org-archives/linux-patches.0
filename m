Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623386;
	b=qh94/fsnrYsdsdC9BrKPVdrW5U5Lf4e0vAJJEHOhFJeKyYgfIZN0SOoi56OxTbxeY61A
	 lwwf28zWqrTnRdyGKFMIyES1aHHlElMiwqnZy17JyAzJEwHdUOFk4TsjWurGzXp9LQMh9
	 kC4dIafNLLSuo9HeqqkNMsecuGh0S7FOsQyunTX0YWBQzsYoORhxbRzTDBgtBANVohbud
	 FSWwyZFZ0ux+j9i2SM8KhbLjJuaCYgYuHBzBV6X/0/JSLrKzFVAE+F5AvBAIv+2TlHqXK
	 D3jG7XivC+GQUZD0OkbnNjVcVloB0v9/JXOI6oGqQA860fQzmYJSjjHSG2qEzMwjQqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1J3FOoYiJLCMVxHTJQ7j1fVrPMGMPP/RG9Ty26dPjrI=;
	b=DKxhOkdl30kZci/F32HxZFxuVlV7udf0p7MJ4t7UbapnjN0dFMU88fOHWnoBMxNWVR/q
	 R17lIMZ1VVY3Yjmf2WRY9pCg0eqlXiuvdAo2LlhHENCfDFwUVE3oa51dYxh16GwZ+qcH7
	 XMt9AnCUX7rVIwNrgHIJGNO3SCeGYtIVUuXdFL4H8a/kfn7GBvdrAGv8UbKsYyRrhmD7w
	 ++7qvkI94EGiu8QZEX+SdKr6q/7iVg/NjzMXUbzF27RR3nOGLsy5OMQ1jhclL/y2oXHDL
	 ZYkBV/xodQf1nBnaAjEQntyHp21EHwdiKjJwpG7s22pHzWO/RGUBQ3px+S1jMpIPLjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8q9GVm0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7915F606A31E;
	Wed, 25 Nov 2026 16:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8q9GVm0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406AA1F000D0;
	Wed, 25 Nov 2026 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623385;
	bh=1J3FOoYiJLCMVxHTJQ7j1fVrPMGMPP/RG9Ty26dPjrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8q9GVm0ty/Pcq/ZSsIMv+OGM2pRheK031T94fVAgndNWiQerbZTnkevHIRgOkWKX
	 Y5Sat8SBEh5ppYCBts7k5tAYb+uh9JVC6Y5w3PwUIWTK8EuoUpwCB15KA5Ytztt8Xl
	 b3vnNBM9WRjc5eAS4I8eurNUP65Ce3F7T43mzAZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 843/990] smb: client: flush deferred handles of other names before a hard link open
Date: Wed, 25 Nov 2026 15:36:50 +0100
Message-ID: <20261125143841.778074297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 25912ed3b75dcf5ff623dcb549b925dd0d0948f7 upstream.

Opening a hard link of a file whose other name still holds a deferred,
leased handle fails with EINVAL over SMB3.  The client caches lease keys
per inode, but the server ties a lease to the file name it was granted
under, so reusing the inode's lease key to open a different name of the
same inode is rejected with STATUS_INVALID_PARAMETER (MS-SMB2 3.3.5.9.11).

Commit 262b73ef442e ("smb3 client: fix open hardlink on deferred close
file error") already closes the inode's deferred handles before such an
open so the new name can take a fresh lease, but cifs_get_hardlink_path()
only triggered that flush when a cached handle had the same open flags as
the new open, so a differently accessed name - written then read, say -
slipped through and still failed.

Match on the name instead: flush when a cached handle for another name of
the inode is open, regardless of access mode.

Reported-by: Giuseppe Piscitelli <ooonea@gmail.com>
Closes: https://lore.kernel.org/r/CACmoRBbDZR3eyEM65j73sWMS7A=T89z1QAvCP=+u0WGzZhwW6g@mail.gmail.com
Fixes: 262b73ef442e ("smb3 client: fix open hardlink on deferred close file error")
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2206,7 +2206,7 @@ cifs_get_hardlink_path(struct cifs_tcon
 	spin_lock(&cinode->open_file_lock);
 
 	list_for_each_entry(open_file, &cinode->openFileList, flist) {
-		if (file->f_flags == open_file->f_flags) {
+		if (open_file->dentry != file_dentry(file)) {
 			rc = -EINVAL;
 			break;
 		}


