Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021228;
	b=wnUOePbnuwkgaqDCSI9otD0M5ppHMQGH8NC0Nu0BAc64PpgR7HrFKlhuM3d7aVnQtSbG
	 z2v5JoaZcHZ1bU4njphZNmCbAip9yx07anOziVeLAGMXN46e9PElwN3pCtufWe/wiSYrO
	 pdDun3taYG26e70M1MSWeTay7F+iqhuaoeU1XWP979geDr5yZ3ztIlwYe12eHH/+boaKe
	 XiQJNKL653N+A7ygW+hPDcWD7g3VDs7mTjaaXkrClWmu0FP2ZG5peMz7kU6FGAp1SUNKJ
	 uDvuLppPo8EJL5gfvbBjsQXzZxU824ZcYsczqU5Kdg1joRvBv/mYC8qptpQPjqg5kuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGqN0Blbpkr/+6XQtgF4LSiAD3zST47CxJVHOgQMemI=;
	b=OqiciZHcJXpaLK3rT8jDvihrxwu24/hvQTkg4bIW/t/p1viyEB0IVxxEY8L3CuxtqYwO
	 1b+F6V9QVBOETZouIpj1996SZAnrEJ5wPAypwZfrsi9+ExXmJ6wzHvAz8cXOn0l1hAUfz
	 4tj2uZdr3UALmDYuSCgoDUxQstqbrGWjyx0AeXiL6YvLVnzsanLHFNsClxNgYcuzf6xsV
	 M5MSd8o6oqcMbwDRlmA3qcU1Jk0uot4Kw+KqIBIsSkod5jY5tYzQyoc1HhsWZsBGFpMeZ
	 VyWP/L71JBV35StV8g2z/CK8CJ0g7OkRGgLBm1KUnCeCzuMebSggDLMsNHLJieYXhuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UycWzpP8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F61606A320;
	Wed, 18 Nov 2026 17:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UycWzpP8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F8F1F000C4;
	Wed, 18 Nov 2026 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021227;
	bh=SGqN0Blbpkr/+6XQtgF4LSiAD3zST47CxJVHOgQMemI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UycWzpP8nTLUF7XkUO93ZHT3zPiIT/h9I++odN7ry5UPAWr6n2hsG1LMVpHp8gBOf
	 Svmy2E957MDgOvet8Tf8rC9G5VVDUgYWI4NQzL1/oDBH7Ru8SJuKbpdhKGqG1jJdFj
	 DeO3SepA4d8mbF+HGTrIF4KwsRVXhbKbXoCKbSE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Fan Wu <wufan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2191/2651] ipe: fix invalid sgid value in audit event documentation
Date: Wed, 18 Nov 2026 15:57:11 +0100
Message-ID: <20261118150404.632782891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Ebner <manuelebner@mailbox.org>

[ Upstream commit edf43c031902787117822b23324cf08ccc023bf6 ]

The audit event example in the IPE documentation contains 'sgid=)',
which is not a valid Set Group ID value. Fix it to use 'sgid=0'.

Fixes: ac6731870ed9 ("documentation: add IPE documentation")
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Fan Wu <wufan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/LSM/ipe.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-guide/LSM/ipe.rst
index a756d81585317..bebf14fc24116 100644
--- a/Documentation/admin-guide/LSM/ipe.rst
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -502,11 +502,11 @@ The following table lists the error codes that may appear in the errno field whi
 Event Examples::
 
    type=1404 audit(1653425689.008:55): enforcing=0 old_enforcing=1 auid=4294967295 ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
-   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
+   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
    type=1327 audit(1653425689.008:55): proctitle="-bash"
 
    type=1404 audit(1653425689.008:55): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
-   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
+   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
    type=1327 audit(1653425689.008:55): proctitle="-bash"
 
 This record will always be emitted in conjunction with a ``AUDITSYSCALL`` record for the ``write`` syscall.
-- 
2.53.0



