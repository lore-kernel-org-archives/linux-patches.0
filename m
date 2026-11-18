Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027436;
	b=ehVJpe44Q1EzSyLqM91Vs4iNSo3EquCtVnRKgDUx3CPBsRsVmph2u02MbX4mNmPkDWhi
	 3xv8KHJ5jAH5ozxiJFm7u0eAKdzI7KsIW2gzqR4Ot7e844yJPSoTAZovrdlr93GHaEXd/
	 kL8OdlaAReNBXaQpPi5sC8IX4G7/cI4zI4ar3xkPKCn5qEIvUhyNBFN4vyxSptlC9Bqx6
	 5bX3ydoFWoZuvTfHKTAq2BSlu3wy8CRfGob8MsOt9gIU1uP4nk9xJ4BrVZfrdVAv60ZZ/
	 DXzdIPH09kzQ18wGHVPXcCt3bEnz8Rl5fbQGcjSp6EPNHFXlxveMWlak3zaj6Z+Xp8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XznJR5nk8XA4IxC1CY5+K9LpLhlzTrD2nOpzpIHQs00=;
	b=YUtOa/Az5TYFOeqLsZ2HEYY5zos9YIaZFqg/TVH2CA/PkA7BrwlQbIOz85sYqnt3eOY8
	 lh8+FPburBrLWNwc31X2zcZQotTIUpqFuB0s8iDIMzsRS9buIYoFjnDdXU7te0x1mGz/t
	 ObiQCu1zlKdgKBTnXZnj8B63+Yv+ToOYmmcEgdCABRMom23nI8whR+2aluLPybHtwrdXY
	 xze4n2F6jhs/ZqINaVsSFJn+Y370CLp9m/e96ZUDTbqhzJXIoXOZhStDGCZUYaTPOeHED
	 nxQiJjDiA3Gzkb7mE5saNMtKeWqqyDzhgdOxQ9P4KXaTaJiEmrkKMQX2pPmXr9Fr1fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHpLXRCk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C2460A260D;
	Wed, 18 Nov 2026 18:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHpLXRCk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341261F000C4;
	Wed, 18 Nov 2026 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027436;
	bh=XznJR5nk8XA4IxC1CY5+K9LpLhlzTrD2nOpzpIHQs00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHpLXRCkTZNzZtun1gMgmctkKHYv8ioz2hZxrE0Yzh5yn3pDf/GB/dLxgPqcQZ1T1
	 BmA4hD40DRro6zm8OInoKtfN15au9e8aniwgbvA6oeGDjxAlZxRPs+VW5MIYjR+pJb
	 ku2AklEjE2D0SaetE/LDdo/1fBakWEtUPjrRtKl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Fan Wu <wufan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1790/2151] ipe: fix invalid sgid value in audit event documentation
Date: Wed, 18 Nov 2026 15:58:45 +0100
Message-ID: <20261118150227.025439871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dc7088451f9d9..58183f05250fc 100644
--- a/Documentation/admin-guide/LSM/ipe.rst
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -489,11 +489,11 @@ The following table lists the error codes that may appear in the errno field whi
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



