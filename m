Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5212179A4
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 10:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED305C433C7;
	Tue, 12 Sep 2023 10:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694515092;
	bh=dIQVlyP42PolZznaFbAugpHLN9YBTqBzjJDxsh5OtkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bqYNCVznT0v0Az3+noQuUAtDd4QEztxZrwh6XGd4u9MrjfTLN1tOd9iQIKGcK1S3B
	 CrwgW0FthmtCVqBdzX/jZ+454Xacv3F26zuLpsklEh5q/acYnTrjno7C3FeV5WjEId
	 eUF8C8ld+PBpPfqO5MPOGpZds2kOcCW+Kctb7OVU=
Date: Tue, 12 Sep 2023 12:38:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Danilenko <al.b.danilenko@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 134/739] spi: tegra114: Remove unnecessary
 NULL-pointer checks
Message-ID: <2023091212-dispose-oboe-ba98@gregkh>
References: <20230911134650.921299741@linuxfoundation.org>
 <20230911134654.832694547@linuxfoundation.org>
 <ZP8lHSmZVOvbI3wN@finisterre.sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZP8lHSmZVOvbI3wN@finisterre.sirena.org.uk>

On Mon, Sep 11, 2023 at 03:33:01PM +0100, Mark Brown wrote:
> On Mon, Sep 11, 2023 at 03:38:53PM +0200, Greg Kroah-Hartman wrote:
> > 6.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Alexander Danilenko <al.b.danilenko@gmail.com>
> > 
> > [ Upstream commit 373c36bf7914e3198ac2654dede499f340c52950 ]
> > 
> > cs_setup, cs_hold and cs_inactive points to fields of spi_device struct,
> > so there is no sense in checking them for NULL.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> This is a code cleanup, why is it a stable candidate?  It's not a
> warning fix or anything.

{sigh}  This is due to the crazy people using SVACE marking stuff as a
"fix" when it really isn't to try to boost the chance that their patches
will be accepted :(

I'm all but refusing to take their patches now due to all of the
problems they have caused in the past.  I'll go drop this from all
stable queues as well, thanks for catching this.

greg k-h
