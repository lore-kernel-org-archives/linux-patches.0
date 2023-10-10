Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A761182AC
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVufBcV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C561C433CA;
	Tue, 10 Oct 2023 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696937271;
	bh=5sE5gUILKS6QhHBpP8Exty2NmNy9zwTSLu679olXZiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gVufBcV3Mw/7ZVyzPyO2D+YniZukJwDNmGRoa6dyxloIU2Z8yGeStTV3tAi5LQHL9
	 atlgy13UlB/oRXKmDuPfSdj3qpE5R5OCzcuW9uLUY2Z58rrYJmdoZ3501dOc54QhYO
	 Ey/qHW9OiWcBtVGYwZ0cfGbMEG6DgPUim59XUD6o=
Date: Tue, 10 Oct 2023 13:27:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Qu Wenruo <wqu@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 4.19 70/91] btrfs: reject unknown mount options early
Message-ID: <2023101008-percolate-sterile-1391@gregkh>
References: <20231009130111.518916887@linuxfoundation.org>
 <20231009130113.943075052@linuxfoundation.org>
 <c55ba96b-9058-42ac-817b-2d42b45ddf3a@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c55ba96b-9058-42ac-817b-2d42b45ddf3a@suse.com>

On Tue, Oct 10, 2023 at 07:23:15PM +1030, Qu Wenruo wrote:
> 
> 
> On 2023/10/9 23:36, Greg Kroah-Hartman wrote:
> > 4.19-stable review patch.  If anyone has any objections, please let me know.
> 
> Please reject the patch from all stable branches (if that's not yet too
> late).
> 
> The rejection is too strict, especially the check is before the security
> mount options, thus it would reject all security mount options.

This is queued up in all stable -rc releases right now, is there a fix
in Linus's tree for this as well or is it broken there too?

thanks,

greg k-h
