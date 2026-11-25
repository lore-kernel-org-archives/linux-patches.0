Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619411;
	b=xxD0OgeUUkhaJ8Rj3oOJIilneU3nW2M/3p2AWN/8X94TJUwY6wSygBh5wQMlX2KzmdEn
	 2yslu+VTScF7BvSEKG0kiER25jm5GPs+BeyGppJRuaSBgdPnrPVV+siaL9k2tia/zedyI
	 48+4s7kfPfA56H6ZZaj71x3tiGLUWH5GxnHyl8+eTy3+gnU/uMXclr8cORU3Jr6WB8G8P
	 EMZVVed3RkINWGUWAkngboW7xJIpuniDFG0ETdv37NPg6/Lr6F7J5Jl2SBquz/HbUD7C7
	 ej0xx10xfY0hh/evomA1O//CYKPk5G5EGCVbRmhZo10ynjXbutVY98GcuhrqOVoUmmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FUn91xv18ohgEezJCquFOD5EcviUvSBw/g5QDZwmElo=;
	b=YjJT+K8y4X6Dhe8p+ogyL9WFqirBN9XQ5Dcr50O3sHdql2ZktVLA3gH3DWadfUJebV5a
	 VJtxFQ5Jp6x7GPI1RlnAMbEy6+++t51I+q/d2oZe7HZPRUwmUEO2e6YUzmHzMqaH6R5IL
	 CvlHdHGMvkx23CGt41g5YSRhKQuePSQ8ATvyq1vvLHHrxlA7qgWtR8iLKapcDVAdRY2lH
	 mUaTweHkkCnH5AJFOfkw7hsSiDoGe/pNcSU+Gw71cbnkcNIDCWQ6Swjtdjfob3g8qmEn3
	 XGnl1bfcn/WijHcHR72HRaydkKrPN1kPSGnhlWJteP4zHY/N1ZQ4iy2OlaABk2Uj0QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwGDq19a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C77606A321;
	Wed, 25 Nov 2026 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WwGDq19a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9511F000CF;
	Wed, 25 Nov 2026 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619410;
	bh=FUn91xv18ohgEezJCquFOD5EcviUvSBw/g5QDZwmElo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwGDq19aBCNwdcHd3nIHQbuOt5lTSM3PZJYZ4UecDCfZNnAWnftGX/V6MP8M0ohBL
	 fnTVgJMSJCr9GaLbCqJPAlHfajkp7QUOwNa1iWmClVJhKDcZLyetJo0mrzynoA//25
	 PqD/yBsa8LT+20IFgZP7XR4abuqeoRGWc0avgo6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Mulloy <joshuamulloy@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.3 0586/1005] memstick: core: dont clear dev->driver in memstick_device_remove()
Date: Wed, 25 Nov 2026 15:32:04 +0100
Message-ID: <20261125143835.473952745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Joshua Mulloy <joshuamulloy@gmail.com>

commit 6f2b998a52746892968741cbf8fc226985cbf286 upstream.

memstick_device_remove() sets card->dev.driver to NULL after calling the
driver's remove() callback. Since commit a995fe1a3aa7 ("rust: driver:
drop device private data post unbind"), device_unbind_cleanup()
dereferences dev->driver after the bus remove() callback has returned,
so this should result in a NULL pointer dereference whenever a
MemoryStick card is removed or its driver is unbound.

The driver core clears dev->driver itself in device_unbind_cleanup(), so
there is no need for the bus code to do it. Remove the assignment.

This was found by code inspection, with the help of an AI coding
assistant, after hitting the same bug in the TI FlashMedia bus code
(drivers/misc/tifm_core.c), which oopsed on SD card removal. It has
only been compile-tested: no MemoryStick hardware was available.

Fixes: a995fe1a3aa7 ("rust: driver: drop device private data post unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Mulloy <joshuamulloy@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memstick/core/memstick.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -100,7 +100,6 @@ static void memstick_device_remove(struc
 
 	if (dev->driver && drv->remove) {
 		drv->remove(card);
-		card->dev.driver = NULL;
 	}
 
 	put_device(dev);


