Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936AD3019DE;
	Sat, 25 Oct 2025 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408912; cv=none; b=WOKYHjQVOr4lhR76tUt28p846T4Q6AwZJt/z4v6sO0GhGni4IfkOmxBAcK35eMLO0cQDH3XR2P2J8LJBjz7e32u+UpKmrJxFlamWhwT9bbkugV6Y+sRbEqP1c6kKCVUJmSg7314t59B7dn9AxiyggPTS3+O9aNXEwjL6xEZ44DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408912; c=relaxed/simple;
	bh=k8/4ps8OSedv+JB05M3ZP54FkmGycvsB9HQbCElcfRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTGNVbOIwXzD5q89Ln0nuJq5m+hKweZq34pKQ3pjn/66qmLF2Xxz/Fboxwk4KESPUoLmEvR1mN8vVPwXucd3omA1ZOtBEY4TmzyysQkrXysTqFFAdPhH7x6BDeeWeUc5jcUF3+wXU2Z6iOyqAo/TeccKMfzWTPc8KAhropX+/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGALKVVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGALKVVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24986C4AF09;
	Sat, 25 Oct 2025 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408912;
	bh=k8/4ps8OSedv+JB05M3ZP54FkmGycvsB9HQbCElcfRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGALKVVf7Z+gYyMSrnV/bA8FcvFrDB/kYjtnRW6zFiScEZP1hE6ono+rBKG84dCt/
	 ItmWrvTN5IIR2LwvorWJ4oLau/exvYvv300BWI7sFYJ3ft3+jX6bsBEa74E6yk3sfR
	 +4vRNqC1uNej5VDbjmR3zCMKZc48ZdnAAPWvvaLyf5vupmgaf/1y+vpv3y3XipWPbu
	 t25DuIyPaX8ffXw1RMLXVtVEYus8IVFyA55sFgtB7sKifFgbGwXxwUyjZf4bdHx+6J
	 /ZZl4tzIBxbVG8BW1cbX+zQ8ICHRxaBnocL4Wa7QGSRIpJK5gzYtN0Rj/s02KbUfBN
	 9aRc8QB4neBSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] udp_tunnel: use netdev_warn() instead of netdev_WARN()
Date: Sat, 25 Oct 2025 11:55:57 -0400
Message-ID: <20251025160905.3857885-126-sashal@kernel.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dc2f650f7e6857bf384069c1a56b2937a1ee370d ]

netdev_WARN() uses WARN/WARN_ON to print a backtrace along with
file and line information. In this case, udp_tunnel_nic_register()
returning an error is just a failed operation, not a kernel bug.

udp_tunnel_nic_register() can fail due to a memory allocation
failure (kzalloc() or udp_tunnel_nic_alloc()).
This is a normal runtime error and not a kernel bug.

Replace netdev_WARN() with netdev_warn() accordingly.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910195031.3784748-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Recommendation: **YES**

After conducting an exhaustive analysis of this commit, I strongly
recommend backporting it to stable kernel trees.

---

## Detailed Technical Analysis

### 1. Understanding the Code Change

The commit changes a single line in `net/ipv4/udp_tunnel_nic.c` at line
933 (in the `udp_tunnel_nic_netdevice_event()` function):

**Before:**
```c
netdev_WARN(dev, "failed to register for UDP tunnel offloads: %d", err);
```

**After:**
```c
netdev_warn(dev, "failed to register for UDP tunnel offloads: %d", err);
```

### 2. Critical Difference Between netdev_WARN() and netdev_warn()

Through my investigation of the kernel source:

- **netdev_WARN()** (defined in `include/linux/netdevice.h:5559-5561`):
  - Expands to `WARN(1, "netdevice: %s%s: " format, ...)`
  - Unconditionally triggers a full kernel WARN with:
    - Complete backtrace
    - File and line information
    - Treats the condition as a kernel bug

- **netdev_warn()** (declared in `include/net/net_debug.h:22`):
  - A regular logging function
  - Prints a warning message at KERN_WARNING level
  - No backtrace, no panic potential
  - Appropriate for normal runtime errors

### 3. Analysis of Failure Conditions

Through semantic code analysis using `mcp__semcode__find_function`, I
determined that `udp_tunnel_nic_register()` can fail with `-ENOMEM` in
exactly two scenarios (lines 823-825 and 833-836):

1. **Node allocation failure**: `kzalloc(sizeof(*node), GFP_KERNEL)`
   returns NULL
2. **State structure allocation failure**: `udp_tunnel_nic_alloc(info,
   n_tables)` returns NULL

Both failures are **normal runtime memory allocation failures**, not
kernel bugs. The commit message correctly identifies this.

### 4. Critical Issue: panic_on_warn Impact

From `Documentation/admin-guide/sysctl/kernel.rst`:
> panic_on_warn: Calls panic() in the WARN() path when set to 1. This is
useful to avoid a kernel rebuild when attempting to kdump at the
location of a WARN().

**Problem**: Systems with `panic_on_warn=1` (commonly used in production
environments for catching real kernel bugs) will **panic** when
encountering a simple memory allocation failure during network device
registration. This is clearly inappropriate behavior.

### 5. Kernel Coding Standards Compliance

From `Documentation/process/coding-style.rst`:

> **WARN*() is intended for unexpected, this-should-never-happen
situations.**
>
> **WARN*() macros are not to be used for anything that is expected to
happen during normal operation.**

Memory allocation failures ARE expected during normal operation. The
current code violates kernel coding standards.

Additionally, the documentation states:
> **These generic allocation functions all emit a stack dump on failure
when used without __GFP_NOWARN so there is no use in emitting an
additional failure message when NULL is returned.**

The WARN() is redundant and inappropriate.

### 6. Historical Precedent

I found similar precedent in commit `abfb2a58a5377` ("ionic: remove
WARN_ON to prevent panic_on_warn"):
- Similar rationale: removing WARN for non-bug conditions
- Had a Fixes: tag and was backported
- Explicitly mentions preventing panic_on_warn issues

### 7. Risk Assessment

**Risk Level: MINIMAL**

- **Functional Impact**: None - this is purely a logging change
- **Error Handling**: Unchanged - error is still returned and propagated
  via `notifier_from_errno(err)`
- **Side Effects**: None - only changes log output format
- **Dependencies**: None - netdev_warn() has existed since 2014
- **Compatibility**: Full - change applies cleanly to all maintained
  stable kernels

### 8. Impact Analysis

**Before the change:**
- Memory allocation failure during NETDEV_REGISTER event triggers WARN()
- Systems with panic_on_warn=1 will panic
- Logs filled with unnecessary backtraces
- False kernel bug reports generated

**After the change:**
- Memory allocation failure logged as simple warning
- No panic on panic_on_warn=1 systems
- Clean, appropriate log messages
- Correct signal to users (runtime error, not kernel bug)

### 9. Stable Tree Criteria Evaluation

| Criterion | Met? | Analysis |
|-----------|------|----------|
| Important bugfix | ✅ YES | Prevents inappropriate panics on production
systems |
| Minimal risk | ✅ YES | Logging-only change, zero functional impact |
| Small and contained | ✅ YES | Single line change in one file |
| No architectural changes | ✅ YES | Pure logging modification |
| No new features | ✅ YES | Only fixes incorrect behavior |
| Obvious correctness | ✅ YES | Clearly aligns with kernel coding
standards |

### 10. Why Author Didn't Add Stable Tags

The absence of `Fixes:` or `Cc: stable` tags is **not** a reason to
reject backporting. This appears to be a coding standards fix that the
author may not have considered critical enough for explicit stable
tagging. However, the technical merits clearly support backporting:

1. Fixes incorrect API usage
2. Prevents panic_on_warn issues
3. Reduces log noise
4. Zero risk of regression

### 11. User-Visible Benefit

**Critical benefit**: Production systems using `panic_on_warn=1` for
debugging will no longer inappropriately panic when network devices fail
to allocate memory during registration. This is especially important in:
- High-availability environments
- Systems with memory pressure
- Environments with many network devices
- kdump configurations

---

## Final Recommendation

**YES - Strongly recommend backporting to all maintained stable trees.**

**Rationale:**
1. Fixes a clear violation of kernel coding standards (WARN used for
   normal runtime condition)
2. Prevents system panics on panic_on_warn=1 systems for expected errors
3. Zero risk of regression (logging-only change)
4. Small, contained, and obviously correct
5. Improves user experience by reducing log noise
6. Prevents false bug reports
7. Has precedent in similar backported commits

This commit should be backported despite lacking explicit stable tags,
as the technical merits and user benefit clearly warrant inclusion in
stable trees.

 net/ipv4/udp_tunnel_nic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_tunnel_nic.c b/net/ipv4/udp_tunnel_nic.c
index ff66db48453cf..944b3cf25468e 100644
--- a/net/ipv4/udp_tunnel_nic.c
+++ b/net/ipv4/udp_tunnel_nic.c
@@ -930,7 +930,7 @@ udp_tunnel_nic_netdevice_event(struct notifier_block *unused,
 
 		err = udp_tunnel_nic_register(dev);
 		if (err)
-			netdev_WARN(dev, "failed to register for UDP tunnel offloads: %d", err);
+			netdev_warn(dev, "failed to register for UDP tunnel offloads: %d", err);
 		return notifier_from_errno(err);
 	}
 	/* All other events will need the udp_tunnel_nic state */
-- 
2.51.0

