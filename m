Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40592ED0
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 07:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0N+SCtcY/k9CimqgVMe/YX4md4YEbNQzEDvTCcqt4bw=; b=TbHcAKwtP7qVQnyr4M3BCyYIa9
	/0zMoVu1Ym18t94ZPKH+tFOvb05xiFTdpVwC6jwn/i8aWIfnathj3m2nd+Fz/WuY6K+sj1gnbIrJw
	PLDE5rtBFWDjO8xqpWgtSV+v7c/cZooSVNk+OWZnYWUfuOpDR7H3LV29R6TOwEN1+8fpgTxENcRrN
	Vk5E2dz3TZTGLbzB/xxNiLvMzRNND6Xb1fYjLRDR9K5vOZvqInK/MTtgg8RzRwvLq61MMSRU8Kksp
	qm2jVnkmnbSN62TJt7mvrf5Uw2cddBqIVlrEL4EqgGEdcmBpFlQAduFI+Hsk2g1cx0r2tLMgsSepe
	DNHJzz+A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paWkT-00DKkw-B4; Fri, 10 Mar 2023 07:01:05 +0000
Date: Thu, 9 Mar 2023 23:01:05 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
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
Message-ID: <ZArVscnCxYfZXwLR@bombadil.infradead.org>
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-12-mcgrof@kernel.org>
 <ZAqvQ57PmdDoNo+F@sol.localdomain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAqvQ57PmdDoNo+F@sol.localdomain>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Mar 09, 2023 at 08:17:07PM -0800, Eric Biggers wrote:
> On Thu, Mar 02, 2023 at 12:28:26PM -0800, Luis Chamberlain wrote:
> > diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> > index 780690dc08cd..e8459fc56b50 100644
> > --- a/include/linux/sysctl.h
> > +++ b/include/linux/sysctl.h
> > @@ -221,13 +221,8 @@ extern void retire_sysctl_set(struct ctl_table_set *set);
> >  struct ctl_table_header *__register_sysctl_table(
> >  	struct ctl_table_set *set,
> >  	const char *path, struct ctl_table *table);
> > -struct ctl_table_header *__register_sysctl_paths(
> > -	struct ctl_table_set *set,
> > -	const struct ctl_path *path, struct ctl_table *table);
> >  struct ctl_table_header *register_sysctl(const char *path, struct ctl_table *table);
> >  struct ctl_table_header *register_sysctl_table(struct ctl_table * table);
> > -struct ctl_table_header *register_sysctl_paths(const struct ctl_path *path,
> > -						struct ctl_table *table);
> >  
> >  void unregister_sysctl_table(struct ctl_table_header * table);
> >  
> > @@ -277,12 +272,6 @@ static inline struct ctl_table_header *register_sysctl_mount_point(const char *p
> >  	return NULL;
> >  }
> >  
> > -static inline struct ctl_table_header *register_sysctl_paths(
> > -			const struct ctl_path *path, struct ctl_table *table)
> > -{
> > -	return NULL;
> > -}
> > -
> 
> Seems that this patch should be titled "remove register_sysctl_paths()", not
> "deprecate register_sysctl_paths()"?

Good call! Will adjust.

  Luis
