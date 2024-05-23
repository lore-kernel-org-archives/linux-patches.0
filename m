Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D7A1D545;
	Thu, 23 May 2024 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470625; cv=none; b=BXzJyko2LPQbMkOYDbcrtM72RyOCd/w0fjapZWk0sFdr2VF1Buatdp9EjWf43yMkJaGld82EqpFKmISJVTrIH/FGc7pHpnRH8gwLDkKjcHpbViTSWN5IQv/NO8VbwiOGMrIE9Haja4Ka7Z6iu8qvDRdEK26iJ4573IPoqmVlI5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470625; c=relaxed/simple;
	bh=hjmDvl1bcA5lsfJckDYAjaF44h0vtniQmJFR6c0BqAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eM5C6rsry4sk5WtDeZsh6kRvPjStgqTj8ZjLcw2BzmW69XEsZS4McUE94DdJiDJSDpMPXSptPZrDAR6anNgRImTxvBEzIMLrjZ2Dbu9BSbJitCW+h5MW1ncSlB4bIldXSR/vsrwyHRc17oi7GANxpQnD0iYsG59S5/GdWlbitHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woB+UQWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woB+UQWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934EEC3277B;
	Thu, 23 May 2024 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470625;
	bh=hjmDvl1bcA5lsfJckDYAjaF44h0vtniQmJFR6c0BqAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woB+UQWrblSetenN07e4JnW/Wrx0d3trC9uLpgpS+B9HEbbRFcju7Ni92f0JPHKXk
	 aNuaEY3cQFQaqv9pHtF55zh28Q3e9EmSJiUc2Bc24gDe8c5uuFLy6SPin/x+sTBLJ0
	 0xQWuR38GUbZ5NG2UF9XcktMbEP+BsCygFE0ghSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.lee@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/102] smb: Fix some kernel-doc comments
Date: Thu, 23 May 2024 15:12:57 +0200
Message-ID: <20240523130343.675565050@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 72b0cbf6b81003c01d63c60180b335f7692d170e ]

Fix some kernel-doc comments to silence the warnings:
fs/smb/server/transport_tcp.c:374: warning: Function parameter or struct member 'max_retries' not described in 'ksmbd_tcp_read'
fs/smb/server/transport_tcp.c:423: warning: Function parameter or struct member 'iface' not described in 'create_socket'

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 0012919309f11..6633fa78e9b96 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -365,6 +365,7 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
  * @t:		TCP transport instance
  * @buf:	buffer to store read data from socket
  * @to_read:	number of bytes to read from socket
+ * @max_retries: number of retries if reading from socket fails
  *
  * Return:	on success return number of bytes read from socket,
  *		otherwise return error number
@@ -416,6 +417,7 @@ static void tcp_destroy_socket(struct socket *ksmbd_socket)
 
 /**
  * create_socket - create socket for ksmbd/0
+ * @iface:      interface to bind the created socket to
  *
  * Return:	0 on success, error number otherwise
  */
-- 
2.43.0



