Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214210;
	b=twbAbz6Elqr4qE2FRh3X5ChUxC+NHZqXPOtDTo2+5b/roENenCOVh+hXuE6J+u1wfZv4
	 T1n2ZxvDaM3WP2wFF9zMhKskZY/P4UjkLRAV2RP3hjDfxk5f68a5P+GhvJjdT3ZzA5VKH
	 P4kxXT/ujfo28CTvCz1qU9z6r7ubmVRFsywXwMb3xT5eWr+0iFVrdfHH2z5dimSFvFuBz
	 KW9BGDgkVml/HBX929Kg3WPOjKM2GduwZj9O1DydZwAIdY81nljFddmNQLvwaF8FGr+eP
	 sapWwhpjKVcZthVhyUligmegCd7ngTHw7qcAWjOXrurGWAxMK4iFja7pb6C0sTqKqgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jwEotpJGSOKYl21yWGAPk/J3twzjkInmOJPog4dVhoA=;
	b=FmXHFk4S49/0gavU4zbVqNzXhSTIpEraR6NzZYkQeKr7VvLVG9Tqd2dJZYvv78ZPif/7
	 pKNc2afVJ4wEw15EJuH1uZa5zmIGwLyt9R/GwlShY6q6DtUpnCzvTSLt6GoFMgx5D8mt0
	 gzzDvaYdNA3hsYUYNdywl3LaR2Pz5MD7EnKhGcaYwlmxkQXOQS2dxBj4YHYuKBt8RwT3o
	 ZlQcFfOFTgCLeBtojLLrq11uwfWWbYUp46eDxzXbqsqmnRzxCR9AzpXAG+M2OD6GYz3rc
	 HbUnwzDOGRrRV54CmTQoST0gJ+t/qzEUySt4SUAcE3tN8H+tOT87PVhFc+Q8qyR3ZjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uf8zpO7e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E377E60A2615;
	Wed, 28 Oct 2026 19:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uf8zpO7e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F3D1F013D0;
	Wed, 28 Oct 2026 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214209;
	bh=jwEotpJGSOKYl21yWGAPk/J3twzjkInmOJPog4dVhoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uf8zpO7ehM/Ky9Db8yE4SX27Wso9DPg635p3DOsHRMQ9hNna+UalZKIt/nzp3j3IJ
	 7nd23hTq2NeKsGPwaMYUKFb77v6HG4KWnaYQ+4JiRfOBgxKtmw6XpfkllUmu2gf2Jn
	 yMaWtqvK36BIY6fD+45n1aS7clAUh1ZxvU28bXJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0779/1887] ksmbd: prevent rename with empty string
Date: Wed, 28 Oct 2026 17:47:55 +0100
Message-ID: <20261028170517.165908920@linuxfoundation.org>
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

[ Upstream commit 53e3e5babc0963a92d856a5ec0ce92c59f54bc12 ]

Client can send empty newname string to ksmbd server.
It will cause a kernel oops from d_alloc.
This patch return the error when attempting to rename
a file or directory with an empty new name string.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 561581c0f26db..16477ad9dde8d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -665,6 +665,11 @@ smb2_get_name(const char *src, const int maxlen, struct nls_table *local_nls)
 		return name;
 	}
 
+	if (*name == '\0') {
+		kfree(name);
+		return ERR_PTR(-EINVAL);
+	}
+
 	ksmbd_conv_path_to_unix(name);
 	ksmbd_strip_last_slash(name);
 	return name;
-- 
2.53.0



