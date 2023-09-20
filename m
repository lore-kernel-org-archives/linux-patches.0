Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8260115AF8
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51CFC433C9;
	Wed, 20 Sep 2023 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695213683;
	bh=2zA9/3hYBCDqdDOzmjX8elA4J0poN9unNs0plv5T9bg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E+yBfcW2X3Mbm6mFwDhMYLDmkVnpnPF58EbUV+U+CMtr4fVxFmJRnRYh7SvhH+mZG
	 3SMFbolY174ts7mb5/iZZ6R+WhoqCXaWTIyc5FHmG9zs3kecxCHNmmcj+ZkvL68wdp
	 gwnN6TaGHGnzA0ZyxSV1wbGFDVmw+YERXkGocu3AsEokpWIhowbykmLMYrjGysbQWx
	 y8XttKjPrF6gb3Y2HhpNn4auTLbjrD9JROaZbPgKKeWiLI2bcNcF+SNJh3og28pK4d
	 ocktE9OW3QOysGInL8N0oBpwsCi7ROsYYD+I35P+C+M8YBsGwv4QHC2cMD/bAZutiq
	 uCmAs9SIWhOaA==
Message-ID: <aadc0c48-4ffa-9ead-3992-c01878e46072@kernel.org>
Date: Wed, 20 Sep 2023 05:41:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 6.5 158/211] ata: libata: remove references to
 non-existing error_handler()
Content-Language: en-US
To: Niklas Cassel <Niklas.Cassel@wdc.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sasha Levin <sashal@kernel.org>
References: <20230920112845.859868994@linuxfoundation.org>
 <20230920112850.780030234@linuxfoundation.org> <ZQrn1rae3Y55/1DG@x1-carbon>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZQrn1rae3Y55/1DG@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2023/09/20 5:38, Niklas Cassel wrote:
> On Wed, Sep 20, 2023 at 01:30:02PM +0200, Greg Kroah-Hartman wrote:
>> 6.5-stable review patch.  If anyone has any objections, please let me know.
> 
> Hello Greg,
> 
> I don't think that we should backport this commit.

Yes, we should not. The IPR driver is still in stable, so adding this patch
would be wrong.

> 
> While the patch did apply without conflicts, it was part of a series that
> did a bunch of other cleanups as well.
> 
> I think that it is best to either have that whole series (and we don't want
> to backport the whole series), or none of the patches in that series.
> 
> (So that at least we know that we have one or the other, not some half-way
> cleanup that will only live in v6.5 stable.)
> 
> 
>>
>> ------------------
>>
>> From: Hannes Reinecke <hare@suse.de>
>>
>> [ Upstream commit ff8072d589dcff7c1f0345a6ec98b5fc1e9ee2a1 ]
>>
>> With commit 65a15d6560df ("scsi: ipr: Remove SATA support") all
>> libata drivers now have the error_handler() callback provided,
>> so we can stop checking for non-existing error_handler callback.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> [niklas: fixed review comments, rebased, solved conflicts during rebase,
>> fixed bug that unconditionally dumped all QCs, removed the now unused
>> function ata_dump_status(), removed the now unreachable failure paths in
>> atapi_qc_complete(), removed the non-EH function to request ATAPI sense]
>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>> Reviewed-by: John Garry <john.g.garry@oracle.com>
>> Reviewed-by: Jason Yan <yanaijie@huawei.com>
>> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> Stable-dep-of: 5e35a9ac3fe3 ("ata: libata-core: fetch sense data for successful commands iff CDL enabled")
> 
> Yes, it is true that
> 5e35a9ac3fe3 ("ata: libata-core: fetch sense data for successful commands iff CDL enabled")
> does not apply cleanly to v6.5 stable without this big commit.
> 
> I'm attaching a backported version of that patch (which is only 2 lines or so)
> that can be applied to v6.5 stable instead.
> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

