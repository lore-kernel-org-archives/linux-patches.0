Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044395;
	b=vpUCw40KFZeVE43/5eNmv9ZQ7GOPlu8SjvQ3ivDFclrTPPfrLMNt3tSkcrq5iYT82Gz+
	 CRAfxzjmy+v7FOMnT7NoCgCEwXrwNrZgYCIifw7HnNRT5EsnhRnrSe+Ju99OKMDz3O27D
	 XTk2FQKuHQx/vk+o5ZHni96Mqv9ntzLqjYghoDBQW0sVRsgzLI8YCdzGHkCrWojC6EJ2Z
	 D7yo2FjeYj1FBkoUiiYOmybzgGAi16eGF3aHtV+kBHDhIlGoSkf2Kk3RksWZH9cvPfNDP
	 mTU3+H+1/OprSOCnXEa/vwvSDRePdsWPvmPWJXfTZBwZnA+zDXmxMXkEbiy8nUh6a5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hw0V+y4Lr/PJrAePwmdOhNBuOksANoMGyoXl4ISVvTg=;
	b=YhNQBwu57uTlTWRDYlXo3YWV19Q748kSBidwd9TTfO9J4jU754DA+giLtuK/YAh0v9lN
	 W28UHK0UzjwbjcZFQEiJbnw5Aijhz961XijJF9vUl5+DhOBFkpoWSz6Iz+NgeYwLqwKXV
	 bU7tbTJYbOhzdGGoW7p7px8VWwVBWQL/MtrA/+GDUEmSAnc4FpztGz0Dc6U30YMefRu1B
	 GwdLXk7vXIkvzluKI84CMMQ76qjoiZ8Y5eSh7CjcJRonoeRCifIynMcu6AH0rZgIorZFK
	 UhSkJFv8HMnqb9ki7cNDS7IDhKdtcg0gmV5FiTOC/J6eUBhJ8ysyP7Eq3H4OxvYg0xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lW84aT7W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D30606A320;
	Wed, 18 Nov 2026 23:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lW84aT7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA6D1F000C4;
	Wed, 18 Nov 2026 23:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044395;
	bh=hw0V+y4Lr/PJrAePwmdOhNBuOksANoMGyoXl4ISVvTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lW84aT7WNg3Dsj+zjgSoAdEpVEFq7ft/MDlrOHchqMgo4+Hh7BSSczRkD+5T70tFV
	 AG79ca3La5BiaBeTYZGAqDBhCuJnAXB6nqVumLMjn+UjP96qcAfw7/zZE1nxhRliaX
	 THeDGCpOoPJVHnjSLwMSYzeIk3lOl9PXjx9sUXzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0551/2857] HID: wacom: Write shared touch initial status only once
Date: Wed, 18 Nov 2026 15:26:25 +0100
Message-ID: <20261118150221.328491791@linuxfoundation.org>
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
@@ -2349,7 +2349,7 @@ static void wacom_set_shared_values(stru
 		 * match historic default.
 		 */
 		if (wacom_wac->is_soft_touch_switch)
-			wacom_wac->shared->is_touch_on = true;
+			WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {


