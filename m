Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EFD7C
	for <patches@lists.linux.dev>; Mon, 13 Jun 2022 19:28:47 +0000 (UTC)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 8A13A381;
	Mon, 13 Jun 2022 19:23:35 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 8A13A381
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1655148215; bh=rBY3N4QR1n3+5OXPHvfMtmdiaKqHzqM5y8hE07IM9iw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=C7OkFKVk1mHRlS5iqhKWKF6fHxsKpj9RLS+0EaxvpU0ML79br35AoIicKUVbfBfNL
	 R3ZhAskiHH26CYBN7gWUuZvf2WBx3/oJ2DIRMyBHrGpodXxC2GXRGvb16MRwP5EO11
	 iynQRrOOF03V1C9boXdc8ubfmOyqW8q1jyXTt5gNUhc4Edws5fWH0HJoqowuVrgPmM
	 jjwA8/aMQLes89AdXqvmu1XgHciYoIRSyww58BcHjOgcFDpCj9dr3nkpt7YgAEeoUk
	 zC/nL5/GYrCeZwygr7lRzgEfSX0SyT0pLeDcegZLgKLI9y6CCYeaq1jautiQqGv6nV
	 dFKgR8lC+TAzA==
From: Jonathan Corbet <corbet@lwn.net>
To: Paul Moore <paul@paul-moore.com>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, patches@lists.linux.dev, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Eric Paris <eparis@parisplace.org>,
 selinux@vger.kernel.org
Subject: Re: [PATCH] docs: selinux: add '=' signs to kernel boot options
In-Reply-To: <CAHC9VhSa74OFVV=XcceO12kVOxivm5cnyvBo-yeMbyPT8+t5Kg@mail.gmail.com>
References: <20220301041454.18960-1-rdunlap@infradead.org>
 <CAHC9VhSuzpuEm437SCYC8pf0mU6qdWXRU38sb2+JjVtj-8T4Kw@mail.gmail.com>
 <CAHC9VhSa74OFVV=XcceO12kVOxivm5cnyvBo-yeMbyPT8+t5Kg@mail.gmail.com>
Date: Mon, 13 Jun 2022 13:23:34 -0600
Message-ID: <87mtegz7t5.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Paul Moore <paul@paul-moore.com> writes:

> I assumed the doc folks would have picked this up but I don't see it
> in the tree so I'm going to pull it into the selinux/next tree right
> now.  Thanks again Randy, I'm sorry for the delay.

Sorry, the "doc folks" have learned that, in general, folks in the
security subsystems prefer to carry their own patches upward, so I
assumed this one was taken care of.  If you'd rather I picked up SELinux
documentation patches, I'd be glad to do so.

Thanks,

jon
