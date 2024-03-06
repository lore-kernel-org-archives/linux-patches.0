Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F0E130AC6;
	Wed,  6 Mar 2024 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709732838; cv=none; b=MQl8ICv9IQBd4nXhOORaS0igJhl8p3yIzWfZKK7osC21uuJqcjDYisfYFboHCPAWAjG2djd2bswYFMMn3nTj2NjZzqHJGUpd1o/C6cwXBk+rbYlrnUH1AAlhLvnBl2ftoKWA0gnXdUv9kyyg1dk0oL5IDA67xhAcviWQAj8Qbdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709732838; c=relaxed/simple;
	bh=R2IvrRW6Bm+d9XStox5A9pSD1kHN6wZYNJdu4xfs/2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IBIiwhfDku9sITmublYCMyoeVyUXpdwGKSMxihC7V1xIbaPUUni3Gi43dP1cUcYy60EamLECxyqj5oYP8JCT0SHTmPyGTEgWvw7QuTWD5cfwSXrKQCF3RNnvvh2QBqTm1OgGH92wGt9Mv6YY159cTsN0YxW4Fyl97PNOqcE/0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWmBS1Ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWmBS1Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4362CC433C7;
	Wed,  6 Mar 2024 13:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709732837;
	bh=R2IvrRW6Bm+d9XStox5A9pSD1kHN6wZYNJdu4xfs/2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FWmBS1NilHOe61Jakpl1JlYu/xbPw7oVzRHMl54+S3DbN5XkrmOSFKV+WiQRLTmtG
	 kGBIKqyg8/489sF2OWkJtm2F2ks8YC3R1dUh9yukcrEJ7DEgJHPlMayeJEGPP/Mkef
	 bOozQw3YDSfeKgCY9X1PmqZ7PzF/JWB+RhEl3zDY=
Date: Wed, 6 Mar 2024 13:47:14 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Filipe Manana <fdmanana@suse.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.7 001/162] btrfs: fix deadlock with fiemap and extent
 locking
Message-ID: <2024030601-portable-lunacy-0c99@gregkh>
References: <20240304211551.833500257@linuxfoundation.org>
 <20240304211551.880347593@linuxfoundation.org>
 <CAKisOQGCiJUUc62ptxp08LkR88T5t1swcBPYi84y2fLP6Tag7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKisOQGCiJUUc62ptxp08LkR88T5t1swcBPYi84y2fLP6Tag7g@mail.gmail.com>

On Wed, Mar 06, 2024 at 12:39:06PM +0000, Filipe Manana wrote:
> On Mon, Mar 4, 2024 at 9:26 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.7-stable review patch.  If anyone has any objections, please let me know.
> 
> It would be better to delay the backport of this patch (and the
> followup fix) to any stable release, because it introduced another
> regression for which there is a reviewed fix but it's not yet in
> Linus' tree:
> 
> https://lore.kernel.org/linux-btrfs/cover.1709202499.git.fdmanana@suse.com/

Ok, thanks, now dropped.  Let us know when you want it added back.

greg k-h
