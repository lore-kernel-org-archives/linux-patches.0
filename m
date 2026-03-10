Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA28E313537;
	Tue, 10 Mar 2026 11:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141112; cv=none; b=c6WYkzMOB8lmSe2H5bsFg06JNiGR31zGEwCFYJ/48e2pDO/6Lbi9z2Peuh1jjaNmiN7BXKRVDph+X9XcZtCVHIu7Sv1cCWzOF4g5YgMVMHkm8nIzl8dDnAfqtl4Ehb1jVsVxsGJy4zJJgri0FiHaYp0eist/Edgqy3Dv6ACDW8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141112; c=relaxed/simple;
	bh=M05alRrTI/oPVhn80DxYuCD6UHuxnI4LYiGzXOqwhxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cg3z3/F8cFO9//4oENWnkEl0hxtpObK0FpB4mLjoEwcHro6NotWnHzeXhYSRrGTKokdxIRj90Urm9VBeBN2drgfjwyEDbbwjev3JhZmbIvQNRUED3ME/7KN74l110ozn5EJ4OE4l+F23Hwck5e7vzPFG83ir7AAxOws/jYxXiLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONWzpY0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ONWzpY0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10256C2BC86;
	Tue, 10 Mar 2026 11:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141112;
	bh=M05alRrTI/oPVhn80DxYuCD6UHuxnI4LYiGzXOqwhxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONWzpY0NlhbQnBwFZbZSF4TgrXZDHQ7zdgCOUaQnyBFnLqznMAoWzamVgNmguZjxB
	 VA6k7Z5yrRgMyu2fXeukVjBZMtngDZWgBvyS9namVOsaYDNOjPsJ5rc226UiyK1tsD
	 XvTIVXPXn31RteQXPYosbO9cScyKhxyzL2nCPLAi6PuUXeebIOt0zKIlXEGqAA02TB
	 PjupLwjmgk2poJ8xllaLI6UPQYLIGvVsWVSbSIKkGNZkvSxUWyV8oMAvGzbJBcarQM
	 ZH9UQRIlcOPmNRYofvAmTDq8EBFhsK8UxXbmHtHUjC7bwUPFTJmh5hAupcU3Vpd0WL
	 UBe6maT/355VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 114/311] HID: pidff: Fix condition effect bit clearing
Date: Tue, 10 Mar 2026 07:02:41 -0400
Message-ID: <2757d8477689d2e4be3cacdaee00ad307c027588.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

commit 97d5c8f5c09a604c4873c8348f58de3cea69a7df upstream.

As reported by MPDarkGuy on discord, NULL pointer dereferences were
happening because not all the conditional effects bits were cleared.

Properly clear all conditional effect bits from ffbit

Fixes: 7f3d7bc0df4b ("HID: pidff: Better quirk assigment when searching for fields")
Cc: stable@vger.kernel.org # 6.18.x
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index a4e700b40ba9b..56d6af39ba81e 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1452,10 +1452,13 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 		hid_warn(pidff->hid, "unknown ramp effect layout\n");
 
 	if (PIDFF_FIND_FIELDS(set_condition, PID_SET_CONDITION, 1)) {
-		if (test_and_clear_bit(FF_SPRING, dev->ffbit)   ||
-		    test_and_clear_bit(FF_DAMPER, dev->ffbit)   ||
-		    test_and_clear_bit(FF_FRICTION, dev->ffbit) ||
-		    test_and_clear_bit(FF_INERTIA, dev->ffbit))
+		bool test = false;
+
+		test |= test_and_clear_bit(FF_SPRING, dev->ffbit);
+		test |= test_and_clear_bit(FF_DAMPER, dev->ffbit);
+		test |= test_and_clear_bit(FF_FRICTION, dev->ffbit);
+		test |= test_and_clear_bit(FF_INERTIA, dev->ffbit);
+		if (test)
 			hid_warn(pidff->hid, "unknown condition effect layout\n");
 	}
 
-- 
2.51.0

