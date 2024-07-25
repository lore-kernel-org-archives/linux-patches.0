Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAAE11711;
	Thu, 25 Jul 2024 16:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721925998; cv=none; b=AiNq5xkdp/Gpgo+k3SQ8/n6wXGbaRrYAA154YTKt6hS17JfdPEVShgJA1aWsL6gthH6aaOz7FUcvw8PeXCYj4yLo4Sb1NKbXwYr9rkDwXeEforOiE7m2wD7jbljPsYxweCKg/mwJy2UzfjRWKSvFPx79/kYxX20AC25GeO6lUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721925998; c=relaxed/simple;
	bh=/7Rbu4ML4kRsbJRad543cZhmD9paOZgLU6Y+kowYtY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SmguDWzt90RbKq25MXc1Ni93bXNDab25MLDJDDJdQPWRGNIgh/6VQvUst+6mCPLCHzvSJ3wclmPfLcF1+oyJKyFyZRncc2Pkx0rlxRWaUc5K8Jq6qiYuT4666w+u/qs4izIOoZERUUT+J5aqUDLu911Ptmeu05spK3nHldCIpp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1PvZhZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1PvZhZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D6AC116B1;
	Thu, 25 Jul 2024 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721925998;
	bh=/7Rbu4ML4kRsbJRad543cZhmD9paOZgLU6Y+kowYtY4=;
	h=From:To:Cc:Subject:Date:From;
	b=h1PvZhZgH8kcPnC8qyftieGjKXoail1hiSOcrgQsp5jnkHRp5GmFpTA/xtx9axoe/
	 O4cnIz3wllw2S3A8P1UO/AkBAouJI5mdPwe+pQsNapAc88agw81qYQKEJ5jF/HnL7n
	 IpwHK//KO89g+JYtwHnOXGb2vZE0uTmyBY4H+XC9CrbJZJBcSdjpvM5stT7NcTwpuf
	 ElHJm3pucUHzlmkOuHG8sVLBf5F7GQjo1puH1fvCrPzi13g4glM63m/PsbhzbNmi14
	 +TUw8Za7L8QuVQbAHj3tBHxaJq4xSnU6XPwuvMpYIHPTp76QYAQWrOvmIT9QwJdb9x
	 /MMGuiMawn+vQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/3] SPMI fixlets
Date: Thu, 25 Jul 2024 09:46:30 -0700
Message-ID: <20240725164636.3362690-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg,

Here's some small SPMI fixes that I found while searching through my
inbox. I see you've already picked up the module description one but
I've included it here anyway for completeness. The pmic-arb irq domain
fix is the most important one here. Unfortunately I missed it and so
SPMI interrupts for newer platforms are busted in v6.10. Luckily there 
aren't that many of those devices in use so the damage was minimal.

David Collins (1):
  spmi: pmic-arb: add missing newline in dev_err format strings

Jeff Johnson (1):
  spmi: add missing MODULE_DESCRIPTION() macros

Konrad Dybcio (1):
  spmi: pmic-arb: Pass the correct of_node to irq_domain_add_tree

 drivers/spmi/hisi-spmi-controller.c |  1 +
 drivers/spmi/spmi-pmic-arb.c        | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

