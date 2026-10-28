Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213445;
	b=p3c3zfFiv2ccT98Jew7qmOJ9kh848DirAAgHEgd/5iZRT46jEjB67Z5bj6nXuzYiXLHe
	 AtzIBT8E+TBR2hXTuoBuIItLHxchVhGsfFh9mrNrWFUiA66s+8h1fvv0sf8eOQI8o6d0V
	 P8w0+Ld0oU8ye3TE4u26/UWONvvwL1ibblfDkVaGTmmIgxKAlK3km1uE1RU79xT5lYsmi
	 V5Jak2xO55u3+gz/aejb/I+QKtL3GCImqvGLfTZJehbgNpsm2G0kRxAM9rNkEYntgusBw
	 dl8fWwDg+DjgfvQLrKxJ+RzG5O+4GcuJxZsvguipFllscqD5F8CC7W0J5uhSUE+LRgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VFrU5wJBzLhaCWU+pS6PNtClvIeRv5+iOZDbZpayX3A=;
	b=QuGpH5bxCav0HWzXWOt8X43IljSJ9D0aW5OsiEobenujtJv+VEj1iJMDzM5rokU8AkWg
	 KEtNPzZLVH5JXbcS+Ar9cDMh+z9v6AoN1rc6/T4yD2hHodEHasUXprJPM/SwrvmQHs7Ld
	 h62Wucb65Iy6R38j8PrbLcCVquwBonjelh+L1KIWk7PeGyp5mAPOmvpaArAiYa6fnNYxH
	 MqySBWc+wANRo7/TW0VtoW2WZeFvIn0MPqcHEZQvBFkR28XtqFbl+eEBCGdimlxFYgLAX
	 Z3KQFRfBB08iYRM/TUiUe6Z9Ogssl3BqWSjfDTpX4ftwkBW96FvdXPlHjyB0LoAvr5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1FH4Mwe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D49606A321;
	Wed, 28 Oct 2026 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1FH4Mwe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538F61F01829;
	Wed, 28 Oct 2026 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213444;
	bh=VFrU5wJBzLhaCWU+pS6PNtClvIeRv5+iOZDbZpayX3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1FH4Mwe8qHaCv0BGrKnK/uVWv58r3fO/xIsfBrLLpdHstPqnO4Bdlhz/kG2rzToY
	 owwGA8M7lYx/lLnEDB8OO8F45+1Oo79DhY25pv04cN37+x1d1MQwqhi8LEREiR0pVG
	 /1QNUuulijoeZPDKBM4/7vegbYUWlWpCWUbOzvfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0508/1887] HID: steam: Rearrange teardown sequence
Date: Wed, 28 Oct 2026 17:43:24 +0100
Message-ID: <20261028170510.868177729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit ddce9641ce924ed91ec8304577e463823a29ffaf ]

This fixes a narrow window during the teardown sequence where callbacks
could still be scheduled during cleanup that would then have a dangling
pointer to the now-freed steam struct.

This also puts work canceling for rumble and mode switch in
steam_unregister, as that shouldn't persist while the client hdev is open.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Omit rumble_work, coalesce_rumble_work and mode_switch
      cancellation as e133dc99fc07 and 1d4549fd1115 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index e8f28c59a3033..0e5fba060c913 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -829,15 +829,16 @@ static void steam_remove(struct hid_device *hdev)
 		return;
 	}
 
+	hid_hw_close(hdev);
 	hid_destroy_device(steam->client_hdev);
+	steam->client_hdev = NULL;
 	steam->client_opened = 0;
 	cancel_work_sync(&steam->work_connect);
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
 		hid_info(hdev, "Steam wireless receiver disconnected");
 	}
-	hid_hw_close(hdev);
-	hid_hw_stop(hdev);
 	steam_unregister(steam);
+	hid_hw_stop(hdev);
 }
 
 static void steam_do_connect_event(struct steam_device *steam, bool connected)
-- 
2.53.0



