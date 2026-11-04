Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827089;
	b=HTq76pxW+lQXC2Ojv7ESgK7l3npijNyJMr4Om2P182di9AON+3aXNKYD0+roMBwl1s+M
	 5y9r+1TmlkN678gQqouahy1VdOGa0GHJP4oYM9ybZyuX40eNnec+WS4T4UjqCavQmpIvr
	 iaEjQjQA3Kr1yT9UvUpA/EOEUnfUqpGIi7HOLQzXDmMD4yjAdahpL8ubp7MBTKKxgcnZI
	 EqtJ3AyrcyTcpFEj4wbWHCuEPbrkEjPz4+Mph+yKZIed5m/xA8VbHzcqDnzn8YSThlJbj
	 0n+KFFQfVCKtmlN0rIEY/tkxvqLhltGgeeZq1asITtIZtSjUkU9lifK879RKrnqFnjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jhZy+a77cpqleP+RnZ0f9S9e/Hg7IiTDQ6ndgtDCHTM=;
	b=Qlk6MHtPENqJCyfmjk6Eon2apMLRV+PENzDW1wQNLSCXlldinfSYy5uz4Zq48rt8LOZF
	 IyEsSNE8t44XDz1OUbhH3rEoz7DZQpGmcIc27sPgywQMjcTUL8Tqc7ezHjtKZSx18gPEb
	 4WEm4aOq0HSlDO8OS76jQE8+LiboLYhSXzJs9DC+ihDzYEuxrBsRTtFsy0leYVvwm3MBJ
	 eMBhpHtYo8oGvB3Q3Euks9Y+0Ep4lheU3I8u6eJSJEiur8EqR+qiiBBjUHnA3wReoLHFZ
	 Svcg5lcQnk7zCS+BXlr4E7Mxkv8wccw5K/KN71JEl0wlutqN02l5pVv7UTvGJVUklBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZeHWDHb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D844606AB22;
	Wed,  4 Nov 2026 21:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZeHWDHb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF26E1F00A15;
	Wed,  4 Nov 2026 21:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827089;
	bh=jhZy+a77cpqleP+RnZ0f9S9e/Hg7IiTDQ6ndgtDCHTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZeHWDHbF1B2CiFPXjFuaKUYmqm924cCehjVy5QAUn3iTHDaq3F4wDbxkwLHeRfrF
	 1drERF3UcE2CbJYso/gqrN2IPd94q0bl9eU9LTnuPjSwo+5MCi00O604RT7YluLIDS
	 95zyLadnbWb8PfYdXg3MXdx+VCJdoneGJz1TKFfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 189/547] HID: wacom: Write shared touch initial status only once
Date: Wed,  4 Nov 2026 16:06:13 -0500
Message-ID: <20261104211043.506440148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2387,7 +2387,7 @@ static void wacom_set_shared_values(stru
 		 * match historic default.
 		 */
 		if (wacom_wac->is_soft_touch_switch)
-			wacom_wac->shared->is_touch_on = true;
+			WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {


