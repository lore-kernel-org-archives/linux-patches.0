Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051488;
	b=vblffr9Pp/S5hEQRF0f/aDsFeQe216FSus6ni/ohQ6iS4FJWSg49NnvMw4QL46V2DM/5
	 V99oxZj16BMS8hRWpqy10mgrkdGDp1OYQ9bzqrU/3QTqgiO/L6DkJuQ1tUkKoGltyi0y5
	 g9XG6pZURHfSvFPdSX4lP5VtRmWbI/nvLJeqpHzyyiZ+EpOsrW4bFnmF+XpAfDkyEyY8F
	 izprSLFuREmIGti6QU2t/XS83gPqncAux2jExwBSDu9oWOKw8n/CcRTdx4M0GmKYAWOCk
	 vCfoLbyQNsHUValKecP4Wr6mp1dhoKVYCCBQVcxnTw1ZfF8JJ0COYP6Sx79dVHR5h4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RFxyPv7bI2/i9WnwbzGVd1YvPwmGAu/Po3PBFr/2y0Q=;
	b=2Nx/pLM8gzsEtGVTED364to8of+pWW0h3uNugru8jws9am9KpwlMZP337ru8s9lsMBeF
	 eH3ZHnCJ3jF8Qdbo0qMu6SFGvWpX3guQrXWHjV3/1sSRhDWjgDDV8x15U91jE8UMTgUUK
	 57eIlLZv4kqYQU0OXvGkKqNEGK3XOM+UCpqZ8ielbW5cwt+uldizcbMNhLQEFTtwF1Hki
	 zI7YrTjsLMqu7ft0nBv8GFMbxksSxS9DhXDE+nvVL3JlgsMUCElk+N0QgHb1AzkB0EFt3
	 CHVlFMMSwZBASWh8XgtCVunttxK5XBdxlBebeEn14v0yq3JBXM8PHacGkr8eTQLmtwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwKc3nC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82E0606A32C;
	Thu, 19 Nov 2026 01:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OwKc3nC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326121F000C4;
	Thu, 19 Nov 2026 01:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051488;
	bh=RFxyPv7bI2/i9WnwbzGVd1YvPwmGAu/Po3PBFr/2y0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwKc3nC54xuGapOI3d5yKk1egBLV1tt/0Mt0YCDmV0kEfZ7ghz2zskYwutPaYbCrI
	 544SDYr6op2N6wCEqi3hIAHXD0TNUZHihDr2uiuEIm3ZbhoR0Bk542I0n6Yj+oQADC
	 ZVSBk5rZKDfnJaO6nVF4fMxXky9mXe31OuaIHlpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0209/2214] ksmbd: preserve access denied status for copychunk
Date: Wed, 18 Nov 2026 15:31:25 +0100
Message-ID: <20261118150018.553036884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index e1aab1b256575..bd51c02c24ca7 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7423,7 +7423,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
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



