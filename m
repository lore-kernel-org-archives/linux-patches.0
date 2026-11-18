Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059239;
	b=FWo9gYaQRA2bsTcrCbbYuQ31wXvpvVeC9Cx9DwUBFAVij29f6ZnP0ydzx58gEPyF2t1n
	 qkAYht6eUzBfWsH/JF59mnUOoZzY31g0nqqFfi0nThSvav9w/mnwBKCpAddMbD0Z864nz
	 n8Ic054FNNuF9r8R+jj25OERotu9WTJCujIIYZFx0/heNL0MiTIwDp4dY18C0LpL6Gows
	 We0trigCw3COxw0R8Hao0OMwqlY3CX8ffd8hwu5rZbrUlmarHLbEeqUjTUJlExpeYzSdv
	 DK01dnR2m6DkJUFKj2BNIDuRiHhjpV+8ZcwiOL8ip5l66sILDEAnDyzRKPqAQFL9vjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YH4S4PHyHM99b3bdqpqVqI8TRZe4tZtYMcNhjwGhP74=;
	b=f/mSJVnhEhR6BsmSnPX2p0ZDBsqns/OyDrMDBuZl/KPyzUnD7oFLeofiGNSQqhQNqPx1
	 RZtPkASSp6dAdnHh1X758w31JiH8/hMD+icZ2lbV8zLOXaNqmgA0+4oLaYtLbAvZj4ILq
	 FOftSt6sGK7vFUkl5gJGtEpOuTpvnqOlXLQlmlG4hyD5fbzEu0qVm8Yb81VZS47G7ZTXW
	 9mWJKHU+aoqJXw2Pl0/kptXt/XGUgfurTa3LHIz4gyASZuPhErbrh4YJ+4aMZEujeJAge
	 nbs4qCqjvIfSQZmZxqiGOCb4cQx/4x/Gfcgoie7yH+s5I04/hESPp5YWuS/3PxgZ30Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5oPDrt6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8D7606A31C;
	Thu, 19 Nov 2026 03:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r5oPDrt6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22DB1F000C4;
	Thu, 19 Nov 2026 03:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059239;
	bh=YH4S4PHyHM99b3bdqpqVqI8TRZe4tZtYMcNhjwGhP74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5oPDrt6CLDl6mvhXpQfAz5mhEr0tmLuzLtHR+0BkO2AtCvuu/6YQXWyt/kf9chyf
	 +vcO7UHw4v05+bnbBnhHhb8x+af7wIgYWrdcWXoCoLHW53YhO8a/6RfP8eJBAHPQ/3
	 J3gHcDjsfWJvXGOUkvxnBehxBePy8Nr8SS+QU+ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0771/1848] HID: wacom: Write shared touch initial status only once
Date: Wed, 18 Nov 2026 15:46:49 +0100
Message-ID: <20261118145948.660052470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Ping Cheng <ping.cheng@wacom.com>

[ Upstream commit cae3031c691dff0be61a26bc64e31a6939010d5c ]

For consistency with how the shared has_mute_touch_switch is handled
during registration, let's apply WRITE_ONCE to is_touch_on too.

Cc: stable@vger.kernel.org
Fixes: ba16e5ffbaa1 ("HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration")
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Resolve context conflict around is_soft_touch_switch in
      wacom_set_shared_values()]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 465d075d16f90..ad570af507458 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2353,7 +2353,7 @@ static void wacom_set_shared_values(struct wacom_wac *wacom_wac)
 
 	if (wacom_wac->has_mute_touch_switch) {
 		WRITE_ONCE(wacom_wac->shared->has_mute_touch_switch, true);
-		wacom_wac->shared->is_touch_on = true;
+		WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {
-- 
2.53.0



