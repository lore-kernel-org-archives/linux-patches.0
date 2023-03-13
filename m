Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC2323C5
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 11:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75CFC433D2;
	Mon, 13 Mar 2023 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678707527;
	bh=S4n4HT8Q6zO639j2exjZJcPIuREtYf6PgD5AffBEIlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Um3qdroXjFHpiyQhRiNcTrUXv7rvkN6Ou67qFdpCTJnXhXZb3wS4ERHizHYzUrvLM
	 PeVS+ErAV+1KtlAIWkc8NufqPonC/8/71aO20hOKKKq3KBnBMaGsk5aeBVmzV6YLGd
	 ABvur/Pz+wEMNJ3oG+Vvp80eHnbT6Xq510ZkDoQ62Zm18ePgWcjdFu8ciNd8vYCLbW
	 cENVM108VmAX9oca9gFM8eJEZ0F8qNuWzYNO0FW7IzH0BtQh3bieAh/l/N3gaHPe6Q
	 1HEKwKGi5/ZTnu1Rfzjp0GktsFLSOO4wh3s5rP3YB5j9jiCbAnVd6HK5Qus7Fk4z+Z
	 ktmfotKa0W8bw==
Date: Mon, 13 Mar 2023 12:38:40 +0100
From: Christian Brauner <brauner@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com, jack@suse.com,
	jaharkes@cs.cmu.edu, coda@cs.cmu.edu, codalist@coda.cs.cmu.edu,
	anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
	ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] devpts: simplify two-level sysctl registration for
 pty_kern_table
Message-ID: <20230313113840.75eyj66ydgbvln6p@wittgenstein>
References: <20230310231206.3952808-1-mcgrof@kernel.org>
 <20230310231206.3952808-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230310231206.3952808-3-mcgrof@kernel.org>

On Fri, Mar 10, 2023 at 03:12:03PM -0800, Luis Chamberlain wrote:
> There is no need to declare two tables to just create directories,
> this can be easily be done with a prefix path with register_sysctl().
> 
> Simplify this registration.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

I can take this one, Luis. Thanks!
