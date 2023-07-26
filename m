Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B31101
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 03:10:55 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1bba04b9df3so22881335ad.0
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 20:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20221208.gappssmtp.com; s=20221208; t=1690341055; x=1690945855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IvvLurWmKpoBDmJ7SuX6DjccQU9JInSh+QxeozTVIBs=;
        b=CfDRR/MsKQr4yQmvH1tf9lA+6ksK77CLAWkfaZG7w+l/aylzxRwjpL0NhZH+6rqCGP
         k+7iykahUIt40I/sncUh0d7v16l60BZBJemQgsqnuWRul/lTrqRq8b8FrncslukXg15T
         18im0RzsPEgylMEn5AMuVo23Z6Tq1NNMUxC/TebzeszW46H4wQ9gcsVc3yurlPbd/ZNP
         72f69+U9Lb4wxU0Z/AhggqGh/oOIng0YiXIM9TWCEbm0hC1sIu4soiSFy3RFMcoOQF7G
         M7hLrNQXinkN+jRZsZ24Hu12UJcNTN5+bWSYe61WBJGDuNUFAc1f3wrcAgKAfOmd85TG
         YkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690341055; x=1690945855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvvLurWmKpoBDmJ7SuX6DjccQU9JInSh+QxeozTVIBs=;
        b=MkbdXrPOoUPdAcVGalioeo/11UyEAwBcDRqe15H/FtZ5bZKtNJ4DX8BDUDo6/2lu49
         IPpV7r1Wp8LGay2jNjvdFFG8DEouw0cdWbAoHAz3OHHLgw+rYYboM6og/NutfdyLNgx7
         k2A/hr4mPTweEknolvlG4NKLMSxm2gTqbwQXHtDAJ7rjugb/qtTblzdZRde+3k7QQoJh
         p5+xDfPLT33UNt11RG9w+wdW8IqKIM69+QpEskTij5878aWT7jZDr+I6O5PI4szzLnjq
         KGeGwOVC+oyo4QtJaw+Uy7QgIjV9TYgxA6oL8agm4bRgWqhaBoSSQIjK71rtKD6Nzyjh
         mVow==
X-Gm-Message-State: ABy/qLbWyUIdSmO8A9mLXrNA3sLaezIIzGYoCvkHUzXWwmDTGPzQDpPd
	BbQnfYHvTOK1ksWqs2SfLaNqrQ==
X-Google-Smtp-Source: APBJJlHdYPlsXo+rZE2sLcNGksogngSSyYL2isOJkEoKdAmD1DcjdxQ4s5yVRrn3/tDMHhCWzz/f4w==
X-Received: by 2002:a17:902:ec89:b0:1ba:fe63:6622 with SMTP id x9-20020a170902ec8900b001bafe636622mr1265902plg.32.1690341054956;
        Tue, 25 Jul 2023 20:10:54 -0700 (PDT)
Received: from x1 ([2601:1c2:1800:f680:ab7f:7b75:8135:310])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902a41200b001bb9f104333sm5565234plq.12.2023.07.25.20.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 20:10:54 -0700 (PDT)
Date: Tue, 25 Jul 2023 20:10:52 -0700
From: Drew Fustini <dfustini@baylibre.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org,
	Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 0/7] Add support for Sub-NUMA cluster (SNC) systems
Message-ID: <ZMCOvMfROYhQEFXo@x1>
References: <20230713163207.219710-1-tony.luck@intel.com>
 <20230722190740.326190-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230722190740.326190-1-tony.luck@intel.com>

On Sat, Jul 22, 2023 at 12:07:33PM -0700, Tony Luck wrote:
> The Sub-NUMA cluster feature on some Intel processors partitions
> the CPUs that share an L3 cache into two or more sets. This plays
> havoc with the Resource Director Technology (RDT) monitoring features.
> Prior to this patch Intel has advised that SNC and RDT are incompatible.
> 
> Some of these CPU support an MSR that can partition the RMID
> counters in the same way. This allows for monitoring features
> to be used (with the caveat that memory accesses between different
> SNC NUMA nodes may still not be counted accuratlely.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> 
> Changes since v3:
> 
> Reinette provided the most excellent suggestion that this series
> could better achieve its objective if it enabled separate domain
> lists for control & monitoring within a resource, rather than
> creating a whole new resource to support separte node scope needed
> for SNC monitoring. Thus all the pre-amble patches from the previous
> version have gone, replaced by patches 1-4 of this new series.

[This comment is unrelated to Sub-NUMA support so please disregard if
this is the wrong place to make these comments]

I think that the resctrl interface for RISC-V CBQRI could also benefit
from separate domain lists for control and monitoring.

For example, the bandwidth controller QoS register [1] interface allows
a device to implement both bandwidth usage monitoring and bandwidth
allocation. The resctrl proof-of-concept [2] had to awkwardly create two
domains for each memory controller in our example SoC, one that would
contain the MBA resource and one that would contain the L3 resource to
represent MBM files like local_bytes.

This resulted in a very odd looking schemata that would be hard to the
user to understand:

  # cat /sys/fs/resctrl/schemata
  MB:4=  80;6=  80;8=  80
  L2:0=0fff;1=0fff
  L3:2=ffff;3=0000;5=0000;7=0000

Where:

  Domain 0 is L2 cache controller 0 capacity allocation
  Domain 1 is L2 cache controller 1 capacity allocation
  Domain 2 is L3 cache controller capacity allocation

  Domain 4 is Memory controller 0 bandwidth allocation
  Domain 6 is Memory controller 1 bandwidth allocation
  Domain 8 is Memory controller 2 bandwidth allocation

  Domain 3 is Memory controller 0 bandwidth monitoring
  Domain 5 is Memory controller 1 bandwidth monitoring
  Domain 7 is Memory controller 2 bandwidth monitoring

But there is no value of having the domains created for the purposes of
bandwidth monitoring in schemata.

I've not yet fully understood how the new approach in this patch series
could help the situation for CBQRI, but I thought I would mention that
separate lists for control and monitoring might be useful.

Thanks,
Drew

[1] https://github.com/riscv-non-isa/riscv-cbqri/blob/main/qos_bandwidth.adoc
[2] https://lore.kernel.org/linux-riscv/20230419111111.477118-1-dfustini@baylibre.com/
