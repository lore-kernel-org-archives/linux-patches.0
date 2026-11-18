Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044862;
	b=xfanOVRhBydLT2uDv88rdAGjsCovD6idkiwAIj6nHfQxQ8gs+2iBpojSenifSHL1jOls
	 7Q5g9YDn1QZzFcWEvkewTiTTKueV0DMnsQoYh2EMTIGq7jOtPM8XtjSFo0/RM0KcGbRk8
	 LJ8g1HJYEzL+287lM287SHaCHWIYfwbCZ42JLJBFVd0HkhBtgsDeCgyiUj3/ojWAQ6ZfO
	 0AWrF/R9nEm1LzJfJQm9eJcCa5TELqGcQwCdPijasl/A8azOMwNJ00lzuTWP5BkRXEugv
	 pKEY4cbP58hdH8eTwJI4gYedGtgsJfycV0UzpadvvthNsaNUc39QoDjiqyqqY4h3d/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vHiTD2yuoUofisEUZh1qlzKIJZWt9QvBBcEAKOznlyk=;
	b=tNrKgivugJ9Jm+eJyWWaQHPmBlI8S39MUm3trdRLvYY+T8MUvojCBjaVnqrsS5j8naKX
	 ++WYWA9K5Yt2IC2gEg56vb1JNAtfI/cbil88dr1GKmU91pAjSSKl1xE77Njn28c5bo8uC
	 vVpQGw+BY/sFugWS/5oljJe05MdJP4Mu4Nb2+wDPfF0xD2htFdbo0YcD1Zg6tlxrkuHRm
	 pCDmFAgCMTMMDbqLOtgXY57K1OV9m1pv6fWDvteBiY9pi85uBgiyC9293iaq7+btn7fJ8
	 cbaVFyapMTN6Z/wJ1DN8gBRdOvSJajnE+JANqzpeXe9ihQPiXEMmAk+kCCug3NqEXYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVAO56dy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6045606A9E5;
	Wed, 18 Nov 2026 23:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eVAO56dy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBD81F000C4;
	Wed, 18 Nov 2026 23:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044862;
	bh=vHiTD2yuoUofisEUZh1qlzKIJZWt9QvBBcEAKOznlyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVAO56dyXt6kJGhmxbGEoaoNZlnKQ1jak40HoFTAI14UY3p6+hOWtJkPngOTmbRN1
	 eo4JpgSATi5wDDwOSbk44rIPU6mryV35zKaJpUSifENPZa3HbpindAx8c2c1w+AKAi
	 ZbLQIBFkuiKGtF+PkAC8RMnQU3ausyAzmZ88u7Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Michal Simek <monstr@monstr.eu>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0716/2857] microblaze: Fix MB_MANAGER build with older binutils
Date: Wed, 18 Nov 2026 15:29:10 +0100
Message-ID: <20261118150227.327912018@linuxfoundation.org>
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



