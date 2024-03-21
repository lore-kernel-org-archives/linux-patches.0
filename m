Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077C134CCC
	for <patches@lists.linux.dev>; Thu, 21 Mar 2024 20:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711053296; cv=none; b=enjBPX8zBLcjhAVXXmR/eMNKpFdO0W2LYBsXy5a04wqfyx4QpVZRqS74gD5lxSYOTc19oDMTPilG2yOEgo+KdfyXm293FmL2ghfmParpPI+1xSmwPywHeuUpVYWZ6C2ov5DykzLqHfnLVI1mZge/qFhGSFl9WtUXjn9AUcxG1Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711053296; c=relaxed/simple;
	bh=KhaMIPegfJcr5L/8X1gkyHdQvQ/vHv8OxYKXLm+yhds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hWaOFFRme6WPhAWxSrIJAkc0LKTo614hpHIXCJ0vgvF9LF4NR3r2VcSrS8XCBQoobPmbH5Fn3IDyfq623u740DG8SDVCulUSB6rOwHDocZCEqRmkUAOjDZnQxyY6AvpLILoWFQiiys9DQQILmnPfV1T6ERxT5g0SW2ZBwwE16Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=iXfzVLb9; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="iXfzVLb9"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id myjcrrLzJPM1hnP7jryChm; Thu, 21 Mar 2024 20:34:51 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id nP7irwoAEuv6XnP7irUzGh; Thu, 21 Mar 2024 20:34:50 +0000
X-Authority-Analysis: v=2.4 cv=YbZ25BRf c=1 sm=1 tr=0 ts=65fc99ea
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=UtBFqMlDG83dypD0sxEoAQ==:17
 a=IkcTkHD0fZMA:10 a=K6JAEmCyrfEA:10 a=wYkD_t78qR0A:10 a=VwQbUJbxAAAA:8
 a=yrvdi-8N2rkvx8MjwWYA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Zpm7JfKyRSFiMuxy4RrheBAGaV77rGxXhF8Tc15ZkFo=; b=iXfzVLb9ipzSWrxpO+QaMhqTqb
	t28vKXvfKfORiO20yaQxPXMX18Xh6+A247y1NDjxJPmcTVy6JHgqqa67W8zrdAuxHMw04o+tVWlax
	xFyT73gvu3rl8vjUGaIBFMKc/LxiLtIhQLwVpI7RgJgMABhqvc1JVXNWrU9w178E3C0EwDsP5q8vi
	S8Ml6xim9UZ2zZt3Vuqlg6ZKKkBdE1kwX6FpKQoqL9dCpjiiIrYu8IActGeiCQqmJzMKJmpG8sQdp
	cwW/Qt3yC5HgAuPaxVHvqfQoLLkgc6zZfPYJtnifCuX52taStHfj+9bQqGjJFySx/9bGpZzQ/v1B3
	mhPwaavA==;
Received: from [201.172.174.229] (port=60044 helo=[192.168.15.10])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1rnP7h-0038oh-2X;
	Thu, 21 Mar 2024 15:34:49 -0500
Message-ID: <25c1ffe7-c141-43e3-b5d2-2dd10808711d@embeddedor.com>
Date: Thu, 21 Mar 2024 14:34:48 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lkdtm/bugs: Improve warning message for compilers without
 counted_by support
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, keescook@chromium.org
Cc: gustavoars@kernel.org, linux-hardening@vger.kernel.org,
 patches@lists.linux.dev
References: <20240321-lkdtm-improve-lack-of-counted_by-msg-v1-1-0fbf7481a29c@kernel.org>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240321-lkdtm-improve-lack-of-counted_by-msg-v1-1-0fbf7481a29c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.172.174.229
X-Source-L: No
X-Exim-ID: 1rnP7h-0038oh-2X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.10]) [201.172.174.229]:60044
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 1
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGMxXZ8P+MvhFDwvZ/fQPodLVAlB10lCq8zgEm/afTNC9o3sYwkQPUazbnx23Tj9QXWxhHpkx6kbgLmpcNV3QjX3m1q2HaqFQUBAuQZ5YdXvMmx2qZ9l
 gaAsC5xLdx3dMm/a9oozpc2FFt1xlVrXVJUUb3JGH3H9L4Jyl41QuTn8cPOpaTLNZeQczPBjSitDbiIQz5ufrXS9ZMEJmI3jq/M=



On 3/21/24 14:18, Nathan Chancellor wrote:
> The current message for telling the user that their compiler does not
> support the counted_by attribute in the FAM_BOUNDS test does not make
> much sense either grammatically or semantically. Fix it to make it
> correct in both aspects.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Looks good to me :)

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>   drivers/misc/lkdtm/bugs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
> index b92767d6bdd2..5178c02b21eb 100644
> --- a/drivers/misc/lkdtm/bugs.c
> +++ b/drivers/misc/lkdtm/bugs.c
> @@ -417,7 +417,7 @@ static void lkdtm_FAM_BOUNDS(void)
>   	pr_err("FAIL: survived access of invalid flexible array member index!\n");
>   
>   	if (!__has_attribute(__counted_by__))
> -		pr_warn("This is expected since this %s was built a compiler supporting __counted_by\n",
> +		pr_warn("This is expected since this %s was built with a compiler that does not support __counted_by\n",
>   			lkdtm_kernel_info);
>   	else if (IS_ENABLED(CONFIG_UBSAN_BOUNDS))
>   		pr_expected_config(CONFIG_UBSAN_TRAP);
> 
> ---
> base-commit: 8d8b79685237b15f4bb676781f6bf241beb068a8
> change-id: 20240321-lkdtm-improve-lack-of-counted_by-msg-d3b9006bd6e3
> 
> Best regards,
