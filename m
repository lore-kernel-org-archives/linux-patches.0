Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86F438F642
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 05:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788240509; cv=none; b=j3Go6xUI/Rq4jeZEVNW9vwTbBLcFDWYyhpx7LUOkD+OyDyQcYjO2u4CDxrPJ86YH70AdxDBxZlq7SWZo0e10odoRKRiEAgWCBXZzEIGE8P+y/ESRh1VScZQVNmOzf2mjjDN0Cwa5LO6Dm1JSYtwoE9gpEaFCSzO6x6wpj1BsWkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788240509; c=relaxed/simple;
	bh=W7Q8xg8BSAYA2tpHUW+AynBJ9lC5DWh80C8PRS4kSR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0QFBz7o07X6TH+yBC0xSOf/DgBmZOVBdEWfgqBS+v3Faw7rUxbD/T+9d3ZxSguH1htaGtOdHKRdj0xf6wSUM6DttgtyVEdxqfUgtf+B91ZpsF9DXx+d9magcpZ80iR8nJ5HZRqebzkFOI8F5/Tr9i/1E2wg61HvWZCAmMS04Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BC/WjRAO; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BC/WjRAO"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so43045985e9.3
        for <patches@lists.linux.dev>; Mon, 31 Aug 2026 22:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788240506; x=1788845306; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W7Q8xg8BSAYA2tpHUW+AynBJ9lC5DWh80C8PRS4kSR0=;
        b=BC/WjRAOlrvFpmVt/1VMCTYElveqmZkvwt40Aty7KwPK+MM76hvb2mioPdAB/jJzSY
         fQzRB/M2CbS4dRupl/OAtqcYYvLHwBspiscrSH3QYzZiRGS8nAUrQ0mPYB6XIYMowf33
         ImnYEMAlaSWMR4wb9C1JQ3n+rwSvcBJgiY6cFjk1ng8p3JDKBAfEP8Z9mVn6kUIyoYtG
         2ddJ3GVphCjEsvOMVl+NhHd7qGNk+mM/nhQm3rup27JSy3BW2vg1HkrPDBov6oF9X/MY
         GlEjQeLnKa3uN9UDHp2kN8UvIEYaLVuYi5e0paYd7/ghuZw5CChKx49+duChfZ8/vGgq
         3F5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788240506; x=1788845306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W7Q8xg8BSAYA2tpHUW+AynBJ9lC5DWh80C8PRS4kSR0=;
        b=oiJnU4xy/34rBpZHAwpspY4rcelpNw33QFC2vliopSuVe0VsfJXgwI9dbk4kXfJtkD
         UcZ60FTauDjPmp0jMnESBJoJdMji+vUvjHwLqCdbHyJeRXKI8NpWbzB/vOtVIeA63W0c
         pFGUvZf8mzE7Tc8D7e/0FkDV4PPQPZnO8YuS3FOGeWfwtOBvkqJ1laQLWI7kGUuauVgz
         ekGJ7xhWGd+WPCXiEIa3ayZlDx7kjsAVoMJ5NejZsRTtSwjB7zwGe2n/LFBZQ5hlzTRp
         rfPIphCfU2PniFAku2YhKFYw/BJz8NA48Pd5INjs1TBQIc4mJojKlG4/vkWKf5HEQ2cW
         BbyQ==
X-Gm-Message-State: AFuF++nVtIoze0nHrePPOCdcdN9S3wI0LSUoSC19zz+8W81TxA1Kkrt/
	zQpcxfjLr/w7l4zesyUcy3HKTlFICxlrqwnq7G/SYrTkw08Ubg9sHcjD
X-Gm-Gg: AR+sD13Bwh3tYHnaeuaScOtNrjW3x7b0ggSYN+AKs7om8FxsaP2vBMmkij4LbzxI64k
	9hgDPereB2fxF1afnaejRD53nbEsQyM4NJr+SNMJoKN1l6kQic143vKhAraIGEe3r3J4UrbSpUz
	70MFtHJbWRE1U/CGrlCtkI6sT6mkt583rcXnN4/QGky24I7pO8iZpKOw5D6dTaiV6GvWXrVvLZn
	xOvT9QRtej8hwMOA1drjglGtFQGStLsYsBR2StktpPVoOMILWS1cKQScnBUCyecyJUk6+y5Q8w7
	0eK3oh2iMk/CfHrcphVG2iTnxI2uzMPIN8SgjQ9S5rJIYCWiRE057xLGkBZdV6ARan/lGLRkFce
	pwyOB/0UpmsuyCy1lsIeEozzN5MvwH0bEg11aqyt3sjTxaopVWPlH183mNLsaZUu5cd0btNQeFQ
	wWYudSDuwBH0nt0nQ1vm390/YZmhIzxKMeypG+AJCbce9QUf2MLLlq7fqOUM5oCC7+GmMZlltfi
	uwKpJWeZEVuUZRRipmglA3fmfQz7iWyedAucNCZ/dMjoZoIBhnm+b23CZ1X+Ntz
X-Received: by 2002:a05:600c:3e18:b0:49a:77c1:d246 with SMTP id 5b1f17b1804b1-49b91c4e073mr525091595e9.15.1788240505850;
        Mon, 31 Aug 2026 22:28:25 -0700 (PDT)
Received: from localhost.localdomain (ip-89-176-136-191.bb.vodafone.cz. [89.176.136.191])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cd8b9a2efsm140752035e9.3.2026.08.31.22.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 22:28:24 -0700 (PDT)
From: Petr Wozniak <petr.wozniak@gmail.com>
To: sashal@kernel.org
Cc: patches@lists.linux.dev,
	stable@vger.kernel.org,
	maxime.chevallier@bootlin.com,
	kuba@kernel.org,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux@armlinux.org.uk,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Wozniak <petr.wozniak@gmail.com>
Subject: Re: [PATCH AUTOSEL 6.18-6.1] net: phy: sfp: probe for RollBall I2C-to-MDIO bridge in mdio-i2c
Date: Tue,  1 Sep 2026 07:28:16 +0200
Message-ID: <20260901052816.3815-1-petr.wozniak@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260831133314.4125787-466-sashal@kernel.org>
References: <20260831133314.4125787-466-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please drop this one from AUTOSEL.

8fe125892f40 was reverted upstream on 2026-06-29 in b521003c27eb
("Revert "net: phy: sfp: probe for RollBall I2C-to-MDIO bridge in
mdio-i2c""), so it is no longer in mainline.

The probe it added runs in SFP_S_INIT, before genuine RollBall modules
have finished initialising their bridge, so the bridge does not answer
CMD_READ/CMD_DONE within the 200 ms window. mdio_protocol is then set
to MDIO_I2C_NONE and PHY detection is skipped for modules that worked
before the commit. Maxime Chevallier and Aleksander Bajkowski both
confirmed that on hardware.

The timing is per-module rather than per-PHY: the FLYPRO
SFP-10GT-CS-30M they tested carries the same AQR113C as a module here
that answers within 200 ms, but needs seconds to load its PHY firmware
from SPI. A fixed probe window cannot cover both, which is why the
commit was reverted rather than adjusted. A proper fix needs per-module
init timing, and per SFF-8472 the host must wait at least 300 ms after
insertion in any case.

Backporting this to stable would reintroduce that regression on
hardware that works there today.

Thanks,
Petr
