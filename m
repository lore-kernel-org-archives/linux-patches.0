Received: from chinatelecom.cn (smtpnm6-10.21cn.com [182.42.147.92])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBDD53370
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 10:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=182.42.147.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719312854; cv=none; b=Wau0T0WW+Yy+Hu7+kb2k3Xi04JCUNOOqzuLYyNivViW/B1imRhzIlF+9zU22FYiT7slBkG1c0FLCEYOS3oTLK9y1a25WXwEQLtgwGjN/w5WmsWIkwaOTopCdOcnCftTwHIxj9m1HqyWfW4dlCT0FN78kvyutZ3QTV7q1QjI/Iwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719312854; c=relaxed/simple;
	bh=0W0oaac1lehuqW0BSrTGA9+rqskyCsLVZ4Rp+TjGceM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I0elXrYxz0aCUPsltnwWT3fJJA0ILBvU2bTM7f5To4G9jCNcRNyowRPlVAUl2ktgUaBSNr1s6eTClRGo0rXkmYMgXaVroQGcOenbsBuYd9SJRDHzJ3UaK63rRBVxIZxFXwiJp/EEwyAnmCCFP+bJIWxc2D0RTqTdaGxZ0/iKPQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn; spf=pass smtp.mailfrom=chinatelecom.cn; arc=none smtp.client-ip=182.42.147.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chinatelecom.cn
HMM_SOURCE_IP:192.168.139.44:0.209578302
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-27.148.194.72 (unknown [192.168.139.44])
	by chinatelecom.cn (HERMES) with SMTP id 99E8FB01197B;
	Tue, 25 Jun 2024 18:46:15 +0800 (CST)
X-189-SAVE-TO-SEND: wujianguo@chinatelecom.cn
Received: from  ([27.148.194.72])
	by gateway-ssl-dep-67bdc54df-cz88j with ESMTP id 996471b79f0c4df6922bece6dea9543d for gregkh@linuxfoundation.org;
	Tue, 25 Jun 2024 18:46:22 CST
X-Transaction-ID: 996471b79f0c4df6922bece6dea9543d
X-Real-From: wujianguo@chinatelecom.cn
X-Receive-IP: 27.148.194.72
X-MEDUSA-Status: 0
Sender: wujianguo@chinatelecom.cn
Message-ID: <740d9249-534a-477c-9740-1e4c3a099d51@chinatelecom.cn>
Date: Tue, 25 Jun 2024 18:46:14 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Ctyun AOneMail
Subject: Re: [PATCH 6.6 100/192] netfilter: move the sysctl nf_hooks_lwtunnel
 into the netfilter core
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
 Sasha Levin <sashal@kernel.org>
References: <20240625085537.150087723@linuxfoundation.org>
 <2935400.2255.1719311647175.JavaMail.root@jt-retransmission-dep-5ccd6997dd-985ss>
From: wujianguo <wujianguo@chinatelecom.cn>
In-Reply-To: <2935400.2255.1719311647175.JavaMail.root@jt-retransmission-dep-5ccd6997dd-985ss>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,


This commit causes a compilation error when CONFIG_SYSFS is not enabled 
in config

I have sent a fix patch: https://lkml.org/lkml/2024/6/21/123



在 2024/6/25 17:32, Greg Kroah-Hartman 写道:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
>
> [ Upstream commit a2225e0250c5fa397dcebf6ce65a9f05a114e0cf ]
>
> Currently, the sysctl net.netfilter.nf_hooks_lwtunnel depends on the
> nf_conntrack module, but the nf_conntrack module is not always loaded.
> Therefore, accessing net.netfilter.nf_hooks_lwtunnel may have an error.
>
> Move sysctl nf_hooks_lwtunnel into the netfilter core.
>
> Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   include/net/netns/netfilter.h           |    3 +
>   net/netfilter/core.c                    |   13 +++++-
>   net/netfilter/nf_conntrack_standalone.c |   15 -------
>   net/netfilter/nf_hooks_lwtunnel.c       |   67 ++++++++++++++++++++++++++++++++
>   net/netfilter/nf_internals.h            |    6 ++
>   5 files changed, 87 insertions(+), 17 deletions(-)
>
> --- a/include/net/netns/netfilter.h
> +++ b/include/net/netns/netfilter.h
> @@ -15,6 +15,9 @@ struct netns_nf {
>   	const struct nf_logger __rcu *nf_loggers[NFPROTO_NUMPROTO];
>   #ifdef CONFIG_SYSCTL
>   	struct ctl_table_header *nf_log_dir_header;
> +#ifdef CONFIG_LWTUNNEL
> +	struct ctl_table_header *nf_lwtnl_dir_header;
> +#endif
>   #endif
>   	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
>   	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -815,12 +815,21 @@ int __init netfilter_init(void)
>   	if (ret < 0)
>   		goto err;
>   
> +#ifdef CONFIG_LWTUNNEL
> +	ret = netfilter_lwtunnel_init();
> +	if (ret < 0)
> +		goto err_lwtunnel_pernet;
> +#endif
>   	ret = netfilter_log_init();
>   	if (ret < 0)
> -		goto err_pernet;
> +		goto err_log_pernet;
>   
>   	return 0;
> -err_pernet:
> +err_log_pernet:
> +#ifdef CONFIG_LWTUNNEL
> +	netfilter_lwtunnel_fini();
> +err_lwtunnel_pernet:
> +#endif
>   	unregister_pernet_subsys(&netfilter_net_ops);
>   err:
>   	return ret;
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -22,9 +22,6 @@
>   #include <net/netfilter/nf_conntrack_acct.h>
>   #include <net/netfilter/nf_conntrack_zones.h>
>   #include <net/netfilter/nf_conntrack_timestamp.h>
> -#ifdef CONFIG_LWTUNNEL
> -#include <net/netfilter/nf_hooks_lwtunnel.h>
> -#endif
>   #include <linux/rculist_nulls.h>
>   
>   static bool enable_hooks __read_mostly;
> @@ -612,9 +609,6 @@ enum nf_ct_sysctl_index {
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE,
>   	NF_SYSCTL_CT_PROTO_TIMEOUT_GRE_STREAM,
>   #endif
> -#ifdef CONFIG_LWTUNNEL
> -	NF_SYSCTL_CT_LWTUNNEL,
> -#endif
>   
>   	__NF_SYSCTL_CT_LAST_SYSCTL,
>   };
> @@ -948,15 +942,6 @@ static struct ctl_table nf_ct_sysctl_tab
>   		.proc_handler   = proc_dointvec_jiffies,
>   	},
>   #endif
> -#ifdef CONFIG_LWTUNNEL
> -	[NF_SYSCTL_CT_LWTUNNEL] = {
> -		.procname	= "nf_hooks_lwtunnel",
> -		.data		= NULL,
> -		.maxlen		= sizeof(int),
> -		.mode		= 0644,
> -		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
> -	},
> -#endif
>   	{}
>   };
>   
> --- a/net/netfilter/nf_hooks_lwtunnel.c
> +++ b/net/netfilter/nf_hooks_lwtunnel.c
> @@ -3,6 +3,9 @@
>   #include <linux/sysctl.h>
>   #include <net/lwtunnel.h>
>   #include <net/netfilter/nf_hooks_lwtunnel.h>
> +#include <linux/netfilter.h>
> +
> +#include "nf_internals.h"
>   
>   static inline int nf_hooks_lwtunnel_get(void)
>   {
> @@ -50,4 +53,68 @@ int nf_hooks_lwtunnel_sysctl_handler(str
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(nf_hooks_lwtunnel_sysctl_handler);
> +
> +static struct ctl_table nf_lwtunnel_sysctl_table[] = {
> +	{
> +		.procname	= "nf_hooks_lwtunnel",
> +		.data		= NULL,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= nf_hooks_lwtunnel_sysctl_handler,
> +	},
> +};
> +
> +static int __net_init nf_lwtunnel_net_init(struct net *net)
> +{
> +	struct ctl_table_header *hdr;
> +	struct ctl_table *table;
> +
> +	table = nf_lwtunnel_sysctl_table;
> +	if (!net_eq(net, &init_net)) {
> +		table = kmemdup(nf_lwtunnel_sysctl_table,
> +				sizeof(nf_lwtunnel_sysctl_table),
> +				GFP_KERNEL);
> +		if (!table)
> +			goto err_alloc;
> +	}
> +
> +	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
> +				     ARRAY_SIZE(nf_lwtunnel_sysctl_table));
> +	if (!hdr)
> +		goto err_reg;
> +
> +	net->nf.nf_lwtnl_dir_header = hdr;
> +
> +	return 0;
> +err_reg:
> +	if (!net_eq(net, &init_net))
> +		kfree(table);
> +err_alloc:
> +	return -ENOMEM;
> +}
> +
> +static void __net_exit nf_lwtunnel_net_exit(struct net *net)
> +{
> +	const struct ctl_table *table;
> +
> +	table = net->nf.nf_lwtnl_dir_header->ctl_table_arg;
> +	unregister_net_sysctl_table(net->nf.nf_lwtnl_dir_header);
> +	if (!net_eq(net, &init_net))
> +		kfree(table);
> +}
> +
> +static struct pernet_operations nf_lwtunnel_net_ops = {
> +	.init = nf_lwtunnel_net_init,
> +	.exit = nf_lwtunnel_net_exit,
> +};
> +
> +int __init netfilter_lwtunnel_init(void)
> +{
> +	return register_pernet_subsys(&nf_lwtunnel_net_ops);
> +}
> +
> +void netfilter_lwtunnel_fini(void)
> +{
> +	unregister_pernet_subsys(&nf_lwtunnel_net_ops);
> +}
>   #endif /* CONFIG_SYSCTL */
> --- a/net/netfilter/nf_internals.h
> +++ b/net/netfilter/nf_internals.h
> @@ -29,6 +29,12 @@ void nf_queue_nf_hook_drop(struct net *n
>   /* nf_log.c */
>   int __init netfilter_log_init(void);
>   
> +#ifdef CONFIG_LWTUNNEL
> +/* nf_hooks_lwtunnel.c */
> +int __init netfilter_lwtunnel_init(void);
> +void netfilter_lwtunnel_fini(void);
> +#endif
> +
>   /* core.c */
>   void nf_hook_entries_delete_raw(struct nf_hook_entries __rcu **pp,
>   				const struct nf_hook_ops *reg);
>
>
>
