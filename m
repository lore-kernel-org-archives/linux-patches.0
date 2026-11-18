Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045188;
	b=btqyVvxWtUlwV9uXKgjD/mdMy0f1MpeJsN6W9TWAvGJ7/PhyHgfw5pObDwEDuaBPAjoD
	 SEdcLttj+63QtGZLziZI6kjaJ7tbJyiW5JxiqEpqs2zoIlmxY0vHlLVNPqUtLg+HYaR3U
	 1gA8wEWfg9fid1cJgqonEk2d2b9mFIO+er+zverK71MlqMJ6YM3G61t0PKQ5030t5SewQ
	 bdgvvZfeIajY3z+QRsYfWqCoK6Izk9+n5iuJLI2A5Imv1gGZYzZwRYn7tokN3+7FNKWQh
	 gRRNOaaNCH/c9YkV159+XjlpSwY0ULg9r5lcrOYFeUp6w6f5xeqJ1ragtDSzM7kUbpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kvUWkBTpHfFRfT3Q4xTsD1AG97xH3gClc61ovvxyayM=;
	b=xXKWDySoxTUUd1LcyXJfZJncehxArzQfLlGePskwNb4Zg96oaYbNSf5rEa/71qQbevNW
	 Jqc+YarVZ/r3otQdPKaSoaZxmz8kM30mRKDK+3C5s0SHfOLayMcmykHN02ZfX18uDqv/P
	 0H8uhCocCzwgoDRlx/6sxH6paG4bLXmiwnYdkqM1YN4cibvqZ0JrlJ+2eiRbZAjqZ5BUg
	 d5tw10j3mZw67wz438gP5LgJCQyNRZsSTXZ+HuUlX/zrXUU6nZwcojbsd3IamTle4MhkB
	 nsjG3B8dqhFdsi4ex76KRpkLcsJELkEJMGnFJyT5XObbZ6DfeHp8QbgS3RZJDH9Pbzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5gK4Bk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8D3606A320;
	Wed, 18 Nov 2026 23:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5gK4Bk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7691F000C4;
	Wed, 18 Nov 2026 23:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045188;
	bh=kvUWkBTpHfFRfT3Q4xTsD1AG97xH3gClc61ovvxyayM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5gK4Bk1KaDO4lue33IFhYz9mX6+yPPtfExjL/T4PPNr1rVRhBiGLZwy4G5a5do5C
	 sp9sWCnNHUbnsqQPVW4ufKaByP05EVkmqu6bY4afKOevXCkPEQF0ykvpCQ0MhovYrk
	 HVhBqxcWogucd6FzjmYY6ChUEvdmtx2daFz6AZDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0787/2857] fpga: Fix of_fpga_mgr_get() reference in fpga_mgr_lock() docs
Date: Wed, 18 Nov 2026 15:30:21 +0100
Message-ID: <20261118150229.903947886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit ac02245b0ca28388ba16273f2fa683c90da2e5dc ]

The fpga_mgr_lock() comment lists of_fpga_mgr_put() as a source of a
manager pointer. The helper which obtains that pointer is
of_fpga_mgr_get(). Correct the reference.

Fixes: ebf877a51ad7 ("fpga: mgr: separate getting/locking FPGA manager")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260912100937.86316-1-kmehltretter@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/fpga-mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index 0c71d91ba7f6e..99862f6feb44f 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -744,7 +744,7 @@ EXPORT_SYMBOL_GPL(fpga_mgr_put);
  * @mgr:	fpga manager
  *
  * Given a pointer to FPGA Manager (from fpga_mgr_get() or
- * of_fpga_mgr_put()) attempt to get the mutex. The user should call
+ * of_fpga_mgr_get()) attempt to get the mutex. The user should call
  * fpga_mgr_lock() and verify that it returns 0 before attempting to
  * program the FPGA.  Likewise, the user should call fpga_mgr_unlock
  * when done programming the FPGA.
-- 
2.53.0



