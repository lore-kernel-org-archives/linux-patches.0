Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6353C6CDBA;
	Thu, 24 Oct 2024 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769579; cv=none; b=ju7l4v2MvLPGtzTuFreutyUBkfGDBXm9Fr5RG0EWuLlVNl2ht7+O5kaBucS2/Us4EcPipFyrO6qD8zm08DXUlvC5sU7HwzYiRk+8fFf/DPVPtzMnN2NgmUeEkcPd9BPFHzHgQW31xpiCjCpewYkZuzvYN/P3ZkMO6RY8RMF9ArA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769579; c=relaxed/simple;
	bh=jaOLrmAOgefAgbtZ2Lh4kHXHkgV6DCOo2suKobuzSjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YbXWQKCqby1PouuABKLEKDe8oaCqb9WmcGqdZe+VcTHFBMI+3xc2y1i+pgF19RgMftfP83b+gJ6YjtAVj7qMfZAWGqiNhLKxEqFKLq64D7CHPN0/o38u6DiDOkTyW+w8lv1ZTuKfSM73ovY7UvXVAKBNIq0DarBdbxpeICnyJjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UzJQY1ih; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzJQY1ih"
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-20caccadbeeso6792465ad.2;
        Thu, 24 Oct 2024 04:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729769577; x=1730374377; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tv6O+TghCU2f9mC++4kG9WDH4zCondacLVwevpdizzo=;
        b=UzJQY1ihDyzB7NXEKMklmQYtRXZIWRsvDayNz26QIZY/EdZUnpMcsDSGP4B10gVtPP
         z3cpqWyY2hkV38DX75iar7wgJuITHlTfO9oWlHwL/YsqiiQm99L6pg2gWDDXmKJ4nGDL
         dyUZmxlcGGeztnLGOSKECwxlCYX+1JOhCS9h95GK/hvkZuxF3TnnmZ0xwFxh9ecDKLY3
         mAQ+K7b64CDjGcaZHby9JuoM2C5ZlSNDPNx0x3PLS/QBOhstf5miraqK3SKod44laUDA
         t5wuHBQbesdKGGxM+7j9nkRYw/WuU5ZdxRqUMUn4jSITsxj4vSLoQ8Gg9TWcCWZBluKj
         BJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729769577; x=1730374377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tv6O+TghCU2f9mC++4kG9WDH4zCondacLVwevpdizzo=;
        b=bn4lNlgk7zTIOUD1mokZa0rn9p4nApaewKSUJPRa5NRhU5QUOsn+loGavKAgKOJBJd
         QMQS8AukcFljYJiMlEDt7cGWT99pNGpLg7d0+4H4e91saGQ2Ehg4wts0x+OctQSLpUuu
         XDpGgVFVB1QrA1N7+ndmjJczGRWwDArTZZ+8SuZ8Lpt2IK9IYDWU+dhwpEAlUFbKDSLy
         xBcQB2ZtNhoZGzTX3htxdGd7/6yqHniyV9ivqMN4gK2Zd+axJb4l0DQqqensVK8Q3n5T
         uqQbDk1NZNO+R22Eb9uWBByu/dHj+ZbwKexlGK7e/X2rXiboAh4VdLdrsEDRwGfRTWpU
         yjnA==
X-Forwarded-Encrypted: i=1; AJvYcCV5nVR/RwthGpAJsnXuzqXoGdJolZgTNB1OqMyHRTPTYdTk3C+HO+58UJZSk0Txx4wZvDs=@lists.linux.dev, AJvYcCW2OyDUV/FR3LHilwmv1E/xCFI15GqT+VfVh6K1LCV5Vfb8jvL5llKKUAQVZiW+0ODCSkjrBWKTsQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YylKSxmtaxitv28uwP6b2O8S7Uq0/K7epm0Egku6Xb4lragLG9U
	2Q70xzgbRz9PduTW3z7RnWeArS1gBJFoFMd9VYz9AQTs4US9enyo
X-Google-Smtp-Source: AGHT+IGnX8BAozTq7iV5Cfb4iMWgUhRXOngKBX3V0+lNlRioh+e/fyzPpLUXG8x8OAUIikKgPta+wg==
X-Received: by 2002:a17:902:e80c:b0:20c:e5b5:608a with SMTP id d9443c01a7336-20fa9de92a8mr80789405ad.5.1729769576555;
        Thu, 24 Oct 2024 04:32:56 -0700 (PDT)
Received: from codespaces-a350b5.m2fxbej512jepnsor2itp05j3d.ix.internal.cloudapp.net ([23.97.62.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0f364bsm70916385ad.264.2024.10.24.04.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 04:32:56 -0700 (PDT)
From: Jensen Huang <jensenhuangnvdia@gmail.com>
X-Google-Original-From: Jensen Huang <JensenHuangNVDIA@gmail.com>
To: torvalds@linux-foundation.org
Cc: aospan@netup.ru,
	conor.dooley@microchip.com,
	ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org,
	dushistov@mail.ru,
	fancer.lancer@gmail.com,
	geert@linux-m68k.org,
	gregkh@linuxfoundation.org,
	hoan@os.amperecomputing.com,
	ink@jurassic.park.msu.ru,
	jeffbai@aosc.io,
	kexybiscuit@aosc.io,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com,
	netdev@vger.kernel.org,
	nikita@trvn.ru,
	ntb@lists.linux.dev,
	patches@lists.linux.dev,
	richard.henderson@linaro.org,
	s.shtylyov@omp.ru,
	serjk@netup.ru,
	shc_work@mail.ru,
	torvic9@mailbox.org,
	tsbogend@alpha.franken.de,
	v.georgiev@metrotek.ru,
	wangyuli@uniontech.com,
	wsa+renesas@sang-engineering.com,
	xeb@mail.ru,
	Jensen Huang <JensenHuangNVDIA@gmail.com>
Subject: [PATCH] MAINTAINERS: Remove some entries due to various compliance requirements.
Date: Thu, 24 Oct 2024 11:32:46 +0000
Message-ID: <20241024113246.22901-1-JensenHuangNVDIA@gmail.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove some entries due to various compliance requirements. They can come
back in the future if sufficient documentation is provided.

Signed-off-by: Jensen Huang <JensenHuangNVDIA@gmail.com>

---

Follow 6e90b67

---

Linus Torvalds said

"I'm Finnish. Did you think I'd be supporting Russian
aggression? Apparently it's not just lack of real news, it's lack of
history knowledge too."

So we should remove Israeli developers too, because Israel is committing aggression and genocide.

Link: https://lore.kernel.org/all/CAHk-=whNGNVnYHHSXUAsWds_MoZ-iEgRMQMxZZ0z-jY4uHT+Gg@mail.gmail.com/
---
 MAINTAINERS | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e9659a5a7..9ce642d40 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2275,13 +2275,6 @@ S:	Maintained
 T:	git git://git.armlinux.org.uk/~rmk/linux-arm.git clkdev
 F:	drivers/clk/clkdev.c
 
-ARM/CONEXANT DIGICOLOR MACHINE SUPPORT
-M:	Baruch Siach <baruch@tkos.co.il>
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	arch/arm/boot/dts/cnxt/
-N:	digicolor
-
 ARM/CORESIGHT FRAMEWORK AND DRIVERS
 M:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Mike Leach <mike.leach@linaro.org>
-- 
2.46.2

