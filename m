Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE337B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 04:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F90C433EF;
	Fri, 10 Mar 2023 04:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678421830;
	bh=seNWL7u3NKJQuYerhpmVKbx/SYPqLN+Awp5eCMPqhCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tva8kSXk6mrM9aI8iXzURZS3gHSWJyE2ILXyBLY0mJR7Q/KH+0sdVu4D3Kn1opurB
	 /DkbJ2Jz9k9rXU8Y9TRnbCJp3XIWhqDnFJrj/ec5RUVyinG0RmFVkzrIeGNGuZ/0i7
	 JVLXsafln288RsmCZHiQPKnxRK/OmCBhVLVjdjeSp9YrBDmI5DYePO4FGmGs/iVjOi
	 6DrTn60g9pJGt2q9BpdqEvDZ6E8AK9FF0OWpA5PLQc9hoYySlFHi4gIUE2EkjJhC6j
	 pJlcKIEUzBYrmB7hu/sTAUcPtxDHv0dTkrP9cxd6C3wLduRVFbGOQA7xVDsMAugCfa
	 /YZy3IxDDInKw==
Date: Thu, 9 Mar 2023 20:17:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	john.johansen@canonical.com, paul@paul-moore.com, jmorris@namei.org,
	serge@hallyn.com, luto@amacapital.net, wad@chromium.org,
	dverkamp@chromium.org, paulmck@kernel.org, baihaowen@meizu.com,
	frederic@kernel.org, jeffxu@google.com, tytso@mit.edu,
	guoren@kernel.org, j.granados@samsung.com, zhangpeng362@huawei.com,
	tangmeng@uniontech.com, willy@infradead.org, nixiaoming@huawei.com,
	sujiaxun@uniontech.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] proc_sysctl: deprecate register_sysctl_paths()
Message-ID: <ZAqvQ57PmdDoNo+F@sol.localdomain>
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-12-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302202826.776286-12-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 12:28:26PM -0800, Luis Chamberlain wrote:
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index 780690dc08cd..e8459fc56b50 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -221,13 +221,8 @@ extern void retire_sysctl_set(struct ctl_table_set *set);
>  struct ctl_table_header *__register_sysctl_table(
>  	struct ctl_table_set *set,
>  	const char *path, struct ctl_table *table);
> -struct ctl_table_header *__register_sysctl_paths(
> -	struct ctl_table_set *set,
> -	const struct ctl_path *path, struct ctl_table *table);
>  struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *table);
>  struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
> -struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
> -						struct ctl_table *table);
>  
>  void unregister_sysctl_table(struct ctl_table_header * table);
>  
> @@ -277,12 +272,6 @@ static inline struct ctl_table_header *register_sysctl_mount_point(const char *p
>  	return NULL;
>  }
>  
> -static inline struct ctl_table_header *register_sysctl_paths(
> -			const struct ctl_path *path, struct ctl_table *table)
> -{
> -	return NULL;
> -}
> -

Seems that this patch should be titled "remove register_sysctl_paths()", not
"deprecate register_sysctl_paths()"?

- Eric
