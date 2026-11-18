Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039607;
	b=ORxOzILZcGPVaaeoEjaUgR2jH78J9+Dr7Ncs0n5ZDyTm1mnmb0yZX7JbLLV5sq5nipDh
	 VD93Zyl7dTs3oQah/X0GXMNuC6EEFyNmTJt6Gl3LOmP6YVkRrwtrgPWvzdUE6Nmou3deq
	 AfkD9HswXygUsjRnqxteersiPz3MJsafyrDq9lRcMmRXYW6euBNUumOEBZTzxW7ZsaUYL
	 BISegr5GP19HOFxUOcPX286A+rXTlvWsXVP1hrbw99f1YybkQv/wDT+Busv0iEQoUyekJ
	 lRXql1QSsn6pGTexQ154ISSgqqXH4z2ZzIYjt9E5xo8uMiPhrEJzFDg00+v1UVKiT1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YRp3uzb8WugFfXC4uBvXuFFyfqpyZNhRFZB3X68IvrE=;
	b=Lx99CXe9pVWMR0pI5WwGhP1p83eancyv/T4KSvFht4ZpQ7H0sPVyNGwtHY5QajL+KJvL
	 mch+O/i75NIx+K+5CNNmug7KpqkkfiirhlJAv12m7w4EpyUn8rMx+TVuN9UHLHqeDszUa
	 C77pEck3yuiLozcBVyWVJsjOhSwr4Z5sfqgcRWCZMqreBdFB24QZdeB5lc5/Zt68HnYSC
	 uhTVTsiJRH6J1hwONpNaxMURBXmrYxSBKZcrUuKcwCmCti00tpPDSPJlgg3E7twgvWeb5
	 QGDKADENyrtV3wb/w6EEHQj8zMtijwf/IRS11TtExZM6WnBcr9i1WcDTfWH5JTjxNDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxA0VSOJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E18606A31C;
	Wed, 18 Nov 2026 22:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CxA0VSOJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7383F1F000C4;
	Wed, 18 Nov 2026 22:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039607;
	bh=YRp3uzb8WugFfXC4uBvXuFFyfqpyZNhRFZB3X68IvrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxA0VSOJ3xsliYYDcVOCWoGYJ6ydfT9PFaFKh1DOkWwYz+TiCObkbArcdOM8jzf3N
	 QJmfSYIfgzygYlJ5STQs5r8zE23OfkT+ScwdsIJ9luEIrGoJjFfgA/5kSQ7tFzpEzw
	 JJBWqZRyxpoDUY549y/vmvYvKfE1xAmJBPdk3+jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2161/3318] regulator: ab8500: Remove stale expand_register kernel-doc entry
Date: Wed, 18 Nov 2026 15:46:23 +0100
Message-ID: <20261118150426.839563084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

[ Upstream commit 0991f3b4624ed713d1d5eb56520c1c9b2deaab7a ]

Commit aeee55b76bfd ("regulator: ab8500: Remove unused embedded struct
expand_register") deleted the expand_register member from struct
ab8500_regulator_info and, in the same hunk, added an empty
"@expand_register:" line to the kernel-doc block. That traded one W=1
warning for another:

  drivers/regulator/ab8500.c:196 Excess struct member 'expand_register'
  description in 'ab8500_regulator_info'

Drop the leftover line; the remaining @member entries all match the
struct.

No functional changes.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202605160857.ZIE3nO9J-lkp@intel.com/
Assisted-by: Claude:claude-opus-5 [kernel-doc]
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Link: https://patch.msgid.link/20260802013304.7-1-bbnpreetsingh@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ac72c091a981 ("regulator: ab8500: Add AB8505 VAUX3 3.05 V setting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/ab8500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 26accd604c395..ca59406d42a85 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -173,7 +173,6 @@ struct ab8500_shared_mode {
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
- * @expand_register: 
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
-- 
2.53.0



