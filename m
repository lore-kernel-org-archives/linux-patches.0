Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDBBD53B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:00:05 +0000 (UTC)
Received: from [192.168.192.83] (unknown [50.47.134.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 6E3503F123;
	Thu,  2 Mar 2023 22:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1677797507;
	bh=bioryjk+aw7umCRjJRv4QvVIBgleMXFeIjs93Jwz0DU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=Cj7XrX8b3UMGQ4YO23XrAP0FCwraXl+y1is+aXBHq4Yaq0NJ8Y8zOoX9mLwzMi+cA
	 W3HPuGOFaftga2KXhKyZ5/4wS3BJLQBJ5S66CQM0hrX5LMpBQztUXGj1ZJW8M57Tj9
	 E70gT7F19dTUoCRQak+Bmmjm6DiRshfhlHBeKvil8gT2zCWDPf/XMYo1iREmsccTjN
	 W73jiILx6RoqVEa9UN6TtrU3KE8vHdtwQu/Blp/WvArnFFzabJzHpde6FZkpMk6+tz
	 aA8hHzFDIvRxA5sc+RxL5w2jCZ/b5qSxjxwm4eMptgFrVN4BVZW/vH7z72DRLHmUiF
	 E9HGDOJeYK7xg==
Message-ID: <0767e9c6-b255-7c66-a75b-e3fc59f129f9@canonical.com>
Date: Thu, 2 Mar 2023 14:51:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 04/11] apparmor: simplify sysctls with
 register_sysctl_init()
Content-Language: en-US
To: Luis Chamberlain <mcgrof@kernel.org>, ebiederm@xmission.com,
 keescook@chromium.org, yzaikin@google.com, paul@paul-moore.com,
 jmorris@namei.org, serge@hallyn.com, luto@amacapital.net, wad@chromium.org,
 dverkamp@chromium.org, paulmck@kernel.org, baihaowen@meizu.com,
 frederic@kernel.org, jeffxu@google.com, ebiggers@kernel.org, tytso@mit.edu,
 guoren@kernel.org
Cc: j.granados@samsung.com, zhangpeng362@huawei.com, tangmeng@uniontech.com,
 willy@infradead.org, nixiaoming@huawei.com, sujiaxun@uniontech.com,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-5-mcgrof@kernel.org>
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
In-Reply-To: <20230302202826.776286-5-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/2/23 12:28, Luis Chamberlain wrote:
> Using register_sysctl_paths() is really only needed if you have
> subdirectories with entries. We can use the simple register_sysctl()
> instead.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>   security/apparmor/lsm.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index d6cc4812ca53..47c7ec7e5a80 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -1764,11 +1764,6 @@ static int apparmor_dointvec(struct ctl_table *table, int write,
>   	return proc_dointvec(table, write, buffer, lenp, ppos);
>   }
>   
> -static struct ctl_path apparmor_sysctl_path[] = {
> -	{ .procname = "kernel", },
> -	{ }
> -};
> -
>   static struct ctl_table apparmor_sysctl_table[] = {
>   	{
>   		.procname       = "unprivileged_userns_apparmor_policy",
> @@ -1790,8 +1785,7 @@ static struct ctl_table apparmor_sysctl_table[] = {
>   
>   static int __init apparmor_init_sysctl(void)
>   {
> -	return register_sysctl_paths(apparmor_sysctl_path,
> -				     apparmor_sysctl_table) ? 0 : -ENOMEM;
> +	return register_sysctl("kernel", apparmor_sysctl_table) ? 0 : -ENOMEM;
>   }
>   #else
>   static inline int apparmor_init_sysctl(void)

