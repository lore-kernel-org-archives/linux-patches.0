Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020673;
	b=YZrnKAV6MIvEMalXbwBrzG0NjCathcpYnU5wJ6UWYvyUIQUGqX6PBvppAOPPA44lL9bN
	 eaDx2SDwgUthVa5YC+WIbmLLMTFHNduW/u/9sVKyhO1rMk5Xz5FGSCxRK+rPzZ+GO4YFW
	 jsVwjZ8xixsisINYHdZA9JKSDo1qFHwtr0xPg+iK/1+0K/N82loyz88rrzhTtRTY+cQNt
	 X7loQpJklqyjxNUwHF46TuSeRzyWGhibjOUD4Yk0Bh8pkOic38llPWpyP29JW/U7HgDyN
	 JN6FuYskx1mPpTTEhiX54fnGAmFOB40o6nD1iUHGWdBgovhcb+cNET6/BmQyaKgoVkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkfatGRlSpiwgSqavcQ782f858tA9mEAcptbcCvvbm0=;
	b=fbIvn9CtFKeOEYWVPwGJOmF5Etm/DTk+PtREZ0FXKu8DY61SCFsVDDvPg2clbkrO2ZJw
	 VS7TcspXXc2Sgc6S6CbozR8UJDTIVBFiZOivec81bKPnmnF63OnkuAXsyG3dx/hF8rVQj
	 i/EhhBXZ9cXSVcLthzaQBz3MhBbf1xbKzuUqs3ZdzWERSI1oe2nzs2MM1Jtnd7m3HjYMP
	 o0Rp6xJFZ4p7pm2xrS8o6gIY5/0zVvcodY22zMg46edF7/0ndQhM3zgHWImqnBtOH9Snl
	 CalKnXC2WxffqfjmwotSktv0prI5sXSoG8igFmJHs40C5SJ3awXwiJF/rJlffqcmy6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8OfI7Ly;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFD8606A333;
	Wed, 18 Nov 2026 16:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X8OfI7Ly
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194981F000C4;
	Wed, 18 Nov 2026 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020672;
	bh=OkfatGRlSpiwgSqavcQ782f858tA9mEAcptbcCvvbm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8OfI7Lyj0N1KlEfVd7obrFZwq717bvhLorGkPnkCDjucixydo6Uo9vnGmUQOoiwZ
	 8Ie5j+J1mhISUD7KjqZufNIUxlR4ASt0mObqDUTK8IvoG2ZI5qNIaXZfiFwEnpi01y
	 1jPYSaL4FJcDltIPTmtW0DVaU3fLGfYQ6YVuB+GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Geels <dmitriy.geels@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2035/2651] HID: logitech-hidpp: cancel reset_hi_res_work on probe failure
Date: Wed, 18 Nov 2026 15:54:35 +0100
Message-ID: <20261118150359.385468406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Dmitriy Geels <dmitriy.geels@gmail.com>

[ Upstream commit 0be03caba6c002385e74d60be934b961aa5e88dc ]

The probe error path cancels hidpp->work before freeing the HID++ device
data, but does not cancel reset_hi_res_work.

reset_hi_res_work can be scheduled while probing the device. If probe
subsequently fails, the work can run after the driver data has been
freed.

Cancel reset_hi_res_work in the probe error path to prevent a potential
use-after-free.

Fixes: ed80cc4667ac ("HID: logitech-hidpp: Add HIDPP_QUIRK_RESET_HI_RES_SCROLL")

Signed-off-by: Dmitriy Geels <dmitriy.geels@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 9646380febaca..27d83b8bbaaf3 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4791,6 +4791,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 hid_hw_start_fail:
 	sysfs_remove_group(&hdev->dev.kobj, &ps_attribute_group);
 	cancel_work_sync(&hidpp->work);
+	cancel_work_sync(&hidpp->reset_hi_res_work);
 	mutex_destroy(&hidpp->send_mutex);
 	return ret;
 }
-- 
2.53.0



