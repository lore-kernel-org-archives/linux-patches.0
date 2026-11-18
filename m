Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060498;
	b=3/E/u4g0nezyxQujXF/0KCxbG9nmsiKk3sCSOFpOkujTSxmW2QjF/cMXNVlYxp2aU2An
	 uyjXur8TG4bCGoKQYNkpilu6DBHIqRqF0Ls9MRIld05fiSG6DOT3AI+9WApjPD+Fb12TI
	 Vs4kmE1r5evQNFr/ZK//Mq1tJwg8le68G64+1U0iuUmKUaepdmyZlAKaSMW6IoUaFyKg0
	 jfFjhd2TVwSgaU016PNjCUL83hCBn4k4CuzyBxUPtIMeXlm1qWLOj30kuaJCBSyHhrgbl
	 UQy9eELsXllSJbidIuyNk7x9EqbhQJxwXQUc91Z00nRV7U2mFEHezDGXWbtgfS2YgIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h4mn81IPYfBX8abNXHc/RkqcpF981Hd9fCJ4gnC29pk=;
	b=uGQV9w1QujtpvhMBD2C7jNHDd0E+zf7q1PPfx0DGQFy1ldx6WccsIZhnaiJK7Pn/Lcec
	 3rX78KbYj51V9o9VVWzblznvJiiY4+zzjYo59jAA3FeCtRoZ81E2VNb4dllLEtxcGuDEc
	 XNNUWly3j0PrrJ+/08eZ4s2Quom0sG/Ee8juMA4IpPK/WZiuni6pSKQIMHAOEHI14jYFh
	 y3uGBGfQJWWwAmc2MSl0g6JHzBO4rL3kcuMuppFM9RtoutY27JJOnJfkOZdbOrSKukF76
	 /JWhg5ZP9BZdIVUp8vmWOkdanHDvP+7BG7gTp3hCvLk3T1elJ9JMofpQaXl25/D7Lng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsvRop7o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB57606A320;
	Thu, 19 Nov 2026 03:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dsvRop7o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2A31F000C5;
	Thu, 19 Nov 2026 03:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060498;
	bh=h4mn81IPYfBX8abNXHc/RkqcpF981Hd9fCJ4gnC29pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsvRop7oLXNcu7OhHEc5h0qI7viXKIsAq86vFR0riKp8MrBS/lmMhERHDsRmE89Pf
	 A9CNo0QED8rj2hKNgJyfAwZ95he7oPgiON0S4utt/o6th7eYKdHWhRSK3rvXul6nbm
	 EYnIKLefiG+mYSHtsu/t7LBO9yH7Aa44jbJ2+9KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1220/1848] regulator: ab8500: Remove stale expand_register kernel-doc entry
Date: Wed, 18 Nov 2026 15:54:18 +0100
Message-ID: <20261118150011.030479348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 66f71bc705d95..b5307bb5e0342 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -59,7 +59,6 @@ struct ab8500_shared_mode {
  * @voltage_bank: bank to control regulator voltage
  * @voltage_reg: register to control regulator voltage
  * @voltage_mask: mask to control regulator voltage
- * @expand_register: 
  */
 struct ab8500_regulator_info {
 	struct device		*dev;
-- 
2.53.0



