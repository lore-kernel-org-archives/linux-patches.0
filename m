Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211692;
	b=cBh65sxJCXV9JuCu5GIq7nE7hjIJVW0+dDQkcwzBY9IcW7/19HZMiAoN9G3dsX7p/y18
	 oNK9CAS7wzpgHlXWjb23IC/4v0fNnW9dMt51ANH4jDzKVbQYX/+RVEB89K0C6tVhjYjb2
	 wNhRFB7XwMerStDECEUbR+1sk6li/UGLqHa8ihuPbnSfLUri7lPVvImXKLDgSSHiz3mqU
	 qJaQAj0KoOxWN/+m4st4YfJ/gQ8nzeEGQ4leKZgjsLlkRaJtO35CabEKM0BJi/7pWeXgf
	 ubls8DxVuvwxiDy0NnVz+d7GXGRti6QRlDzqUAQHpIKKbd5650eBrCi3UfNEqtt2m4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7JIjTkXXJOCjhHSKgVq4y3B5JVXjVPyikUnkoevialQ=;
	b=JjDiRhhR2g1zZDpo2mb52MG0n04Aqs4nBtve+tIlgsSP1nf03u7Gw/jvbKvY11RWwDH4
	 Ua4GflmeNpBos1fhEbhoti2JCVFbyopO/AeL+p1Hp6KA6iB1FV15gHIUQG7X6rNE2a1y1
	 1UgA+QIF5jgfYcZjuD/UkTYhSIsvbMpFoGCUOgApZbqPascS8weTI1PWtu38DsFSXcK4w
	 kd7hOhv2R2F7VJRxD3MqQK49xQMcPDjgurNcsZIe/miOPUSQ7Os33Ae6KHBKLkjfqQTeY
	 3acS4eEHIYp8cfn+2JaHBaB/3Kz/qzLpa5phPRrnZgWyQ0P9DSm+KM+sH01J75KLi9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KdPOxm4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800E4606A31A;
	Wed, 28 Oct 2026 18:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KdPOxm4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E24F1F01829;
	Wed, 28 Oct 2026 18:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211692;
	bh=7JIjTkXXJOCjhHSKgVq4y3B5JVXjVPyikUnkoevialQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KdPOxm4kZoQ6kYmFecbH8qOwiM4MbVyyUimsTvsbUFia11ZigWeymxWs6xTzjb5+
	 s1dB1wICqhtyjNxjAgDP0l4nG2+jmqGRxD5cL1NHFxpUp5xWsgbjIWdsBmOJZOLDpV
	 l6YMY1SfLYHbxaIuKXsmKfMdF/1rsuMUSfH01lNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/571] HID: steam: Rearrange teardown sequence
Date: Wed, 28 Oct 2026 17:59:28 +0100
Message-ID: <20261028170018.003752589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a856276b6c2cf..628e4ef72b81b 100644
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



