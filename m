Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774341;
	b=Sz87sDYw2pLcCukN0veWkEiuaS/NWT18Gmo1GaDtpT7tz13djgU5/L+BZdEO3OTIfG0E
	 UmEKwao9HYlsPh8j2urc0HGj4neNInsdXfk8+F1tm6BuUUUtj/mkk1NPm8rJpif8tTkhH
	 JyIl8Op5t3drmwsrW5zCOOS61yjeceUwLRpQcpEsly64BaVvc1P9pXVB5KDLru9PRL8ao
	 4F9s6sxlTUg9GXzN4vMro7WXCNmd4ieZo3ah9mJ8bXxZWeJ9SPq9jioEF5ocEFCT0tvpO
	 ZT0+byUXIPJCPru9sTWnokvvFPgG+Ni+VCgvnujXYaNutE3lVCE8FrNe0IIu8DVbmvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPP31pOCEoZUZ9p++sCp+Ro6I3RxuOE4vKvMVGwgUzk=;
	b=bGgYT0xzkAi6OLT7FIw6l7Alft1mFJIilxQoNPLgiEPU2BKX1fCdTvwgRGMtUnTeeiOr
	 4phzJIF/yjppOdWZiueTODURyqhu0DKwdIaGRLcI5owf33hZrbHCKpLEIGgbRDyA/cHeh
	 WWw1LNQWlO0uyeLi4P804GmlBlom1Ff9Ecoi288ONgc6/acYWPIANlM8XVb28eY4WVMo/
	 G2HQR22CjLrJYj3RBT7cqLHaOLm2oaaVo990Ls9LcD9QRWHZM5uM9GP25l5F/RWNOKPiI
	 5qlMCl2szMhuySq12XoNEeoLavpTHBxJQpLMsV8SYlULYUaMlX9Nt8e6ttjXsJ+cx9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgUcSfSo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554A0606A31A;
	Fri, 23 Oct 2026 16:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgUcSfSo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBC91F01825;
	Fri, 23 Oct 2026 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774341;
	bh=jPP31pOCEoZUZ9p++sCp+Ro6I3RxuOE4vKvMVGwgUzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgUcSfSoqNXfTjNFPunuMBghJl9UFnFiU8zAsBfdDU8QXKk1dNcaVjDpnlfxtFLMF
	 9PrTmOFqCBCtuecrkLFMRpLmUCThKiUySt5quqC4YB117q+DaJd42tKOz5KRGqy1NR
	 Ln/b0IQJL1DKs8iaIsh+R9Cxlbp/YNSUSxfF2cIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 001/242] ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic file-id lookup
Date: Fri, 23 Oct 2026 18:37:23 +0200
Message-ID: <20261023163713.849250995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit a3bcea7c819a6c69ca937a68631311711bf20e66 ]

smb2_ioctl() rejects FSCTL_PIPE_TRANSCEIVE with
STATUS_OBJECT_NAME_NOT_FOUND before fsctl_pipe_transceive() runs. RPC
pipe IDs live in sess->rpc_handle_list, a separate namespace from the
ksmbd_file table the generic ksmbd_lookup_fd_slow() gate searches, so
the lookup always misses.

Found while testing generic SMB browsing (Finder's "Connect to
Server"): every DCE/RPC bind over a named pipe (SRVSVC, WKSSVC, SAMR,
LSARPC) failed right after CREATE. Adding FSCTL_PIPE_TRANSCEIVE to the
same no_fileid_ioctl exemption as FSCTL_PIPE_WAIT fixes it, confirmed
by testing a build with and without the change.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5f82dcd9a0b55..7cc5ca6a12652 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9634,6 +9634,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
 	case FSCTL_PIPE_WAIT:
+	case FSCTL_PIPE_TRANSCEIVE:
 		no_fileid_ioctl = true;
 		break;
 	default:
-- 
2.53.0



