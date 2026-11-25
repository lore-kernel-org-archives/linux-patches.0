Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625821;
	b=FUWksEhgeEiUQe4fCvM/xiXqQqnp1Xisjx5jkWU1Zbshe6TbfOKt0V6GuwymSPl8t9DS
	 ZCOna9DFxBbfQR2IqyrYc1LZUPoLGFnKJ4mdk13jVSAQFpN/05778JFt9HBCjhOL/laVw
	 f/mbMpP1Xj3thKBYgsoqQV8ZQgudocsTvyeu/wBpQLLBYdIGL6BiOUYpXO2OLjaHK0pq0
	 8Vt0cJR/mSAkSq6jBjlEq965TVnl4Y8DpcPxE6Ta+clR613qemS7j/k6TVEm9r0nzGgsD
	 FXe9CBriTsv0T7o0tnv6btH3mX3DbEJHxuW+R/5qGeVS2cf0BY1n4nuJp19Qxpmsq5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A5Lc30jBAWm4isNJuSrwUNB1UjbjbUUVCvr3ur7AJWI=;
	b=2yfCEFSuzxV2JnGrdnKOdqHKG8b0yr3MPhJUpWnxBm/0tV1seTIx1KnjknXjA4Sqtpig
	 2i7yRPheEVueEEM4T/KnFNCmBu6BkMeB7ZkiyAivw9U71dYHX93ROESsyD49YIwYPoPTK
	 uZDNL0Aoi5Cyn0S+Ee0lVrmQNAQ8MUl+PEEU6myrBRIQNH0cIbg1n3RIYu5Zsck2cT22W
	 /vGsw1WFbJo5Js7mIzq+iWOWSCaya1v2kEc5Hj68DzNteRmXJoKiMOhfih00RYyQoBNmL
	 PcSvstcaZLu2AUKHXAS3g8xUovN1CYh16W9qUvAwLwZokHRvdBZhiCSa5aZ1cbDFy9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psm48FIS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A0C606A321;
	Wed, 25 Nov 2026 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psm48FIS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CE11F000CA;
	Wed, 25 Nov 2026 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625821;
	bh=A5Lc30jBAWm4isNJuSrwUNB1UjbjbUUVCvr3ur7AJWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psm48FISS8pWLdGiSjxjU3YY9PHq7keNOQC5Z3dvF3D+uztRnXBtucWyQkf/m6uxg
	 3jzbWWsMXPwvWrZ95i3Q/+GVcTHAsKUBI6N2RN2abHsfOTVqm9n96RZ9HUq3nQmrqF
	 KYzGRJvo83Yr8IU370YboJhLnd7nlTvp1T0l9DEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 641/816] hwmon: (max31760) Report 0 RPM before the first fan speed measurement
Date: Wed, 25 Nov 2026 15:36:29 +0100
Message-ID: <20261125143904.021201590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Stanislav Aleksandrov <lightofmysoul@gmail.com>

commit 33d58cbf2ab26bda81bc3052158d8b9867d5b9a6 upstream.

The tachometer count registers initialize to 0 until the first
measurement cycle completes after power-on. To prevent division by
zero, tach_to_rpm() clamped tach == 0 to 1, causing it to compute
and report 3,000,000 RPM (60 * 100000 / 1 / 2).

Return 0 RPM when tach == 0 instead.

Fixes: 38b04ad02d0d ("drivers: hwmon: Add max31760 fan speed controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Link: https://patch.msgid.link/20261108-max31760-fixes-v1-3-a61450463059@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max31760.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/max31760.c
+++ b/drivers/hwmon/max31760.c
@@ -68,8 +68,9 @@ static const int max31760_pwm_freq[] = {
 
 static int tach_to_rpm(u16 tach)
 {
+	/* The count is 0 until the first measurement */
 	if (tach == 0)
-		tach = 1;
+		return 0;
 
 	return 60 * 100000 / tach / 2;
 }


