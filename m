Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E121710A10;
	Mon,  4 Mar 2024 06:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709533967; cv=none; b=MFFatQo4K5L+BHN+NjVvHZpfVi1p/KFehnTjsxhtq28GwJgvH9hZhwq2gUd0O1v41zYRDmdg2R+N4Yds7ZwhSXVw0GXw6DKcGI4eW82TT9qpORErdOCyyoJs+M4UDzDwitRuXp6kZSUhdXmloVvQ4l0zs8p1AO0Rsv1QFzMnwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709533967; c=relaxed/simple;
	bh=iTmYUuQ/LL/UFj1qpAZVenJ5e85b9AQXhuehP8gCWRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prbpcpalQ8T4V27PbpLB5z3z6LincEwZVdcW+lqcWqn95XB9KNVK5yyb/5QCQYfODdyvxyiMf4xJCzsXL1dwDTaNZhiq8DYGMaUp9q4wNEiwj10YvoLQCqi379EoRiYCygG82Zg84Av6AKhGvsACid/7nNsaAkCeL23zExG6khE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmzS7yX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmzS7yX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B85C433C7;
	Mon,  4 Mar 2024 06:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709533966;
	bh=iTmYUuQ/LL/UFj1qpAZVenJ5e85b9AQXhuehP8gCWRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hmzS7yX81z+zIMWhHXu6iTb9Yil+21GcHXObat+K3t01sa5QVIARqAs4m124MN2iQ
	 HKtTuUsYypZqVYo0+th/aZH1yIhQIF7zrvzYTsCErZl7q2vwZJ3mQ20BP1dx4jWnbz
	 JkFDxW4uV2Nr76G3L32fKrWC1Ve/fP0KhfpDU3K4=
Date: Mon, 4 Mar 2024 07:32:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeffrey E Altman <jaltman@auristor.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 032/267] afs: Hide silly-rename files from userspace
Message-ID: <2024030417-spoken-tremor-c871@gregkh>
References: <20240221125940.058369148@linuxfoundation.org>
 <20240221125941.044302264@linuxfoundation.org>
 <03aa52e3-7ab9-484e-9ad2-b03938d2019b@auristor.com>
 <2024030356-moody-flight-5f4f@gregkh>
 <e90b3830-02b8-4f9c-abaf-dad2becb9524@auristor.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e90b3830-02b8-4f9c-abaf-dad2becb9524@auristor.com>

On Sun, Mar 03, 2024 at 09:10:23PM -0500, Jeffrey E Altman wrote:
> On 3/3/2024 2:36 AM, Greg Kroah-Hartman wrote:
> > On Sat, Mar 02, 2024 at 11:32:04PM -0500, Jeffrey E Altman wrote:
> > > Greg,
> > > 
> > > If its not too late it would be best not to backport this change to 6.7,
> > > 6.6, 6.1, 5.15, 5.10, and 5.4.
> > This commit is already in the following releases:
> > 	5.4.269 5.10.210 5.15.149 6.1.76 6.6.15 6.7.3 6.8-rc2
> > 
> > > This change can result in an infinite loop in directory parsing and the fix
> > > for that has yet to be merged by Linus.
> > Is it in linux-next with a stable git id?
> 
> The commit is on linux-next as
> 
> 5f7a07646655fb4108da527565dcdc80124b14c4 ("afs: Fix endless loop in
> directory parsing")

And it's in -rc7 so all is good as it's already part of our patch queue
for the next round of releases.

thanks,

greg k-h
