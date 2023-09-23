Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3435CA68
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 08:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D2AC433C7;
	Sat, 23 Sep 2023 08:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695457037;
	bh=lUrqarf5J/wNG3skXdLJr09ehc0tAMmI/R3wOn0LZUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XtjlFyPFGldr9hWy6p8i/8u5Enjr/9tXZQ7qOlyoyhycQ383ULchc7Z4K3BNSSEVt
	 XBb5aUkHwQ0LPF6MQPNnGMUM4dH4DaN7THbEH04P1+R9Lw+FbTw6YBrMlRdjn+D851
	 f4QeIiabtoONTn9J7vOezPTxwUj3wybIaSQbkDGw=
Date: Sat, 23 Sep 2023 10:17:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.5 158/211] ata: libata: remove references to
 non-existing error_handler()
Message-ID: <2023092355-shadow-halves-8c2a@gregkh>
References: <20230920112845.859868994@linuxfoundation.org>
 <20230920112850.780030234@linuxfoundation.org>
 <ZQrn1rae3Y55/1DG@x1-carbon>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQrn1rae3Y55/1DG@x1-carbon>

On Wed, Sep 20, 2023 at 12:38:50PM +0000, Niklas Cassel wrote:
> On Wed, Sep 20, 2023 at 01:30:02PM +0200, Greg Kroah-Hartman wrote:
> > 6.5-stable review patch.  If anyone has any objections, please let me know.
> 
> Hello Greg,
> 
> I don't think that we should backport this commit.
> 
> While the patch did apply without conflicts, it was part of a series that
> did a bunch of other cleanups as well.
> 
> I think that it is best to either have that whole series (and we don't want
> to backport the whole series), or none of the patches in that series.
> 
> (So that at least we know that we have one or the other, not some half-way
> cleanup that will only live in v6.5 stable.)

Thanks, now dropped.  It was added for a later patch as a dependancy,
but I fixed that up by hand so all should be good now.

greg k-h
