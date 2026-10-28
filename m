Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216897;
	b=dFWtaNg3nXecixfLpyQ/dPVIoZUUwN4+DWaE1Z9kX7UuoN5K0hmdipKT9215MeHr5nYw
	 3E6GRTgnPTz++H6jnrPQI9RQ2vCHwayF/QY1TEpmjFT5KRv0I/J8MCwXclhdPh0rbk9k2
	 oU6bu7IRKVPjl+6lNTkxBknYBuOCjVctpFWmEEuY2KYjSd4sANCt5sRFPHkeR3hCKTkuV
	 YqBxFHUmF6tpYqheXwNf3QEtL7+C8/3wfy2X1ajYA3zAeY9KwdGrKjUi2jk2a6gFUsyfR
	 vO6lNOCnsHIpZLuv5U0XOsP8sUThSMTi8UIDgnD1rMmF6Ik3+7kgs2ks5ZkDIo/ZAyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wfTi70ubzu8ZJJB/wifPBUKMzPvQxl5NziUaiywepUE=;
	b=XL3usMsFGruIBZXRkFrMG7ZMT4bxaV8xM5ozoje6jAM4bDerFnEps6oRxFQYJXu7vSJo
	 bB2rLhN7H8JqIZ8jUJkMujKuw6FfY9+4Bw4w5nR7Xs/L5JvIUQ8wOsYTsvNBKXXsmJW1v
	 G7rwuGrCx/tcSBz+RHAI2OMnaHlaAqTVQ6YlEW7nqoPOz96cSYg9eWYi0x9oamPvGaQAR
	 uFT1s7/N+6BWujtZrfpfCMgf0A7Udmf8jZb2gjw9oMpdl6APJZYPnLNNCJxK9hYliuD5Z
	 oWbr7Up9MgtA7e3ZuJk6kAs2KNj8hWeIjGlvn57Th/JnKhlIdCcB46iDRrF6695zY0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8EyDStg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC55606A31A;
	Wed, 28 Oct 2026 19:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t8EyDStg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1860E1F01825;
	Wed, 28 Oct 2026 19:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216896;
	bh=wfTi70ubzu8ZJJB/wifPBUKMzPvQxl5NziUaiywepUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8EyDStgoczaqdVHSwYC4gbuOHZkH62IOI2tMxSJCFRuxMnUd7bwjC3QjWGhUGevW
	 ZyCwHaz2Jn21J7KL4hspCI8+cP9RDAoxTWbNwC4B8AqJCVv2PXk3M9rdFJV6y8EMY9
	 jWdmbAEqtzte4K7GfZgxXQSqOH9ROLuxIYUPSgXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1717/1887] nios2: fix __wsum type degradation in csum_fold()
Date: Wed, 28 Oct 2026 18:03:33 +0100
Message-ID: <20261028170538.530737772@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b963f2345fa20417401c51a69dedb6a58eea33a9 ]

csum_fold() shifts a bitwise __wsum type, which sparse reports as
"restricted __wsum degrades to integer". Sparse only checks the body of
a static inline once something instantiates it, so this went unnoticed
until a recent block layer change added the first csum_fold() caller to
a file built on this architecture.

Force cast to a __u32 for the shift, as the other architectures do.

Fixes: eea9507a69d6 ("nios2: Library functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609222053.5gjiJjtb-lkp@intel.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index 69004e07a1ba3..b6b415ae17a08 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -27,7 +27,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		"add	%0, %0, r8\n"
 		"nor	%0, %0, %0\n"
 		: "=r" (sum)
-		: "r" (sum << 16), "0" (sum)
+		: "r" ((__force u32)sum << 16), "0" (sum)
 		: "r8");
 	return (__force __sum16) sum;
 }
-- 
2.53.0



