Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724C7320B
	for <patches@lists.linux.dev>; Thu, 23 Jan 2025 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737639486; cv=pass; b=AkOlnL5b8HtQk2jl5ZJ+puSOnpFPNB7j1Iea4R1+1yBu4CztoHRtE+nHtmjzGt27vi1Wc+2KhExmP3sDTe3FXHSfIU38sJ8mgnBic6pBsxThSTk1azSIKm0MBifyzbgCmfwa/RWTPIvaeb79elx3JhKlCQxlgmSNOqodbb3dk7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737639486; c=relaxed/simple;
	bh=v/x10FlJ2cw1ZJwxs4zi9TtlwvYLs81aGkrYmH+lPm0=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m+EGxG1AFGFwkRLKRx/3CGdI04YwA56GlbQbt2ughV8EaGTpVvc4jssu5zpchtqs849EbnZu0T3EQkhJfby/rgxSUu9ZqhZvEsOP3ULi8KI8BmhyU3M1DeZuE4bS/a2w1GBM6llTNbpRQd+DhkEbZYbWR9i28Wsz26BfPCUIeVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=N/xpqw/n; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="N/xpqw/n"
ARC-Seal: i=1; a=rsa-sha256; t=1737639475; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=d/ZUXMfktN/nOfX9qkpKydrIMdgjYDkYJJFXHtNjd8b3WabIHztDaTnwutdfRWwE+y8wxSant2nUifpKanv0P6BY4rkIQ97W1L7W/P/eDKOWMQqv5CzcNTyNFz/1oqJ2lo3GVGwbt5od2tL9P6I+n2cZpnzXo63YrzLE4D0SWJA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1737639475; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=EPIcy0NGroPxCUK70MElho+KBeQ0o57fOlWUP8QH1Ek=; 
	b=QYp+M/WXYwxC2JD1ZkJobrGWwulvdMdY76niKWdZJLpiz6AP7An5psgDXX4eNoFVoryq3oRAcbrOMh6djaNoTFJUHVJcE1FlVwhxLdWZigvQLBJ90DuXmPG45sZPWiBnyVBui8BrAotpjCXc5utJCdIm0i0l+k7e/JjM6IXsLxo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
	dmarc=pass header.from=<Usama.Anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1737639475;
	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=EPIcy0NGroPxCUK70MElho+KBeQ0o57fOlWUP8QH1Ek=;
	b=N/xpqw/n0lUX50inoHe2LdYLwOedEP6DOYreVivo18afwgEajAZApnxCMB+iQt3E
	rLmnE7IIcE0CB9A0HEXQAr1UcD8aBXPvqZdes0cb5fe4Oh357vn8541DPrRm4F9D+jX
	gETzIFzu2hHVQgdKi0k8MjW9z3TxNjwRA0UvNYhs=
Received: by mx.zohomail.com with SMTPS id 1737639453371537.9867917957669;
	Thu, 23 Jan 2025 05:37:33 -0800 (PST)
Message-ID: <93513ab9-5e20-4546-8646-2aaf4aa45144@collabora.com>
Date: Thu, 23 Jan 2025 18:37:56 +0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Usama.Anjum@collabora.com, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/64] 6.1.127-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <20250122073827.056636718@linuxfoundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
In-Reply-To: <20250122073827.056636718@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External

On 1/22/25 1:04 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.127 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 07:38:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.127-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
OVERVIEW

        Builds: 38 passed, 0 failed

    Boot tests: 197 passed, 0 failed

    CI systems: broonie, maestro

REVISION

    Commit
        name: v6.1.126-65-gc5148ca733b3
        hash: c5148ca733b386401ef46ed4ec93a2f4a078e187
    Checked out from
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y


BUILDS

    No build failures found

BOOT TESTS

    No boot failures found.

See complete and up-to-date report at:

    https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-git_commit_hash=c5148ca733b386401ef46ed4ec93a2f4a078e187&var-patchset_hash=


Tested-by: kernelci.org bot <bot@kernelci.org>

Thanks,
KernelCI team

