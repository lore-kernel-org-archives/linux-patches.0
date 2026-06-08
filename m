Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C20318EC4
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780929444; cv=none; b=H8YAId9/MjR/eiqcRhsPRjBxtiB4ciqgSJqrHlPAAzgeVPpOck8jcBwDT5o6hRlUNh2EjzvGmm7+ddJ/6ivl9Ggr+pp/BZIUy1M/p45qncN1u3sXmdgR09umCVynhwbW+dT5q6mSlFX3ilp3ohZrhGl+E0B5eLuxvknDh0bqYqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780929444; c=relaxed/simple;
	bh=GR+fkz+vEjcwix+5ZmEAaFUKvsWR+llgMpQ13XU1cZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6CLhdrybAZ/uoLhevm5QqPj332zOth9hVbJEXCGs4V55bgw/SAs8BcC+lv9ud9s8rCrfaL6UKjrp/CMqbaPz35ZUo/VhJEHSLfrtlo7lSXnTjn0/WBt1yMs6goVyKAZzkWhinVvRId0yK6zPBpK9Hlisr99rVEB8d143oLqsF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=BM86ErMy; arc=none smtp.client-ip=188.68.63.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="BM86ErMy"
Received: from mors-relay8204.netcup.net (localhost [127.0.0.1])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4gYvkx38xyz8jVC;
	Mon,  8 Jun 2026 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1780929433;
	bh=GR+fkz+vEjcwix+5ZmEAaFUKvsWR+llgMpQ13XU1cZM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BM86ErMysWYM6w2l/6oPi/7JCsY52DI4I0fRmp9RR8ZIRF+Yb9ZtQK7e9oMb5BNh3
	 1J8+CCE5uc7Cx7MoVabu9L1di2uKorTSqHFboLgSX+/+mdLelsYeXX2ASgEvDCpZIN
	 wL8JqZ8RQQFkgJI7wHVMPdrPZRPiOiOpA/7iVKVFEF8WuKMFHKXfuDtRrVcuJXFST1
	 GjHKe/w4khRu0DTQt/Cp8oW+uEIarjKTLDzv8GKMW++ypHamz8l3TjbQU4rKz2EaqV
	 SgQlUFkhS5R/Tc4vvDTbE6nBWJjQYGVVB9xGEmoeJxAd3+Nbz/z9x5K4sEXEDhfNZ8
	 bS80i8FX6Pmaw==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay8204.netcup.net (Postfix) with ESMTPS id 4gYvkx2Nd3z8jV8;
	Mon,  8 Jun 2026 14:37:13 +0000 (UTC)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4gYvkw5RD8z8tH0;
	Mon,  8 Jun 2026 16:37:12 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 74D226185D;
	Mon,  8 Jun 2026 16:37:11 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=linux@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <3fe6ad12-30e4-4a57-8167-268ffdb4488a@leemhuis.info>
Date: Mon, 8 Jun 2026 16:37:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 089/332] net/handshake: Pass negative errno through
 handshake_complete()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Hannes Reinecke <hare@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Sasha Levin <sashal@kernel.org>, Justin Forbes <jforbes@redhat.com>
References: <20260607095728.031258202@linuxfoundation.org>
 <20260607095731.416875228@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <20260607095731.416875228@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178092943184.839797.16245267668465139144@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 74D226185D
X-NC-CID: Kqbwtft2TTCFeo7+3W1sFialsW+w2RFEHdCmxU510gxZ/g9kkyU=

On 6/7/26 11:57, Greg Kroah-Hartman wrote:
> 7.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> [ Upstream commit 6b22d433aa13f68e3cd9534ca9a5f4277bfa01c2 ]
> 
> handshake_complete() declares status as unsigned int and
> tls_handshake_done() negates that value (-status) before handing
> it to the TLS consumer. Consumers match on negative errno
> constants -- xs_tls_handshake_done() has

This causes a error for me when building ynl. See below for the build
log. The problem can be avoided by reverting this patch from the
stable-rc queue or by cherry-picking fbf5df34a4dbcd ("tools: ynl: add
scope qualifier for definitions") [v7.1-rc4].

I'd suggest doing the later, as I last week had a quite similar error
when building ynl during the 7.0.11-rc1 phase:
https://lore.kernel.org/all/d66f5c95-ebc0-4c53-9852-f73c790363f7@leemhuis.info/

Back then Sasha went for dropping the problematic change ("net: shaper:
reject handle IDs exceeding internal bit-width") from the 6.18.y and
7.0.y queues. But given that this is the second time within a week the
missing patch seems to cause trouble I suspect it might not be the last.

The build error looks like this:

"""
> Traceback (most recent call last):
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3734, in <module>
>     main()
>     ~~~~^^
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3439, in main
>     parsed = Family(args.spec, exclude_ops, args.fn_prefix)
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 1245, in __init__
>     super().__init__(file_name, exclude_ops=exclude_ops)
>     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/pyynl/lib/nlspec.py", line 472, in __init__
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
>      'name': 'max-errno',
>      'value': 4095,
>      'header': 'linux/err.h',
>      'scope': 'kernel'}
> Traceback (most recent call last):
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3734, in <module>
>     main()
>     ~~~~^^
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 3439, in main
>     parsed = Family(args.spec, exclude_ops, args.fn_prefix)
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/generated/../pyynl/ynl_gen_c.py", line 1245, in __init__
>     super().__init__(file_name, exclude_ops=exclude_ops)
>     ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/builddir/build/BUILD/kernel-7.0.12-build/kernel-7.0.12-rc1/linux-7.0.12-0.rc1.301.vanilla.fc44.x86_64/tools/net/ynl/pyynl/lib/nlspec.py", line 472, in __init__
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
>      'name': 'max-errno',
>      'value': 4095,
>      'header': 'linux/err.h',
>      'scope': 'kernel'}
> 	GEN ovs_datapath-user.h
> 	GEN ovs_flow-user.c
> 	GEN ovs_flow-user.h
> 	GEN ovs_vport-user.c
> 	GEN ovs_vport-user.h
> 	GEN psp-user.c
> make[1]: *** [Makefile:44: handshake-user.h] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make[1]: *** [Makefile:47: handshake-user.c] Error 1
> 	AR ynl.a
> make: *** [Makefile:28: generated] Error 2
"""
Ciao, Thorsten

> 	switch (status) {
> 	case 0:
> 	case -EACCES:
> 	case -ETIMEDOUT:
> 		lower_transport->xprt_err = status;
> 		break;
> 	default:
> 		lower_transport->xprt_err = -EACCES;
> 	}
> 
> so the API as designed expects callers to pass positive errno
> values that the tlshd shim then negates.
> 
> Three internal callers in handshake_nl_accept_doit(), the
> net-exit drain, and a kunit test follow kernel convention and
> pass negative errnos -- -EIO, -ETIMEDOUT, -ETIMEDOUT. The
> implicit conversion to unsigned int turns -ETIMEDOUT into
> 0xFFFFFF92; the subsequent -status in tls_handshake_done()
> wraps back to 110, the consumer's switch falls through, and
> the xprt reports -EACCES on what should be -ETIMEDOUT or -EIO.
> 
> Fix the API rather than the call sites. The natural kernel
> convention is negative errno in, negative errno out. Change
> handshake_complete() and hp_done to take int status, drop the
> negation in tls_handshake_done(), and negate once in
> handshake_nl_done_doit() where status arrives from the wire
> as an unsigned netlink attribute. The three internal callers
> were already correct under that convention and need no change.
> 
> At the same wire boundary, declare MAX_ERRNO as the netlink
> policy upper bound for HANDSHAKE_A_DONE_STATUS. Attribute
> validation rejects out-of-range values before
> handshake_nl_done_doit() runs, and negating a bounded u32 there
> stays within int range -- closing the UBSAN-visible signed-
> integer overflow that an unconstrained u32 would invoke.
> 
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@kernel.org>
> Link: https://patch.msgid.link/20260525-handshake-file-pin-v3-3-66c616906ead@oracle.com
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  Documentation/netlink/specs/handshake.yaml | 8 ++++++++
>  net/handshake/genl.c                       | 3 ++-
>  net/handshake/genl.h                       | 1 +
>  net/handshake/handshake-test.c             | 2 +-
>  net/handshake/handshake.h                  | 4 ++--
>  net/handshake/netlink.c                    | 2 +-
>  net/handshake/request.c                    | 2 +-
>  net/handshake/tlshd.c                      | 4 ++--
>  8 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
> index 95c3fade7a8d7b..1024297b38513a 100644
> --- a/Documentation/netlink/specs/handshake.yaml
> +++ b/Documentation/netlink/specs/handshake.yaml
> @@ -12,6 +12,12 @@ protocol: genetlink
>  doc: Netlink protocol to request a transport layer security handshake.
>  
>  definitions:
> +  -
> +    type: const
> +    name: max-errno
> +    value: 4095
> +    header: linux/err.h
> +    scope: kernel
>    -
>      type: enum
>      name: handler-class
> @@ -80,6 +86,8 @@ attribute-sets:
>        -
>          name: status
>          type: u32
> +        checks:
> +          max: max-errno
>        -
>          name: sockfd
>          type: s32
> diff --git a/net/handshake/genl.c b/net/handshake/genl.c
> index 8706126094915d..4b20cd9cdd0e09 100644
> --- a/net/handshake/genl.c
> +++ b/net/handshake/genl.c
> @@ -10,6 +10,7 @@
>  #include "genl.h"
>  
>  #include <uapi/linux/handshake.h>
> +#include <linux/err.h>
>  
>  /* HANDSHAKE_CMD_ACCEPT - do */
>  static const struct nla_policy handshake_accept_nl_policy[HANDSHAKE_A_ACCEPT_HANDLER_CLASS + 1] = {
> @@ -18,7 +19,7 @@ static const struct nla_policy handshake_accept_nl_policy[HANDSHAKE_A_ACCEPT_HAN
>  
>  /* HANDSHAKE_CMD_DONE - do */
>  static const struct nla_policy handshake_done_nl_policy[HANDSHAKE_A_DONE_REMOTE_AUTH + 1] = {
> -	[HANDSHAKE_A_DONE_STATUS] = { .type = NLA_U32, },
> +	[HANDSHAKE_A_DONE_STATUS] = NLA_POLICY_MAX(NLA_U32, MAX_ERRNO),
>  	[HANDSHAKE_A_DONE_SOCKFD] = { .type = NLA_S32, },
>  	[HANDSHAKE_A_DONE_REMOTE_AUTH] = { .type = NLA_U32, },
>  };
> diff --git a/net/handshake/genl.h b/net/handshake/genl.h
> index 8d3e18672dafcf..46b65f131669a6 100644
> --- a/net/handshake/genl.h
> +++ b/net/handshake/genl.h
> @@ -11,6 +11,7 @@
>  #include <net/genetlink.h>
>  
>  #include <uapi/linux/handshake.h>
> +#include <linux/err.h>
>  
>  int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info);
>  int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info);
> diff --git a/net/handshake/handshake-test.c b/net/handshake/handshake-test.c
> index 55442b2f518afb..df3948e807a0fd 100644
> --- a/net/handshake/handshake-test.c
> +++ b/net/handshake/handshake-test.c
> @@ -25,7 +25,7 @@ static int test_accept_func(struct handshake_req *req, struct genl_info *info,
>  	return 0;
>  }
>  
> -static void test_done_func(struct handshake_req *req, unsigned int status,
> +static void test_done_func(struct handshake_req *req, int status,
>  			   struct genl_info *info)
>  {
>  }
> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
> index a48163765a7a1d..2289b0e274f40a 100644
> --- a/net/handshake/handshake.h
> +++ b/net/handshake/handshake.h
> @@ -57,7 +57,7 @@ struct handshake_proto {
>  	int			(*hp_accept)(struct handshake_req *req,
>  					     struct genl_info *info, int fd);
>  	void			(*hp_done)(struct handshake_req *req,
> -					   unsigned int status,
> +					   int status,
>  					   struct genl_info *info);
>  	void			(*hp_destroy)(struct handshake_req *req);
>  };
> @@ -86,7 +86,7 @@ struct handshake_req *handshake_req_hash_lookup(struct sock *sk);
>  struct handshake_req *handshake_req_next(struct handshake_net *hn, int class);
>  int handshake_req_submit(struct socket *sock, struct handshake_req *req,
>  			 gfp_t flags);
> -void handshake_complete(struct handshake_req *req, unsigned int status,
> +void handshake_complete(struct handshake_req *req, int status,
>  			struct genl_info *info);
>  bool handshake_req_cancel(struct sock *sk);
>  
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> index 97114ec8027a5a..039344979de934 100644
> --- a/net/handshake/netlink.c
> +++ b/net/handshake/netlink.c
> @@ -160,7 +160,7 @@ int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info)
>  
>  	status = -EIO;
>  	if (info->attrs[HANDSHAKE_A_DONE_STATUS])
> -		status = nla_get_u32(info->attrs[HANDSHAKE_A_DONE_STATUS]);
> +		status = -(int)nla_get_u32(info->attrs[HANDSHAKE_A_DONE_STATUS]);
>  
>  	handshake_complete(req, status, info);
>  	sockfd_put(sock);
> diff --git a/net/handshake/request.c b/net/handshake/request.c
> index 5d4a17f902d201..97f9f823994994 100644
> --- a/net/handshake/request.c
> +++ b/net/handshake/request.c
> @@ -284,7 +284,7 @@ int handshake_req_submit(struct socket *sock, struct handshake_req *req,
>  }
>  EXPORT_SYMBOL(handshake_req_submit);
>  
> -void handshake_complete(struct handshake_req *req, unsigned int status,
> +void handshake_complete(struct handshake_req *req, int status,
>  			struct genl_info *info)
>  {
>  	struct sock *sk = req->hr_sk;
> diff --git a/net/handshake/tlshd.c b/net/handshake/tlshd.c
> index af294c6cc71731..7567150c2a4f95 100644
> --- a/net/handshake/tlshd.c
> +++ b/net/handshake/tlshd.c
> @@ -93,7 +93,7 @@ static void tls_handshake_remote_peerids(struct tls_handshake_req *treq,
>   *
>   */
>  static void tls_handshake_done(struct handshake_req *req,
> -			       unsigned int status, struct genl_info *info)
> +			       int status, struct genl_info *info)
>  {
>  	struct tls_handshake_req *treq = handshake_req_private(req);
>  
> @@ -104,7 +104,7 @@ static void tls_handshake_done(struct handshake_req *req,
>  	if (!status)
>  		set_bit(HANDSHAKE_F_REQ_SESSION, &req->hr_flags);
>  
> -	treq->th_consumer_done(treq->th_consumer_data, -status,
> +	treq->th_consumer_done(treq->th_consumer_data, status,
>  			       treq->th_peerid[0]);
>  }
>  

