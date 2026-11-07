Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063818;
	b=zWKO8AbondWnLVa+GgVHkhei5lNdZfi+jU6cZGAanNu5/RNKnwmwqYzbUDHKeA7DuAPL
	 LWD3tLiqt8lXpY7dhIz1uxZhNRrK4w72IT2gEieWL5ZN0Stj1Wz7tveuVmOfEY5DwCUhQ
	 yc59EpP4DpbPmXkQsfGkwZ+WqppllG4ylC3LSqdzWTDOaSQcDqI8pVbn4oyjJWQFMe32b
	 OBvVJ+HZo8bBy/ekzKnSvTPYXGnQTwQhl9K7HK7oFZbYwzSt5Ay5YEsctfqHGfl/KOS/R
	 HgwcHjc7wcMgUpYICxV0ljvVkWTR5UaaTSVbAjt+/2EjvXF86DcMfTEw+oQAYBVbXCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gb5YHOvy1HQFhlu07qL7sQBxXuP+6eZS1RKTcFDEYEk=;
	b=NzJO6Cc2zkGRAB6yoRj/CTWoMZq1Aj8eToI6BWgYaPeWG7mzO4bNBew2L6BQFacSgnVQ
	 hdWcU+TQXBmkhwqBOz5fKmyqRNDsaZgTtU5HCSglT5z20LYwi33vRz4/UZn9iDIgnSpIQ
	 3Az7zw0eCXFoUXj8B0KzQGkVX6njhqHDJqGFpyj4piYuQm6lShy8TBcbvcw6Sh+uOT5gv
	 6nJh/NABJfQpwS+7PZpJStbsu7lLlYUtUAWtRsyLCidHyXBjza7TYPbPoil/tSWRaVFN7
	 BYde3/ZbyEyhQuMdwN6+MjoJ6Mk2VGwsbjozEPx5KQtzH4zg/z+qbAb/eh9+OXDh8Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4oVmVYC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDBF606D822;
	Sat,  7 Nov 2026 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r4oVmVYC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7CA1F0089F;
	Sat,  7 Nov 2026 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063818;
	bh=gb5YHOvy1HQFhlu07qL7sQBxXuP+6eZS1RKTcFDEYEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4oVmVYCZqncDtIz76l0bQP8Pj6Kha47gs5XZ6hbvY9UKB6LZCoxa69N/Efa+0i0o
	 BjKCcJH8ptBivKyfT17KPFRCs6PEqpJ1v0uG0LaGwf7x4/c9aKOLGSGYl9b6ntgI//
	 zqLv+nYIZRLJTyzUFB/L1wUo0oUopAa9Z2SdsZRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Michal Simek <monstr@monstr.eu>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0035/1257] microblaze: Fix MB_MANAGER build with older binutils
Date: Sat,  7 Nov 2026 08:38:51 -0500
Message-ID: <20261107134940.374664089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 79c8aa4da3d5453dd956d2170d1c9c716311ea06 ]

Commit 88707ebe77e2 ("microblaze: Add custom break vector handler for mb
manager") added the suspend mnemonic to the MB Manager break handler.

GNU as only learned this mnemonic in binutils 2.42. Linux supports
binutils 2.30, where enabling CONFIG_MB_MANAGER fails:

  arch/microblaze/kernel/entry.S:946: Error: unknown opcode "suspend"

The suspend mnemonic is an alias for mbar 24, and both encode as
0xbb020004. Use the underlying instruction, which GNU as 2.30 already
supports.

Fixes: 88707ebe77e2 ("microblaze: Add custom break vector handler for mb manager")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310310151.UhB396Qs-lkp@intel.com/
Suggested-by: Michal Simek <monstr@monstr.eu>
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260813024026.5402-1-kmehltretter@gmail.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
index 582d7256d8154..ad44341a5dbc7 100644
--- a/arch/microblaze/kernel/entry.S
+++ b/arch/microblaze/kernel/entry.S
@@ -943,7 +943,7 @@ ret_from_break:
 	mbar	1
 	mbar	2
 	bri	4
-	suspend
+	mbar	24 /* suspend */
 	nop
 #endif
 
-- 
2.53.0



