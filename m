Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.246.77.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792507072;
	b=jmHTaM3fpxeD0Rm98k1l/7Z5MmWGF60uaW8BhS+8JIgskjS3Kvo+o//4PDuOjawsD6Nq
	 R7OEu9dgAMShUJ9tYkzrTeZYzR/T9ZmK0jfED6G6wDi5WY5XdiLuoAuA6WlLmEpGSSueT
	 RQHQM5ow9F+6gYi8w/JHByqCY++jPwjejQOujs9ZdxwW+k43dXBpOWZ0nsx92atjuUzqU
	 U2+XP3PIQgz9j5OEzdZ3OQ4LbosZnEm+kVx/10kZM99MMe+rBO1yPpkbY/e/OHKbXXzTx
	 DCuBeo1oS0ZxkTdEm449EIKlyzhmPuOwLw+m8iqJeFAfpkN1FPddek7vmJ3Z1A/sjew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792507072;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=5LRGHN8ntoxFrPJWrn1Xk1SCNt11RbrFeIIOupsDSQM=;
	b=Nnn6tAcnusrjHG6cQz0/otoxuM+KKC6hm4pDpmV+PGPf1wCHPH1IS6ck30F1SAdxQKFl
	 v+ETjdHSJmxY23cxD0S1ulQsSjyR9HCufFXhdV8yrkiraUWOqfHeIdviztCyfWfJjwJAJ
	 QDHfxEd6bV8s5Ji7FNRzLBaoEQ4fzAScB8mpazfeIkCodNKfHC3gRV5ZvupoZlw/ewoW8
	 IMJq5ORipF3VN5IGjlsCengE1iM+tEBoboC4RgYYThZ6ePWMBjf888loOEL9KEasPDv5v
	 QFd9GSyNCfXzfqR+zwnJWxVNR42jQ7N7pT3PXid0jn1Q05yFNchyaK7vxDhm0n6nePg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=VwsdkBBp;
	arc=none smtp.remote-ip=44.246.77.92
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CFF606A31E
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 14:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00CFF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=VwsdkBBp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1792507071; x=1824043071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5LRGHN8ntoxFrPJWrn1Xk1SCNt11RbrFeIIOupsDSQM=;
  b=VwsdkBBpuN+I7Fdmb31hkVRQG7S3shPV/IxRWL/u4Tl63rs9GH37ZAZm
   EOUEgj6x1npPQcWPma1iIRR35OAV1K4stZ1pwwYkfHb8l5vtzsAsS8v7F
   vZznuc/nw7TVBPzfuNrf8ZFRndqkOOz5YaalL+ZiOOKt5sZscZB18BEbn
   68McxU9CmNjuLOXoijm0w5Iw6q1dCi+Himo6BWDN8LvAKB4WsC1Sf3Pzs
   9BcyswT7VqHy3Qrc0C76a0t9S4Z9kO2ExtQuY+M/XPac4k1BQIvZ52GGj
   WYtQrUj6hG8gm6uImunDYmusEL2eBVlY3aLRY/2vy17f4noE9rVxMiliO
   A==;
X-CSE-ConnectionGUID: ECEm+QCsSqCyXSgn9k7Kuw==
X-CSE-MsgGUID: zvOFRcvFQQSX/LtWEJd9qg==
X-IronPort-AV: E=Sophos;i="6.27,168,1787011200"; 
   d="scan'208";a="31743108"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 14:37:49 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:11916]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.1:2525] with esmtp (Farcaster)
 id a382078a-ae68-482a-a6ab-df5e639d8f90; Tue, 20 Oct 2026 14:37:49 +0000 (UTC)
X-Farcaster-Flow-ID: a382078a-ae68-482a-a6ab-df5e639d8f90
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Tue, 20 Oct 2026 14:37:48 +0000
Received: from dev-dsk-avivb.amazon.com (172.19.102.34) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53;
 Tue, 20 Oct 2026 14:37:47 +0000
From: Aviv Bakal <avivb@amazon.com>
To: <sashal@kernel.org>, <patches@lists.linux.dev>, <stable@vger.kernel.org>
CC: <robin.murphy@arm.com>, <ilkka@os.amperecomputing.com>, <will@kernel.org>,
	<mark.rutland@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-perf-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.18] perf/arm-cmn: Add workarounds for CMN-S3 on Graviton5
Date: Tue, 20 Oct 2026 17:37:45 +0300
Message-ID: <179250706537.3484860.18363532452101434862@amazon.com>
In-Reply-To: <20261019135441.1420968-145-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org> <20261019135441.1420968-145-sashal@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Please drop this from AUTOSEL -- it's new-silicon enablement, and its
parent commit 56603c28d916 isn't in 6.18.y, so the static_assert in
arm-cmn.c would fail.

Thanks,
Aviv
