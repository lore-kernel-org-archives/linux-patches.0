Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B37E29A2;
	Mon,  4 Aug 2025 00:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267230; cv=none; b=sfzUfroAQ4s/TUmp4KzbyuauDXyzlwcs3qaal3x3pz2TGSGMyhvmioaFkFhW2PojtC/BZAwUwcc02oQZFwev/VvNqAFVjLo64DJcEl6tNasGByav+MzO+ziGEOmZ946lmxF5iIh+w72LjcybcJrALordh3NFsApgO7nG0m1p1MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267230; c=relaxed/simple;
	bh=o1gEbAT2Gwkk9DBrp7RGMkbSUo8XK6WaVrcf6cgf5Ko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A052ems3ZcOPWSATm5ks+R87pZDMriEz4PJLAP+fxRiQsewPtRjj3+pKtBBBEYVfgtX2OQOBjD8vor94xFHBRqzPpTv515HznAfF6Szwh5D2BEzxrkoRA6Tt0raowxlN87JH+HMTUGAqs+ALg0DtfPQOG66KwxB6v2Zl7iaCtgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijD/pj91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijD/pj91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F43BC4CEEB;
	Mon,  4 Aug 2025 00:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267230;
	bh=o1gEbAT2Gwkk9DBrp7RGMkbSUo8XK6WaVrcf6cgf5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijD/pj91kJWOeZbR26nbO5JcpmPKxMpikMaHImo/R/yI68LbpVR/MVR3aQcDIb3KE
	 Ek0GQlc+84GnDjtQ2t4YnzZ6JR+yaGTMmHcfel8C/qcj34AVmYTnyM0yc+Wiq/CsIO
	 fV6EvdH/4TEDt0Jrr+qmbvZeMJqrdu/rto64Qzt3LcnTkraasOSR/Er2U8SOGaOfOP
	 w0sP+dnuP7FfTas+A166RJ8PDs/kfeVDC+OmFAEEO4PFSptXgxGbHaeUecTHDqpdTR
	 B+VNuVwznvfLTYmbAqIaQumnuHqwhzDyG7lKo/3Bnc+P3AMwVgcP9Nuw1BYkwsRj0X
	 +k+8C+F3WL1RA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@treblig.org,
	thomas.weissschuh@linutronix.de
Subject: [PATCH AUTOSEL 6.16 72/85] usb: core: usb_submit_urb: downgrade type check
Date: Sun,  3 Aug 2025 20:23:21 -0400
Message-Id: <20250804002335.3613254-72-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
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

