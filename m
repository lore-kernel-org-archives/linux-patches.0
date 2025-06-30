Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C0292B4D;
	Mon, 30 Jun 2025 21:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317319; cv=none; b=SKa82H2edCtYXgTVGHm3yX+GsfvHEH6hZcNZ1ISJx4/g5zDcRU6WqW91hnHf6tABNlGmB2vZ05elnIkjSm8qs35NkDUIxDNDnMJniklR1adsjkREptRjFE2C8QP/4JODufS2fjTMqNV8VzdCeK5mT8nAg10QWFjtN8loQ75//9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317319; c=relaxed/simple;
	bh=eiUkk3krtWCp6+7ek/Zqkx1BAoP6Ur/B+UWBUzkR4Cc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DMCCBQRzt+ijqjpRUe/s2lHYQZ+YhN4kdG322kIhlkPJFgIbLneONS7xEvISQl4VDvlSQFSuuf99gphZ666pZiLZhS66IbnuMysZWMnr2+1jHfz411LHIPEldQiaaiCDE5katpFTgHur+g6WoTdEcddXKI1sU9U8mP4iELQzyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PL9L9ptz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PL9L9ptz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44B9C4CEEB;
	Mon, 30 Jun 2025 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317319;
	bh=eiUkk3krtWCp6+7ek/Zqkx1BAoP6Ur/B+UWBUzkR4Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL9L9ptzl/4Lb7QVg8BERlybXd/I/RMblo80a+PForY1Dqc9pkIpOKmEXVzTd4mjx
	 T9ezxF/IreHFzyd41fmuesFJduvFdVlWq65l/hr5s5A1uJ4hhxTAu3yfIugLe6HMDd
	 d/R2OWtw4o/r1b/Mb++C43jnM3i2Ozp8u6zOr21ATXfoSgjGYlj3iX98MZwYKzsa9f
	 Bn2lRBfB6lFvRgdlfsIYvX6+M1TBB3/Xbv8lXLUBMUd1k5yLyntH5+8TL6d1Duc2O/
	 Dfvd+9Ej6uwN8wW/GyyvwPOH0/tTcyPTHW6KWdaL3g2YqYmLy+yThv3Rbcz2D//HMP
	 c4RtLmkQLRVsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Pitre <npitre@baylibre.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	aha310510@gmail.com,
	mingo@kernel.org,
	kees@kernel.org,
	gnoack@google.com,
	tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.15 5/7] vt: add missing notification when switching back to text mode
Date: Mon, 30 Jun 2025 17:01:42 -0400
Message-Id: <20250630210144.1359448-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630210144.1359448-1-sashal@kernel.org>
References: <20250630210144.1359448-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.186
Content-Transfer-Encoding: 8bit

From: Nicolas Pitre <npitre@baylibre.com>

[ Upstream commit ff78538e07fa284ce08cbbcb0730daa91ed16722 ]

Programs using poll() on /dev/vcsa to be notified when VT changes occur
were missing one case: the switch from gfx to text mode.

Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://lore.kernel.org/r/9o5ro928-0pp4-05rq-70p4-ro385n21n723@onlyvoer.pbz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real bug affecting userspace programs**: The commit
   addresses a missing notification that prevents programs using
   `poll()` on `/dev/vcsa` from being properly notified when the VT
   switches from graphics mode back to text mode. This is a functional
   regression that breaks userspace applications monitoring VT state
   changes.

2. **The fix is minimal and low-risk**: The change adds only a single
   line - `notify_update(vc);` - in the `do_unblank_screen()` function.
   This follows an established pattern where `notify_update()` is called
   after VT state changes to notify userspace watchers.

3. **Consistent with existing code patterns**: Looking at the codebase,
   `notify_update()` is already called in similar contexts throughout
   vt.c. For example, in `vc_do_resize()`, we see:
  ```c
  vt_event_post(VT_EVENT_RESIZE, vc->vc_num, vc->vc_num);
  notify_update(vc);
  ```
  The same pattern should apply when unblanking the screen.

4. **Similar commits were backported**: The historical commits provided
   show that previous fixes adding or correcting `notify_update()` calls
   were marked for stable backporting (all three YES examples had `Cc:
   stable@vger.kernel.org`). These commits fixed similar issues where
   userspace poll() notifications were missing.

5. **Clear symptom and fix**: The bug has a clear symptom (missing
   notifications when switching from graphics to text mode) and a
   straightforward fix that directly addresses the root cause. The
   `leaving_gfx` parameter in `do_unblank_screen()` specifically
   indicates this transition scenario.

6. **No architectural changes**: This is purely a bug fix that restores
   expected behavior without introducing new features or changing the
   architecture of the VT subsystem.

The commit meets all the criteria for stable backporting: it fixes an
important bug affecting userspace, the fix is minimal and contained, and
it follows established patterns for similar fixes that were previously
backported.

 drivers/tty/vt/vt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index bd125ea5c51f4..4898299768121 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4443,6 +4443,7 @@ void do_unblank_screen(int leaving_gfx)
 	set_palette(vc);
 	set_cursor(vc);
 	vt_event_post(VT_EVENT_UNBLANK, vc->vc_num, vc->vc_num);
+	notify_update(vc);
 }
 EXPORT_SYMBOL(do_unblank_screen);
 
-- 
2.39.5

