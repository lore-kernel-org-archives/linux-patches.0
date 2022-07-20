Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D69D53A4
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4B1C3411E;
	Wed, 20 Jul 2022 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658326868;
	bh=98bDbkmxGmljYMNmP7yZenxlhYQOpClbVxoZVMGX7GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IWCDidbSKcRTPnUBRouuwwQFPhSebSeiJ5dd2IUnakSZgIzppDYhxHphFXyk6xSpe
	 om103v4/bPdin3d8mvO3g8Bh7b2nsyJW0sY4s06s42IgfDZUhpv9KGhQxkuLtvbL3J
	 dLEoV2dILJ74FbDeG+/4NQnHs1zbohRifAuwlIjoTopIGKRxdFDwufJfbUG+IO3H4L
	 aqQOqUs4tqHOTb8TE0R2pk2jB5YuE0/oJlggS/6XuVIyNnog/x4MK4HcFtTyFyT2K4
	 HHpi7nTxJi7d6AoQ5EGn+TcJfM5TMDFWuWHx3ppvcwDlyZFG4/wg1LsDD+gGSZFWpL
	 7fpWlgBipCxNg==
Date: Wed, 20 Jul 2022 10:21:06 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linux Patches <patches@lists.linux.dev>
Subject: Re: [PATCH v2 3/3] README: rename Linux to Kahlux
Message-ID: <20220720142106.y7vymmajp5wafic3@meerkat.local>
References: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
 <20220720-claim-for-kahless-v2-3-ddbde3dd27ea@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220720-claim-for-kahless-v2-3-ddbde3dd27ea@linuxfoundation.org>

On Wed, Jul 20, 2022 at 10:17:36AM -0400, Konstantin Ryabitsev wrote:
>The name speaks for itself!
>
>Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
>
>diff --git a/README b/README
>index 669ac7c32292..3a48a87cbc83 100644
>--- a/README
>+++ b/README
>@@ -1,5 +1,5 @@
>-Linux kernel
>-============
>+Kahlux kernel
>+=============
>
> There are several guides for kernel developers and users. These guides can
> be rendered in a number of formats, like HTML and PDF. Please read

Long live Kahless!

Reviewed-by: General Martok <mricon@kernel.org>

-M
