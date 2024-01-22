Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0F05479F;
	Tue, 23 Jan 2024 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969788; cv=none; b=kbQ1WJv9m26eSZ518Qe877wH2zdGU1Bezqkjsclve50JWkD3C4ZDEv2da4cff0EhFH+YARvxMMpv85kzbZ0v3Tai55yhQY7B9Nwy5qz7LXwXZaY/2FdNiDDLip948LoLUgxK79yiiJewcNJOu5nMEfszaU5nWgCLMZlEZYacxfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969788; c=relaxed/simple;
	bh=6fRqbbtaQGoMa3vkoIMto2FH3+7EF9+9AImlOTNifHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niPydcSNd+2QQ9h2OFcYL+9o3JSdLuqrl2H2fV66Tlk3g4WOi17WV/UkQYycZ8O3Inw8KwvJXeMuh8whYn6wkQKpts2+RhV5wa+wcbpA7w41J18+OFUFgQj++Zpo20yyABdk869T5/++18kCheakxaliJ8ypuJoYfJC3/oQUD08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrgOW+3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrgOW+3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD3CC43399;
	Tue, 23 Jan 2024 00:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969788;
	bh=6fRqbbtaQGoMa3vkoIMto2FH3+7EF9+9AImlOTNifHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrgOW+3ZQTgiN6vCXteSGKPMk3uULhQst0xe6WsGrLXXKij1liNI7ZXhs4wXkPrlB
	 BPXhMNEZYiL/fN5DWdPcvFF8/JtgUWWjs2UQT8xOBgKS2o1oJvv/g6jgMNKokMDNgF
	 XhoM/tiuzLUj0d6TVrdYUnh7AI9XcMYlU7ZtZ5hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.7 425/641] ceph: select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
Date: Mon, 22 Jan 2024 15:55:29 -0800
Message-ID: <20240122235831.291354524@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 9c896d6bc3dfef86659a6a1fb25ccdea5dbef6a3 upstream.

The kconfig options for filesystems that support FS_ENCRYPTION are
supposed to select FS_ENCRYPTION_ALGS.  This is needed to ensure that
required crypto algorithms get enabled as loadable modules or builtin as
is appropriate for the set of enabled filesystems.  Do this for CEPH_FS
so that there aren't any missing algorithms if someone happens to have
CEPH_FS as their only enabled filesystem that supports encryption.

Cc: stable@vger.kernel.org
Fixes: f061feda6c54 ("ceph: add fscrypt ioctls and ceph.fscrypt.auth vxattr")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -7,6 +7,7 @@ config CEPH_FS
 	select CRYPTO_AES
 	select CRYPTO
 	select NETFS_SUPPORT
+	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	default n
 	help
 	  Choose Y or M here to include support for mounting the


