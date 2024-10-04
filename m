Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FC1D365A;
	Fri,  4 Oct 2024 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728051047; cv=none; b=PZr9KLR942C/Y/XFENvOeWQ/EZMqjzzarPak/4OKejd6RxvWr49wEFyRAglwK7YF/kNVkvpipm5X8FdPmPlUV+nlrOEFJO1TRBLn85Ds3GKxdNzC6oicuIBN9MKhIxjruO2pHGKcXGfsUHtCOPm2lIqbQgfXbSBLSWTtTJ1xpW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728051047; c=relaxed/simple;
	bh=JhqgHobV6MEfri81zjjex2KoSYRyHJfaqiyISDxcOpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQjaXG93856+1QSi261qtUHGpOAtxm48o9QCtkGiq1d83oAT4RnNc25ZKWCOQmdm90URbWLG82miX79a39mxTT/Q/kHPEYSGluV2CBOY3ZYuZ541D4HcRm4eTpQ4bpRRn7BUdutFMRzgL9sk/NvNY6uVRrqY5ynTr7RXOMZwh8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ldPRVZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ldPRVZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270F2C4CECE;
	Fri,  4 Oct 2024 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728051046;
	bh=JhqgHobV6MEfri81zjjex2KoSYRyHJfaqiyISDxcOpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1ldPRVZGsa9em0yNhvsV9p4ogHeI13x4QcgdOTt+9nJCy4B+iXGzhtzJyUVdMhAql
	 2mGCJsD6OGsuLQsFmdW+nhgSqMLk1lVuyV/kJKHKK8gQcZhmizR1BGAVdPrQTbA93W
	 BRPGLNHeE8rqcHqPvAcR/g9RzvKqtwrK13lTgaMM=
Date: Fri, 4 Oct 2024 16:10:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Youzhong Yang <youzhong@gmail.com>
Cc: Chuck Lever III <chuck.lever@oracle.com>,
	linux-stable <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jeff Layton <jlayton@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
Message-ID: <2024100420-aflutter-setback-2482@gregkh>
References: <20241002125822.467776898@linuxfoundation.org>
 <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh>
 <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>

On Fri, Oct 04, 2024 at 10:01:46AM -0400, Youzhong Yang wrote:
> I applied 2/4, 3/4 and 4/4 on top of kernel 6.6.41 and tested it under
> our work load, unfortunately leaks occurred. Here is what I got:
> 
> crash>  p nfsd_file_allocations:a | awk '{print $NF}' | perl -e
> 'while(<>){ $sum += $_; } print $sum, "\n";'
> 114664232
> crash> p nfsd_file_releases:a | awk '{print $NF}' | perl -e
> 'while(<>){ $sum += $_; } print $sum, "\n";'
> 114664221
> 
> So yes, 1/4 is needed for fixing the issue.

What exactly is 1/4?  For where?

Sorry, top posting loses all context :(

greg k-h
