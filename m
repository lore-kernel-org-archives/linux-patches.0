Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057911;
	b=qb+IFiRkxt5uxmSsbEoe/DUGQSkdWVvcQml6HyXjDxRHWGF3vOeXHky3atT2HIbR8mEo
	 d1rTtatX/DS0x1oIKSb/tS14iAM2KZ1BzuTI8Qlr2zhKCNgBNEr41QMN2Ou6xUtdlNEkg
	 5Pgm4ETRWrRvQDZ+L0yRlW8iFEJMCMSXhfdD/QQeSzc3ZYlCUBqeG2IXewVOPV1XxXMQ5
	 KPjUJ+b4fQBJ7raH+n5IqF6M/h45fZFeJgggeCC9Q3p9ARIeIHa0JjtPS9vcxsi4CGSkN
	 331hLXomvNP0V8XbNpBLO12XFFu1q17UaOXAQKmN5YYbnRr+UQuAyB5bj+6noWeDoZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=78AkbjV5VI2u1LLFtK5HnVv+ghOWGd7pMGS6zXStTpg=;
	b=mRTeMppBpbauXc0VSbUI4YSm9byXqUj2urid3JBU6W3m2W97IeiJ4MVqQp3YRR45PTDZ
	 thCBXVgXbalzwaGTPRc3mnBFTKDvEn8980HAb2/cT0vitGF5u6jZjeB9whl2BR2CUS3Ey
	 7FjuZxIet8i+yZjHdQ+bkAm5/zOiD43MgrUmmSFGxJpsMtvnzyRqxF7tZoS7pwrw35H8B
	 THpdZE26Kzbbsg8JApEHzHV+98reInE8twOAwM6g+bZXRmoHOTjfya3lEneI834qG90Du
	 ymcNzAtiSo4Ge9nXgdRq4bLY9Oyv6P4RF85pin+RZTd9HixijlzK2cb/L0P86bm/k2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nDmr6/ZT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74952606A31C;
	Thu, 19 Nov 2026 03:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nDmr6/ZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23C51F000C4;
	Thu, 19 Nov 2026 03:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057911;
	bh=78AkbjV5VI2u1LLFtK5HnVv+ghOWGd7pMGS6zXStTpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDmr6/ZToZLszpswZZ+4/SvBaQ6UiaHlKhVIFSekGrBtKDEA1NBoWfOYzq6hKqeqo
	 Ht6zkfsh+g/dB2eZVhxICOgNxqGQ6Q9WGLiPm7Twdb9Rc3kPCad+fABupfYQiyrhev
	 qr5Tair8Rhoed9ZbaqAHLoEiiylXVaTy9a/E2Lwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0297/1848] nfsd: propagate SETXATTR value decode errors
Date: Wed, 18 Nov 2026 15:38:55 +0100
Message-ID: <20261118145924.484395434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit cfcfe0b38a66bbc4122c78a2b75e1b97b3534761 upstream.

nfsd4_decode_setxattr() stores the status returned while assembling a
non-empty attribute value, but then unconditionally returns nfs_ok. An
allocation failure can therefore leave a NULL value buffer paired with a
non-zero length and allow compound processing to continue.

Return the decoder status so that the operation stops on the original
error.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915125636.2849626-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2251,7 +2251,7 @@ nfsd4_decode_setxattr(struct nfsd4_compo
 						&setxattr->setxa_buf, size);
 	}
 
-	return nfs_ok;
+	return status;
 }
 
 static __be32


