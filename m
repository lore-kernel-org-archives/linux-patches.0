Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8681105
	for <patches@lists.linux.dev>; Fri, 30 Sep 2022 00:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5B9C433D6;
	Fri, 30 Sep 2022 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664499019;
	bh=+6R03dn+E9VnNGIMblDFkT8hOzlRK7toIuzpRGq5YPg=;
	h=From:To:Cc:Subject:Date:From;
	b=Bkx8PBoxMcclC3UGtSdhaf6NPdT/e654GshpJy1u/2cpyeT4vUatkbCko4ZdSGGu/
	 ISTYb9qOXbiRQ7ZbKpK7b3+bbQB6VASQu68tWSBJPF/1fFKw4jhP/Slo4ANnqWrwVZ
	 E4DAlPjOWGYd01+i5+Z6bz4m3cudKWhKMo/QHm3dGQUwkyal6QwI6dJ4Y77aXH6R1h
	 99bUH2gVyDUyAc6iw62NblQ8DLLqKEXbDxQlGYm7dHlamzuGd0P2JmY9O4Dvm9qGFs
	 iFqOXMSFMmbNNon8L99b+FYlsAtMrEvhRulib4tQBYwlPgo6MQpzwzWowwBs2P337Y
	 Ibq262BLlt1IQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/9] SPMI patches for v6.1
Date: Thu, 29 Sep 2022 17:50:09 -0700
Message-Id: <20220930005019.2663064-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg,

Here's my pile of SPMI patches for the next merge window. I'm going to
send an email to get the SPMI kernel.org branch merged into linux-next,
I'll Cc you on the thread. That will provide more robot test coverage.

This patch collection is mostly for Qualcomm's SPMI PMIC arbiter, to fix
various issues found on newer hardware.  There's also a janitorial IDA
patch.

Abhijeet Dharmapurikar (1):
  spmi: pmic-arb: add a print in cleanup_irq

Ashay Jaiswal (1):
  spmi: pmic-arb: add support to dispatch interrupt based on IRQ status

David Collins (4):
  spmi: pmic-arb: check apid against limits before calling irq handler
  spmi: pmic-arb: correct duplicate APID to PPID mapping logic
  spmi: pmic-arb: block access for invalid PMIC arbiter v5 SPMI writes
  spmi: pmic-arb: increase SPMI transaction timeout delay

Fenglin Wu (1):
  spmi: pmic-arb: handle spurious interrupt

Subbaraman Narayanamurthy (1):
  spmi: pmic-arb: do not ack and clear peripheral interrupts in
    cleanup_irq

keliu (1):
  drivers: spmi: Directly use ida_alloc()/free()

 drivers/spmi/spmi-pmic-arb.c | 91 +++++++++++++++++++++++++++---------
 drivers/spmi/spmi.c          |  4 +-
 2 files changed, 70 insertions(+), 25 deletions(-)

-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

