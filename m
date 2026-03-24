Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E93402B83;
	Tue, 24 Mar 2026 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370717; cv=none; b=tK/JTyKPiUngVckFZzYlH0Cb4ogs4LlBkn85X1zIT8HB/qJtdHarzsjlFEkzfO/wvj7AfqoF9XTZ4omHv2X5Zt/WdSjWf5RQWAbkECb1+ZB50Kzp+K7TXoWoZ936GrOR9yfQjdhUotTZIt63BYuiBseamw41//x2OxzhpfPyzdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370717; c=relaxed/simple;
	bh=LeG2KCV4/Hdn4qXx/XVMXDyOrpBMwTVPU8WDTCFX66g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDmdJ51lbWMfcH5FbwE49wycHQAU39pYz2XLHUUE+8+NK4NGJ0sIOcArkyPXzE5I0l4ZJ+x2MqzBSuazJ/NRwQGxAlm2hlMCkUJtv0Uvff0Ab22UT+6JikMG0Zy8UHQ0/NV9VPF+pc1LQ/dzTo15fOOolZ7029EXKqodtpQxHdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3EelZoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3EelZoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576ABC19424;
	Tue, 24 Mar 2026 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774370717;
	bh=LeG2KCV4/Hdn4qXx/XVMXDyOrpBMwTVPU8WDTCFX66g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F3EelZoIcJQ1XA+ysw6NxwI536GEqBp+VkCuljehKMNIw0NOGJRpa8jL1sZcCTXb/
	 uk3UB5t6ossBcqiX+x+/BX/jMKVzPs1B7JjeDTU9PieqRXg/H/i9DFW7jXwx1bJtEZ
	 vFbAIjQxsOH45bKyg8y7trijjLRltq7xvYWKKHMZf6ueifgQMdPckKMv4IP4l7pstB
	 CEETFN7gccIeWJjrvD1LzVnkOzYW0BK1G8AgQd7UlLMoxkH8Mhu6S/NKVXdj2hWrAg
	 3REGvblO5r7gYRHEJw3er9xPfLbRhsLt1yEnBC1+UrBOGHed9vEr/Ivp+60EDkzoQu
	 YbibBFfjHjRiA==
Date: Tue, 24 Mar 2026 10:45:15 -0600
From: Keith Busch <kbusch@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH 6.19 378/378] cxl/acpi: Fix CXL_ACPI and CXL_PMEM Kconfig
 tristate mismatch
Message-ID: <acK_mxmLlvD5vQog@kbusch-mbp>
References: <20260317163006.959177102@linuxfoundation.org>
 <20260317163020.886316423@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317163020.886316423@linuxfoundation.org>

On Tue, Mar 17, 2026 at 05:35:35PM +0100, Greg Kroah-Hartman wrote:
> 6.19-stable review patch.  If anyone has any objections, please let me know.

No objection, but a little confused how this got to stable before
landing in Linus' tree. Does stable pull directly from downstream
subsystems now?

Speaking of upstream, will the CXL maintainers be submitting a pull
request for the staged fixes soon? I'm just getting new bug reports from
people testing 7.0-rc, so wanted to check in on that.
