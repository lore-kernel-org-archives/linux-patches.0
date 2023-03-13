Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501F023C5
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F0BC433D2;
	Mon, 13 Mar 2023 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678706413;
	bh=ISe5UVZfG0kk7GI8PLSL2i+qiFvy8AcPIus/O+t/3OM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qTozJycmwfU0NrgRVFw0XTG2UAdZmPJAlAeLL4lMCMnKEIWRByxCrUzxKKMMLc2Yl
	 lcG5YOzkBKX0lOxW1Egdlnw3euXEyV2cSZBteox5J9JGwd6lCITjRt0UhXYUc4wDLP
	 otkj8R+uA7zKywNGTTsu5jnAG3PEwwHFoO1wWIjKTiBc1+BBSXm61mUwXczCZascUJ
	 oKTs17bd9xLqqFldyOYVsvg9uvfVpktxsEAyqN2IyTddIE0hn1/Ya1qIKQANSAeVff
	 V4DCQ8CEiuihLvqnYk4W87POoap/ADfBT4zhyz4Jgkb2rs1yqzr6jcwEHXE+vu98BL
	 0dg/iHwI4uIcg==
Date: Mon, 13 Mar 2023 12:20:06 +0100
From: Christian Brauner <brauner@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: pvorel@suse.cz, akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, Jason@zx2c4.com, ebiederm@xmission.com,
	yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsname: simplify one-level sysctl registration for
 uts_kern_table
Message-ID: <20230313112006.m5vmtzbepo6lcoj5@wittgenstein>
References: <20230310231656.3955051-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230310231656.3955051-1-mcgrof@kernel.org>

On Fri, Mar 10, 2023 at 03:16:56PM -0800, Luis Chamberlain wrote:
> There is no need to declare an extra tables to just create directory,
> this can be easily be done with a prefix path with register_sysctl().
> 
> Simplify this registration.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

Looks good,
Reviewed-by: Christian Brauner <brauner@kernel.org>
