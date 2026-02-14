Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1073C2D;
	Sat, 14 Feb 2026 21:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104319; cv=none; b=qeZ3eTSvOXHcxSsgpeBeq7jVN7HGTk1SMbOYVTU6W9muZq5DLcUKnSWp5YShPagsp6TwRwJs7pa6nwmwmYXw/TlS8Z8yrck9Vcz2vZ6PjKMlBKlfYIfU1L0emuGP/YaUbTvi8Fmc1So62uBPLIMS4QMzVe21hCQ2d/b4WeZP24c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104319; c=relaxed/simple;
	bh=SYr2jZH/JP9Q2+T65btHGzZV/xMCQcU2k3NTQZNlZYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9l46Uo8O1Jc9LjizRE6eDTt2D+I3LHG2gb8VWeybHFEwtxFN+xe4/PMe2mQ2bIV0QE48SU5n8/vxq7bFPynt062p7gztE8iywidWLxQhUZ6LjuGlqYGk6Y37BU9XgaQIsC8PM56ZKv2a6M56hG2I9EmTekHUZGseX3N1zJAAS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOSOAlch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOSOAlch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9948C16AAE;
	Sat, 14 Feb 2026 21:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104319;
	bh=SYr2jZH/JP9Q2+T65btHGzZV/xMCQcU2k3NTQZNlZYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOSOAlchxPkQsgbn//peqQenf9TNeqzgjGmjfjqUJt5TEy6MaVk+XG/R18x9sdEHP
	 PcdLnpcRb/odVkhmd5bSyKXwp5S682fVl+G7bbTIotNfZXFdYP8SZVmeHH/ZkqVM/h
	 VjilcQkMmEkLtlqBFBxwqpFrutEXCWEJNVMeLBlmXOHTBB5xwEtjlu4nP3IWYLNV9o
	 E8TOtmI1HeAJtMe+Ldz17ekoDSSFKMuIzG5/kxZZXoSCDb3j4yiGLtg5ZcUXvswZq+
	 jqJKCpQn3nSv5I5CzlIP/ZI3Z6MLXan4x34qNKw2K81Xy3Gb5hpDDAUwvdf7/06lcL
	 XN5MrqgsgeP0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Slark Xiao <slark_xiao@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	loic.poulain@oss.qualcomm.com,
	ryazanov.s.a@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] net: wwan: mhi: Add network support for Foxconn T99W760
Date: Sat, 14 Feb 2026 16:22:39 -0500
Message-ID: <20260214212452.782265-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 915a5f60ad947e8dd515d2cc77a96a14dffb3f15 ]

T99W760 is designed based on Qualcomm SDX35 chip. It use similar
architecture with SDX72/SDX75 chip. So we need to assign initial
link id for this device to make sure network available.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
Link: https://patch.msgid.link/20260105022646.10630-1-slark_xiao@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit adds network support for a new device, the Foxconn T99W760,
which is based on the Qualcomm SDX35 chip. The commit message explains
that this device uses a similar architecture to SDX72/SDX75 and needs an
initial link ID assignment to make networking functional.

### Code Change Analysis

The change is extremely minimal — a single line addition:

```c
strcmp(cntrl->name, "foxconn-t99w760") == 0)
```

This adds the "foxconn-t99w760" device name to the
`mhi_mbim_get_link_mux_id()` function so that it returns
`WDS_BIND_MUX_DATA_PORT_MUX_ID` instead of `0`. This is the same
treatment already given to "foxconn-dw5934e" and "foxconn-t99w640".

### Classification: Device ID / Hardware Enablement

This falls squarely into the **"New Device IDs"** exception category for
stable backports. It's adding support for a specific device to an
existing driver by matching its name and applying the same configuration
that other similar devices already use.

Without this change, users with the Foxconn T99W760 WWAN modem cannot
use networking — the device gets the wrong mux ID (0 instead of
`WDS_BIND_MUX_DATA_PORT_MUX_ID`), making the network interface non-
functional.

### Risk Assessment

- **Scope**: 1 line added, 1 file changed
- **Risk**: Extremely low — the change only affects devices matching the
  exact name "foxconn-t99w760". No other hardware is affected.
- **Pattern**: Follows the exact same pattern as existing devices in the
  same function
- **Complexity**: Trivial string comparison addition

### User Impact

Users with the Foxconn T99W760 WWAN modem (a real shipping hardware
device) cannot use network connectivity without this patch. This is a
real-world hardware enablement fix.

### Stability Assessment

- The driver (`mhi_wwan_mbim.c`) already exists in stable trees
- The function `mhi_mbim_get_link_mux_id()` already exists
- The pattern is identical to existing entries
- Zero risk of regression for any other hardware

### Dependencies

No dependencies on other commits. The change is entirely self-contained.

### Conclusion

This is a textbook device ID addition to an existing driver — one of the
explicitly allowed exception categories for stable backports. It enables
real hardware for real users, is trivially small, has zero regression
risk, and follows an established pattern in the same function.

**YES**

 drivers/net/wwan/mhi_wwan_mbim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/mhi_wwan_mbim.c b/drivers/net/wwan/mhi_wwan_mbim.c
index f8bc9a39bfa30..1d7e3ad900c12 100644
--- a/drivers/net/wwan/mhi_wwan_mbim.c
+++ b/drivers/net/wwan/mhi_wwan_mbim.c
@@ -98,7 +98,8 @@ static struct mhi_mbim_link *mhi_mbim_get_link_rcu(struct mhi_mbim_context *mbim
 static int mhi_mbim_get_link_mux_id(struct mhi_controller *cntrl)
 {
 	if (strcmp(cntrl->name, "foxconn-dw5934e") == 0 ||
-	    strcmp(cntrl->name, "foxconn-t99w640") == 0)
+	    strcmp(cntrl->name, "foxconn-t99w640") == 0 ||
+	    strcmp(cntrl->name, "foxconn-t99w760") == 0)
 		return WDS_BIND_MUX_DATA_PORT_MUX_ID;
 
 	return 0;
-- 
2.51.0

