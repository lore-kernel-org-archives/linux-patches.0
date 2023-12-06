Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35811A5B6
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 23:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlzifUXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D4FC433C7;
	Wed,  6 Dec 2023 23:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701904654;
	bh=w5d5tl99JxM0Ktza2Q3G2taem4VmC9tnx4l5C6e0vNY=;
	h=From:To:Cc:Subject:Date:From;
	b=hlzifUXUQz7+mXK/y7VPeaiaj+qqDw62v4f6x/C+ZAKFr/Bl+4MDilIpxZC5Y9d1n
	 Qege0dBlqg1Jv7UEkh7t6akSrG7OszjKfg6UK5jeP7lE6Rl5WeERP7oXTe7Ipzl8hp
	 MaDh49J+SFrIIpwurx2jqAcsoD0CNHN92CPnD8w2AhYyNH1VsdEv0ntrPXIog5j+Gg
	 M7A7COoCBL90KgW4ivVsAIp1jClYDiwyV9WvZmDOyrGm/zGmCZD4P66/0ca/hFkesn
	 5R7GFXFG+2Ugfa+TZaNgqdt8wlbK+rHjr8dDNUZTUStgYi8h8v9vA9Iuj86Ag4dDsW
	 gvivJZQbQ5EfA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/8] SPMI patches for the merge window
Date: Wed,  6 Dec 2023 15:17:23 -0800
Message-ID: <20231206231733.4031901-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Greg,

Here's a collection of SPMI patches that I picked up a bit ago but
didn't send because we were too close to the merge window. The first
patch should probably be applied now though, because we're hanging the
PMIF interface on some mediatek boards when async probing. Otherwise the
patches improve mediatek spmi controllers and introduce some devm
wrappers for spmi controllers to simplify.

Fei Shao (5):
  spmi: Introduce device-managed functions
  spmi: Use devm_spmi_controller_alloc()
  spmi: mtk-pmif: Reorder driver remove sequence
  spmi: hisi-spmi-controller: Use devm_spmi_controller_add()
  spmi: Return meaningful errors in spmi_controller_alloc()

Nícolas F. R. A. Prado (1):
  spmi: mtk-pmif: Serialize PMIF status check and command submission

Sen Chu (1):
  spmi: mediatek: add device id check

Yu-Che Cheng (1):
  spmi: mediatek: Fix UAF on device remove

 drivers/spmi/Makefile               |  2 +-
 drivers/spmi/hisi-spmi-controller.c | 32 +++--------
 drivers/spmi/spmi-devres.c          | 64 +++++++++++++++++++++
 drivers/spmi/spmi-mtk-pmif.c        | 61 ++++++++++++--------
 drivers/spmi/spmi-pmic-arb.c        | 87 ++++++++++-------------------
 drivers/spmi/spmi.c                 |  6 +-
 include/linux/spmi.h                |  3 +
 7 files changed, 146 insertions(+), 109 deletions(-)
 create mode 100644 drivers/spmi/spmi-devres.c


base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

