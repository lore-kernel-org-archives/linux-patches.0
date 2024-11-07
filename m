Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729C818FDBC;
	Thu,  7 Nov 2024 06:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730961964; cv=none; b=GjMgYOYRgoTpEeGTnxgDWMrFFbblituUh2eISlw7dTGMHJPBKKej9aVob5jvU6S/sg37+Ck6zXDBs6YXcfGV1UhpB2TxewTopnOB7H4E0sxyD7oPf1R2FCN7gOMV70Jp3wsBDMXL3LQR/Wj7KTnlnqQ/twMknXv5/dvZw4H7Giw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730961964; c=relaxed/simple;
	bh=szG+Op6906zNSIxRO0qOgjtmZndgY8NT1NbTe4nCzbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSxdaeljD2oiyStrjZuScPOkd+1gPU6wvr48uu5z/zKYqaaOY+RNqXXOHAbuHuPfRFxeAD8GwhicSEb1ERu/Co7gX2Bur2JCfT6TKAviskwLpY98d+XgpkoPZDkJ65RhwIsTOsF4m3Lp4iXalAiVgwg+82VWXwK8x/+4Xymb6dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVGTmiFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVGTmiFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF07C4CECC;
	Thu,  7 Nov 2024 06:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730961963;
	bh=szG+Op6906zNSIxRO0qOgjtmZndgY8NT1NbTe4nCzbs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NVGTmiFn62tuwuGAw8W1K/bBb6WFsoSdB2WGZKJaFUZk1UZs7uw6d0j14Jo9qZb1L
	 x2UGRckcpb2vUhJECTnaXYP1BP9wvd2Ch63nNeawSwGB1eTtecv4FphfmcGo8cK67W
	 1HTwMd3nLCMAE4i+w4lfKgJ5Ga2fAukCJyi3N3p0=
Date: Thu, 7 Nov 2024 07:45:45 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com,
	vbabka@suse.cz, greearb@candelatech.com, kent.overstreet@linux.dev,
	stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 6.11.y 1/2] rcu/kvfree: Add kvfree_rcu_barrier() API
Message-ID: <2024110725-goofiness-release-bd30@gregkh>
References: <20241106170927.130996-1-surenb@google.com>
 <2024110700-undertone-coastline-7484@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024110700-undertone-coastline-7484@gregkh>

On Thu, Nov 07, 2024 at 07:37:43AM +0100, Greg KH wrote:
> On Wed, Nov 06, 2024 at 09:09:26AM -0800, Suren Baghdasaryan wrote:
> > From: Uladzislau Rezki <urezki@gmail.com>
> > 
> > commit 3c5d61ae919cc377c71118ccc76fa6e8518023f8 upstream.
> 
> No, that's not the right git id :(

But it is the git id of the fixup patch that I also need to take, so now
grabbed, thanks for making me look :)

greg k-h
