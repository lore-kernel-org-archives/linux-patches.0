Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2B9473C65
	for <patches@lists.linux.dev>; Thu, 13 Aug 2026 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786623079; cv=pass; b=unYoIE77tidTT9dA2m5ZykqfyqPf5fyQ7Dp6vJEAKHBGrtyswcn3o0LrARSwLm4otFqPtjVRYBz8WZ8VTDZIZf8dZkMpUxVspWj0hda7rEkwQ7wpVwRAWW7NMup9x//NvV0opz1m7B/NrxxuLi0FfSXxkDE+gTGBrUIYawoA980=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786623079; c=relaxed/simple;
	bh=/H+h37ktJXQFR3ayxqO5EhAjCsQanT1aeEs7IGCODHk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KpRJT7Q+XVmRwfJrrRhjROqweSGT9gmL0axnO9uoQMlksvKkI2rmBEJt2ZqEHJSJtolXYbsviW34hLkqUPsSdp0dpMnfzc/f7uYr0QPnZddYqyKY9kGXT87/8I16/prUIb1QTsJNrqu8Jc0LXqeO5rUUAannzqQYIK6r/YbwSvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=thundersoft.com header.i=@thundersoft.com header.b=hmO2hLxo; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=thundersoft.com header.i=@thundersoft.com header.b="hmO2hLxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E02F1F000E9
	for <patches@lists.linux.dev>; Thu, 13 Aug 2026 12:11:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=thundersoft.com header.i=@thundersoft.com header.a=rsa-sha256 header.s=default header.b=hmO2hLxo
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 13 Aug 2026 13:11:15 +0100
Resent-Message-ID: <an20Y6qL2Tsthwnu@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by 172-238-120-221.ip.linodeusercontent.com (Postfix) with ESMTPS id 618A835853
	for <broonie@sirena.co.uk>; Thu, 13 Aug 2026 11:54:02 +0000 (UTC)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97E01600AD
	for <broonie@sirena.co.uk>; Thu, 13 Aug 2026 11:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 637211F00A3D; Thu, 13 Aug 2026 11:54:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=8.221.36.76
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786622041;
	b=NjE445n06S+Oo7zV6df/WZyzTHkh0zNootWpnEkdcSsCE/XsYMKSMO5ft1/6gbbYoPFG
	 4dAs/Po/USBCxCtG1TONoePASgzFEed7iAlwZAubm0Ouy+34+PAKfxP23Sc2bdahDoova
	 fYPy1k9rgOqCYg22Li3pKaCkjwnkWzWFEz+h/gQ1V4fSVY42bJE6dxAERZc1T0Yp/Wijk
	 8AA3iT6JHND8P10bl2/0jLg8TW95mS5yUJDmdUXp2RZezo4h74yGRHbeRwo0w6NOXQx1a
	 oY+iPYAsII9dOhuLwSVou4GOYSrdR5+wOwumGGCYcVjZVlzZa/odybCcp72tgL5S1qw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786622041;
	h=DMARC-Filter:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=/v4oCG7KsiGimIbQ0haXjVkJtc7ra71e9ZPL8hOWsr8=;
	b=1gjYo+WN6eymoZK6ERwISnrMJb0DbX9lmtP4nxgf6jiU4MMASCGNTJ6XTIPfgi1vJH6C
	 C4Rk7CUwTvIJBbyEJGuvl3iCxgWd742lB/4euKyhY+bfvozEbHE9Zav3TaKpfVzvq4kHF
	 m8R76/iFbI/udWLtAxa6UjQFJ49Jx0dY7zvQ4LU7APcVLMx98Yz5piMzh0lH3W1rQ9o9s
	 sWZUn2iM3yqpJGgW+e/nadQV0/i5L437DvqViMoBoPtpb9sd4YRxmmMFp0enFuBdRgg1c
	 AT66q49ZyjDHXUAYgETIBYtla3Mm6gtrAy0n0QRXsLMJwRY+AI7UDwrVPSQrpfCCxWA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=thundersoft.com header.i=@thundersoft.com header.a=rsa-sha256 header.s=default header.b=hmO2hLxo;
	dmarc=pass header.from=thundersoft.com;
	spf=pass smtp.mailfrom=thundersoft.com;
	arc=none smtp.remote-ip=8.221.36.76
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2AE11F000E9;
	Thu, 13 Aug 2026 11:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org F2AE11F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=thundersoft.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=thundersoft.com
Received: from [127.0.1.1] (unknown [36.129.139.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49e09c484;
	Thu, 13 Aug 2026 19:53:43 +0800 (GMT+08:00)
From: Hongyang Zhao <hongyang.zhao@thundersoft.com>
Date: Thu, 13 Aug 2026 19:53:34 +0800
Subject: [PATCH] ASoC: dt-bindings: es8316: Fix supply property constraints
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-es8316-binding-conditional-fix-v1-1-6cd56aa1370c@thundersoft.com>
X-B4-Tracking: v=1; b=H4sIAD2wfWoC/x2NwQqEMAxEf0VyNtDUXVF/RTzYNnUDUqUVWSj++
 4Y9DW/gzVQonIULTE2FzLcUOZICtQ34z5o2RgnKYI3tzUAduhdyGTrq0UkKkjb0h+al3rpjlC8
 a5/xIb4ocLejOmVnr/8e8PM8PqUEbzXMAAAA=
X-Change-ID: 20260813-b4-es8316-binding-conditional-fix-0bbc9151fef2
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Daniel Drake <drake@endlessm.com>, 
 Katsuhiro Suzuki <katsuhiro@katsuster.net>, 
 Matteo Martelli <matteomartelli3@gmail.com>, 
 Binbin Zhou <zhoubinbin@loongson.cn>
Cc: linux-sound@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Roger Shimizu <rosh@debian.org>, 
 Hongyang Zhao <hongyang.zhao@thundersoft.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786622023; l=1569;
 i=hongyang.zhao@thundersoft.com; s=20260127; h=from:subject:message-id;
 bh=/H+h37ktJXQFR3ayxqO5EhAjCsQanT1aeEs7IGCODHk=;
 b=imYgtZBUslINZE+SejnGIsjy2NA8dFogwaaP9RefhU4EgAhiiiFpdoyCdXixcUO7l434lMjRw
 S5W+f4eCS+fBMieLkT7PBZCX6ltQhza8xCtr91DKiDDP81I9zZ8OY9m
X-Developer-Key: i=hongyang.zhao@thundersoft.com; a=ed25519;
 pk=D9yL5W9Zj0lPBDAq9gzY++1849VlXuTWAkROzZ88J/4=
X-HM-Tid: 0a9ffaf8960009d5kunmf4a1915b47dc88
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSR1MVh5MTB8ZQkxDSUkeH1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlITVVKSUJVSkhCVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=hmO2hLxovFAuvK0oW2lCckNLuPFYH3Ry06aqW0xuLnD1UP090s0Wx6uhtf0Sntud+PKxw4B0twe6OyvRN5XpM5tcCl1h6JDHOkF9FPvdkeUllR6MOvHMfMnE2TsbZ2LVFKaxgnQ8KUSj+oFsx+tIhbqvas7e3hVHrveKaq1yS6M=; c=relaxed/relaxed; s=default; d=thundersoft.com; v=1;
	bh=/v4oCG7KsiGimIbQ0haXjVkJtc7ra71e9ZPL8hOWsr8=;
	h=date:mime-version:subject:message-id:from;

The DT meta-schema requires a `then` clause when an `if` condition has
an `else` clause. Invert the compatible check and move the supply
property restrictions to `then` so they remain allowed only for ES8316.

Fixes: e9966d450b46 ("ASoC: dt-bindings: es8316: Add regulator supplies")
Reported-by: Rob Herring <robh@kernel.org>
Closes: https://lore.kernel.org/r/20260812194234.GA693895-robh@kernel.org
Signed-off-by: Hongyang Zhao <hongyang.zhao@thundersoft.com>
---
Fix the conditional schema added by commit e9966d450b46. Invert the
compatible check and move the supply restrictions under `then`.
---
 Documentation/devicetree/bindings/sound/everest,es8316.yaml | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/everest,es8316.yaml b/Documentation/devicetree/bindings/sound/everest,es8316.yaml
index 276c73bb4790..f4ff23120c5b 100644
--- a/Documentation/devicetree/bindings/sound/everest,es8316.yaml
+++ b/Documentation/devicetree/bindings/sound/everest,es8316.yaml
@@ -33,9 +33,10 @@ allOf:
   - if:
       properties:
         compatible:
-          contains:
-            const: everest,es8316
-    else:
+          not:
+            contains:
+              const: everest,es8316
+    then:
       properties:
         avdd-supply: false
         cpvdd-supply: false

---
base-commit: 79a883d53960fb2eaf02f72a37182078b4fc938e
change-id: 20260813-b4-es8316-binding-conditional-fix-0bbc9151fef2

Best regards,
-- 
Hongyang Zhao <hongyang.zhao@thundersoft.com>

