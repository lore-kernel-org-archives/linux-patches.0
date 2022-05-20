Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DF52F34
	for <patches@lists.linux.dev>; Fri, 20 May 2022 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653072843; x=1684608843;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=i7lxz5F2iHOC0vf8IlCJWIHGh3ktHo4EfaBwOtQyuVw=;
  b=XHTkuRheo17OereYhKfjrfmkRLO++SYhVQmN9z8YCeS6Cjuk/CVfpAee
   NR7RH43pZ2XGfomSPEF2nXidcNYQKDVj40WvuJxdMN5wWaAqDbs0eb1Gb
   136rqAPBR+70OUaZqybPisha+mnwWQn5mK0zm727sif1sqBoH8xsQlb4O
   NJ/fnljWF7x8MVIWN3t5vzeWlpMpgIMvOWcXr8oCMROklDK1MOBD4uRpu
   l3sIH4wTIJtSbr09Fbc7n8rZWBYNRqxsESxL3ngnPNvQmtFTuF99nPvdT
   sG5gt9brDBdQu0ei3JYgGe783i9U2WX5Pr0pn/ATFMrspiHmtPwMJDozE
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="298015711"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="298015711"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 11:54:02 -0700
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="701878804"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 11:54:02 -0700
Date: Fri, 20 May 2022 11:54:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <bwidawsk@kernel.org>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Widawsky, Ben" <ben.widawsky@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Update Ben's email address
Message-ID: <20220520185440.GA1411046@alison-desk>
References: <20220520180059.632054-1-bwidawsk@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520180059.632054-1-bwidawsk@kernel.org>

On Fri, May 20, 2022 at 11:00:59AM -0700, Ben Widawsky wrote:
> From: Ben Widawsky <ben.widawsky@intel.com>
> 
> I'm leaving Intel. Update email address to korg and add .mailmap
> entries. For now, I will be taking a reduced role in CXL development,
> but I still plan to spend time working on it, and I can still serve as a
> good substitute if needed for maintainer responsibilities (that may
> change in the future).
> 
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>

Thanks Ben! Glad to hear your staying in the region ;)

Reviewed-by: Alison Schofield <alison.schofield@intel.com>



> ---
>  .mailmap    | 3 +++
>  MAINTAINERS | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/.mailmap b/.mailmap
> index 97ccdf147111..e8fb056a8935 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -61,6 +61,9 @@ Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
>  Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
>  Ben Gardner <bgardner@wabtec.com>
>  Ben M Cahill <ben.m.cahill@intel.com>
> +Ben Widawsky <bwidawsk@kernel.org> <ben@bwidawsk.net>
> +Ben Widawsky <bwidawsk@kernel.org> <ben.widawsky@intel.com>
> +Ben Widawsky <bwidawsk@kernel.org> <benjamin.widawsky@intel.com>
>  Björn Steinbrink <B.Steinbrink@gmx.de>
>  Björn Töpel <bjorn@kernel.org> <bjorn.topel@gmail.com>
>  Björn Töpel <bjorn@kernel.org> <bjorn.topel@intel.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e127c2fb08a7..f5545ce42cc8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4842,7 +4842,7 @@ COMPUTE EXPRESS LINK (CXL)
>  M:	Alison Schofield <alison.schofield@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Ira Weiny <ira.weiny@intel.com>
> -M:	Ben Widawsky <ben.widawsky@intel.com>
> +M:	Ben Widawsky <bwidawsk@kernel.org>
>  M:	Dan Williams <dan.j.williams@intel.com>
>  L:	linux-cxl@vger.kernel.org
>  S:	Maintained
> -- 
> 2.36.1
> 
