Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BB7345EC0
	for <patches@lists.linux.dev>; Sat, 15 Aug 2026 12:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786795409; cv=none; b=IU6mZbgMcgIb9pFF6KurYjxREWGfb7IdI42tzPAhlVZu+AAURyk5oPPUHeGfQQJue/7H4geUUlsMutdhHx9VuKhTUV5qzGY6qJEi3+QE1nCgx5R1n96AYkkRl3ZlmmvB3f1Jh6Xu7Lj1x90Vza4WlZD8i1RIRZ3EUEu/6Z3lPik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786795409; c=relaxed/simple;
	bh=LYGRILV/oF9trCXsIGSs2jsbXo2JEiK39Pyy+rnrfoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSBYWIJiPZbFvp6xII4nGhMR638WdhbbKQg9M7IOIvoS1lTCcYRXY1XNV6ynfNJBQF4bvkqVN7pt0Gab2fZMy8UFHk6G1VbLMpG7G7JYPsOphXgAUs3FbYNcdvF+0aLRSLgkWn5u3R3QrK9w4Uvsr3JlgESBFcI/Egr9/KN0MMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z/xHP5yq; arc=none smtp.client-ip=91.218.175.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z/xHP5yq"
X-Envelope-To: patches@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LYGRILV/oF9trCXsIGSs2jsbXo2JEiK39Pyy+rnrfoI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786795406; v=1; x=1787400206;
 b=Z/xHP5yqXmLMRCFuKAHh35Ur3s161UWbOO3NIS3aNIwSMfDS0x80o4x+JYkTLj5CZJ3zUlOZ
 n48mR+FX2CF6vs5rB8hVe15r1RVHPZnfQbH3RfFzUgrbrwVPX86D85tl6qX4KskQzPUu9vil1I1
 7LEt7mpa5JSKsBSC6xaLPKBc=
X-Envelope-To: patches@lists.linux.dev
Received: from [IPV6:2a02:6b6f:e75b:1900:855:edd6:ce7b:4965] (2a02:6b6f:e75b:1900:855:edd6:ce7b:4965)
	by smtp.migadu.com with ESMTPS id 214e31bdbe017913;
	Sat, 15 Aug 2026 12:03:26 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <0a97021b-7fdf-4e29-b59d-d9fe07c6c409@linux.dev>
Date: Sat, 15 Aug 2026 13:03:25 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0019/1611] iommu/amd: Use maximum PPR log buffer size
 when SNP is enabled on Family 0x19
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Borislav Petkov <bp@alien8.de>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>,
 samuelcrossley@gmail.com
References: <20260813132447.3396830-1-usama.arif@linux.dev>
 <20260814193000.12@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260814193000.12@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 15/08/2026 03:33, Sasha Levin wrote:
>> I have raised this in [1] but also raising it here, this series seems to break
>> kexec on Milan hosts.
>>
>> kexec starts working on SNP hosts once we do:
>> Revert "iommu/amd: Use maximum PPR log buffer size when SNP is enabled on Family 0x19"
>> Revert "iommu/amd: Use maximum Event log buffer size when SNP is enabled on Family 0x19"
>>
>> on top 6.18.43 release.
> 
> Does the kexec hang also reproduce on v7.1.y, or on mainline? That would tell
> us whether this is the code itself rather than anything specific to the 6.18
> backport, and it decides whether a stable-side revert is the right remedy at
> all.
> 

I tested on mainline, thats broken as well.

We are deploying 6.18 in the fleet and we caught it that way.
