Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7F337107F
	for <patches@lists.linux.dev>; Fri, 29 May 2026 04:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.61.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028614; cv=none; b=rdW7WQZ/XCJQgyoMn0GLmOtmuWRMOTwrPS8efmD9glKAoPCpt//gY3FZReDOkOjIogSqNffDqOltGfn/5P+hobYFtMxEQfFYb7M3gmBttn3rZCUFIL4bcR4u9x94gYPHCb0CoZLN0BdcVsDnRRUmclXsQWKtLq2H6F4W4I9kmY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028614; c=relaxed/simple;
	bh=VI+zN+U9mnRel4FyP26jh3w1GM29zTBMlPuNIhxk4Zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j5WRiahH9PFwx0SnfDCpzhy8QUfUiziK29cnB+50UAjQcPi3jyL87Fg1LEONIShFqCP3QmPzg9KSt0+R6+WJxTIQS/Ctzs1495Vw4sU3rFEYa+xD6AB+dRSkAbIrqw/wB0gQgD55Aj90ddRJKzYcVWLYLaduZgSzPrcv9aT2Pac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=OoL1W9bg; arc=none smtp.client-ip=188.68.61.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="OoL1W9bg"
Received: from mors-relay-8403.netcup.net (localhost [127.0.0.1])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4gRVbJ06kgz88Mn;
	Fri, 29 May 2026 06:23:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1780028604;
	bh=VI+zN+U9mnRel4FyP26jh3w1GM29zTBMlPuNIhxk4Zc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OoL1W9bgvVPri8TtRVoS653mvFvx2BM+ICzGSO2dElEMSTR/i+ZBv1SgxmShmxX32
	 NuCG1BBDqqVz4quGLlbcfIPp5djOyVV4o3BVdcIktRHpTpA1hkdzM8hwm3Fdmac/51
	 EM+s/+Jc7b+bowDzfBzy+AJ99XsWxYzRzLLMoW5hHgFA3f3usLkle/5HPqBMbvV0W4
	 lmCidsXKoVPXA4PgVvpAaYwNPuzoq2iAkfcpF1kRHHSWXctLndB9Loij5hjYumLN/j
	 jsUfc8fbnINl0RASh2HG7ZgFXPxs0GX4Hpmzn/9Ek0XdepnBj85llIKaSyo7tN6jEb
	 ElcEA7i1dpDkA==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8403.netcup.net (Postfix) with ESMTPS id 4gRVZz69Ldz8DWV;
	Fri, 29 May 2026 06:23:07 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.898
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4gRVZy2f7Kz8tY8;
	Fri, 29 May 2026 06:23:06 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id A478C61743;
	Fri, 29 May 2026 06:23:05 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=linux@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <d66f5c95-ebc0-4c53-9852-f73c790363f7@leemhuis.info>
Date: Fri, 29 May 2026 06:23:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 284/461] net: shaper: reject handle IDs exceeding
 internal bit-width
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20260528194646.819809818@linuxfoundation.org>
 <20260528194655.415018028@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20260528194655.415018028@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178002858599.2275909.5788585644474533789@mxe9fb.netcup.net>
X-NC-CID: vN1nhgLmAUckWVYgptyBtvsbVJMXPzSKFqBy00s84wIrhJS6RL0=

On 5/28/26 21:46, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me know.
> > ------------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 8d5806c600fddb907ebe378f9c366d4b52ac3a39 ]
> 
> net_shaper_parse_handle() reads the user-supplied handle ID via
> nla_get_u32(), accepting the full u32 range. However, the xarray key
> is built by net_shaper_handle_to_index() using
> FIELD_PREP(NET_SHAPER_ID_MASK, handle->id), where NET_SHAPER_ID_MASK
> is GENMASK(25, 0) - only 26 bits wide. FIELD_PREP silently masks off
> the upper bits at runtime. A user-supplied NODE id like 0x04000123
> becomes id 0x123.

This causes a error for me when building ynl.

It can be fixed by reverting this patch from the stable-rc queue or by
applying fbf5df34a4dbcd ("tools: ynl: add scope qualifier for
definitions") [v7.1-rc4] (preceding patch from the same patch series)

The build error looks like this:

"""
> GEN nlctrl-user.h
> 	GEN ovpn-user.c
> 	GEN ovpn-user.h
> 	GEN ovs_datapath-user.c
> Traceback (most recent call last):
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3734, in <module>
>     main()
>     ~~~~^^
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3439, in main
>     parsed = Family(args.spec, exclude_ops, args.fn_prefix)
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 1245, in __init__
>     super().__init__(file_name, exclude_ops=exclude_ops)
>     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/pyynl/lib/nlspec.py", line 472, in __init__
>     SpecFamily.jsonschema.validate(self.yaml, schema)
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^
>   File "/usr/lib/python3.14/site-packages/jsonschema/validators.py", line 1332, in validate
>     raise error
> jsonschema.exceptions.ValidationError: Additional properties are not allowed ('scope' was unexpected)
> 
> Failed validating 'additionalProperties' in schema['properties']['definitions']['items']:
>     {'type': 'object',
>      'required': ['type', 'name'],
>      'additionalProperties': False,
>      'properties': {'name': {'$ref': '#/$defs/name'},
>                     'header': {'description': 'For C-compatible languages, '
>                                               'header which already '
>                                               'defines this value.',
>                                'type': 'string'},
>                     'type': {'enum': ['const', 'enum', 'flags']},
>                     'doc': {'type': 'string'},
>                     'value': {'description': 'For const - the value.',
>                               'type': ['string', 'integer']},
>                     'value-start': {'description': 'For enum or flags the '
>                                                    'literal initializer '
>                                                    'for the first value.',
>                                     'type': ['string', 'integer']},
>                     'entries': {'description': 'For enum or flags array of '
>                                                'values.',
>                                 'type': 'array',
>                                 'items': {'oneOf': [{'type': 'string'},
>                                                     {'type': 'object',
>                                                      'required': ['name'],
>                                                      'additionalProperties': False,
>                                                      'properties': {'name': {'$ref': '#/$defs/name'},
>                                                                     'value': {'type': 'integer'},
>                                                                     'doc': {'type': 'string'}}}]}},
>                     'render-max': {'description': 'Render the max members '
>                                                   'for this enum.',
>                                    'type': 'boolean'}}}
> 
> On instance['definitions'][0]:
>     {'type': 'const',
>      'name': 'max-handle-id',
>      'value': 67108862,
>      'scope': 'kernel'}
> Traceback (most recent call last):
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3734, in <module>
>     main()
>     ~~~~^^
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3439, in main
>     parsed = Family(args.spec, exclude_ops, args.fn_prefix)
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 1245, in __init__
>     super().__init__(file_name, exclude_ops=exclude_ops)
>     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/builddir/build/BUILD/kernel-7.0.11-build/kernel-7.0.11-rc1/linux-7.0.11-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/pyynl/lib/nlspec.py", line 472, in __init__
>     SpecFamily.jsonschema.validate(self.yaml, schema)
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^
>   File "/usr/lib/python3.14/site-packages/jsonschema/validators.py", line 1332, in validate
>     raise error
> jsonschema.exceptions.ValidationError: Additional properties are not allowed ('scope' was unexpected)
> 
> Failed validating 'additionalProperties' in schema['properties']['definitions']['items']:
>     {'type': 'object',
>      'required': ['type', 'name'],
>      'additionalProperties': False,
>      'properties': {'name': {'$ref': '#/$defs/name'},
>                     'header': {'description': 'For C-compatible languages, '
>                                               'header which already '
>                                               'defines this value.',
>                                'type': 'string'},
>                     'type': {'enum': ['const', 'enum', 'flags']},
>                     'doc': {'type': 'string'},
>                     'value': {'description': 'For const - the value.',
>                               'type': ['string', 'integer']},
>                     'value-start': {'description': 'For enum or flags the '
>                                                    'literal initializer '
>                                                    'for the first value.',
>                                     'type': ['string', 'integer']},
>                     'entries': {'description': 'For enum or flags array of '
>                                                'values.',
>                                 'type': 'array',
>                                 'items': {'oneOf': [{'type': 'string'},
>                                                     {'type': 'object',
>                                                      'required': ['name'],
>                                                      'additionalProperties': False,
>                                                      'properties': {'name': {'$ref': '#/$defs/name'},
>                                                                     'value': {'type': 'integer'},
>                                                                     'doc': {'type': 'string'}}}]}},
>                     'render-max': {'description': 'Render the max members '
>                                                   'for this enum.',
>                                    'type': 'boolean'}}}
> 
> On instance['definitions'][0]:
>     {'type': 'const',
>      'name': 'max-handle-id',
>      'value': 67108862,
>      'scope': 'kernel'}
> 	GEN ovs_datapath-user.h
> 	GEN ovs_flow-user.c
> 	GEN ovs_flow-user.h
> 	GEN ovs_vport-user.c
> 	GEN ovs_vport-user.h
> 	GEN psp-user.c
> 	GEN psp-user.h
> 	GEN rt-addr-user.c
> 	GEN rt-addr-user.h
> make[1]: *** [Makefile:43: net_shaper-user.h] Error 1
> make[1]: *** Waiting for unfinished jobs....
> 	GEN rt-link-user.c
> 	GEN rt-link-user.h
> make[1]: *** [Makefile:48: net_shaper-user.c] Error 1
> 	AR ynl.a
> make: *** [Makefile:28: generated] Error 2
"""

Full log:
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora-rc/fedora-44-x86_64/10521840-stablerc-fedorarc-releases/builder-live.log.gz
Ciao, Thorsten


> Additionally, a user-supplied id equal to NET_SHAPER_ID_UNSPEC
> (0x03FFFFFF, which is NET_SHAPER_ID_MASK itself) would collide with
> the sentinel used internally by the group operation to signal
> "allocate a new NODE id".
> 
> Reject user-supplied IDs >= NET_SHAPER_ID_MASK (i.e., >= 0x03FFFFFF)
> in the policy.
> 
> Fixes: 4b623f9f0f59 ("net-shapers: implement NL get operation")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://patch.msgid.link/20260510192904.3987113-9-kuba@kernel.org
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  Documentation/netlink/specs/net_shaper.yaml | 7 +++++++
>  net/shaper/shaper.c                         | 4 +++-
>  net/shaper/shaper_nl_gen.c                  | 7 ++++++-
>  net/shaper/shaper_nl_gen.h                  | 2 ++
>  4 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/netlink/specs/net_shaper.yaml b/Documentation/netlink/specs/net_shaper.yaml
> index 3f2ad772b64b1..de01f922040a5 100644
> --- a/Documentation/netlink/specs/net_shaper.yaml
> +++ b/Documentation/netlink/specs/net_shaper.yaml
> @@ -33,6 +33,11 @@ doc: |
>    @cap-get operation.
>  
>  definitions:
> +  -
> +    type: const
> +    name: max-handle-id
> +    value: 0x3fffffe
> +    scope: kernel
>    -
>      type: enum
>      name: scope
> @@ -140,6 +145,8 @@ attribute-sets:
>        -
>          name: id
>          type: u32
> +        checks:
> +          max: max-handle-id
>          doc: |
>            Numeric identifier of a shaper. The id semantic depends on
>            the scope. For @queue scope it's the queue id and for @node
> diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
> index 08fde2d9e8aa8..eb049847fed65 100644
> --- a/net/shaper/shaper.c
> +++ b/net/shaper/shaper.c
> @@ -21,6 +21,8 @@
>  
>  #define NET_SHAPER_ID_UNSPEC NET_SHAPER_ID_MASK
>  
> +static_assert(NET_SHAPER_ID_UNSPEC == NET_SHAPER_MAX_HANDLE_ID + 1);
> +
>  struct net_shaper_hierarchy {
>  	struct xarray shapers;
>  };
> @@ -360,7 +362,7 @@ static int net_shaper_pre_insert(struct net_shaper_binding *binding,
>  	    handle->id == NET_SHAPER_ID_UNSPEC) {
>  		u32 min, max;
>  
> -		handle->id = NET_SHAPER_ID_MASK - 1;
> +		handle->id = NET_SHAPER_MAX_HANDLE_ID;
>  		max = net_shaper_handle_to_index(handle);
>  		handle->id = 0;
>  		min = net_shaper_handle_to_index(handle);
> diff --git a/net/shaper/shaper_nl_gen.c b/net/shaper/shaper_nl_gen.c
> index 9b29be3ef19a8..76eff85ec66df 100644
> --- a/net/shaper/shaper_nl_gen.c
> +++ b/net/shaper/shaper_nl_gen.c
> @@ -11,10 +11,15 @@
>  
>  #include <uapi/linux/net_shaper.h>
>  
> +/* Integer value ranges */
> +static const struct netlink_range_validation net_shaper_a_handle_id_range = {
> +	.max	= NET_SHAPER_MAX_HANDLE_ID,
> +};
> +
>  /* Common nested types */
>  const struct nla_policy net_shaper_handle_nl_policy[NET_SHAPER_A_HANDLE_ID + 1] = {
>  	[NET_SHAPER_A_HANDLE_SCOPE] = NLA_POLICY_MAX(NLA_U32, 3),
> -	[NET_SHAPER_A_HANDLE_ID] = { .type = NLA_U32, },
> +	[NET_SHAPER_A_HANDLE_ID] = NLA_POLICY_FULL_RANGE(NLA_U32, &net_shaper_a_handle_id_range),
>  };
>  
>  const struct nla_policy net_shaper_leaf_info_nl_policy[NET_SHAPER_A_WEIGHT + 1] = {
> diff --git a/net/shaper/shaper_nl_gen.h b/net/shaper/shaper_nl_gen.h
> index 42c46c52c7751..2406652a9014a 100644
> --- a/net/shaper/shaper_nl_gen.h
> +++ b/net/shaper/shaper_nl_gen.h
> @@ -12,6 +12,8 @@
>  
>  #include <uapi/linux/net_shaper.h>
>  
> +#define NET_SHAPER_MAX_HANDLE_ID	67108862
> +
>  /* Common nested types */
>  extern const struct nla_policy net_shaper_handle_nl_policy[NET_SHAPER_A_HANDLE_ID + 1];
>  extern const struct nla_policy net_shaper_leaf_info_nl_policy[NET_SHAPER_A_WEIGHT + 1];

