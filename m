Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBF62D630
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 16:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712854202; cv=none; b=iQdOdeo1OYR3funLWOPD+YZyLS/06gzJZxjYPn/F2EflcyW0KW0U4QV4EiuwtiOS+B21yTud6jpL2WpAqPzG3wyPJd6fnoDtjF3UrVZ1gBMUCbty+BQaqGhw6z7/UoGoVk09jerrQzI5L1Sx33OHdDMf/mMCwILJ4ZU6bv5QVDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712854202; c=relaxed/simple;
	bh=QvtatgeOuMyYkq8lWFRExh/VSfBIfbc9tecb7cykvcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jm00hQKoqusyto524dKlLcrv9h6EgEAEfm08PB2j3BhSq4AgQmWZjH9xjoSNqy602R80FW7DuGxgpFWzEpuD3FPKQOo49fswqhtrdHwDHwdp4Y2x7iwm3qgfSWST+GNp01BPsPv6FitHp1IG4iSBjn9xGTT5QFnuMWpNZ73BVSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ZaV4GTWG; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ZaV4GTWG"
Received: from [100.64.216.186] (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 67D4F20EB6ED;
	Thu, 11 Apr 2024 09:50:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 67D4F20EB6ED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712854200;
	bh=SruCmoGVxFxMCpcxT/E0JKUQScXTOnhv9UUPX/u53dY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZaV4GTWGMHX6ryDpBiCMqWK26DjHx/Rj2joG4SoFvMBxQzZDGAxNTKe/2K5Rwo7Jk
	 z4Og5rlaRKccJR9ksXVQhEIrhdtMG6xtHRn+qOsHzFN5B8spamDCRyxHj99EBa6blb
	 o3uNPk118Y1iVLGLDzk2zol4azddu/9GpZ+89C88=
Message-ID: <97d25ef7-dee9-4cc5-842a-273f565869b3@linux.microsoft.com>
Date: Thu, 11 Apr 2024 09:49:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 102/399] ACPI: CPPC: Use access_width over bit_width
 for system memory accesses
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Jarred White <jarredwhite@linux.microsoft.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Sasha Levin <sashal@kernel.org>,
 Vanshidhar Konda <vanshikonda@os.amperecomputing.com>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152552.230440447@linuxfoundation.org>
 <4fabd250-bfa8-4482-b2f2-b787844aeb0b@linux.microsoft.com>
 <2024040235-clutter-pushing-01e2@gregkh>
Content-Language: en-CA
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <2024040235-clutter-pushing-01e2@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi stable team,

On 4/2/2024 12:55 AM, Greg Kroah-Hartman wrote:
> On Mon, Apr 01, 2024 at 10:16:46AM -0700, Easwar Hariharan wrote:
>> On 4/1/2024 8:41 AM, Greg Kroah-Hartman wrote:
>>> 6.8-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Jarred White <jarredwhite@linux.microsoft.com>
>>>
>>> [ Upstream commit 2f4a4d63a193be6fd530d180bb13c3592052904c ]
>>>
>>> To align with ACPI 6.3+, since bit_width can be any 8-bit value, it
>>> cannot be depended on to be always on a clean 8b boundary. This was
>>> uncovered on the Cobalt 100 platform.
>>>
>>
>> Hi Greg,
>>
>> Please drop this patch from all stable kernels as we seem to have a regression reported
>> on AmpereOne systems: https://lore.kernel.org/all/20240329220054.1205596-1-vanshikonda@os.amperecomputing.com/
> 
> Ok, all now dropped.  Please let us know when the fix gets into Linus's
> tree (and also properly tag it for stable inclusion as it is fixing a
> commit that was tagged for stable inclusion.)
> 
> thanks,
> 
> greg k-h

Despite having dropped the backport of this patch from all stable kernels, the 5.15 backport seems to have snuck through.

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.15.y&id=4949affd5288b867cdf115f5b08d6166b2027f87

Both the regression fix for AmpereOne[1] and a fix for another bug[2] we found while testing haven't been accepted into Linus'
tree yet, so 5.15.154 has a known issue. Please revert this for 5.15.155 and I'll send an email when the full set is in Linus' tree.

Thanks,
Easwar

[1] https://lore.kernel.org/all/20240329220054.1205596-1-vanshikonda@os.amperecomputing.com/
[2] https://lore.kernel.org/all/20240409052310.3162495-1-jarredwhite@linux.microsoft.com/
