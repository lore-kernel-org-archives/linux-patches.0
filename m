Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D7E3EE1C8
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370988; cv=none; b=V1yl7P4ayiYmGPXJj31wBEzXxjsg3oxIt+9icD9qgQJvLfAINvFvtwJKrxLCEDf3iczfcwc45vHDNhodXTJrg7n3EYTaCd43uUQnbm90PGRn2Y7QicDf3OWOiOcbGMqC9LGMtTf2SItMMAbwrw0e2+JxhHs89rFxXBETw7ifRs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370988; c=relaxed/simple;
	bh=41Qf05O8U1obBYOSOWvATaYc2cpdkTfjUa6W0IdTaRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gW5eWiSKJr435J48IFmpGSq7tApHfTjUVgvox4yMGAmwBm8IJ6rA56CAqlnHgU2HJmANI+8G+Vt7dskTwuwJG9gg0J6naZM5xUyY+oJ6GYF4/JrS5ktxkwl1rKOmmSFhlJm8FXSZfO3i1Jg+sm2afs8BjI3TbQIn32l4bCyfmo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aNwwjNGI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aNwwjNGI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774370986; x=1805906986;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=41Qf05O8U1obBYOSOWvATaYc2cpdkTfjUa6W0IdTaRs=;
  b=aNwwjNGI9vnJmHMOTZJPirjxEgT72mn8/wQSqncWKMcN7Y/xAjmeth+t
   EkQ1PHr6J04tPPm1BluS5FGUvZYgbMP7p0l8w9XKDBd9w7VqGi7xcd/z3
   oyW3wNnObUwoDROhuZHePZzyogMic0RSxrDYfCPwUsuUsXch65N7kZOov
   QPu1p92zF1sc58oUZ3OO/KQAhryU1vKpeWDxhx8se4SOSMjKP0lk4xZJI
   qfKlk9H5Q2Vb50xhhzcOK69XTNL7cCMPbi9N1QIfEbFvkU9xG23dVmepO
   3uXSn3YhcP6RK+nI3UDWZYqzuhl0KVTo85/4sT4lJHdxpIw7zlTBl1m21
   Q==;
X-CSE-ConnectionGUID: rtWpPEzKQ0yq8By5mbKbcA==
X-CSE-MsgGUID: W/1QyikOSJOLsvgIXWSmVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="85707720"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="85707720"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 09:49:46 -0700
X-CSE-ConnectionGUID: 2l1lXzMjR9q3OcXuyNsh7g==
X-CSE-MsgGUID: y8c3fbXkRPeZsszVwV/YOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="221059748"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.110.6]) ([10.125.110.6])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 09:49:44 -0700
Message-ID: <551037c4-665e-4701-9689-a75bdabe4211@intel.com>
Date: Tue, 24 Mar 2026 09:49:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 378/378] cxl/acpi: Fix CXL_ACPI and CXL_PMEM Kconfig
 tristate mismatch
To: Keith Busch <kbusch@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20260317163006.959177102@linuxfoundation.org>
 <20260317163020.886316423@linuxfoundation.org> <acK_mxmLlvD5vQog@kbusch-mbp>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <acK_mxmLlvD5vQog@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/24/26 9:45 AM, Keith Busch wrote:
> On Tue, Mar 17, 2026 at 05:35:35PM +0100, Greg Kroah-Hartman wrote:
>> 6.19-stable review patch.  If anyone has any objections, please let me know.
> 
> No objection, but a little confused how this got to stable before
> landing in Linus' tree. Does stable pull directly from downstream
> subsystems now?
> 
> Speaking of upstream, will the CXL maintainers be submitting a pull
> request for the staged fixes soon? I'm just getting new bug reports from
> people testing 7.0-rc, so wanted to check in on that.

I can send it today. Looks like I got enough days in linux-next soaking for the PR.
