Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D501E47CA;
	Sat, 25 Oct 2025 16:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408927; cv=none; b=r5GL5qJwgHh7cqIBnr/WG46tNBZTRc1gasr3OPr4iljCaAKn61E6nlipalxs/FCUg7GHoHdgIPd806rGvuqWq+NaQePYuFQcJTIZjpzN5N7crQW9erc7/HxnHS7NUo/5+W/545J22nPbgu2JrKZM4KQZc8FrV+ZLN2YcSGy7xxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408927; c=relaxed/simple;
	bh=9CHm00zvlHDD+BHxHedZ5Ksq8ayuZoCoLxiNYauIfBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IyjIwK21VeTfxoFiYt5NxMZqC0FUN0OxBYyQE3KP8SR0YSuWypdxe8Cbm5YbNkFKYmjpGvpdx6bhyqZEZAmu+6ADu33ooes8RVIig6u8aZ7+peZ5LurWauEHUmNeVJnoXbTDOTw0qzG8vDbURFqrSTAHkj9ehpEGqX06qKCvX2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DGgKNgc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DGgKNgc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FEE7C4CEFB;
	Sat, 25 Oct 2025 16:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408927;
	bh=9CHm00zvlHDD+BHxHedZ5Ksq8ayuZoCoLxiNYauIfBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGgKNgc+kMJGySVX2WSA42L14TX9SYWuQ6SEvcWDhEkJuK5A0QCIRC4IC6ja1zjf/
	 3vhkUb/fXuBDBAEYBoRLRUF8ZtLzu4c1hR0p7IDbxsr525L5ve4s0MiUWjw3daG37e
	 Yxetg0IZ1oKprNEP7YtGd2mrucWSw7IZcTQXlfrWRH3NafjmcwiYD45Jt9qSWesfiI
	 1L+tb7kwGiMuwF52Gy317Av/0+Azf0T27Uhruva95mAhxDDmSUPRTYlcx93EYdFR27
	 CmzL98hWFcgJpBJASQfrEvC3fxq6wFHvja66Mie/RPZ5yi30V+aZTx8tFgqe4yyEiV
	 XiBDJ7ziCafRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>,
	willemb@google.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17] selftests: drv-net: devmem: add / correct the IPv6 support
Date: Sat, 25 Oct 2025 11:56:06 -0400
Message-ID: <20251025160905.3857885-135-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 424e96de30230aac2061f941961be645cf0070d5 ]

We need to use bracketed IPv6 addresses for socat.

Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250811231334.561137-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: socat requires bracketed IPv6 literals; without
  brackets, IPv6 addresses containing colons are parsed incorrectly,
  causing the devmem selftest RX path to fail on IPv6 setups.
- Exact change: In
  `tools/testing/selftests/drivers/net/hw/devmem.py:27`, the destination
  and bind addresses in the socat pipeline switch from
  `cfg.addr`/`cfg.remote_addr` to `cfg.baddr`/`cfg.remote_baddr`, i.e.:
  - From: `TCP{cfg.addr_ipver}:{cfg.addr}:{port},bind={cfg.remote_addr}:
    {port}`
  - To: `TCP{cfg.addr_ipver}:{cfg.baddr}:{port},bind={cfg.remote_baddr}:
    {port}`
- Why this is correct: The environment already provides bracketed-
  address variants specifically for commands that need `[]` around IPv6:
  - `tools/testing/selftests/drivers/net/lib/py/env.py:154-156` defines
    `cfg.baddr` and `cfg.remote_baddr` as `[v6]` when IPv6 is
    configured, or plain v4 otherwise.
- Consistency with other selftests: Other net selftests already use
  bracketed forms with socat (e.g.,
  `tools/testing/selftests/drivers/net/ping.py:42` and
  `tools/testing/selftests/drivers/net/ping.py:50`).
- Minimal scope: Single-line functional change in a selftest only; no
  kernel code or interfaces are touched.
- No architectural changes: The testing flow and ncdevmem invocation
  remain unchanged; only socat’s address formatting is corrected.
- IPv4 unaffected: For IPv4-only environments, `cfg.baddr` resolves to
  the plain IPv4 address, preserving existing behavior.
- Correct handling for ncdevmem: The ncdevmem tool parses unbracketed
  literals with `inet_pton` and remains passed unbracketed strings in
  `listen_cmd` (e.g., `devmem.py:28`), which is required (see
  `tools/testing/selftests/drivers/net/hw/ncdevmem.c:~560`
  parse_address()).
- User impact: Fixes IPv6 test failures and false negatives in the
  devmem RX test, improving test reliability for stable trees.
- Regression risk: Very low. The change aligns with established patterns
  in the same selftest suite, doesn’t alter APIs, and is gated by
  existing cfg fields already present in stable.
- Stable policy fit: This is a small, contained test fix, not a feature;
  it improves correctness and is safe to backport even late in the
  cycle.
- No mention of stable Cc is not blocking: Selftest fixes are commonly
  backported when they fix real failures.

Conclusion: This is a straightforward, low-risk correctness fix for the
selftests that resolves IPv6 misparsing in socat. It should be
backported.

 tools/testing/selftests/drivers/net/hw/devmem.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/devmem.py b/tools/testing/selftests/drivers/net/hw/devmem.py
index baa2f24240ba5..0a2533a3d6d60 100755
--- a/tools/testing/selftests/drivers/net/hw/devmem.py
+++ b/tools/testing/selftests/drivers/net/hw/devmem.py
@@ -24,7 +24,7 @@ def check_rx(cfg) -> None:
     require_devmem(cfg)
 
     port = rand_port()
-    socat = f"socat -u - TCP{cfg.addr_ipver}:{cfg.addr}:{port},bind={cfg.remote_addr}:{port}"
+    socat = f"socat -u - TCP{cfg.addr_ipver}:{cfg.baddr}:{port},bind={cfg.remote_baddr}:{port}"
     listen_cmd = f"{cfg.bin_local} -l -f {cfg.ifname} -s {cfg.addr} -p {port} -c {cfg.remote_addr} -v 7"
 
     with bkg(listen_cmd, exit_wait=True) as ncdevmem:
-- 
2.51.0

