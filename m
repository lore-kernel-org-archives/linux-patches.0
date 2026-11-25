Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623373;
	b=HCOw6LR6GElFw5W8edds6nbBTbqSE1h2JuqE67tHG9w53kxu0mSDoHqHOvZv7vUQPGf9
	 LwZUsjr1BvBxczM44NuhsmqWpY00QKgLxr9Z9N2/QdWQdx6uwM/g+S3/L8PI3n3YZ4TSF
	 Sma2Yh2+dRzrB5N00dc5Hwffgqr32yFPyL01JbvuucA0eK2T5B92e5cF2ZWz8nzFP9Lr+
	 zM+Nl0LsMZbVg8zQ7RTeBhsRp7cPzUWAyN5jFtRoAtyLfmVjWZeEYyr1xBi9NbgZv/P67
	 by9bdhYiBIuubHeX02rpjRNMD99/wV2B5G9/Xe6G3Zu+T3PZnfF7gfCz8xCXrWN8a6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=409gaLVdfqL37YZ9aAGd5vPJ00EqfgDbjIKJttT38i8=;
	b=K7syzIPOC8J5NKI6eXlEpHk2zjRRuFfs940m2gkxKsy4XzjMrz0/7MEcnh4Qy2Y67IKy
	 iCrW2lyU1T+wQKnaYfL6FRrDPTTGYgQXGF1goaFR3LY29S3b8HgKPuLDC6iYxRJs38HNr
	 UbvjcEqNNoz44R+IYgUHKtJaAlAvBbPPvwyzhXOm6Eipz2DJT0nWxWmSJZ5OfnVeftJ6t
	 kx36kne5xsrj/2zF1Zx0uou43Tk+BSI2+dXR8BEUy60EbYM9Xd6GPz6If++n85JgyGxNC
	 +K8Flu5dq6fHQnOEwWXmuUC5EwXLBKuElaq1klT6npKkOyA+vjKxeWbpP2obYL5iW2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w2BlzdCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987A9606A323;
	Wed, 25 Nov 2026 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w2BlzdCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DDE1F000C4;
	Wed, 25 Nov 2026 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623373;
	bh=409gaLVdfqL37YZ9aAGd5vPJ00EqfgDbjIKJttT38i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2BlzdCp5hiwU8oX45YZzNW8K3LABF6o/XzoJD1ez9z3tyD6/b5JhcvXdrwY4FvCX
	 aGcxBSbCXE2S1kFldqHcKCUf5YPV/4cqF43H12PqKNEs+zzSXCmDxJJE51zNETjYmz
	 HqSamGsjJahF3DYXeYPlwznDVrjUTjLDbfVb1zMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 783/990] hwmon: (max31760) Report 0 RPM before the first fan speed measurement
Date: Wed, 25 Nov 2026 15:35:50 +0100
Message-ID: <20261125143840.388133341@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


