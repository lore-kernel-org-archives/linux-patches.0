Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C4A33DF;
	Fri,  7 Mar 2025 06:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741328450; cv=none; b=fQ6Me6fAq+t+/f4+5XrnPfJ41Bye3b/pS6/83WCz9gKq2xfzbFbrc/wvM9iT98zETqXVGFs/XrTUg5uCxCYCsfkz5dUptgpG0EZzcScF7jxqbL50j0WilTnJP9018xm8Old++tvKqvT0FfRaWWvSP8z5ugrVLsqgS1MLKJrcFoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741328450; c=relaxed/simple;
	bh=gS8u1gzCZKU+ogDaTKY2dH9arL2041QkASdxnfsOqwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FOpzZcQrYwhZvuZ69H+yRO13K3+fLG0X94+NDpCLU23rUDe2qFs1UfUZPUm4mePRKtVu9G7g+RnpyQ4homGOtPCzTCum+DGewHdUoAqkrbYKMqoS8WdXr8k3WqB3t8W89QyanTdmlhSl8wia0+dvX5BWm+XbFtLrYgXpC3hd++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3bw/e4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3bw/e4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E741C4CED1;
	Fri,  7 Mar 2025 06:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741328450;
	bh=gS8u1gzCZKU+ogDaTKY2dH9arL2041QkASdxnfsOqwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J3bw/e4Hnyj/NHF1pCx/PV8mYP7x6Ae1FTIBnlZdjwc/bXEtaSqhWpgOtZ8AnvwWC
	 6U3kpr9HKwsRqF9W+eIAN9elvArEjj2Uqd1sPbOhy/kchtdo/7NztXUq52Jiu25wSu
	 VD5xbE7ELcV9DFLVw3E/Gc9/pMN055VmenGi6jjE=
Date: Fri, 7 Mar 2025 07:19:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 058/150] drm/xe: cancel pending job timer before
 freeing scheduler
Message-ID: <2025030756-unengaged-showdown-43e6@gregkh>
References: <20250305174503.801402104@linuxfoundation.org>
 <20250305174506.154179603@linuxfoundation.org>
 <Z8kklJj90JKGPCHC@lstrano-desk.jf.intel.com>
 <2025030621-fame-chastity-0bbd@gregkh>
 <Z8qO3xZ6VmHwCJN5@lstrano-desk.jf.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z8qO3xZ6VmHwCJN5@lstrano-desk.jf.intel.com>

On Thu, Mar 06, 2025 at 10:14:55PM -0800, Matthew Brost wrote:
> On Thu, Mar 06, 2025 at 02:32:56PM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Mar 05, 2025 at 08:29:08PM -0800, Matthew Brost wrote:
> > > On Wed, Mar 05, 2025 at 06:48:07PM +0100, Greg Kroah-Hartman wrote:
> > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > 
> > > We just got CI report on this patch, can you please hold off on backporting this.
> > 
> > Ok, but note you all better revert this upstream as well soon, otherwise
> > our tools have a tendancy to want to drag stuff like this back into
> > stable kernels to remain in sync with Linus's tree.
> > 
> 
> Thank you for the information on the workflow for issues like this.
> 
> I'm pretty sure the follow-up in [1] will fix this and be merged any
> minute now—I just saw this email after reviewing [1]. Is the correct
> flow here to let the tools pick up the original offending patch and the
> subsequent fix, or is there something else we should do? Please advise.

Please let us know when the fix hits Linus's tree and what the git
commit ids are that should be added to the stable tree at that time.

thanks,

greg k-h
