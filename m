Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45151B2193;
	Wed, 16 Oct 2024 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729065574; cv=none; b=NBTiZOBhQc1sHXfM8F2M0M2ayc+t2KfsuiObljP8iBm6jo1dfSQMrK6wZOsJbooy6TaHh72DVkRMo9A16W9Wfo72jYM+1v/t26mgOxP/9Gc+HQznAWEX4CSeUaNCzSJ+YL4LKK1JFvBftQBlC+MjzDN4YbvGf5CLAaHxPeGNu1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729065574; c=relaxed/simple;
	bh=eeUDcbu9QfPWyhTdngqXSZksohzlhJtY8GsSnAuuiB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwLbhjFCNeRs5STV09aTsVOwZXJ+aU8YJihttIh45ja5b9tas0iVqdLsJXL9S8Lpd3MTJn/KSD4SppKPVp8j4JVwFLQQVqmXD88oGaojb6Y9pfZ+u5FSF72MNUawMmkg6T8k1pZcLqi7fa2xfTVKOQG+R7MRI1U0rPam1rBxNAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EglDLpUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EglDLpUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27A2C4CEC5;
	Wed, 16 Oct 2024 07:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729065574;
	bh=eeUDcbu9QfPWyhTdngqXSZksohzlhJtY8GsSnAuuiB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EglDLpUTiJaDvnR3MO1I/s6jTsOv4+v5DDXB4gJBeRJ7+eORlNzjizOMIg/E2Wpby
	 SJC/ezBhNN/o/oz7HQTg9r/mXB1vSOa0CLAmqlnlFU/nOEYjpp/s76c8TUm5mxjP3d
	 G1NSBulX40YSuiu5po3yVPgJi9fi+2RLtHLTMTQc=
Date: Wed, 16 Oct 2024 09:59:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Dave Penkler <dpenkler@gmail.com>, linux-staging@lists.linux.dev,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] staging: gpid: fmh: Drop residue from
 fmh_gpid_fifo_read_countable()
Message-ID: <2024101607-unmovable-serving-6a0d@gregkh>
References: <20241015-staging-gpib-fmh-fix-residue-used-uninitialized-v1-1-23ef05b099da@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015-staging-gpib-fmh-fix-residue-used-uninitialized-v1-1-23ef05b099da@kernel.org>

On Tue, Oct 15, 2024 at 01:09:02PM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):

<snip>

Nit, the subject should have had "gpib" not "gpid".  I've fixed it up
when applying, thanks for the fix!

greg k-h
