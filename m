Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044131;
	b=E8TuIaLNCXLKqgaQu6V4ixoHUJIQe5/tUT7fUaublcZikO9pvu/LvW8bJWo5GP85HRwb
	 l8WVH2DbqxlxeiKxMr0HSBPONWZrDtxthfHucI2XcKx3FeOBP28Y1jqc7jb33zalIitIZ
	 FfsS80I4ECwyZM4fty5xUaK5E/PzlB43s3UMgTf7NisrTh8sxNeJNqPuHy8cVspAxmPin
	 SEus4+XCGnH3fanbAPGa9I8c+AEHaNSgaxi2pto/6WO6J0ipUn0907dfsEAxytDDtU3NL
	 SCDuYS+MLAPzndWtdSdXQxKgxugMNt35BtA9HB7AjXK2S8uC1nXJVFOXXTI9mUENAHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8umiK4vqa2GUpEIgeNkKjjknpI9GUuNgUbiqR+DuZRA=;
	b=bsosgF+4le4a29KeZNUJBqiYSPnZ45hbMjdGoewLhwUEjajF+SRHaTPwlkFbR3kVNjKx
	 q1NYOzQavsVa+2BqF8RischZ23zqsWNSi5rlf8DWlNrvNSeyou14sMjT48I1AJoLHo70W
	 mBHz/ZIIL5fHQQprRg1zvOGQk2cwW6pvgMRoOPBiBP9nSpqyTbIYWm/KOriH8WlnEom0i
	 mN0kkt3BLzirI254722WBraAw4LUP4qNxndB216EX3tEbuXLCxPMUE74pydDZYKB0LgAZ
	 0oC57QVLRORnGdPyIGdSa2FtxwmU6fTwKXNrxTOV5E0HDZ+XKUOkZ3uwRe7BBb7X5sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDmhOLIt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFCF606A31C;
	Wed, 18 Nov 2026 23:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDmhOLIt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F5C1F000C4;
	Wed, 18 Nov 2026 23:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044131;
	bh=8umiK4vqa2GUpEIgeNkKjjknpI9GUuNgUbiqR+DuZRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDmhOLItKpAY+P1al3cjA3hnlNkGJAy13de+jEBjKMWDKEqcl9OU8vk9ciF5YV62z
	 71/thcAxinryo+S31qQwUhPA1kBA8LJV4qi7wGYznaDJY3vPdR9rh/oIvhonEWCClu
	 aKMAm8DF+CIh9VXIAX1sKPIpkSzqEMdKm6JbV0/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0456/2857] HID: multitouch: stop the release timer from being rearmed on remove
Date: Wed, 18 Nov 2026 15:24:50 +0100
Message-ID: <20261118150217.844236333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 5acb2dace582f061aab5e14c399ac9480315f44b ]

mt_remove() quiesces the sticky-finger timer before stopping the
hardware:

    timer_delete_sync(&td->release_timer);

    sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
    hid_hw_stop(hdev);

timer_delete_sync() waits for a running callback and dequeues the timer,
but it does not stop the timer from being armed again. The transport is
still delivering reports at that point, and the report path rearms it:

    if (app->quirks & MT_QUIRK_STICKY_FINGERS) {
        if (td->mt_io_flags & MT_IO_SLOTS_MASK)
            mod_timer(&td->release_timer,
                      jiffies + msecs_to_jiffies(100));

A report that arrives after timer_delete_sync() has returned therefore
leaves the timer queued. td is allocated with devm_kzalloc() against
hdev->dev, so it is freed when the driver is unbound, after mt_remove()
returns. When the timer fires afterwards, mt_expired_timeout()
dereferences the freed td:

    struct mt_device *td = timer_container_of(td, t, release_timer);
    struct hid_device *hdev = td->hdev;

    if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))

Simply moving the teardown after hid_hw_stop() does not fix this on its
own, because mt_expired_timeout() calls mt_release_contacts(), which
walks hdev->inputs; the timer still has to be quiesced before
hid_hw_stop() tears the input devices down.

Use timer_shutdown_sync() instead, which additionally makes any later
mod_timer() a no-op, so neither ordering constraint has to be traded off
against the other. This is the final-teardown pattern the function was
introduced for, and hid-wiimote already uses it for the same reason.

Fixes: 4f4001bc76fd ("HID: multitouch: fix rare Win 8 cases when the touch up event gets missing")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260723224211.613112-1-you@example.com?part=1
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
[ sashal: Replaced the older del_timer_sync() call with timer_shutdown_sync() in mt_remove(), since this tree lacks the timer_delete_sync() name that upstream's context line used. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 7ef85f307b123..0e061f266cef2 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1892,7 +1892,7 @@ static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 
-	del_timer_sync(&td->release_timer);
+	timer_shutdown_sync(&td->release_timer);
 
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
-- 
2.53.0



