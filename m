Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023448;
	b=o9SCzqiMBqOelWloM127SQyefTWnnqH21jRephSwuLZTq9LoBzbTLFJ8tS58dtAUn5Jb
	 4gvQMjsEn3l2OHuBuWhj0s/SGzEInVo/Y3ek3rD7i0mnqgoTiwqaU8ShIHvGn8j/LJTzJ
	 chWydsE1r5Cko1yZQOtfGFJeL4wsrciwjOAT5VZEOwTk7ptSQU2AcuLocqtZbE2n0+smP
	 BI+gdPDXk4m2gC5m6R4JDKky/WH0yFe+pQY0nWl6aJ3YdxU0SqAcrU64bAwJrAG9gyzP7
	 wkvv/zpfB/R9esRe8G5yJr9TnCIWMIpOJ7lg7j7NDn5F8Kc8AyndqcLnay4141ARelQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WH5Qf9tommeVbdw5kxRSgJ1vYfFhGb6YWiqjIDGxCRs=;
	b=AsmBglfrmxDh2TVN/qluYQ/e8BI23QNoPx9ndmd7wqRwJCSEpQhf65nbrPhww3D3z0UI
	 I8pXWICyJrY1Pynt5CdJyCa/JxNHec5SxDqve48VO1fEjQq5wvjwQcF6hvraw70qecUaq
	 qgWGVBRUrrzVXpL3tprThgkrsv5ccdJHwSQOeL1io1+itcyLiPxclL3Nh9XsjrO7pVJTb
	 FO447hgxn7Rgcpv6ZUAnfGfHKqZBt2s3AWaS7UZflNtOjXMbseZIsC7G4FQTCRfcbbokK
	 D5wbVir02MufsO75Npgo34zTL8s8ZINDC/0iRYq/SBH2tJ3C2ug/4Ll3rUCuQAfQ3SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfhIbiJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7580D606A32A;
	Wed, 18 Nov 2026 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfhIbiJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DC01F000C4;
	Wed, 18 Nov 2026 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023448;
	bh=WH5Qf9tommeVbdw5kxRSgJ1vYfFhGb6YWiqjIDGxCRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfhIbiJiL9VlxGHhRGQmu1v2MWhOw2z3aLsov9GljWSAu4TSR9dAe9jbfhmFx/yxO
	 lgiXwelAYGAlX2etqbbaYtmcTP0Ckv9lFVuQPp/zfLSwMz0LgvP6Qc6Lvo4d2RyB3C
	 dDv+4u1yNW209FgzHnAlf8XPmWzH48+ly+tbc2Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0372/2151] regulator: ab8500: Remove stale expand_register kernel-doc entry
Date: Wed, 18 Nov 2026 15:35:07 +0100
Message-ID: <20261118150135.636281898@linuxfoundation.org>
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



