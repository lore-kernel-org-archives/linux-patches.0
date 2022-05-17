Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797137A
	for <patches@lists.linux.dev>; Tue, 17 May 2022 19:29:53 +0000 (UTC)
Received: from localhost (unknown [IPv6:2601:281:8300:3d::5f6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id D3F1077D;
	Tue, 17 May 2022 19:29:52 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net D3F1077D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1652815793; bh=OBzRUCW8ddO4NPOBKcocR9YkpBA9oZ1Is7paLy2cbE8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UA/faQw42VSKim4c6CiTATiJ4mLFwO8FFOjo9lpkXjzGizMx0L9twn6wjHUkwKtdl
	 POGxT7AXpxjXuKxsUw8n3aIOwrToilcLJf0wkSReaf5pSM7gGhcBewozETHAcbAF+w
	 gyO1RXYrcxqRnt7j0KfFAfgF2MNj4OZvmZ9yq30aKfpcQ0DRH7z0zpU4hO+gYM96Zt
	 tdzqy1av8SJaBHwCsvJaY20PPFp5CHJCGWy7r77gQj1rhBT+TcyxQEvUySGjX1xgfi
	 QpWI0tB7LAQSF/wZaqpqoL7cbX7SsRBLL06Gfa+UMfKrwh94/vezwOLA4TgUMTFxGQ
	 xEWC6ZeUNXttg==
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, Dmitry
 Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: Docs: correct ntrig.rst typo
In-Reply-To: <20220516002047.11395-1-rdunlap@infradead.org>
References: <20220516002047.11395-1-rdunlap@infradead.org>
Date: Tue, 17 May 2022 13:29:52 -0600
Message-ID: <87tu9oufdb.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Randy Dunlap <rdunlap@infradead.org> writes:

> Fix a typo in ntrig.rst (found with 'codespell').
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> ---
>  Documentation/input/devices/ntrig.rst |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/Documentation/input/devices/ntrig.rst
> +++ b/Documentation/input/devices/ntrig.rst
> @@ -32,7 +32,7 @@ The following parameters are used to con
>  |activation_height,	|size threshold to activate immediately		      |
>  |activation_width	|						      |
>  +-----------------------+-----------------------------------------------------+
> -|min_height,		|size threshold bellow which fingers are ignored      |
> +|min_height,		|size threshold below which fingers are ignored       |
>  |min_width		|both to decide activation and during activity	      |
>  +-----------------------+-----------------------------------------------------+

Applied, thanks.

jon
