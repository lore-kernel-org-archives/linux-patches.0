Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619122;
	b=y0Az0wKgxDzGBBmJGZ/MLOFg/yGCfAAG4imGOpZLZS9ph8PpcNDuke8Sfa9c8OzdVO/U
	 08v/0DsTeeBvA7NzsMLV53Y0ybamEjbsh7YGPEwIiL3cR41f+BFJ/LTK/InJWwDPhXfif
	 LcO3GSTexDhxB5hww+1oLJIfPT2EWTMwTJG2yFknzPwwQEz/pO7VD8V7ibtYQ57zFdwPk
	 /1yDHZcvMdhUjSMrHVEdWSekyQAzsWQP/m3lKm3P9ip+Kug7UbVAAVqEOtbPAjGY5Q8Hk
	 0Z/wFTFZfGENWE5DqzXW3nlIYz10KJDQlxtG4RwIVMNC9sWjL7fnA2nWIjHQFHgvQKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zB4pgLqo5Xl8I5Z9gPTIemyDZuzTr9dvNcx7PafQWHY=;
	b=1IcJKU6yxS59PN2SzTeKvDXacN8IyXOK+ZChjwUWZh0cueYfwazqBugRPqXOW0G5DMa6
	 B0rF2DKXxMghy5yHGAhkFR3NfACGqWgSHzvn0S9HI+rw11UMhB2F2dxMtRL8ev4C1HMpW
	 r4EZnyXhGcaNvxJd1bs0au6Cvn51sUnY1oZg44gJE6E/ec7F5B4yeZi7ry7oSYJ0CBO5v
	 E03VHpnMOTwg5qE290wTt5V1DO44gY0cULfadlXGpH3rx6kTABKrJhC0ae8c2a4GGDh3Z
	 30I7ZP9u/MT5ZV/QaZmBhTpS5FrCz7AIfUTQExo9DB56hLQ9QNjpqyAH1K2NT+B2T4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7tebG58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D07606A321;
	Wed, 25 Nov 2026 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7tebG58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A011E1F000CA;
	Wed, 25 Nov 2026 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619122;
	bh=zB4pgLqo5Xl8I5Z9gPTIemyDZuzTr9dvNcx7PafQWHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7tebG58tCfdHMKDUGjp6NBWupOZyo8kYo7xOSeUt3rhxbfdWJ0l26D/ChziLK+C6
	 Mg6RSychDtF3tTBMGV7JmS0C2fHXuVyIvclUEOS8XoblCHqRM7JXg0EUM7wc9qKfL0
	 kDMrUJY98cODvMW8hvbXSegrBXzRpaT64U1r9uLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0495/1005] ptp: kvm: x86: Leak clock_pair page if changing its encryption fails
Date: Wed, 25 Nov 2026 15:30:33 +0100
Message-ID: <20261125143833.341119600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 6a01fb125ba6474cb97f14b68fe5435d3cdd08e5 ]

In a confidential guest, kvm_arch_ptp_init() shares the clock_pair page
with the host using set_memory_decrypted(), and kvm_arch_ptp_exit()
makes it private again with set_memory_encrypted() before freeing it.

The untrusted host can make either call fail and leave the page shared.
Both paths still free the page: the init error path with __free_page(),
and kvm_arch_ptp_exit() after only a WARN_ON(). The page allocator can
then hand a page the host can still access to an unrelated user.

Leak the page in both cases instead, as was done for the same situation
in commit b9fa16949d18 ("dma-direct: Leak pages on dma_set_decrypted()
failure") and commit 03f5a999adba ("Drivers: hv: vmbus: Leak pages if
set_memory_encrypted() fails").

Fixes: 6365ba64b4dbe ("ptp: kvm: Use decrypted memory in confidential guest on x86")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://patch.msgid.link/20261105164324.23501-2-oss.patchbox@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_kvm_x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 6cea4fe39bcfe..811758bd8b0de 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -36,7 +36,7 @@ int kvm_arch_ptp_init(void)
 		clock_pair = page_address(p);
 		ret = set_memory_decrypted((unsigned long)clock_pair, 1);
 		if (ret) {
-			__free_page(p);
+			/* The page may be left shared, so leak it. */
 			clock_pair = NULL;
 			goto nofree;
 		}
@@ -68,8 +68,9 @@ int kvm_arch_ptp_init(void)
 void kvm_arch_ptp_exit(void)
 {
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
-		WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1));
-		free_page((unsigned long)clock_pair);
+		/* Leak the page if it cannot be made private again. */
+		if (!WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1)))
+			free_page((unsigned long)clock_pair);
 		clock_pair = NULL;
 	}
 }
-- 
2.53.0



