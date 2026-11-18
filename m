Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035102;
	b=cTg6k8j4dBh743iZLhT7+6cJu20qfLjjfLxWKLGBp3gGl9669hs8cd2x6K03EVOtlvf2
	 6nX4vcM2MZKgOBBwD+LK5YMQVpW+wnApngfQzFfsQvbwIso/uvW3Rsfny0hpOkj5Q/xUS
	 WCj8GWD7fvGkbwaiVhMDkOL1NSVbSgX4KKMS8BVFSucfHh6G9wwkvz6ZASsx5FOFcd75L
	 JjrOnzfG+GUlKM5E7+ZNGqGbjxI9tG+9LBFfqr8Ml2x0iOw3mauc57EfbZjwtbq7DGbCQ
	 XqHjiqq9mVvTT34TR7Zt6M3UlUec5keE2EmeF6lbcCVwRqpmPIAoqBQLwIzBU+EPwsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VY6RCO63gRU6hjiFY2NPysIyQCTp19vRguXG1DN9Gsk=;
	b=JOvg8vyfG/LwiNCOdnGGkNzDBL3LzPqyjZ9SfaakwMDzLaeEky0sl1tIHGjSA0LrlQdK
	 h0ZIU0VyZZ4nDLMrh3QmIp/kxkK7zabcLyymLfE0cFxwPpjU6oKDvAE4yVFqFyyBnDkzO
	 1Q6QYjKpdn34VMQ5oQ7r/B1TvsGu8E8M1Inex8FjP4t4aZz9JshHUcvEDeYTINuZx6Rzi
	 pUDILVXhVXfrZkI/LyItiUbJBq6dH85sUEND6+4Yjbb46imT+dqfYieeKwcBqqPDLnzeB
	 uvptuCdhLExQwEyAzxyvq2jIWvFEeebCt5DAYOJ1dTwKZiCfrR8INQMgyn+I/21XNvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkuYRCVa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17424606A320;
	Wed, 18 Nov 2026 20:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vkuYRCVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C721F000C5;
	Wed, 18 Nov 2026 20:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035101;
	bh=VY6RCO63gRU6hjiFY2NPysIyQCTp19vRguXG1DN9Gsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkuYRCVaAGoSt4TaJ6ha8dPS9vDU7lQSY72O26KT3BPIViGM7CNHvFywoHK7zWpFB
	 k0sAFLYzzdWYTtFX5W4/2nSnsveCf7+tPAUyk/wYg3iomTvjjz6siyuiDiYfDoqBMU
	 SZrRrJ5vjhsBEq7KdEoa7ZzY0YNTfED4Ldx4HW6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0607/3318] HID: wacom: Write shared touch initial status only once
Date: Wed, 18 Nov 2026 15:20:29 +0100
Message-ID: <20261118150335.939669813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <ping.cheng@wacom.com>

commit cae3031c691dff0be61a26bc64e31a6939010d5c upstream.

For consistency with how the shared has_mute_touch_switch is handled
during registration, let's apply WRITE_ONCE to is_touch_on too.

Cc: stable@vger.kernel.org
Fixes: ba16e5ffbaa1 ("HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration")
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2353,7 +2353,7 @@ static void wacom_set_shared_values(stru
 		 * match historic default.
 		 */
 		if (wacom_wac->is_soft_touch_switch)
-			wacom_wac->shared->is_touch_on = true;
+			WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {


