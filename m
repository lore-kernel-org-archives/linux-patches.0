Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055076;
	b=Dz8C5UTYHEkSYaYjv8Rl+GwFlAhH2rRpO9eLPw5WL32MQ0thQ5EHvewO9Ged/vyy1TsZ
	 RSj2FbkQQ+tOY8xsU6o+aiX0zuRKAOxIhTG47Xir0j+WKrjiC42gXHM6uZtdhFgLg5fZI
	 E7juuC2rOZzGD+u2tGlpy1qltSpUpZvBm22GbmkzVma0PI3Lv3VooM9L82FEE3Z5E0Fjz
	 f5kHYoESkW5JMEDzwIkTziLOTyiD8c3E+tteMI12lH59THvDWVoF88XvRYIKcu80zLGhq
	 SkwOXPB0mdNNzInWOLMOxnmqqCsWczmSsSNIujDp/770vKgBndrKMrej+o9Mkw0f51Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+miUAVw7L8OqifA3lCYTshtA6bv3uzQXlT+ROnaI4HY=;
	b=gbTML3+UlGrKbRFkGSEdyY06MNnHefx0Hy+N6Vny9bK/LKILxjO/fUBExyH2hTGFfk6/
	 3Zm13UxoLTTvR5rGZPzltEsqwnMGSkqcInNirFPimhNsBYZGiLcAj1ABSsPLptE1zFslo
	 IT+SRKKDDo0NqnHp8NQ3r6d3Zc+FBZv1MRku2F2eo5gmcDJqabFfr61eqnktW3yOLrF0q
	 zGvir+xvm3FJGGezZZ9rZXQ3pINyEwdTQrAD4MQpYfh55763280mb9Ix/ZzfrdEMcMycV
	 /MKKSTMyG2SHFxV3rmCUEZpqr4RXb83M/0oZrTmWy/oZ/lIt37VH3Fs9u8rbeGqIpvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qp9mtaJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF67606A325;
	Thu, 19 Nov 2026 02:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qp9mtaJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5701F000C4;
	Thu, 19 Nov 2026 02:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055076;
	bh=+miUAVw7L8OqifA3lCYTshtA6bv3uzQXlT+ROnaI4HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qp9mtaJBQK8v/wMWhd13r235tbFbBkxXNY20vgkR1Mk9WNjgfpLoKO9yWOO2Q498x
	 iNOUiWpTXKyjPL2Q5h4tCrwDBAoZRHY08R2OdWjmsKmVyKvAP3VJUUz+5V2nH0CkEg
	 SR6evO5qzQ1d2kas6BxsRQzCmF+qEz0TMXfSugis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1465/2214] regulator: ab8500: Remove stale expand_register kernel-doc entry
Date: Wed, 18 Nov 2026 15:52:21 +0100
Message-ID: <20261118150109.798536591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d603d7b9f6821..066ce04cbca4b 100644
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



