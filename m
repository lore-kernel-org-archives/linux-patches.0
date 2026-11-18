Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042241;
	b=Lj1vVSChSudVso7n8ZwFxesfHCI7B13KxhfB9Y/Asr67gVjH0WR5U55N7QOPxnHZoNDF
	 WvxQ4C2jvefYZ5pZwMFZkeftBv9PHTpitA+4yUg5nVDGn+X8bPemNt6QOy4dXYX8i8tdm
	 A8WC8xdCcCbOCj/S5EvYWvm7AKp606Ds1C2ORlSpF/EnuGmzCHg/FgIZC/PwNp6V04/ok
	 Mq8mFzgjv2oemVWBfH33EO+nb9V3ndSbCV3BNAm2rPoo322IL9ypcMmMBj2ujMGS6pd/e
	 0071hkY5oFSLeCdwuj4X1EF2ZNVYM0b5LPvLQgx08MLTK6WRvdHO63/98GEVPVzdyVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8zGf9Dp6UW1iFG/FIFTgX827XBqg1qNMjXmtTlxjcXM=;
	b=uQIrSa9GWyvlMtR9PKKYgU7M39ZcffZkfJAD646AoKMnkpo5vvJGOqCVcitUxe+bTE7B
	 iKazteucCVTljCszCOekZ6gxGaOR1iKHEx2EHZE286ZM7ioyjdWNrOi7Zf/x3FPhC7F0G
	 KJKqhmhWCE4N7wzcBKqpUcxlJOZtB6u8O/uVnuJbhvmsKkzmESflSdLPksWYQKWaQ4Wki
	 33dPkdyozzRJp4BEXc1wIRQPvSN0plC5BMkLhG3wDrVK5om8UtHkLewvO4L6RzHR4MXKO
	 Ds7hKbv/MFbpOkt+U+z/VLN3df3mM1D7k2j1+Eh9kxQO/CNZvn/ZUVGU815654ke6qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgtQOi+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604F5606A31C;
	Wed, 18 Nov 2026 22:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgtQOi+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B119A1F000C4;
	Wed, 18 Nov 2026 22:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042241;
	bh=8zGf9Dp6UW1iFG/FIFTgX827XBqg1qNMjXmtTlxjcXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgtQOi+gtipXg+E/slDENx+67J2gLIrxoB/LynEOdQPXNyWV9YSQTlat2+wcn0fi7
	 fDIDC/dTNQ2w0wAAYsbJtWmHUG+r0uUMIhUJzVzKTzsroqiOad/bgfC/C2Ofbhz6k4
	 I1dKXOUwJgYlCMyXK+CSIfrJVG6s/qv5GQvlTsOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3099/3318] smb/server: fix trailing period in generated short names
Date: Wed, 18 Nov 2026 16:02:01 +0100
Message-ID: <20261118150452.978210816@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit e8486c5cfbdd07811afa4196060bafbf78ccdae2 ]

Reproducer:

  1. touch /mnt/file
  2. smbinfo filealternatenameinfo /mnt/file
     Alternate Name: FILE~9!.

See MS-FSCC 2.1.5.2.1. The base filename MUST be 1-8 characters in length
and MUST NOT contain a "." period character.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb_common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index e4e9bc919ee8e..26604c7a96f43 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -494,8 +494,6 @@ int ksmbd_populate_dot_dotdot_entries(struct ksmbd_work *work, int info_level,
  * @shortname:	destination short filename
  *
  * Return:	shortname length or 0 when source long name is '.' or '..'
- * TODO: Though this function conforms the restriction of 8.3 Filename spec,
- * but the result is different with Windows 7's one. need to check.
  */
 int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 			    char *shortname)
@@ -559,7 +557,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 	if (dot_present)
 		memcpy(out + baselen + 4, extension, 4);
 	else
-		out[baselen + 4] = '\0';
+		out[baselen + 3] = '\0';
 	smbConvertToUTF16((__le16 *)shortname, out, PATH_MAX,
 			  conn->local_nls, 0);
 	len = strlen(out) * 2;
-- 
2.53.0



