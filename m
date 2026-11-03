Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793731485;
	b=WunbRXFRPI370ntwlJBKnQ+I9c30UytOcxg9cpCb8vVHxM+2KtRfeh4pOagEouW+gsoZ
	 Hn92eISNIkb/JtZQ8Ykj/sKH37ASbR+u36yULPDIiZHAWeFcO55cmZvspvEj3H5Xbg0on
	 KpUHvdolylO8BelWdccigIrJqAWzYMvsmLmHaSvSabXhsLT0YeIGunJBxl5eo62x1SUQZ
	 dBQLhK00dTq7GHyaMhqkV2EVUOWq9uveJEOfM489e3RImt/wKblujiTg4byizuDv8oPQJ
	 s09N/oWQfjwDi3YFXrtWCA4SnDgy8CB5cVCVHrqjuPFqU1W0NFJzwjuPNhogqiW5Ibw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793731485;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1A8p6Yw8QB5cZ4R6ZLUTqYya8xg0OkNzmH7mK5ip2II=;
	b=QhpjWNjbaWlKHjbjjSq7UDlR2vadCk+ECOBDh6qHexWquPldv/+JbAfrq7AEOcv+DIau
	 oxBuDigtGbpecinRZhCepOWLCeUYSle46ElDl96VxQcqG1geXSg1mc0M7abn4dHxjGPlz
	 f7GwqEtKO6KvwsUxSj9e6tPWOvMlffLuWtORXLqnLm6y4YhvhkIEkjaAJGbBnCU7D9e87
	 ky5J5EREppE19FZu+fSfgRZ705JbVOvhEBSJmkARTDD4n4yXWZ/wGf2qQZUI/3P7vH9fF
	 1Es32yUxbjOvvk4eA0n75H0lpB5eGOT2gkUnUaSFbozbEnow68ZtLC6Mqx+qxMYVnNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="RE4/eDH9";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EFC606A326
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 18:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63EFC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RE4/eDH9
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BD561595;
	Tue,  3 Nov 2026 10:44:40 -0800 (PST)
Received: from [10.211.55.3] (unknown [10.57.89.242])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0B333F628;
	Tue,  3 Nov 2026 10:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793731483; bh=uAQW7HvA0v7nIV7mc4N2TG5pPdvVVKtuJnC0ma5RjYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RE4/eDH9BflLfmG4pGA+XUXDeV9ihXn60ajrcwLY+TgWH82Pbak1ug67AKrnpV94m
	 zxL9dPNkSuyq/d9D5CRQiQGg4iOo4rD/gyaiTZJp7ObekDaiOHS74Q7bYHkdg1iRUz
	 WuCWnBi95UKRxA++0Wq2csBpNcihRbP5C2Xu13aY=
Message-ID: <fa595d08-9b92-4266-acb7-489e1b2277c4@arm.com>
Date: Tue, 3 Nov 2026 18:44:39 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [RFC PATCH v2 01/10] arm_mpam: resctrl: Use find_component() when
 allocating a domain
To: Reinette Chatre <reinette.chatre@intel.com>, james.morse@arm.com,
 Dave.Martin@arm.com, fenghuay@nvidia.com
Cc: tony.luck@intel.com, yu.c.chen@intel.com, babu.moger@amd.com,
 fustini@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1792443633.git.reinette.chatre@intel.com>
 <94ddff51b91f4a51965baf0384c2368e292c1a8c.1792443633.git.reinette.chatre@intel.com>
 <308b326e-9fc8-4d49-9c85-c3b9cb9288f3@arm.com>
 <9400d7a6-3d00-474d-bf1d-6db1a08c16fb@arm.com>
 <200bd69e-61fd-4680-8e14-338e2d45c266@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <200bd69e-61fd-4680-8e14-338e2d45c266@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 03/11/2026 18:13, Reinette Chatre wrote:
> Hi Ben,
> 
> On 11/3/26 9:48 AM, Ben Horgan wrote:
>> On 03/11/2026 15:01, Ben Horgan wrote:
>>> Hi Reinette,
>>>
>>> The change seems good but I think the commit message can be cut down at bit.
> 
> Thank you very much for taking a look and providing the needed changes. Since I
> am unable to test and especially since this involved a locking change I ended up
> with changelogs containing more than the usual reasoning about correctness.> >> It looks like this patch also has the plus of addressing this sashiko
>> report:
>> https://sashiko.dev/#/bug/linux-9a564d61-b4d8-400d-b4b9-cd5f20729468
> oh. Would you like this commit to capture this? To do so I can add the following tags:

I don't think it counts as a real bug as its only going against the
cleanup.h guidance and making the code fragile rather than actually
breaking anything. Good to fix though.

Thanks,

Ben

> 
> 	Fixes: 09e61daf8e96 ("arm_mpam: resctrl: Add boilerplate cpuhp and domain allocation")
> 	Reported-by: Sashiko <sashiko-bot@kernel.org>
> 	Closes: https://sashiko.dev/#/bug/linux-9a564d61-b4d8-400d-b4b9-cd5f20729
> > Reinette
> 
> 
> 

