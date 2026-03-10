Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EC83876D7;
	Tue, 10 Mar 2026 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142018; cv=none; b=C1XNwbrG6eLXXXFfwQXbQezUULDrKVbZFU/65XQCo5Vz3wbIlSc1YD8UQ7AJwzM5u7G+U+p2rHSF9dyRkEr/aDyGwhyELYVYtz7m+Hh2qWQ7Q2expL9Y62x6ZcZubpy6YIrD9ot6bQdcx5FrOYZIMcMIzxBjtvY+CXvn08TJX3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142018; c=relaxed/simple;
	bh=M05alRrTI/oPVhn80DxYuCD6UHuxnI4LYiGzXOqwhxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUl0cs/J4d5eA8XTHt3SbC2enIZqjEd7HhCs3IEtBSYTrEEp7O2wsEUzBhsEiiQf5wwA06Hxr9whmDmjMvCqPA41C40ert1bA4IG73XX28WNAr9b/lFW4J6AZd12qnhmSpk8BalWToRKAwF+Zhv50bhLbOq7ycTpjI9YaZUDUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LdeJmdRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LdeJmdRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49612C2BC86;
	Tue, 10 Mar 2026 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142017;
	bh=M05alRrTI/oPVhn80DxYuCD6UHuxnI4LYiGzXOqwhxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdeJmdRJurPxaf3laP4GULI44PXLVTzzGUzh9wle/MGNSFows+eoRq+LjI0lcAP7s
	 2w5LpuNLCUziZj7DwA65Z4gSYChdt5LSrKxhfSuqmtS36oNGGRpvqRQ2rzEwPugVmp
	 LMuqmtbUra2H7wGFXuv7bJ4wBR0yE1V8Rsdx6Pvk2CuNfj0rFHoUrEsAH75sBeNr+E
	 UtcAzPO5gsqCpCgkJtwZdL9Ok+NMNBwtpFh0oTicQdj3ymGjjd33oj1GiM/36SwT5C
	 84RcL1u0yJ7xizuY8Sjs7VVNPPt9ZqqcwmG5/0MVbsgbCHyh35lTi914hRTILgFqgc
	 05JfE/U8q0hZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 144/314] HID: pidff: Fix condition effect bit clearing
Date: Tue, 10 Mar 2026 07:16:43 -0400
Message-ID: <1ba3df6a39853b2c93e4e3fbd5af5475a534dd0b.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

