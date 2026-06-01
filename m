Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449F63DE427
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 17:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780335272; cv=none; b=sG/Q6VXUMXho+eVUqxZ/7SmSrdYt5IefSD+2iMHJzptdJyMF73SrwDXUpufN1FCKVwuuopvWZlgiOjUJaPdo93nGtoxYbj44DEkcDbrnjZr1gYipC/JMhCxbvXHS7/bLXqEu98zgusz9JDiMvDDTbwbyZ7Xa9kH/NkQgO/8u/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780335272; c=relaxed/simple;
	bh=sE6njkJEp4k7reIjcuUdLFOAcSxP1sZIw+VApabLxJI=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TwOGaWrCvTkvUVdBd1g/2RMJH7Nma4ZhpvwfEv1PFxJGuC9ROYZKyupfEBHK/29xGoWc3SPR8yMe5Vg0E/sdSf2vm1sGSBbfqGR2l1yQlfzSqGMwnhlDtVYzKCkuHvag5z06v2HgunJF4h6OrKVpqkD8tLzXgt3RsO15IRJV2J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=GOjBc+Mh; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="GOjBc+Mh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1780335271; x=1811871271;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=gNTAQDrVKLggTTWWyzpgrt2RReuC1quSVK4V/MXLIwU=;
  b=GOjBc+MhZlo56F16GiqMqdJhPCn714Znsa4fwysi7+rs3esac1Yd9jJi
   mlyvBDi9GVERL5TTVhVuoG5REpJuVp0U8LXeCXOevULqfyUJaMcLsX4Lu
   6TwprngDGy5vqVltKSRCIfvVDXR5dsQ9CovYzXQ2ZA7+p+Dz7tbliqMzH
   ZFan9I23fx50t4XiwxuoSLzcOlSdxS2HmFxhxRGuqCaeM8QUwYHIUFDD6
   XNdpm8DXeH8jF/SUdSCjX1dCv7YKLJcwM+RfdqtP+JIOFS7Xb6HTaRSoY
   rnG6OAmvuPLjrVyqkPpsVVrJgkaer9sOdgpSMelsjMGZ1vGdak7PFdMW1
   Q==;
X-CSE-ConnectionGUID: /wTNCTaoQn699AJ6A9LWJQ==
X-CSE-MsgGUID: b7RJvN6BR1WEVvGZTCq0nQ==
X-IronPort-AV: E=Sophos;i="6.24,181,1774310400"; 
   d="scan'208";a="20851813"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 17:34:28 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:25088]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.154:2525] with esmtp (Farcaster)
 id fc2b5218-b6d3-4437-98e6-e21bfec254e2; Mon, 1 Jun 2026 17:34:28 +0000 (UTC)
X-Farcaster-Flow-ID: fc2b5218-b6d3-4437-98e6-e21bfec254e2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 1 Jun 2026 17:34:27 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com.amazon.de
 (10.253.107.175) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 1 Jun 2026
 17:34:26 +0000
From: Mahmoud Nagy Adam <mngyadam@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Mingzhe Zou
	<mingzhe.zou@easystack.cn>, Coly Li <colyli@fnnas.com>, Jens Axboe
	<axboe@kernel.dk>, <nagy@khwaternagy.com>
Subject: Re: [PATCH 6.1 431/969] bcache: fix uninitialized closure object
In-Reply-To: <20260530160312.161639627@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
	<20260530160312.161639627@linuxfoundation.org>
Date: Mon, 1 Jun 2026 19:34:24 +0200
Message-ID: <lrkyqqzmq17xb.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWA001.ant.amazon.com (10.13.139.45) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)


Hey Greg,

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>
> commit 20a8e451ec1c7e99060b1bbaaad03ce88c39ddb8 upstream.
>

Just a heads up, that this fix patch is missing from 6.6->6.18
kernels. While being backported to older kernels (< 6.1). Any blockers
for it to be backported to newer kernels as well?

Regards,
Mahmoud Nagy Adam



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

