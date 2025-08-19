Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269492C11F0;
	Tue, 19 Aug 2025 12:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755606765; cv=none; b=V32HCCrKTHXOOZieGzLDLgavyaYDz00zLfPQKgLcu4URxk0qhAEKHxmP50LR/ItQh9ND7QRvGUxbP5OUPpFHpsTxRlWJtAb/5vZQPwJI45yvFJMyqCZ5uzEQvZS9LnWd0ght2A3VFW5/tNTNknRu2U+FaEcf2RbpEy+VpPbnS0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755606765; c=relaxed/simple;
	bh=WkT0zlQitYXGUwCoHZYVvA6x6OUJGG+ff7vT1/lnGqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMEVZpFsGUFL3P7FA2FSJ1f5HXqfV0MSCl9r4xDL8d3MAPa3D/6CiHfSgj1loJy2zeeIfONRRoEICgLllp7sRtQ4Zeq4S8wdDaT+T2z9iqhdKETIciwUKDxNIK5EuUz2NU9Am4zY67eW5vU3GHAbVIiDBXpUVjmnbWzQDQ7xfZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMgG8kLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMgG8kLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801A2C4CEF1;
	Tue, 19 Aug 2025 12:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755606764;
	bh=WkT0zlQitYXGUwCoHZYVvA6x6OUJGG+ff7vT1/lnGqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pMgG8kLxTwVBjR1Crmt8Ii2Bytrxh8SmQ7MMoUBHHW2gaWbSFDTJEsefTfzoALVQo
	 7jmSfLCdI75Sw4DZgVctf2HVZpGMen2nh7rtGbc2w9cv2amus2C+P+oLCxm/g1PgPy
	 gny/svc8StYjL58OsAfif8pAqFm8RUPGY1Xv3VLE=
Date: Tue, 19 Aug 2025 14:32:41 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hanjun Guo <guohanjun@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 222/444] ACPI: Suppress misleading SPCR console
 message when SPCR table is absent
Message-ID: <2025081935-quicken-satin-5bfd@gregkh>
References: <20250818124448.879659024@linuxfoundation.org>
 <20250818124457.168346613@linuxfoundation.org>
 <559e5f67-0fc9-8c62-4820-7523d9c52f07@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <559e5f67-0fc9-8c62-4820-7523d9c52f07@huawei.com>

On Mon, Aug 18, 2025 at 11:21:42PM +0800, Hanjun Guo wrote:
> Hi Greg,
> 
> On 2025/8/18 20:44, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Li Chen <chenl311@chinatelecom.cn>
> > 
> > [ Upstream commit bad3fa2fb9206f4dcec6ddef094ec2fbf6e8dcb2 ]
> > 
> > The kernel currently alway prints:
> > "Use ACPI SPCR as default console: No/Yes"
> > 
> > even on systems that lack an SPCR table. This can
> > mislead users into thinking the SPCR table exists
> > on the machines without SPCR.
> > 
> > With this change, the "Yes" is only printed if
> > the SPCR table is present, parsed and !param_acpi_nospcr.
> > This avoids user confusion on SPCR-less systems.
> > 
> > Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> > Acked-by: Hanjun Guo <guohanjun@huawei.com>
> > Link: https://lore.kernel.org/r/20250620131309.126555-3-me@linux.beauty
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/arm64/kernel/acpi.c | 10 +++++++---
> >   1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> > index e6f66491fbe9..862bb1cba4f0 100644
> > --- a/arch/arm64/kernel/acpi.c
> > +++ b/arch/arm64/kernel/acpi.c
> > @@ -197,6 +197,8 @@ static int __init acpi_fadt_sanity_check(void)
> >    */
> >   void __init acpi_boot_table_init(void)
> >   {
> > +	int ret;
> > +
> >   	/*
> >   	 * Enable ACPI instead of device tree unless
> >   	 * - ACPI has been disabled explicitly (acpi=off), or
> > @@ -250,10 +252,12 @@ void __init acpi_boot_table_init(void)
> >   		 * behaviour, use acpi=nospcr to disable console in ACPI SPCR
> >   		 * table as default serial console.
> >   		 */
> > -		acpi_parse_spcr(earlycon_acpi_spcr_enable,
> > +		ret = acpi_parse_spcr(earlycon_acpi_spcr_enable,
> >   			!param_acpi_nospcr);
> > -		pr_info("Use ACPI SPCR as default console: %s\n",
> > -				param_acpi_nospcr ? "No" : "Yes");
> > +		if (!ret || param_acpi_nospcr || !IS_ENABLED(CONFIG_ACPI_SPCR_TABLE))
> 
> We also need to backport this preparing patch:
> 
> b9f58d3572a8 ACPI: Return -ENODEV from acpi_parse_spcr() when SPCR support
> is disabled
> 
> Or it will print the wrong message.
> 
> It applies for 6.15 and 6.16 kernel as well.

Thanks, now queued up.

greg k-h
