Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D721748781
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991808; cv=none; b=a/eiTnHTJ8Gmg2zQJ7H0HLy6FaJkd4pZw6usf1VZXuW1LXg5a61dxs2y3XEFyGB6CDAs+5vN/NQsGvs0gumcJGPgY23jhhniui5qXq8g5jJrsXyt7kUs8JKgBvGX+OVGxfkO85KkQ3p3Fp9h1nOLlJSZ5DCf2qj20/30eKX6UTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991808; c=relaxed/simple;
	bh=oA/XnSGPM/zTFEG1vP9MCwsA88QcnXZe9haFS+aiefA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YI6C5GfCpsNXFDAJgssPdojGrf/FFjAT3+kwSUAv1XNOB5T+GHAaLleA3fEI6q6Zy9pXtQkO3JV0wHIWCjNGaBzS9J/MRdYFelLlPJOtlvFB76Bzids6ZW4JrOhcghJVVFLAQJ3L5FOXHuyZYn+xJgyXyw+OxeOqnY7A4Q4lwQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ifF7LEh2; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ifF7LEh2"
Received: from [100.64.193.111] (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 2FD642085CE4;
	Mon,  1 Apr 2024 10:16:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2FD642085CE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1711991806;
	bh=3m23lwO20r+YWkieSxiB8VHUDLf75Iije7ummqYP6Ks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ifF7LEh2rhbn7jR1pdBzEHJowXzCz7CGjLdoJ5+Zc4spOxcjIyH7EmJQIzPOFLMLp
	 mhn50HyY7UB/NOKWg/LdoD7NPYcjBDeU38eC89QIxTu6pzm49SKY8un9xInTWC12s5
	 8bRJ5LTOeJcq0/HuMRgUEmeozu2lqXTPKuTIZyAs=
Message-ID: <4fabd250-bfa8-4482-b2f2-b787844aeb0b@linux.microsoft.com>
Date: Mon, 1 Apr 2024 10:16:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 102/399] ACPI: CPPC: Use access_width over bit_width
 for system memory accesses
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jarred White <jarredwhite@linux.microsoft.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Sasha Levin <sashal@kernel.org>
References: <20240401152549.131030308@linuxfoundation.org>
 <20240401152552.230440447@linuxfoundation.org>
Content-Language: en-CA
From: Easwar Hariharan <eahariha@linux.microsoft.com>
In-Reply-To: <20240401152552.230440447@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/1/2024 8:41 AM, Greg Kroah-Hartman wrote:
> 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jarred White <jarredwhite@linux.microsoft.com>
> 
> [ Upstream commit 2f4a4d63a193be6fd530d180bb13c3592052904c ]
> 
> To align with ACPI 6.3+, since bit_width can be any 8-bit value, it
> cannot be depended on to be always on a clean 8b boundary. This was
> uncovered on the Cobalt 100 platform.
> 

Hi Greg,

Please drop this patch from all stable kernels as we seem to have a regression reported
on AmpereOne systems: https://lore.kernel.org/all/20240329220054.1205596-1-vanshikonda@os.amperecomputing.com/

Thanks,
Easwar

