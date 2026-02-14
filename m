Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C431C84DE;
	Sat, 14 Feb 2026 21:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104309; cv=none; b=aWRbuKHdV3UiUcB7BmwiabMqfyeyuQ9WC55WiStpNu3yBmXCjEqMbYJCNUROVazuS5gZr1zMyf221mo8Uv7W9v7dWx2bp2gj6FnFOa74BjiZjBmH7SRYe+Sm0tPktbgsGKZqYhBCAG2ELL7Mp4T484ReWahF7Slb4wfcy1KlSO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104309; c=relaxed/simple;
	bh=QP1Mxt56RkhuEfSgRzgq6bcfzX827a6zZrXFGKW3xUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XrZD2WgFHok14HmytZFSuaBk36mEDrLkLd3XKNzeDeDFCfjb0YHUPb9iazVyxAIuQfxiEUWZ2Wq1nDkkadzHlKh8CGIRDFBb2EbgiApAXSMi130tYp4ObQ+2EfpTJjeO/psQEaWzho6DNZLbnxp6jQ6KN9RgSh2VsMmA/t+gkDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ameAn710; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ameAn710"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6239DC16AAE;
	Sat, 14 Feb 2026 21:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104309;
	bh=QP1Mxt56RkhuEfSgRzgq6bcfzX827a6zZrXFGKW3xUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ameAn710/kEid/UYZ80rYKucPl+wirxkYv0tKEZ5cGhRfk1i0yVRCdJQlH3QCKdnw
	 luckSf62VJlsyOX4jnmtUFC/5RQ3/0B0IdbKLtCWvTqpYaPwoivvfYwiZb5Sw7YNPT
	 +KQ67h4IgskVhvVR0FZi+SHcDvPMv7eVRMsLmGbDLcquuaOJPshVQsYSyj5fRBSHY/
	 E3SYF9jzWLvx1/ce9r+fBLwdrbJk0TRRyW60SB610/suxaGpSe9D3FWgODIRtIGCiT
	 v86gY9e2uyStrRauQ7a5pBX+bfjFwZGO/RO/yu0JqNdtY2Xiuy15EHXM+F8XVv5Qmc
	 mBvsgXKOxD1pw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jian Zhang <zhangjian.3032@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jk@codeconstruct.com.au,
	matt@codeconstruct.com.au,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] net: mctp-i2c: fix duplicate reception of old data
Date: Sat, 14 Feb 2026 16:22:33 -0500
Message-ID: <20260214212452.782265-8-sashal@kernel.org>
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

From: Jian Zhang <zhangjian.3032@bytedance.com>

[ Upstream commit ae4744e173fadd092c43eda4ca92dcb74645225a ]

The MCTP I2C slave callback did not handle I2C_SLAVE_READ_REQUESTED
events. As a result, i2c read event will trigger repeated reception of
old data, reset rx_pos when a read request is received.

Signed-off-by: Jian Zhang <zhangjian.3032@bytedance.com>
Link: https://patch.msgid.link/20260108101829.1140448-1-zhangjian.3032@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of net: mctp-i2c: fix duplicate reception of old data

### 1. Commit Message Analysis

The commit message clearly describes a **bug fix**: the MCTP I2C slave
callback was not handling `I2C_SLAVE_READ_REQUESTED` events, which
caused **duplicate reception of old data** when an I2C read event
occurred. The fix resets `rx_pos` when a read request is received.

Keywords: "fix duplicate reception of old data" — this is an explicit
bug fix.

### 2. Code Change Analysis

The patch makes two changes:

**Change 1: Handle `I2C_SLAVE_READ_REQUESTED` in the switch statement**
```c
case I2C_SLAVE_READ_REQUESTED:
    midev->rx_pos = 0;
    break;
```
This adds handling for a previously unhandled I2C slave event. When a
read request comes in, `rx_pos` is reset to 0, preventing stale data
from being re-processed. Without this, the `rx_pos` would retain its old
value from a previous transaction, and when `I2C_SLAVE_STOP` fires,
`mctp_i2c_recv()` would process stale data in the buffer — resulting in
duplicate/ghost packet reception.

**Change 2: Early return in `mctp_i2c_recv()` when `rx_pos == 0`**
```c
if (midev->rx_pos == 0)
    return 0;
```
This is a defensive guard: if `rx_pos` was reset to 0 (by the new
READ_REQUESTED handler), `mctp_i2c_recv()` should do nothing since
there's no valid write data to process. Without this check, the function
would proceed with invalid state (`rx_pos == 0`), potentially causing
incorrect length calculations or accessing uninitialized buffer data.

### 3. Bug Mechanism

The I2C slave callback handles events during I2C bus transactions. The
MCTP-over-I2C protocol involves the bus master writing MCTP packets.
However, the I2C bus can also generate `I2C_SLAVE_READ_REQUESTED` events
(when the master reads from this slave). Without handling this event:

1. `rx_pos` retains its value from a previous write transaction
2. When `I2C_SLAVE_STOP` fires after the read, `mctp_i2c_recv()`
   processes the stale buffer
3. This causes **duplicate reception of old MCTP packets** — a data
   integrity/correctness bug

### 4. Classification

- **Bug fix**: Yes — fixes incorrect behavior (duplicate packet
  reception)
- **New feature**: No — this handles an existing I2C event that was
  previously ignored
- **Scope**: Very small — adds 5 lines of code across two locations in
  one file

### 5. Stable Criteria Assessment

| Criterion | Assessment |
|-----------|------------|
| Obviously correct and tested | Yes — simple, logical fix; accepted by
net maintainer Jakub Kicinski |
| Fixes a real bug | Yes — duplicate reception of stale MCTP data |
| Important issue | Moderate — data correctness issue in networking
stack |
| Small and contained | Yes — 5 lines added in a single file |
| No new features | Correct — just handles a missing event case |
| Applies cleanly | Likely — small, localized change |

### 6. Risk Assessment

**Risk: Very low**
- The change is minimal and purely additive (no existing code modified)
- Adding a case to a switch statement with a simple assignment is very
  safe
- The early return guard in `mctp_i2c_recv()` is a standard defensive
  check
- Only affects MCTP-over-I2C users — very narrow blast radius

**Benefit: Moderate to High for affected users**
- MCTP (Management Component Transport Protocol) over I2C is used in
  server/BMC management
- Duplicate packet reception causes incorrect behavior in management
  stacks
- Without this fix, any I2C read event corrupts the MCTP receive path

### 7. Dependencies

No dependencies on other commits. The fix is self-contained and modifies
only the existing `mctp_i2c_slave_cb()` function and `mctp_i2c_recv()`
function.

### 8. Conclusion

This is a clean, small, obviously correct bug fix that addresses a real
data corruption/correctness issue (duplicate reception of stale data) in
the MCTP I2C driver. It meets all stable kernel criteria: it's small,
contained, fixes a real bug, introduces no new features, and has very
low regression risk.

**YES**

 drivers/net/mctp/mctp-i2c.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index f782d93f826ef..ecda1cc36391c 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -242,6 +242,9 @@ static int mctp_i2c_slave_cb(struct i2c_client *client,
 		return 0;
 
 	switch (event) {
+	case I2C_SLAVE_READ_REQUESTED:
+		midev->rx_pos = 0;
+		break;
 	case I2C_SLAVE_WRITE_RECEIVED:
 		if (midev->rx_pos < MCTP_I2C_BUFSZ) {
 			midev->rx_buffer[midev->rx_pos] = *val;
@@ -279,6 +282,9 @@ static int mctp_i2c_recv(struct mctp_i2c_dev *midev)
 	size_t recvlen;
 	int status;
 
+	if (midev->rx_pos == 0)
+		return 0;
+
 	/* + 1 for the PEC */
 	if (midev->rx_pos < MCTP_I2C_MINLEN + 1) {
 		ndev->stats.rx_length_errors++;
-- 
2.51.0

