Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF81612FF7B
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723068965; cv=none; b=rIfUR1qEgt5BasWScaa5C2BKb14qtmLqF3HhiLwMIN29Pjgwtp/yvbou0PcK9cN1T2fmVZedZWRliDmfd4qFjYiSuI4CBwjWaeNtrA4DfoLXnyYhNTez/64cXDxF8bULMQnKL7FxrRTACW/+FYVFnUiogJk4E8z3sjKoZN+qrE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723068965; c=relaxed/simple;
	bh=5dGec4BtOSX629Q9D8fwLxG2Wg9I8wXgjSG4Ryur2Oc=;
	h=From:To:Cc:Date:Message-Id:Subject; b=gDHnk3NxxmDOJyWtCw+RDYxsGZ5Le6f+zshLB0AKQej8+u5Un9F9w7ABEr4Ta70g6yIU5BG5XiZDj9HXUhXr2XAmJSISM1tll4Rcc8yZrfCus1fXq1J0QyBCwzThrqVmd5b2I+yVu4XePPIurGBijFtLs53Vr43TZAGWME537IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329D4C4AF0D
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 22:16:04 +0000 (UTC)
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Wed, 7 Aug 2024 23:16:00 +0100
Resent-Message-ID: <ZrPyIP4nj_2-idaS@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 07 Aug 2024 03:56:42 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Nwo7=PG=everest-semi.com=zhangyi@kernel.org>)
	id 1sbWqu-00AaNi-2N
	for broonie@sirena.co.uk; Wed, 07 Aug 2024 03:56:42 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D9C046112F
	for <broonie@sirena.co.uk>; Wed,  7 Aug 2024 02:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id A16C7C4AF0D; Wed,  7 Aug 2024 02:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FBFCC32786
	for <broonie@kernel.org>; Wed,  7 Aug 2024 02:56:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 7FBFCC32786
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([180.172.39.131])
	by sina.net (10.185.250.31) with ESMTP
	id 66B2E1C800005724; Wed, 7 Aug 2024 10:54:01 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 6ECF8FEFE79D42E59A78B7C1A48E0E9B
X-SMAIL-UIID: 6ECF8FEFE79D42E59A78B7C1A48E0E9B-20240807-105401
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Wed,  7 Aug 2024 10:53:54 +0800
Message-Id: <20240807025356.24904-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=Nwo7=PG=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 0/2] ASoC: codecs: ES8326: button and input issue
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: RTYpmsNgk8n8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

TO solve button and input issue, We have modified parts of the driver
related to button and input.

Zhang Yi (2):
  ASoC: codecs: ES8326: button detect issue
  ASoC: codecs: ES8326: input issue after init

 sound/soc/codecs/es8326.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.17.1

