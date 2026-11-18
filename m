Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034250;
	b=s0oI0GdjmGPNk7V6TO4Tj1qyfNT+nppCaGxUsbHRoJdW4GtJzgioXa9kOi3jMRhi89/2
	 rWmY8xf7gaprzfQHysdz9HC1Kb1vmd3wTuoUu482/JZi2uzrONJ+MPSyZ9uee29+Rz+ce
	 L6FtXNpXkoW/WmckWq9fd26gYkxZijDBRTYdi4SHaFElwXNs/ttY0MnZ0AAtiPHtQvvZb
	 3xz7CqlHJCpNLOG67EfeAYJEhD5unBPlFSposaDqFnBVS8NLoguLnLHoAhabITCXl90a5
	 bFcLGGTqucc6zrXgzmiWlTEOJHbMiIKzzwAvJid3kpLuxJVQmYzM5aJgKUAyqwUIp7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EDjvYYmWb7K85M6xKFs+pZ/J/FgfWMs1zyf7U1R/bvI=;
	b=OaNAFLaDnKwFdwGQkuMWfsJnF5sgomAVMccYvykI07PJeDvY2A0stVQmr2rek1HnuY8S
	 Zs2iQ94k9lj/RItGEKOLKLAPjGDj0pqFSCdmOvR6p+uzwu4hwcI0/fOTShZhsnZBlC8SF
	 PEatvo7+BX9Ah5y9H/SWsLM4Ecvv7rE9XrDPa8DN4FvsdNmde/j3PScYS/TgJGJs2vCOa
	 hmT+2AmArsmR1ZA1SjHXYui5xfDSLRTwmWwrBDicO2et03tojnIeC5Igi1eFWGT69EBbM
	 Dze0uXcnSkDjtT/k7DPzH2XWNXW5wpH4V3cVubVHBxn16AkCIbuRR4FPvr7aeQ8+afA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kliZUCRM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFD6606A31C;
	Wed, 18 Nov 2026 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kliZUCRM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D016F1F000C4;
	Wed, 18 Nov 2026 20:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034250;
	bh=EDjvYYmWb7K85M6xKFs+pZ/J/FgfWMs1zyf7U1R/bvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kliZUCRM0rfQ/FZZQOG/J0FNxmQ6PReknpLiQjwMGfuxS/x2AdzbY7/O6oAa/sgUd
	 QbI9N1DymGcKPAqhj+oOV4dh+tMGLGnysIe+MWr0FHdiww5qJbtoW4KeT35CgcaxCX
	 XltnYx4t0r3hPSXFwd8CVXw0DrpOIqMOOH6INdfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0286/3318] ksmbd: preserve access denied status for copychunk
Date: Wed, 18 Nov 2026 15:15:08 +0100
Message-ID: <20261118150324.150660618@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f7c0366e0a80bf8cd5eacc5479927abb50958b5e ]

The copychunk error mapping handles -EACCES in an independent if
statement. The following error chain therefore reaches its final else
clause and overwrites STATUS_ACCESS_DENIED with
STATUS_UNEXPECTED_IO_ERROR.

Join the -EACCES check to the remaining error chain so an access failure
is returned as STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 63af3d2d139cf..503f3219382b6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8021,7 +8021,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	if (ret < 0) {
 		if (ret == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		if (ret == -EAGAIN)
+		else if (ret == -EAGAIN)
 			rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
 		else if (ret == -EBADF)
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
-- 
2.53.0



