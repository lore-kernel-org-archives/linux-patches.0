Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25788280CE0;
	Wed, 23 Apr 2025 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745425672; cv=none; b=d6vhXf+/EbNsqqFcRV7FN4C2byLHEYsbDaINqyZMNJ8yDhfTscqovc8cojfDMgHfUfrxhXnvbAAehwJ3zB1bKVRXCsHe8iS2EeoBfBqqUdpkXqG65mZJzxUy6BE3XIN1UTMurKZzFHhJ6KhQwXTMWxWhZ+GpPc7GxWMDtZg7d9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745425672; c=relaxed/simple;
	bh=bYwzAggJLL1OqB+NXewwmcNSrowHZ6NEoUXa3OA6Tt4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ff80saDabfKezv8vPK69+UAS2xcPZPm4p3cDqngLj7/INZsRJ0CDJqUWim7fhsb50p3FKBZfTYOagxRBxWERbDH28/hPtpSnqNjsxDcE3zCMD4ad2oPR+/prLMLhfHh6ZpnOtbp7GGTFzspIZ09nQ+TQcSjzIMlmwQM+CFKHQck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=UHisgQrJ; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="UHisgQrJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=Q+DOv7/jxYYIbT2QhiPXr8gtNdcTIXB1oHIBFxJ4Ggc=; t=1745425670;
	x=1745857670; b=UHisgQrJYV1sr/wF+M3XEj0PkqQ7OhJxfGcnJZBOnjx9vBqk4Ov2+ASUbcu5G
	1F5DYVZNCdIqhmqDbI1b9sJDZrnoGhjYo3Ga5W3Jcv82hq7h3M0IV9QnQganbtbMsUt68iLLS06MV
	2j27K1EHJe8dFlRiqMJgYi4aZK1WPV6vVm91oXkAkJo1XQtot8NBmj5v394N+w1l1JqLPL9jlG1Xd
	Y5nAWAHcLXhnYeTo8OFr+gzZln8JU1FtChWRKWX+1/jP2ErRx3V65ckt2DFKL7dTQCBoeThGhrhng
	svf/v0q9KoP4KP6+D3uGtOCx+Njj+7PKF3+8E6UMve6jGq2EJQ==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1u7cwt-0035S8-1R;
	Wed, 23 Apr 2025 18:27:47 +0200
Message-ID: <d478c0b9-2846-496d-b345-429d98f93d38@leemhuis.info>
Date: Wed, 23 Apr 2025 18:27:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 065/241] tools: ynl-gen: individually free previous
 values on double set
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Donald Hunter <donald.hunter@gmail.com>,
 Jacob Keller <jacob.e.keller@intel.com>, Jakub Kicinski <kuba@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20250423142620.525425242@linuxfoundation.org>
 <20250423142623.257470479@linuxfoundation.org>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <20250423142623.257470479@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1745425670;4f0be670;
X-HE-SMSGID: 1u7cwt-0035S8-1R

[note, to avoid confusion: the problem mentioned below is independent of
an ynl problem I ran into with -next today:
https://lore.kernel.org/all/59ba7a94-17b9-485f-aa6d-14e4f01a7a39@leemhuis.info/ ]

On 23.04.25 16:42, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit ce6cb8113c842b94e77364b247c4f85c7b34e0c2 ]
> 
> When user calls request_attrA_set() multiple times (for the same
> attribute), and attrA is of type which allocates memory -
> we try to free the previously associated values. For array
> types (including multi-attr) we have only freed the array,
> but the array may have contained pointers.
> 
> Refactor the code generation for free attr and reuse the generated
> lines in setters to flush out the previous state. Since setters
> are static inlines in the header we need to add forward declarations
> for the free helpers of pure nested structs. Track which types get
> used by arrays and include the right forwad declarations.
> 
> At least ethtool string set and bit set would not be freed without
> this. Tho, admittedly, overriding already set attribute twice is likely
> a very very rare thing to do.

This change caused the following build error for me on Fedora while
using a slightly modified version of the distro's kernel.spec file to
build kernel rpms for Fedora. Reverting the change fixed the problem.

"""
[....]
	CC net_shaper-user.o
	CC netdev-user.o
	CC nfsd-user.o
In file included from net_shaper-user.c:8:
net_shaper-user.h: In function â€˜__net_shaper_group_req_set_leavesâ€™:
net_shaper-user.h:420:1: error: old-style parameter declarations in prototyped function definition
  420 | __net_shaper_group_req_set_leaves(struct net_shaper_group_req *req,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from dpll-user.c:8:
dpll-user.h: In function â€˜__dpll_pin_set_req_set_parent_deviceâ€™:
dpll-user.h:522:1: error: old-style parameter declarations in prototyped function definition
  522 | __dpll_pin_set_req_set_parent_device(struct dpll_pin_set_req *req,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net_shaper-user.h:426:14: error: â€˜iâ€™ undeclared (first use in this function)
  426 |         for (i = 0; i < req->n_leaves; i++)
      |              ^
net_shaper-user.h:426:14: note: each undeclared identifier is reported only once for each function it appears in
dpll-user.h:528:14: error: â€˜iâ€™ undeclared (first use in this function)
  528 |         for (i = 0; i < req->n_parent_device; i++)
      |              ^
dpll-user.h:528:14: note: each undeclared identifier is reported only once for each function it appears in
dpll-user.h: In function â€˜__dpll_pin_set_req_set_parent_pinâ€™:
dpll-user.h:535:1: error: old-style parameter declarations in prototyped function definition
  535 | __dpll_pin_set_req_set_parent_pin(struct dpll_pin_set_req *req,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dpll-user.h:541:14: error: â€˜iâ€™ undeclared (first use in this function)
  541 |         for (i = 0; i < req->n_parent_pin; i++)
      |              ^
	CC nlctrl-user.o
make[1]: *** [Makefile:53: net_shaper-user.o] Error 1
make[1]: *** Waiting for unfinished jobs....
	CC ovs_datapath-user.o
make[1]: *** [Makefile:53: dpll-user.o] Error 1
In file included from netdev-user.c:8:
netdev-user.h: In function â€˜__netdev_bind_rx_req_set_queuesâ€™:
In file included from nfsd-user.c:8:
nfsd-user.h: In function â€˜__nfsd_version_set_req_set_versionâ€™:
netdev-user.h:563:1: error: old-style parameter declarations in prototyped function definition
  563 | __netdev_bind_rx_req_set_queues(struct netdev_bind_rx_req *req,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
netdev-user.h:569:14: error: â€˜iâ€™ undeclared (first use in this function)
  569 |         for (i = 0; i < req->n_queues; i++)
      |              ^
nfsd-user.h:190:1: error: old-style parameter declarations in prototyped function definition
  190 | __nfsd_version_set_req_set_version(struct nfsd_version_set_req *req,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
netdev-user.h:569:14: note: each undeclared identifier is reported only once for each function it appears in
nfsd-user.h:196:14: error: â€˜iâ€™ undeclared (first use in this function)
  196 |         for (i = 0; i < req->n_version; i++)
      |              ^
nfsd-user.h:196:14: note: each undeclared identifier is reported only once for each function it appears in
nfsd-user.h: In function â€˜__nfsd_listener_set_req_set_addrâ€™:
nfsd-user.h:237:1: error: old-style parameter declarations in prototyped function definition
  237 | __nfsd_listener_set_req_set_addr(struct nfsd_listener_set_req *req,
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nfsd-user.h:242:14: error: â€˜iâ€™ undeclared (first use in this function)
  242 |         for (i = 0; i < req->n_addr; i++)
      |              ^
make[1]: *** [Makefile:53: nfsd-user.o] Error 1
make[1]: *** [Makefile:53: netdev-user.o] Error 1
	AR ynl.a
make: *** [Makefile:25: generated] Error 2
"""

Full log:
https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/fedora-rc/fedora-42-x86_64/08955628-stablerc-fedorarc-releases/builder-live.log.gz

Ciao, Thorsten
 
> Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
> Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Link: https://patch.msgid.link/20250414211851.602096-4-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/net/ynl/pyynl/ynl_gen_c.py | 62 +++++++++++++++++++++++---------
>  1 file changed, 45 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/net/ynl/pyynl/ynl_gen_c.py b/tools/net/ynl/pyynl/ynl_gen_c.py
> index c2eabc90dce8c..9c9a62a93afe7 100755
> --- a/tools/net/ynl/pyynl/ynl_gen_c.py
> +++ b/tools/net/ynl/pyynl/ynl_gen_c.py
> @@ -157,9 +157,15 @@ class Type(SpecAttr):
>      def free_needs_iter(self):
>          return False
>  
> -    def free(self, ri, var, ref):
> +    def _free_lines(self, ri, var, ref):
>          if self.is_multi_val() or self.presence_type() == 'len':
> -            ri.cw.p(f'free({var}->{ref}{self.c_name});')
> +            return [f'free({var}->{ref}{self.c_name});']
> +        return []
> +
> +    def free(self, ri, var, ref):
> +        lines = self._free_lines(ri, var, ref)
> +        for line in lines:
> +            ri.cw.p(line)
>  
>      def arg_member(self, ri):
>          member = self._complex_member_type(ri)
> @@ -258,6 +264,10 @@ class Type(SpecAttr):
>          var = "req"
>          member = f"{var}->{'.'.join(ref)}"
>  
> +        local_vars = []
> +        if self.free_needs_iter():
> +            local_vars += ['unsigned int i;']
> +
>          code = []
>          presence = ''
>          for i in range(0, len(ref)):
> @@ -267,6 +277,10 @@ class Type(SpecAttr):
>              if i == len(ref) - 1 and self.presence_type() != 'bit':
>                  continue
>              code.append(presence + ' = 1;')
> +        ref_path = '.'.join(ref[:-1])
> +        if ref_path:
> +            ref_path += '.'
> +        code += self._free_lines(ri, var, ref_path)
>          code += self._setter_lines(ri, member, presence)
>  
>          func_name = f"{op_prefix(ri, direction, deref=deref)}_set_{'_'.join(ref)}"
> @@ -274,7 +288,8 @@ class Type(SpecAttr):
>          alloc = bool([x for x in code if 'alloc(' in x])
>          if free and not alloc:
>              func_name = '__' + func_name
> -        ri.cw.write_func('static inline void', func_name, body=code,
> +        ri.cw.write_func('static inline void', func_name, local_vars=local_vars,
> +                         body=code,
>                           args=[f'{type_name(ri, direction, deref=deref)} *{var}'] + self.arg_member(ri))
>  
>  
> @@ -477,8 +492,7 @@ class TypeString(Type):
>                 ['unsigned int len;']
>  
>      def _setter_lines(self, ri, member, presence):
> -        return [f"free({member});",
> -                f"{presence}_len = strlen({self.c_name});",
> +        return [f"{presence}_len = strlen({self.c_name});",
>                  f"{member} = malloc({presence}_len + 1);",
>                  f'memcpy({member}, {self.c_name}, {presence}_len);',
>                  f'{member}[{presence}_len] = 0;']
> @@ -531,8 +545,7 @@ class TypeBinary(Type):
>                 ['unsigned int len;']
>  
>      def _setter_lines(self, ri, member, presence):
> -        return [f"free({member});",
> -                f"{presence}_len = len;",
> +        return [f"{presence}_len = len;",
>                  f"{member} = malloc({presence}_len);",
>                  f'memcpy({member}, {self.c_name}, {presence}_len);']
>  
> @@ -569,12 +582,14 @@ class TypeNest(Type):
>      def _complex_member_type(self, ri):
>          return self.nested_struct_type
>  
> -    def free(self, ri, var, ref):
> +    def _free_lines(self, ri, var, ref):
> +        lines = []
>          at = '&'
>          if self.is_recursive_for_op(ri):
>              at = ''
> -            ri.cw.p(f'if ({var}->{ref}{self.c_name})')
> -        ri.cw.p(f'{self.nested_render_name}_free({at}{var}->{ref}{self.c_name});')
> +            lines += [f'if ({var}->{ref}{self.c_name})']
> +        lines += [f'{self.nested_render_name}_free({at}{var}->{ref}{self.c_name});']
> +        return lines
>  
>      def _attr_typol(self):
>          return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
> @@ -627,15 +642,19 @@ class TypeMultiAttr(Type):
>      def free_needs_iter(self):
>          return 'type' not in self.attr or self.attr['type'] == 'nest'
>  
> -    def free(self, ri, var, ref):
> +    def _free_lines(self, ri, var, ref):
> +        lines = []
>          if self.attr['type'] in scalars:
> -            ri.cw.p(f"free({var}->{ref}{self.c_name});")
> +            lines += [f"free({var}->{ref}{self.c_name});"]
>          elif 'type' not in self.attr or self.attr['type'] == 'nest':
> -            ri.cw.p(f"for (i = 0; i < {var}->{ref}n_{self.c_name}; i++)")
> -            ri.cw.p(f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name}[i]);')
> -            ri.cw.p(f"free({var}->{ref}{self.c_name});")
> +            lines += [
> +                f"for (i = 0; i < {var}->{ref}n_{self.c_name}; i++)",
> +                f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name}[i]);',
> +                f"free({var}->{ref}{self.c_name});",
> +            ]
>          else:
>              raise Exception(f"Free of MultiAttr sub-type {self.attr['type']} not supported yet")
> +        return lines
>  
>      def _attr_policy(self, policy):
>          return self.base_type._attr_policy(policy)
> @@ -661,8 +680,7 @@ class TypeMultiAttr(Type):
>      def _setter_lines(self, ri, member, presence):
>          # For multi-attr we have a count, not presence, hack up the presence
>          presence = presence[:-(len('_present.') + len(self.c_name))] + "n_" + self.c_name
> -        return [f"free({member});",
> -                f"{member} = {self.c_name};",
> +        return [f"{member} = {self.c_name};",
>                  f"{presence} = n_{self.c_name};"]
>  
>  
> @@ -747,6 +765,7 @@ class Struct:
>          self.request = False
>          self.reply = False
>          self.recursive = False
> +        self.in_multi_val = False  # used by a MultiAttr or and legacy arrays
>  
>          self.attr_list = []
>          self.attrs = dict()
> @@ -1114,6 +1133,10 @@ class Family(SpecFamily):
>                      if attr in rs_members['reply']:
>                          self.pure_nested_structs[nested].reply = True
>  
> +                if spec.is_multi_val():
> +                    child = self.pure_nested_structs.get(nested)
> +                    child.in_multi_val = True
> +
>          self._sort_pure_types()
>  
>          # Propagate the request / reply / recursive
> @@ -1128,6 +1151,8 @@ class Family(SpecFamily):
>                              struct.child_nests.update(child.child_nests)
>                          child.request |= struct.request
>                          child.reply |= struct.reply
> +                        if spec.is_multi_val():
> +                            child.in_multi_val = True
>                  if attr_set in struct.child_nests:
>                      struct.recursive = True
>  
> @@ -2921,6 +2946,9 @@ def main():
>              for attr_set, struct in parsed.pure_nested_structs.items():
>                  ri = RenderInfo(cw, parsed, args.mode, "", "", attr_set)
>                  print_type_full(ri, struct)
> +                if struct.request and struct.in_multi_val:
> +                    free_rsp_nested_prototype(ri)
> +                    cw.nl()
>  
>              for op_name, op in parsed.ops.items():
>                  cw.p(f"/* ============== {op.enum_name} ============== */")

