Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208991;
	b=bffadO5ih+bzXsaQ+n3qZ01IP3CxWxK9OjMSoak2sbK5ZhJAhJEujLx5SVS0ZnVBXmKH
	 jPItioyZiUMvwE3Ix4mkjgv7L1EFdl0Deck+KlhS2AMzmilTh9xV7Dq5kzirYu9atzVM/
	 GIxiwiSV/rkC3TWiwtvWaAD+JsOFzjmkPXFPBCdeBeQxGVfAmNX35Dc26By1sJYYq5pwd
	 wEUK7Nz9iY/kIQhcZvF9cZvOhVyGa5lTXAH0UApM0u0UV4n7jG3PF+AQdbjP7Z1kRXPrP
	 vWu7iSXsJIMSrqPpobqXhl3z4K6XVMip3cFZIlKhPzpMOu6EyVkVCu+nKbqSGVJYjHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zpS5V9Z6PUzcKVRgow9O1zLY3ki7Acp9ef7ItMmaER0=;
	b=K8R38Vtdb/Yyka4RKTev2FRulOiESsKXUPFmWWDb9wRK+0FExFeVirmuQWcrcESZeIzd
	 /HbYnDLjKHgvGFzdoDGUBqHyW14qa77VdsrtKLBtFSuFqCv+0P6Ia8BXvNng6TLbnKVpU
	 VfwhhjjKnW/oFrbUIUjCevo/9/F8SgxpbEK/yZYJT7PoTYXxvY4jwtK29k880NpSxnPIU
	 p8uu2srhtjNq4UjKa5RvLPyAN4hz61rEZsSUz4mC0y9hy/A3pFuBWjjDAQHk7c2T8aHq0
	 t//uvxI2fYM8VySmfkh59FGSQSqJke3Sdk53u55mVbQKxtsGyH+OwqBJDECPuzBzn7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RybssuC1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3399E606A31E;
	Wed, 28 Oct 2026 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RybssuC1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823941F01825;
	Wed, 28 Oct 2026 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208991;
	bh=zpS5V9Z6PUzcKVRgow9O1zLY3ki7Acp9ef7ItMmaER0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RybssuC17Ad163DP0RkQYkEHKx9uc7KYIGUHQUBfWxVUkRUVCpF3PKUGNk65Rs6Ry
	 Rfy/ThKm4oi+Wsw5Mw/zwu5d4TY6VRqZpct7onRjuBlSNAKmvyCipykoB8O7vUri5e
	 9Ph1OeklFw/7ajuVlMxv6ryUwZP7x5hDOK8BCzDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/516] HID: uhid: convert to hid_safe_input_report()
Date: Wed, 28 Oct 2026 17:57:45 +0100
Message-ID: <20261028170010.904856747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 63a694c51bf120a37550890b8e7736b4888985e9 ]

Commit 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing
bogus memset()"), added a check in hid_report_raw_event() to reject
reports if the received data size is smaller than expected. This was
intended to prevent OOB errors by no longer allowing zeroing-out of
shorter reports due to the lack of buffer size information.

However, this leads to regressions in hid_report_raw_event(), where
shorter than expected reports are rejected, even though their buffers
are sufficiently large to be zero-padded.

To solve this issue, Benjamin introduced a safer alternative in commit
206342541fc8 ("HID: core: introduce hid_safe_input_report()"), which
forwards the buffer size and allows hid_report_raw_event() to safely
zero-pad the data.

Convert uhid to use hid_safe_input_report() and pass UHID_DATA_MAX as
the buffer size. This prevents the reported regressions [1], allowing
hid core to zero-pad the shorter reports safely as expected.

Cc: stable@vger.kernel.org
Fixes: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/ [1]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Lee Jones <lee@kernel.org>
Closes: https://lore.kernel.org/all/ahsh0UtTX6e0ZeHa@google.com/
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/uhid.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index ba0ca652b9dab..30d533ada00b3 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -597,8 +597,8 @@ static int uhid_dev_input(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!uhid->running)
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data,
-			 min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
@@ -608,8 +608,8 @@ static int uhid_dev_input2(struct uhid_device *uhid, struct uhid_event *ev)
 	if (!uhid->running)
 		return -EINVAL;
 
-	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data,
-			 min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
+	hid_safe_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data, UHID_DATA_MAX,
+			      min_t(size_t, ev->u.input2.size, UHID_DATA_MAX), 0);
 
 	return 0;
 }
-- 
2.53.0



