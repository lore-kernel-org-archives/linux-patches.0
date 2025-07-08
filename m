Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625012192F1
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752003252; cv=none; b=VwlgBCsdT+RF/J4Db4EY+a14YOyQ/m8BmAQtcEC+r4JweKOLhghlygGjCu7gRJeyDcTVJr89iEA4ILM67yxLtpx2YIJvXn87QVCwbwD3J7hjGW8G+PXwBcXW/xNPAAxe4DymWTyC/nRXFArBxTRG/9hM5X1bbs+eH4R1UMJlj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752003252; c=relaxed/simple;
	bh=AQfKFFSCMJAWtmBuZ+9fLxNHqJT04PXBw4n0+6KL4+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0f+r9D0ZtnBwm26B1QPWhobf7IEXGA5qGrXS14bwLA34h5UZ0OoKxP5AWish3wvhGa2B4XW/05Uu/W9SsvRNodCfvi+sRe47hTAIanZ07W2y4oVi7yN/JZLzWMGSll9nPA2QnwtdDG7j6bcSZxFot7IsEGMJeiFWJl0od6fok8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com; spf=none smtp.mailfrom=foss.arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=foss.arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6443152B;
	Tue,  8 Jul 2025 12:33:58 -0700 (PDT)
Received: from bogus (unknown [10.57.51.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D49D3F66E;
	Tue,  8 Jul 2025 12:34:08 -0700 (PDT)
Date: Tue, 8 Jul 2025 20:34:00 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 029/232] firmware: arm_ffa: Add support for
 {un,}registration of framework notifications
Message-ID: <20250708-jumping-strange-lemming-1bfc92@sudeepholla>
References: <20250708162241.426806072@linuxfoundation.org>
 <20250708162242.198209294@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708162242.198209294@linuxfoundation.org>

On Tue, Jul 08, 2025 at 06:20:25PM +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> [ Upstream commit c10debfe7f028c11f7a501a0f8e937c9be9e5327 ]
> 
> Framework notifications are doorbells that are rung by the partition
> managers to signal common events to an endpoint. These doorbells cannot
> be rung by an endpoint directly. A partition manager can signal a
> Framework notification in response to an FF-A ABI invocation by an
> endpoint.
> 
> Two additional notify_ops interface is being added for any FF-A device/
> driver to register and unregister for such a framework notifications.
> 
> Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
> Message-Id: <20250217-ffa_updates-v3-16-bd1d9de615e7@arm.com>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Stable-dep-of: 27e850c88df0 ("firmware: arm_ffa: Move memory allocation outside the mutex locking")

I understand these are being added in order to resolve the dependency
from 27e850c88df0, but this patch adds new feature. I would like to
drop 027/232, 028/232 and 029/232 from the queue. I already knew this and
had backports ready for

Upstream commit 27e850c88df0e25474a8caeb2903e2e90b62c1dc - 030/232 here
Upstream commit 9ca7a421229bbdfbe2e1e628cff5cfa782720a10 - 190/232 here

I will send then now.

-- 
Regards,
Sudeep
