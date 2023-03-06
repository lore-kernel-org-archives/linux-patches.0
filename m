Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A76A5665
	for <patches@lists.linux.dev>; Mon,  6 Mar 2023 17:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6F7C433EF;
	Mon,  6 Mar 2023 17:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678122327;
	bh=SzGuuldXDSypwzcSvDtfrNS0kCnjIS0XQ+ud/id4d/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d8/tBAoT+YYRwYkiVKxurweDU2/y9Fys1/QQX0dkcYyAzwunuAXlJF1wsm8jce4jm
	 mEijJxqfVNyWM/ttz7vCMqmrHdAI5fMGSukA533TxiDXOfQSmcIBOgKjjRdtS0McRa
	 YIrEnoaWjTKacUiPH3K4YXYH4Ws3FWj4dBZxCgTdr3O4wr2xkXHK+L7VWkqkZzCE06
	 Ntd/15wQF3h93Z/kg9qB+hQsZCfm8B69mihF9s8CvhXvNuWvOVBd1pOUMEfCtALbXz
	 F3lXLh3hUSdjyJ8LihTL0s/Uhna0SrLswNPUpERb4KteGHhWZVaOaxe9qnO+oPt2p0
	 2sTJ7cVtwQ98w==
Date: Mon, 6 Mar 2023 18:05:21 +0100
From: Christian Brauner <brauner@kernel.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, willy@infradead.org,
	linux-mm@kvack.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] shmem: update documentation
Message-ID: <20230306170521.fphuzhblaxjzs4r6@wittgenstein>
References: <20230302232758.888157-1-mcgrof@kernel.org>
 <20230302232758.888157-6-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230302232758.888157-6-mcgrof@kernel.org>

On Thu, Mar 02, 2023 at 03:27:57PM -0800, Luis Chamberlain wrote:
> Update the docs to reflect a bit better why some folks prefer tmpfs
> over ramfs and clarify a bit more about the difference between brd
> ramdisks.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

Looks good,
Reviewed-by: Christian Brauner <brauner@kernel.org>
