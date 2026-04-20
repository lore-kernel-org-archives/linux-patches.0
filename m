Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66C13A542C;
	Mon, 20 Apr 2026 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691023; cv=none; b=kffMzyIIrGvgiZG6OXpci2XoYUCmkuuyCfg+Z7JNTf7o1JUFAMNpB5uCobTQlZRVm8GDnD1W5m3iao2Gb3cEQxWfrFGAYN4tkMqAUFJ3gStVdqo6peoorgn1C7VD7Hcl3fOANI/87DLuakeyQALxUOYmK+Zl4ofjOMg/i1106p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691023; c=relaxed/simple;
	bh=OzW7wDv3OMl4BXDqJdUWvmrcdA8hP211SQKOFii3JOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhYn+y7TukqaZwALvPKYF4moXk0Llj4MMRf12hULK50OeFsN0xPtJj8t1mlP8QkNVztHuXc4fDVILQgoKy4Rfv7O03woevHSQi1NlNUmsb/xbQ6CUdvoj+beA0kisffe4gAhDPbVN/6M3wGbmrc5X+WIZh/NbEghYgL9JROqQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5X6ovMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5X6ovMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B60C19425;
	Mon, 20 Apr 2026 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691023;
	bh=OzW7wDv3OMl4BXDqJdUWvmrcdA8hP211SQKOFii3JOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5X6ovMZ5YyAqPZ4dHtdQ1c6NgD0nKSzCp0QZzqRo53xaIIG8BaCgQgJrd5o8PXBj
	 bEjkLvLkBMhoY2t3szkX4xFevkgNvfLyD/sjjMps+AhHW/UeCCU5rL4EkjuRjcaCKY
	 4uicgEhVI35m2TIMSB7xeIkPlA6TbcCR/dLkpSgOrDLe5luzRrrPdCsIlH1hyVX07O
	 jDAxcdtbGUGzyovmZ3hmZYmgNS9kXlziDslpHnG5GfOCMDdfemAqZa16P7nOEq2Vd1
	 mZc0E8SfgsrGoXqqTQLQf4Io346IMvbrfdo6Wd3GEgikUrTEWokW4t1+PGAaHb5Amr
	 L6MUj5pdTksCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mika.westerberg@linux.intel.com,
	andy@kernel.org,
	linusw@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)
Date: Mon, 20 Apr 2026 09:08:35 -0400
Message-ID: <20260420131539.986432-49-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a4337a24d13e9e3b98a113e71d6b80dc5ed5f8c4 ]

The 1kOhm pull down and hardware debouncer are features of the revision 0.92
of the Chassis specification. Fix that in the code accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/pinctrl/intel/pinctrl-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index d68cef4ec52ac..103eccc742a53 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1606,7 +1606,7 @@ int intel_pinctrl_probe(struct platform_device *pdev,
 		value = readl(regs + REVID);
 		if (value == ~0u)
 			return -ENODEV;
-		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x94) {
+		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x92) {
 			community->features |= PINCTRL_FEATURE_DEBOUNCE;
 			community->features |= PINCTRL_FEATURE_1K_PD;
 		}
-- 
2.53.0

