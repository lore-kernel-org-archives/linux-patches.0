Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1C7BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29617C433D2;
	Tue,  7 Mar 2023 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678218477;
	bh=/1zAIbTQcsRF2izXv8x+EJJixmh8dm5+NhK5ibW2Rsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AyyYAwqUTTOk9EKiTutS5g25pM/VHwE2Yo3m82FjZAEXqu/CleA62t3i3SG/UTcG8
	 cfH4mySgtTAl/FkN3gD0CJ7euNCSl9MX75AxDRKpva3vVaLJWbvyQOasMf1XPhtEse
	 iBPu1h6EuVXY5lSdO/v6rwRJyxtn75T589Un0p3nRcpQZTj4bzppHMLBRDyhPnoXuz
	 bHLOcMt+mmUsAQeljRkMmtZP9ekqGRdabMDAkS8V22Sb9MTBleK1hrduVVF14vWP/W
	 aM3Nzol2A4VsZbRWcmcKEm4dvZ7lbDMj/phDraV03qLey3PXcapCMK6yTL8Mqeg2US
	 bLMU3ZOVlo9ww==
Date: Tue, 7 Mar 2023 11:47:54 -0800
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
Subject: Re: [PATCH 09/11] fs-verity: simplify sysctls with register_sysctl()
Message-ID: <ZAeU6shP3vjBOqo7@sol.localdomain>
References: <20230302202826.776286-1-mcgrof@kernel.org>
 <20230302202826.776286-10-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302202826.776286-10-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 12:28:24PM -0800, Luis Chamberlain wrote:
> register_sysctl_paths() is only needed if your child (directories) have
> entries but this does not so just use register_sysctl() so to do away
> with the path specification.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  fs/verity/signature.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)

Applied to https://git.kernel.org/pub/scm/fs/fsverity/linux.git/log/?h=for-next  

- Eric
