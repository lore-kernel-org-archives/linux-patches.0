Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580E1283FEA;
	Fri,  8 Aug 2025 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667070; cv=none; b=qe1++Y0NZml8SA42LHRMZPHtqeRPBYhqrHVRngR4MPrKjfOQ5KNl8v+Wx0twbkWkiEJJ4bHCcEyyjsbLBdAnCaVNaALYG6wWrAcI+C4wZSqs4xj62ZxaRhFbUyeFnIP0NVHf9RhTI802c77Us2yV0uPsoxDPhN++Xpl/i9cOGcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667070; c=relaxed/simple;
	bh=hV5ulevw+EDTUKCYHFOtVgVwDNFnlDvb9cJgbIDjtQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KbwQxftU4KveOdpCcKCmtRONlNxkw76DCU4zx74GMjmCSihG/wXpm+8OFqsQWqnVm57fMx/w7zvvDL00S6AWHkh4wDdkZNYiYK5rQpUjo48EeJvk/EHJxDE2nekEaqMVgHNBQbaZ6MdoX2pmllXjh4G65kpuMDStEYp5eM2Rx94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IodIvo9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IodIvo9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA07C4CEED;
	Fri,  8 Aug 2025 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667070;
	bh=hV5ulevw+EDTUKCYHFOtVgVwDNFnlDvb9cJgbIDjtQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IodIvo9Zz7+55bMfqUeqy9PoLiC2U3yK6LJkP64x9XlLCH/QKI2GinNkCzqobfD/D
	 bdXyxKkn5XZ2ccavHxAEo8gocTYqg8B8qKFaxdB4b0AfwsOYlhfnDJf0RxYqP0s5PZ
	 kEu85dp3HPq1vUbBsFibJP8XkwzFiOE4STbxRou52yATaF3Hr5utcj6xJcbpPENvsX
	 jCMNZIiKJkRLUwddklsxqwSx6hYc0nABQIhVFnMv4lxzVnBUWm3AJcB1CpADQd0srt
	 WNIim3VRLIUEcjUKmOV4v+d2X3NPcYgHUd095TS1Xnsb9B3kZiJRk/+F20oCauEPZT
	 2IBmK3g7PF19g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jorge Marques <jorge.marques@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-i3c@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16-6.1] i3c: master: Initialize ret in i3c_i2c_notifier_call()
Date: Fri,  8 Aug 2025 11:30:47 -0400
Message-Id: <20250808153054.1250675-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit 290ce8b2d0745e45a3155268184523a8c75996f1 ]

Set ret to -EINVAL if i3c_i2c_notifier_call() receives an invalid
action, resolving uninitialized warning.

Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250622-i3c-master-ret-uninitialized-v1-1-aabb5625c932@analog.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Analysis

The commit fixes a serious uninitialized variable bug in
`i3c_i2c_notifier_call()`. Looking at the code:

1. **The Bug**: The function declares `int ret` at line 2449 but doesn't
   initialize it. The switch statement only handles two cases
   (`BUS_NOTIFY_ADD_DEVICE` and `BUS_NOTIFY_DEL_DEVICE`), leaving `ret`
   uninitialized for any other action values.

2. **When It Triggers**: Since this notifier is registered with
   `bus_register_notifier(&i2c_bus_type, &i2cdev_notifier)`, it receives
   ALL bus notification events for I2C devices, including:
   - `BUS_NOTIFY_REMOVED_DEVICE`
   - `BUS_NOTIFY_BIND_DRIVER`
   - `BUS_NOTIFY_BOUND_DRIVER`
   - `BUS_NOTIFY_UNBIND_DRIVER`
   - `BUS_NOTIFY_UNBOUND_DRIVER`
   - `BUS_NOTIFY_DRIVER_NOT_BOUND`

3. **Impact**: When any of these unhandled actions occur, the function
   returns an uninitialized stack value, which could:
   - Accidentally return `NOTIFY_STOP` or `NOTIFY_BAD`, halting the
     notification chain
   - Cause unpredictable behavior in the device/driver binding process
   - Lead to intermittent, hard-to-debug failures

## Backport Criteria Analysis

1. **Fixes a real bug**: ✓ Yes - fixes an uninitialized variable that
   causes undefined behavior
2. **Small and contained**: ✓ Yes - adds only 2 lines (default case
   returning -EINVAL)
3. **No side effects**: ✓ Correct - the fix properly handles unexpected
   actions by returning an error
4. **No architectural changes**: ✓ Correct - simple bug fix, no design
   changes
5. **Critical subsystem**: ✓ Yes - affects I3C/I2C device management and
   driver binding
6. **Follows stable rules**: ✓ Yes - important bugfix with minimal risk

## Additional Context

- The bug was introduced in commit 72a4501b5d08 ("i3c: support
  dynamically added i2c devices") in January 2022
- The I3C subsystem has had other uninitialized variable fixes (e.g.,
  commit 6cbf8b38dfe3)
- This is a classic compiler warning fix that prevents real runtime
  issues
- The fix is conservative, returning -EINVAL for unexpected actions
  rather than silently ignoring them

This is exactly the type of bug that stable kernels should fix: a real
issue with unpredictable runtime consequences, fixed with a minimal,
safe change.

 drivers/i3c/master.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index e53c69d24873..dfa0bad991cf 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2467,6 +2467,8 @@ static int i3c_i2c_notifier_call(struct notifier_block *nb, unsigned long action
 	case BUS_NOTIFY_DEL_DEVICE:
 		ret = i3c_master_i2c_detach(adap, client);
 		break;
+	default:
+		ret = -EINVAL;
 	}
 	i3c_bus_maintenance_unlock(&master->bus);
 
-- 
2.39.5

