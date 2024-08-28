Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7121AC43D
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 23:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724887458; cv=none; b=T5U1255iZnRr51WcBOgAZz+BZJ46diiUh++e08p8kV9V7//KPGf22jPd3zoCM9VVd0uhbTt18pmL+Msn1szACbQU3K0hcHiEMp1vMQ7Eml/bZXdLS4a76c6PO++y4RGYUfldgb8YEoG5du0wKx+Slwa/gj5+PTf7T3Bb8S2IA1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724887458; c=relaxed/simple;
	bh=KQoVU0ohfoUcNvHfCK/fBDoRXiT+Jb90mxBNFE81rNQ=;
	h=From:To:Cc:Date:Message-Id:MIME-Version:Subject; b=WFi7dEfilBhVmbhaUWxuhigi7yA8p7OY4w9VAxF+QaR8s1QIP1qwrxGKQbfI7P06XQmF1mQdTrNbC48xN3Su8C+Sqg4Be0NmFPTx4/1kfWoVBI5r1Y5TDGHoFHSPm1f6KTei0CjH8UtUV+iRy4EcVIIkkuHx5MRUuh5srdzbEvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aRU6A9l+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRU6A9l+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD1C4CEC2
	for <patches@lists.linux.dev>; Wed, 28 Aug 2024 23:24:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRU6A9l+"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 29 Aug 2024 00:24:14 +0100
Resent-Message-ID: <Zs-xnt3XoJeHIVQj@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 28 Aug 2024 19:01:23 +0100
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=8O97=P3=gmail.com=festevam@kernel.org>)
	id 1sjMyv-00CxbS-0O
	for broonie@sirena.co.uk; Wed, 28 Aug 2024 19:01:23 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id C7998CE17AA
	for <broonie@sirena.co.uk>; Wed, 28 Aug 2024 18:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 067F0C4CEC3; Wed, 28 Aug 2024 18:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1173AC4CEC0;
	Wed, 28 Aug 2024 18:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 1173AC4CEC0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-6c5bcb8e8edso5072681a12.2;
        Wed, 28 Aug 2024 11:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724868076; x=1725472876; darn=kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YwO1tVhas9mZORSVkPcYgJoFV2fs+6URakIgFUk7sX4=;
        b=aRU6A9l+ItSIM+hVUqsHeEaOzYwvIBgUtqxdp1/S4pTVTkmu5eVZlD06SD30QchBtq
         GJNBU7td/kg/mF1le3d2Y7v/bEF9VxRX8V52+88276YWT0bnmQ4zCwxYU4Snd0Xn22KF
         7K+nT2tZ7LshcmzP+U0bm3AS9CrJKeVmZ+FtBaBB7M06m6n4ndt6ERP/tkSYgWMk6+yz
         GQb8zkDl9qv9Q4jHSviD8GECbWWijcVyfgbBmlAtmTCU2LYzRr69mcwdCNLNJ2XUUuC/
         /GSiV+w7XwQJbrU182M2NCKuSVnnizKcpViTYRRtLbU67+4vRJqs5fCydzWYocXjorB0
         pOVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724868076; x=1725472876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YwO1tVhas9mZORSVkPcYgJoFV2fs+6URakIgFUk7sX4=;
        b=E9P8rBva7Gh5r+NHG4PuUOu1MZtaUI+sCHySZjfxOck/NFHxmvMfTH7/WV66v5LoLl
         78+PBBZW5Vw4oZyxG4CDuWepsVHGoZFsuUKwLUXGTnCjHEDZrg0XzUCx76zScWh/t28E
         2AbQkN+rMLHNBXeN9hNZzrdRVxupHbf+uEQdAiPUrTevsql2f2gdYT6JUicsbTwIh/+E
         E8uO1xfSNmtA800wMBhO632oAUmV7z4/L3hYECQ5FskMfvfjJrXFqrWur9eGK29Q1teF
         0lGSPT2t1uvAHc4ZnurgeiosII2gOYnjZn828VepBgX8wFAKflMp3jq6IuT62jZHp9cg
         T75A==
X-Forwarded-Encrypted: i=1; AJvYcCUn1OGTLkdNWbM6e42QNLchq3SEs08bItE7GyTm1YhmhSmyh0rnY/J/4Z6q4vVCU2dteaAO7w==@kernel.org, AJvYcCV79NuxOKpUZv27ow5ln+xnnLLUJb2TQlcpGEv7Vi9+s/UYIi8vg8V1K072JzC0kujqZK8kOA==@kernel.org, AJvYcCVHU+VKL1FeBhEv3HkhHNlr7YXevAeusGiiGNysClRwUcq9NwueHCRK3sxnCgcRGHNiurTYZw==@kernel.org
X-Gm-Message-State: AOJu0Ywh64Q2qSsS8MRgdZPErjjryNRzir6r9IT2t08I2LelNYWeR7RS
	ziWBhPWFHa5k+A2ci2Id6hrQfJnK3qkNJ6rPEDsCsuI4A65L3bzaD82xRg==
X-Google-Smtp-Source: AGHT+IGZe7JIGsLE4aR1OrNxkm4LBaa7dLfetL/m/nucpE6rqmJWf1USTSzPH0YjvsyjuK6svnI1NQ==
X-Received: by 2002:a05:6a20:cd0e:b0:1ca:c673:9793 with SMTP id adf61e73a8af0-1cce1027d15mr129193637.23.1724868075718;
        Wed, 28 Aug 2024 11:01:15 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:4b3a:557e:6b5b:dbdc])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143434294asm10300127b3a.216.2024.08.28.11.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 11:01:14 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-spi@vger.kernel.org,
	otavio.salvador@ossystems.com.br,
	heiko@sntech.de,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Fabio Estevam <festevam@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>
Date: Wed, 28 Aug 2024 15:00:55 -0300
Message-Id: <20240828180057.3167190-1-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=8O97=P3=gmail.com=festevam@kernel.org
Subject: [PATCH RESEND v2 1/3] dt-bindings: trivial-devices: Document elgin,jg10309-01
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: CobAOb4oB6JA

The rv1108-elgin-r1 board has an LCD controlled via SPI in userspace.
The marking on the LCD is JG10309-01.

Add an entry for the "elgin,jg10309-01" compatible string.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
---
Changes since v1:
- Use a more specific compatible string. (Conor)

 Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
index 7913ca9b6b54..49dee2a1f6b4 100644
--- a/Documentation/devicetree/bindings/trivial-devices.yaml
+++ b/Documentation/devicetree/bindings/trivial-devices.yaml
@@ -110,6 +110,8 @@ properties:
           - domintech,dmard09
             # DMARD10: 3-axis Accelerometer
           - domintech,dmard10
+            # Elgin SPI-controlled LCD
+          - elgin,jg10309-01
             # MMA7660FC: 3-Axis Orientation/Motion Detection Sensor
           - fsl,mma7660
             # MMA8450Q: Xtrinsic Low-power, 3-axis Xtrinsic Accelerometer
-- 
2.34.1

