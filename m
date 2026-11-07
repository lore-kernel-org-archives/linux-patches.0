Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061880;
	b=4ueXGKxIYcZHZryoxy525LGRSOpkRQlM+/+lJLWXZp8BgH6Ab+zXdy3Z7wRMxKpEfB5T
	 U7ScgF0P4BaBEf15rq9rTLZaUE4Zhv38tq2HSdfN4IvH7hjEtLVWqGK5S3gOH04gAgdFM
	 mt1/vAtbFKQtmY+TsMjDwX6XMbw/T0fdqHmSccbrqjiAuMl1jRHwPGYN8yIKpBXhvakBw
	 8SRJz5WzAXvaVkOmcaYcvI60WJ84fU6EZAPT/Qw30NfuIYa0imlvMgzRfQKAGo3dLp8yT
	 xf6VurcKs/P69zTT0Wn7WxvhonSdnhZJg3jzsqEhgTsXiLE73LybOfzpn50k9p6/yFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rCm+MNwfIJLBVzzwEdI54mFR/702CFH2CXrL23Z87dk=;
	b=eDiW4ONwQ4iTSXF1RZIRCCE3nGZyeybqhUdYixOfcXTeV74sfKK+usyGvbMzjKoiVkvc
	 5WDTWi+km7xg2BeE+U7NOvV+R0d2/3GcqQlEckrGP30KGxKs1b4qZ9IzKT4UbqKvfw1PS
	 YX/x0CC5O7qUZ7b0pVmurJuFWvbOdRFpV5nE/kcy4Vt0CBijZ7KeGbDWHM+0sFaV09de0
	 mK+6Ib0Il9JhzsBoMiWpx139lHfhjZ7/EPUZYQFJVB7yll+9famqYNEtD/ihhvZS28yGW
	 dbhcAiv/1QHJmNy+iGXRgZbeogyiFAVWLHSy3CDaZdspAhdkR+akEkcCKxJlYUnt2UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tc+4MrIK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A68E606A32D;
	Sat,  7 Nov 2026 14:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tc+4MrIK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D731F0089F;
	Sat,  7 Nov 2026 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061879;
	bh=rCm+MNwfIJLBVzzwEdI54mFR/702CFH2CXrL23Z87dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tc+4MrIKvGON6kw/umqNz6O7fkJRvA4PTgf41oQPw+GbdhTaxUAhxkQWXaP/uE9pN
	 FFSaQdCC2CVo4UvNtZ5cGEKdCkQhIqTY7Xms0NaMsDeBFXH70bZbQl4w1OzAnLTT1K
	 WmTFXW+QEdu+PCqOBIRmZocCRnqQOGdnjcSGv45A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0893/1536] media: streamzap: Add missing rc_unregister_device()
Date: Sat,  7 Nov 2026 08:48:29 -0500
Message-ID: <20261107135022.711371374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 3982d2eeb1bdf7a9c14e4ff69015cb456f11da51 ]

If usb_submit_urb() fails during probe, then the error path is missing a
call to rc_unregister_device(), which will leak various things like the
input device.

Fixes: 42844992664f ("media: rc: streamzap: Error handling in probe")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 8c85b9f30a3a9..e91cf2ffbc876 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -365,6 +365,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 rc_submit_fail:
+	rc_unregister_device(sz->rdev);
 	rc_free_device(sz->rdev);
 	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
-- 
2.53.0



