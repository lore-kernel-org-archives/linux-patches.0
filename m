Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCA82209B
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723048701; cv=none; b=LXdjlaOB0D0lSBlramZS6HO9a0dhLeFyuEcwmYP1ub367f66r5ing5d3rTFqyNwMCGK53ERUKDgJQOcGMGI9LaDsupVhBb6oqVEJAJGj88bsSGFcm3+hsRbsqC6xwyjgCp7DtiAD3r9bb57WTEmGYZgGU03Ih10tUV2cQyvOwss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723048701; c=relaxed/simple;
	bh=swXe+VWaAkni4Hx0T2da1vs9jbN54TFsI8Ydd4FkgFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAojiDBk0VyixpI4RMQwWRv7gd15AcTSUbxIGPstA9c8Dz4MaE4b0DnbXbkyyJtib2kjLoP81ldFPtKAKZIhu5oAK4tV24DJJFe6G/oWBPc/p2AfYn/68dT5sJo3mq4rGi+sCWaGSxNQ/wqlBcV484FDDjx/p3lXR8KhfWURxoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=CmbFhUFN; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="CmbFhUFN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1723048693;
	bh=swXe+VWaAkni4Hx0T2da1vs9jbN54TFsI8Ydd4FkgFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CmbFhUFNeIm0z+ciBCp4l8554iUhkUGfHEz7XYaAxc5jQl3Ruix7pGpezPAOSrpGO
	 oE/pJD3Y+nIGcFsW2i8adcZPi4CYWj5xDG18yaMqoun8bM6WqqHjSYQ2vdZoDLdlNa
	 J6gs6L67/fBaKxcdxZzYNHkzCxxT8D15+j1we7mc=
Date: Wed, 7 Aug 2024 18:38:13 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Joel Granados <j.granados@samsung.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 015/121] sysctl: treewide: drop unused argument
 ctl_table_root::set_ownership(table)
Message-ID: <0352ae40-ba3e-4d27-84c6-19926a787c33@t-8ch.de>
References: <20240807150019.412911622@linuxfoundation.org>
 <20240807150019.868023928@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240807150019.868023928@linuxfoundation.org>

Hi Greg,

On 2024-08-07 16:59:07+0000, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.

I don't think this has any value being backported to any version.

> 
> ------------------
> 
> From: Thomas Weißschuh <linux@weissschuh.net>
> 
> [ Upstream commit 520713a93d550406dae14d49cdb8778d70cecdfd ]
> 
> Remove the 'table' argument from set_ownership as it is never used. This
> change is a step towards putting "struct ctl_table" into .rodata and
> eventually having sysctl core only use "const struct ctl_table".
> 
> The patch was created with the following coccinelle script:
> 
>   @@
>   identifier func, head, table, uid, gid;
>   @@
> 
>   void func(
>     struct ctl_table_header *head,
>   - struct ctl_table *table,
>     kuid_t *uid, kgid_t *gid)
>   { ... }
> 
> No additional occurrences of 'set_ownership' were found after doing a
> tree-wide search.
> 
> Reviewed-by: Joel Granados <j.granados@samsung.com>
> Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> Signed-off-by: Joel Granados <j.granados@samsung.com>
> Stable-dep-of: 98ca62ba9e2b ("sysctl: always initialize i_uid/i_gid")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/proc/proc_sysctl.c  | 2 +-
>  include/linux/sysctl.h | 1 -
>  ipc/ipc_sysctl.c       | 3 +--
>  ipc/mq_sysctl.c        | 3 +--
>  net/sysctl_net.c       | 1 -
>  5 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 5b5cdc747cef3..cec67e6a6678f 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -481,7 +481,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  	}
>  
>  	if (root->set_ownership)
> -		root->set_ownership(head, table, &inode->i_uid, &inode->i_gid);
> +		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
>  	else {
>  		inode->i_uid = GLOBAL_ROOT_UID;
>  		inode->i_gid = GLOBAL_ROOT_GID;
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 61b40ea81f4d3..698a71422a14b 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -205,7 +205,6 @@ struct ctl_table_root {
>  	struct ctl_table_set default_set;
>  	struct ctl_table_set *(*lookup)(struct ctl_table_root *root);
>  	void (*set_ownership)(struct ctl_table_header *head,
> -			      struct ctl_table *table,
>  			      kuid_t *uid, kgid_t *gid);
>  	int (*permissions)(struct ctl_table_header *head, struct ctl_table *table);
>  };
> diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
> index 01c4a50d22b2d..b2f39a86f4734 100644
> --- a/ipc/ipc_sysctl.c
> +++ b/ipc/ipc_sysctl.c
> @@ -192,7 +192,6 @@ static int set_is_seen(struct ctl_table_set *set)
>  }
>  
>  static void ipc_set_ownership(struct ctl_table_header *head,
> -			      struct ctl_table *table,
>  			      kuid_t *uid, kgid_t *gid)
>  {
>  	struct ipc_namespace *ns =
> @@ -224,7 +223,7 @@ static int ipc_permissions(struct ctl_table_header *head, struct ctl_table *tabl
>  		kuid_t ns_root_uid;
>  		kgid_t ns_root_gid;
>  
> -		ipc_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
> +		ipc_set_ownership(head, &ns_root_uid, &ns_root_gid);
>  
>  		if (uid_eq(current_euid(), ns_root_uid))
>  			mode >>= 6;
> diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
> index 21fba3a6edaf7..6bb1c5397c69b 100644
> --- a/ipc/mq_sysctl.c
> +++ b/ipc/mq_sysctl.c
> @@ -78,7 +78,6 @@ static int set_is_seen(struct ctl_table_set *set)
>  }
>  
>  static void mq_set_ownership(struct ctl_table_header *head,
> -			     struct ctl_table *table,
>  			     kuid_t *uid, kgid_t *gid)
>  {
>  	struct ipc_namespace *ns =
> @@ -97,7 +96,7 @@ static int mq_permissions(struct ctl_table_header *head, struct ctl_table *table
>  	kuid_t ns_root_uid;
>  	kgid_t ns_root_gid;
>  
> -	mq_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
> +	mq_set_ownership(head, &ns_root_uid, &ns_root_gid);
>  
>  	if (uid_eq(current_euid(), ns_root_uid))
>  		mode >>= 6;
> diff --git a/net/sysctl_net.c b/net/sysctl_net.c
> index 051ed5f6fc937..a0a7a79991f9f 100644
> --- a/net/sysctl_net.c
> +++ b/net/sysctl_net.c
> @@ -54,7 +54,6 @@ static int net_ctl_permissions(struct ctl_table_header *head,
>  }
>  
>  static void net_ctl_set_ownership(struct ctl_table_header *head,
> -				  struct ctl_table *table,
>  				  kuid_t *uid, kgid_t *gid)
>  {
>  	struct net *net = container_of(head->set, struct net, sysctls);
> -- 
> 2.43.0
> 
> 
> 
