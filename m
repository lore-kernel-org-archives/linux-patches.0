Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216159;
	b=wFXTscH3y7DpmvVY3cimO0L6Mzo81jXW9ytgSfoHFvXCBsbRuPX1y5TpBrqtWfOZ0Fus
	 vWtHKjbeNtptyEi4H61NUUbJYE0puX718Y/tixGrOG/F9T8aPbUpgZz5FnhuiOQPA722i
	 Z1YC8fb3Vhffppr7YMER41FtF/jWgrkkxWsdvpH6j1j7Ut76MxUy2RsZ1HN+YksynpIga
	 Gj0pBYoMRBAuRkX0EiztH/lLT0Yu/yFJ1qNq6M9nFGb40zNPgbAI8om6Bc/VVgU6tYhas
	 q9RbVIujzj5uLTFuDfQZJejE3y+u+iGvq2xrZwyD0eBzq5aNslhsKjf0NjH/8LrJoeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XEhkCm275o0uuRG1YNPPGdwYUuiR4yu9TqlSud/X5X0=;
	b=Iv1ggfxxqwzITK+Vonc8IWyD4FzFcxtOa2UvMdFeKmuznCIpFVvMFAyXnja+h3Hn5b+n
	 5QvymSyoNuYlmzNhCPrflDCMMVyB6dTuh0PCqz4iKa4S+CXc3OcD7Ydi7YfMJJtJYg9KT
	 WKW5mA3gBlBo/XF/raf27hiTtemEaHs69bGIGNl0e0IlOB6yJx+Bnb6nyMylZR34OQy9A
	 b7ftuulYSZTFqNZZ92TfqAWjaR1J20hAhH39f94JjSS2w/EfGBsup5uBvvpMW7t+CIzTZ
	 gQ68M5CPm9zw8XZC+yaxisfMi9mgvz1JOLhW4WMxUQAOaoeFTGszB4yNtSmmx7P/yXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aH2pJo9c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CE4606A31D;
	Wed, 28 Oct 2026 19:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aH2pJo9c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C945D1F01825;
	Wed, 28 Oct 2026 19:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216159;
	bh=XEhkCm275o0uuRG1YNPPGdwYUuiR4yu9TqlSud/X5X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aH2pJo9cWpKWVgi+MLarqeHmvvRbUDk9c57Ml8nfAjMRIZewvyO0qv5aVPJp1/sF9
	 tZuoamoZwYfa6h7rCB63TDR2n6y4VMMjdPmUfP0Grr3/iPb/cA33OLJUuYWvLk9k2i
	 NtlRZHBE+fnc8JaeliCXTZEBIal3TxMn8NvSteB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1418/1887] smb: client: reject a tree connect response whose byte count is too small
Date: Wed, 28 Oct 2026 17:58:34 +0100
Message-ID: <20261028170531.726794038@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 65deb18359341141d37dc86fc7853511be3c87a7 ]

CIFSTCon() bounds its strnlen() over the byte area with the server's
ByteCount minus two, which for ByteCount 0 or 1 goes negative as an int
and converts to a huge size_t.  The later subtraction wraps the __u16
bytes_left, and that is what bounds cifs_strndup_from_utf16(): a bound of
up to 65535 against a ~16 KB cifs_req_poolp object runs off the end of the
slab object, and the bytes reach userspace through tcon->nativeFileSystem
in /proc/fs/cifs/DebugData.

Reject a byte area too small for what the parser consumes.  Two bytes is
the least it can consume, and no conformant response carries fewer.  The
new trace point is the 129th smb_eio_trace entry, which __mode(byte)
cannot represent, so the attribute goes with it.

Fixes: cc20c031bb06 ("cifs: convert CIFSTCon to use new unicode helper functions")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index abc03adb692b5..fd74814bdc84a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4138,6 +4138,10 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		tcon->tid = smb_buffer_response->Tid;
 		bcc_ptr = pByteArea(smb_buffer_response);
 		bytes_left = get_bcc(smb_buffer_response);
+		if (bytes_left < 2) {
+			rc = -EIO;
+			goto out;
+		}
 		length = strnlen(bcc_ptr, bytes_left - 2);
 		if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
 			is_unicode = true;
@@ -4193,6 +4197,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
 		}
 	}
+out:
 	cifs_buf_release(smb_buffer);
 	return rc;
 }
-- 
2.53.0



