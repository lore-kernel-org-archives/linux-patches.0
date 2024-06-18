Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE1A155737;
	Tue, 18 Jun 2024 12:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715482; cv=none; b=hmNJ/q306Mj81UBxkGPcfyPkPD9u8rmgJHDUiE6xWz5/dPOSWSiJYccWJS2PNV0GHTgM3jO1L5hTo3RLeNzYDe5hVeAMyg+DruIWm5I5eJK+z7QXDjBFP7US/6X6I2mkq3dne6JfST60atfqPv0X4F72fA2e1bwwCkcEZDd/vUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715482; c=relaxed/simple;
	bh=qyHanIN9B4pNKhh9YsL19+zpwG6ojJr1qW4c3sj48eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGmAg6T8+OudfF05X/JDzaAUn4R4uMaDGLSnLduH4GWOIITOQNuJo/NwezvwjmGT260XnEYw4HBwdrN7/8Jr7MGqgOWTU5hbBE7eZ0WbDPF/FAoj9dG6w9uLJV4kgMxIgrqU3kApyKKeyas61+AV6jHQKi4bcoHov0RU1nAnQRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3LAAfhJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3LAAfhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD486C3277B;
	Tue, 18 Jun 2024 12:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715482;
	bh=qyHanIN9B4pNKhh9YsL19+zpwG6ojJr1qW4c3sj48eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3LAAfhJXP7yLGWflg8zRv7hQnZ3/7ePcPTcbp7n2No819JVsa9BSfhpH0rRYSp0o
	 kWxIPWtNYuKEcSeS+e5UBybmXFuxPzu/klamODuBhtq9GF8JhDChb550FmKW3mLPJf
	 XI+wtUaW6xKH5505FWdMdzjCHWsGeR8I6CrlgiA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/770] lockd: Update the NLMv4 void results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:57 +0200
Message-ID: <20240618123419.763689871@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ec757e423b4fcd6e5ea4405d1e8243c040458d78 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 6c5383bef2bf7..0db142e203d2b 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -324,6 +324,17 @@ nlm4svc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+
+/*
+ * Encode Reply results
+ */
+
+int
+nlm4svc_encode_void(struct svc_rqst *rqstp, __be32 *p)
+{
+	return 1;
+}
+
 int
 nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -356,9 +367,3 @@ nlm4svc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 	*p++ = resp->status;
 	return xdr_ressize_check(rqstp, p);
 }
-
-int
-nlm4svc_encode_void(struct svc_rqst *rqstp, __be32 *p)
-{
-	return xdr_ressize_check(rqstp, p);
-}
-- 
2.43.0



