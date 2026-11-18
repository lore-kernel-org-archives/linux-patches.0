Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048135;
	b=keaYNQaw8DgnvXjftJv05mX83xHUskOZtRzpXatg/MVUz98n0lCndWCIxqyGxCp+yl0+
	 ggEQVEFUG1oGgd4UNIsxAPqneIT5/qFg3BxiUfreAZ7ft/KTqphf+tYonUitWccZAlSxb
	 +2ae4WLJ6CQF0F8mlrZ65VZL7ItRcA5JP26sknKPe1x/gTjhjKwUmOYVSQkjlgeL5OCB1
	 ewEQjAGoVoJwybGgK8tBHIcqiUjLXyCX5Tn6GorZ5Tv8kkKH+uNL6zFUG2VqRkTV+BKl1
	 ZqaNGHpI5uTXQ/JySKkzkZ8wEPKcH9hirSRADm6l5tH5O1gI0IFyoAEYF43qJHFaLBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zaupIa7SYs+pAq7KApY9Qpd7f3j1FTsH61SD2Orz2LM=;
	b=G3kiNAAvtTRRWaNeQjXt3yM6LPg69A/dMiwh67zFO8HWnAt3yCx/QiBKSVlCWDduRMDo
	 cS1wez/NZvj9Bl6NROR/byjvYeTpKLrNNxjTxpqpt+e8HOil4nNC0irRh7oNQ4U4M2TLg
	 Kts2r4UAVnPnu3diQMlMycyt7GgCX4CwMJcQzZKJAk0aa3XIqNWJArCqwNU5+kPmpxpEC
	 YH3mpUgJHgv82wO+lUSUS/wWz53sY+Hac6OFIH4taNwICuddufGnhJKEix8y6nMvGXtHA
	 +YP4J7XE5P7lXo5T4BzN0vYGLaeNX6h1+mhyU7n5wMAWKoNCDe6HmmcKyeZ8DsZzmKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbBHllIj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F5F606A325;
	Thu, 19 Nov 2026 00:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbBHllIj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9141A1F000C4;
	Thu, 19 Nov 2026 00:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048135;
	bh=zaupIa7SYs+pAq7KApY9Qpd7f3j1FTsH61SD2Orz2LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbBHllIjciIooyZzJklNpzLkqjlQaPKu0DKzuuwclnoqpkoBIQFiLIARDnYOEEPpw
	 lIsV58XhVKDJzhCqnXRdBTgN5o8N+FcC4Wh74YhUg/+HlueV0WpXL+OvcVkYrjOpE9
	 K6v/adDtfFzx4xk0rv2ACcWZN1+E2t9grWU9fx1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1886/2857] regulator: ab8500: Remove stale expand_register kernel-doc entry
Date: Wed, 18 Nov 2026 15:48:40 +0100
Message-ID: <20261118150309.135224095@linuxfoundation.org>
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



