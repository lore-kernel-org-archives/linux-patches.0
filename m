Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB615EFD5
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 15:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713970946; cv=none; b=b3AYN5fw+J6VJs8146K4JKdtW1B9JI5LnOq51xOy9577tyEuQwDBwt5vXx1DVsMiyUZflbpZTxphRoQorpy3spCPbG4A5+r2S4qqvNZGU0rPzKG1O05HyMEeFTgY4BrrQ3iPLWhJje8RcFGbPfjweOqKd5+pLXPUYBrjURrglYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713970946; c=relaxed/simple;
	bh=XLGFL+xC3/Alxez9rYkwKhLSznzQjOJqaZBZKON6piI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pB0qZsJVwVU4K2C0zCm/89KF93WziDs/xCVAlVoBJ/TvK2TQbdtoYDYFYjOz6wNJAAfOvUPN8Ee6BFO+RCrsKyJBsCFgakelQYuaf4dGP2YYqbPs/bbxVo1lUTM93+R0Gwp9LlMT612wM6qSOL2x8BdzTg9aG2eWKwXCT4xXNVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.1.105] (178.176.75.123) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 24 Apr
 2024 18:02:10 +0300
Subject: Re: [PATCH 6.8 050/158] ravb: Group descriptor types used in Rx ring
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>, Paul Barker
	<paul.barker.ct@bp.renesas.com>, "David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
References: <20240423213855.824778126@linuxfoundation.org>
 <20240423213857.537678352@linuxfoundation.org>
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <c137268a-b86c-d2d6-822a-d39521076277@omp.ru>
Date: Wed, 24 Apr 2024 18:02:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240423213857.537678352@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.0, Database issued on: 04/24/2024 14:48:11
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 184901 [Apr 24 2024]
X-KSE-AntiSpam-Info: Version: 6.1.0.4
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 18 0.3.18
 b9d6ada76958f07c6a68617a7ac8df800bc4166c
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info:
	omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.75.123
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/24/2024 14:52:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 4/24/2024 1:31:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 4/24/24 12:37 AM, Greg Kroah-Hartman wrote:

> 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> [ Upstream commit 4123c3fbf8632e5c553222bf1c10b3a3e0a8dc06 ]
> 
> The Rx ring can either be made up of normal or extended descriptors, not
> a mix of the two at the same time. Make this explicit by grouping the
> two variables in a rx_ring union.
> 
> The extension of the storage for more than one queue of normal
> descriptors from a single to NUM_RX_QUEUE queues have no practical
> effect. But aids in making the code readable as the code that uses it
> already piggyback on other members of struct ravb_private that are
> arrays of max length NUM_RX_QUEUE, e.g. rx_desc_dma. This will also make
> further refactoring easier.
> 
> While at it, rename the normal descriptor Rx ring to make it clear it's
> not strictly related to the GbEthernet E-MAC IP found in RZ/G2L, normal
> descriptors could be used on R-Car SoCs too.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Paul Barker <paul.barker.ct@bp.renesas.com>
> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Stable-dep-of: def52db470df ("net: ravb: Count packets instead of descriptors in R-Car RX path")

   I still highly doubt that this patch is really necessary in -stable.
This patch shouldn't depend on it...

> Signed-off-by: Sasha Levin <sashal@kernel.org>

[...]

MBR, Sergey
