Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098981C84B2;
	Mon,  4 Aug 2025 00:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267443; cv=none; b=ZRgvklgZNn/ycqOEkxts5Ev9BUDhVyDaUfM77zXjgBaq8IjWksygmJ5kATV/ZvwclMZBpXuD+jk0aN4iM4j7UY1BBOS9MXA35R3pCEG5Q5ANF7GPaGqUM5HBUkySU7gExOj5yDaUGOH7ytobsP0XVWZv04oHNhikL7WQETVawEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267443; c=relaxed/simple;
	bh=o1gEbAT2Gwkk9DBrp7RGMkbSUo8XK6WaVrcf6cgf5Ko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DuylB6ei7wVrhTR3+OEW26IMKSYacYtYA5qHe2ixEahntznc1MAwJbNpuQWgiG1o4eAwZ9tKXZwrbYlI5hiKMDDb2FL3G2PaFGJ+fq7QvR0wPFSYp1zPuQzTEEH75XellWlK8NgqhIH6zesjWTl2yf13xN5V40+w4TijGrIJtGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1WVS8NN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1WVS8NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52756C4CEF0;
	Mon,  4 Aug 2025 00:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267442;
	bh=o1gEbAT2Gwkk9DBrp7RGMkbSUo8XK6WaVrcf6cgf5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1WVS8NNvLdr34K2odcZMOlE7/Dz0cYkxTr1KwrB3GPCzt7EHzivuchNIkIcnFsHi
	 bpU6AtYGjQv1SB5/vHNYwjbyvEwU6lVYJAGBVIIKBJm3uJN5MZE9eaBGBcdzsZxbhB
	 i1LyIdAH0FzKHpjVbfLRdOybqRS81HTnaZnSI2epzu+dlcASW2shqp6vUfaM+my+kd
	 ocYE5J88paHOO3PI/ezkihrUhkzCr0Dv8f81vUheBhgXDrvdLrO4kGi4qlmNfpV14N
	 ZUwBMYBVJLx6J/uzZQe8koKFan5u+8srFFLgGdYlz+R/QMYyn6alcN+5+nJkupXyxw
	 MuY1qi8IjMoWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@treblig.org,
	thomas.weissschuh@linutronix.de
Subject: [PATCH AUTOSEL 6.15 67/80] usb: core: usb_submit_urb: downgrade type check
Date: Sun,  3 Aug 2025 20:27:34 -0400
Message-Id: <20250804002747.3617039-67-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 503bbde34cc3dd2acd231f277ba70c3f9ed22e59 ]

Checking for the endpoint type is no reason for a WARN, as that can
cause a reboot. A driver not checking the endpoint type must not cause a
reboot, as there is just no point in this.  We cannot prevent a device
from doing something incorrect as a reaction to a transfer. Hence
warning for a mere assumption being wrong is not sensible.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20250612122149.2559724-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here is my determination:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real issue that affects users**: The commit addresses a
   problem where a `dev_WARN()` can cause system reboots when
   `panic_on_warn` is enabled. This is a serious issue because a driver
   bug (not checking endpoint types properly) should not be able to
   crash the entire system.

2. **Small and contained fix**: The change is minimal - it only replaces
   `dev_WARN()` with `dev_warn_once()` on line 503 of
   drivers/usb/core/urb.c. This is a one-line change that doesn't affect
   any other functionality.

3. **Clear side effects**: The only behavioral change is that:
   - The warning will no longer trigger a kernel panic when
     `panic_on_warn` is set
   - The warning will only be printed once instead of potentially
     multiple times
   - No backtrace will be generated

4. **No architectural changes**: This is a simple logging level change
   that doesn't modify any USB subsystem architecture or functionality.

5. **Affects critical kernel subsystem**: While USB is a critical
   subsystem, this change actually makes it more stable by preventing
   potential system crashes.

6. **Follows stable tree rules**: This is clearly a bugfix that improves
   system stability. The commit message explicitly states that "A driver
   not checking the endpoint type must not cause a reboot" - this is a
   stability improvement that prevents denial-of-service scenarios.

7. **Similar fixes in the kernel**: There's precedent for this type of
   fix, as shown by commit 281cb9d65a95 ("bnxt_en: Make PTP timestamp
   HWRM more silent") which made a similar conversion from
   `netdev_WARN_ONCE()` to `netdev_warn_once()` for the same reason.

The key insight from the code is that `dev_WARN()` calls `WARN()` which
can trigger a kernel panic if `panic_on_warn` is set. This means a
malicious or buggy USB device could potentially crash the system just by
triggering this warning. Converting to `dev_warn_once()` maintains the
diagnostic value while removing the crash risk.

 drivers/usb/core/urb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 5e52a35486af..120de3c499d2 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -500,7 +500,7 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 
 	/* Check that the pipe's type matches the endpoint's type */
 	if (usb_pipe_type_check(urb->dev, urb->pipe))
-		dev_WARN(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
+		dev_warn_once(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
 			usb_pipetype(urb->pipe), pipetypes[xfertype]);
 
 	/* Check against a simple/standard policy */
-- 
2.39.5

