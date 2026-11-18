Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027112;
	b=A4YMXbrJQgfqAv93uMLPdXQy+WsmztMR80rxeOaEFDD9ZZ0xlZGOUkq4hZ8IkuR3ie7t
	 bQp5bDhqxBZt2ZGqyk9EOo6PSDmTIWwoqn+X2B84JlfEKyGi18g4nXa8lxNgfgpZXprXz
	 puW+WFOk6pVt5dJIvXL92gTqN5Plpgj8C1YMFo6+jrRBPitO1d8HlNIFupsXcYsMiZ7IM
	 Or+sl5SZ/IRR9jI9WUQu1yuFyguFR8oLaWlEBGO3DNSG8Mb3noEYQsXBCwZmTSJlMrWIP
	 PXY8ulniiVPHDDrUfNz2qliQ8gFCalk6SVtIoT02gj5tsUz1iDud5sYmdogLxLvFiyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4rVw5c3ffXjXC7LKgzO9Zpx5V7PwSBeSNIHHrzX0mR8=;
	b=ZP2Y4IB19BsVVU4YiA3yko8tabL0L/H/F2tJzVvq8YMCkRDcqEonvtRg4MeFROyjieXW
	 S+OwPImV15bxEWZkjF/apyt6HX0eq9ZM62crtLdm90l3Ag6eG5C65gc6FRf/xKwETZH1a
	 wCHtyHu2SHzUvEZhs5PBO9pz2a/W1x6rYYTFbvTyIvk4P02k4keZNydVpc1Sdm1AG98hv
	 FMWcS+InTaxHRQ5+b0xic9QN9hSNme5Lw/5Of8jPHQMB250OMshvdQfYDoLSOP79m4CVq
	 ltEHmbh9//leIC4qJ9uNigvAKk+LYLumo749fpT8zM5s0HZkNg04ZpBi+LuFCHVXTrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZY/0nNxD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BAC606A320;
	Wed, 18 Nov 2026 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZY/0nNxD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A716F1F000C5;
	Wed, 18 Nov 2026 18:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027112;
	bh=4rVw5c3ffXjXC7LKgzO9Zpx5V7PwSBeSNIHHrzX0mR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZY/0nNxDTPJgV5gQoGcg+XxB6I35mPoOSEupSoJdyCE+ftG7AYTNUrN7rV0nlsIPX
	 RJaAZMd+283+rBDGvSyJzXVXIfssi7+roJlWNwZH3krh2z+oTRLzc/kVHN6UYohAJE
	 or4yNGvai6YhirwepfxoxXwhjDpN4+dOfLJ7Lzeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Geels <dmitriy.geels@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1673/2151] HID: logitech-hidpp: cancel reset_hi_res_work on probe failure
Date: Wed, 18 Nov 2026 15:56:48 +0100
Message-ID: <20261118150222.775267306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a931713a9cb69..1140ad92aacee 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4527,6 +4527,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 hid_hw_start_fail:
 	sysfs_remove_group(&hdev->dev.kobj, &ps_attribute_group);
 	cancel_work_sync(&hidpp->work);
+	cancel_work_sync(&hidpp->reset_hi_res_work);
 	mutex_destroy(&hidpp->send_mutex);
 	return ret;
 }
-- 
2.53.0



