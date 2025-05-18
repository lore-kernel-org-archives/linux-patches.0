Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D001898FB;
	Sun, 18 May 2025 03:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747538612; cv=none; b=XZRf4ZmmTjErxuzeO1MXDcZznwEextWbVWPUaKgyN1gqzv1g73F8RBrKeg+nbwjEkZIZ1pVB4TZ6YfP48VFXL1OV8YrBxGorRSErU2oobzh2gONAgOX4qsXZAPP5Mp2mRD9hHCbieCYnJ1S+OmA/2gkfLNs5buLrZVS3jm52HD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747538612; c=relaxed/simple;
	bh=3N8+ZNr2O6HYyn8yyS6NSnSQFgCsda7ZCB17wtWsM9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IB883V3Ye+yJYo+Jyh0C6lNJbfSvSNIXXdangAXp/eCFEEc9u1jDVbdEjK0Lj1BKANsfuixO7TbPcaY8DvkczdUKOhQOzsqY5Fk7qnIct8+icJ8uJnEAzKDy61sTDY9NWofPvjnawH6j8g4UF0kf7kEx9QyQuFZOZzPXn2sqjbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfJyYnGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfJyYnGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE78AC4CEE7;
	Sun, 18 May 2025 03:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747538612;
	bh=3N8+ZNr2O6HYyn8yyS6NSnSQFgCsda7ZCB17wtWsM9c=;
	h=From:To:Cc:Subject:Date:From;
	b=JfJyYnGNk2Itk78XtFXvbYHN1FEoEoOVNcL9On8WmbQiGEbnd7TYuz4Uy1eChM8lB
	 DgnKD3JVLMi+BzBQFuNBHm97WQirUkcu6Oxusy803L5+DywhzXiFyxdIvmoF8U10gX
	 QJ+qFx3T3QcrcK5ot5cOfoKMWnUkr+68CtgqixJvlj9/Zx+E7ZIhqLpZY7aQJFGvxT
	 tmJiLlPyxwVOxadVfLrYlLQyGM1JqvfRJIyHKW++wQOkerE2929ybYwvS5FLczhdFW
	 xfFA/YPWi9vR4ynhOcMZYwvr/TgyDSVzxfhk+4q8tQAhMVgUllXjvrGN5GF47QWkFy
	 W29XqZWwWjKOQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/4] SPMI patches for the merge window
Date: Sat, 17 May 2025 20:23:25 -0700
Message-ID: <20250518032330.2959766-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg,

These are the SPMI patches for the next merge window.

 - A new SPMI driver for Apple SoCs
 - Limit Hikey 970 SPMI Kconfig to arm64
 - Use irq_domain_create_tree() where appropriate

Jean-Francois Bortolotti (1):
  spmi: add a spmi driver for Apple SoC

Jiri Slaby (SUSE) (1):
  irqdomain: spmi: Switch to irq_domain_create_tree()

Sasha Finkelstein (1):
  dt-bindings: spmi: Add Apple SPMI controller

WangYuli (1):
  spmi: Only use Hikey 970 SPMI controller driver when ARM64

 .../devicetree/bindings/spmi/apple,spmi.yaml  |  49 +++++
 MAINTAINERS                                   |   2 +
 drivers/spmi/Kconfig                          |   9 +
 drivers/spmi/Makefile                         |   1 +
 drivers/spmi/spmi-apple-controller.c          | 168 ++++++++++++++++++
 drivers/spmi/spmi-pmic-arb.c                  |   2 +-
 6 files changed, 230 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/spmi/apple,spmi.yaml
 create mode 100644 drivers/spmi/spmi-apple-controller.c


base-commit: 0af2f6be1b4281385b618cb86ad946eded089ac8
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

