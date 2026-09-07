Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5BD44237C
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 09:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772883; cv=none; b=e17obgpOFuXCUNB/pHOx4YLZbnUClPXMZaeAL0TS0DXvsuKFuvdCKbW8WbkEViGoU4y6Qfpz7e3Zrr3Bm8S/HzlAf+ZZ0sni3/nobAJvrFRAytHvmeqIrMNi1t0Fs+kA0FqDm8D0MUlabudxUXKjxI3ITYZ/UUzZ1NAA5Izf7Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772883; c=relaxed/simple;
	bh=K3qa1TQpTV87MVucLwzIVV0UEx/miaMiRTH3FpZpHp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sXrIDEu77q4iRWL+xYaXLrFRSM86Ekkithad1EPF3nhix1ukn/r7sH+1x2VAuYWLcMzkHfWGrhjxfU8zts6qGpsT1SdWAOiZLZHQs/ynM513yEebFZgjZHiFZ4cft0qGizRaYDazJsrZHcD9dXOmnFqVPSqKYh+jFAaXx+lgZ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RbeQYAUz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RbeQYAUz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B11831477;
	Mon,  7 Sep 2026 02:21:16 -0700 (PDT)
Received: from [10.2.212.8] (e134344.arm.com [10.2.212.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A1D23F7B4;
	Mon,  7 Sep 2026 02:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788772880; bh=K3qa1TQpTV87MVucLwzIVV0UEx/miaMiRTH3FpZpHp0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RbeQYAUzbez7TNp8A5/0RkvEliIZxxgAdj9VlLpVz4iVZ7H18gHIPHAdiMNPeuPtP
	 W5m13FKdd1RMPSKKcYa+KeTGnpM9zsWaPn09+w+Knee6o25moTRWIpJy09PVG4itg2
	 g0xuACDMLHDXL8tnv9HtIy6wXhhLfh0WWpaqapdo=
Message-ID: <790b4d24-a9bf-4226-b929-1c4611cd8540@arm.com>
Date: Mon, 7 Sep 2026 10:21:16 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] fs/resctrl: Drop unnecessary parameter from
 resctrl_io_alloc_parse_line()
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <4d050a1f7dc0b22bd8c4e6db1c2f2781e2bf929f.1788452481.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <4d050a1f7dc0b22bd8c4e6db1c2f2781e2bf929f.1788452481.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 03/09/2026 17:57, Reinette Chatre wrote:
> resctrl_io_alloc_parse_line() only has one caller that determines the
> resource via resctrl_schema::res and then passes a pointer to the resource
> as well as struct resctrl_schema.
> 
> Only pass pointer to struct resctrl_schema. resctrl_io_alloc_parse_line()
> can determine the resource itself.

Nit: Without taking into account that a resource is going to support multiple controls in the future
this change feels a little under justified. Perhaps any extra line in the commit message is warranted.

Regardless, this looks good to me.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben

> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes since RFC v2:
> - Rework changelog.
> ---
>  fs/resctrl/ctrlmondata.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 4562072b8ba6..69123b2a3274 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -955,11 +955,12 @@ int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq,
>  	return ret;
>  }
>  
> -static int resctrl_io_alloc_parse_line(char *line,  struct rdt_resource *r,
> -				       struct resctrl_schema *s, u32 closid)
> +static int resctrl_io_alloc_parse_line(char *line, struct resctrl_schema *s,
> +				       u32 closid)
>  {
>  	enum resctrl_conf_type peer_type;
>  	unsigned long dom_id = ULONG_MAX;
> +	struct rdt_resource *r = s->res;
>  	struct rdt_parse_data data;
>  	struct rdt_ctrl_domain *d;
>  	bool update_all = false;
> @@ -1052,7 +1053,7 @@ ssize_t resctrl_io_alloc_cbm_write(struct kernfs_open_file *of, char *buf,
>  	io_alloc_closid = resctrl_io_alloc_closid(r);
>  
>  	rdt_staged_configs_clear();
> -	ret = resctrl_io_alloc_parse_line(buf, r, s, io_alloc_closid);
> +	ret = resctrl_io_alloc_parse_line(buf, s, io_alloc_closid);
>  	if (ret)
>  		goto out_clear_configs;
>  

