Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D1EA20
	for <patches@lists.linux.dev>; Wed, 27 Jul 2022 02:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB5EC433D6;
	Wed, 27 Jul 2022 02:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658890582;
	bh=AG7dd4K/CnHCHaBHMZJfShZVr4X0Wk6i6JQ+reKkYsE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tj/fNfwd+v2BY9e81QiM0R/SCa7Vkl+KxcuDuB6cNyujj8B4EDV7wkKzVEXtBybzW
	 y0ef5ZdP4RJ6ZyXfsWW0vHhfPVAkyrsKrM6oOEonmRjHWKgS6oaOQ2N41adW5g66z/
	 0xkd656Crh2gdLLgVgxUbmKNiOc2u5Z/Wg6F4XrwwqeIbzjc+HOFvASjsIghg266Po
	 7dWFgIa9vebQdYCDDdGEloP5pX491HqR+9M7Tbuj7AWH95c/4CyFioUDO403lE8yR0
	 BHYrSB41nhS0Wz/J7MoEMXCcjSxJ+r8jyjS6yvWuoevvqk/6KNfIaw4jOOE8wYIM4y
	 X/joID4xwcM2g==
Date: Tue, 26 Jul 2022 19:56:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, patches@lists.linux.dev, kernel test robot
 <lkp@intel.com>, Vadim Fedorenko <vadfed@fb.com>, Jonathan Lemon
 <jonathan.lemon@gmail.com>, Richard Cochran <richardcochran@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] ptp: ocp: select CRC16 to fix build error
Message-ID: <20220726195621.1b023508@kernel.org>
In-Reply-To: <20220727011213.24274-1-rdunlap@infradead.org>
References: <20220727011213.24274-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 Jul 2022 18:12:13 -0700 Randy Dunlap wrote:
> ptp_ocp.c uses crc16(), so it should select CRC16 to
> prevent a build error:
> 
> ERROR: modpost: "crc16" [drivers/ptp/ptp_ocp.ko] undefined!
> 
> Fixes: 3c3673bde50c ("ptp: ocp: Add firmware header checks")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vadim Fedorenko <vadfed@fb.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>

Jonathan just posted this fix a few hours ago:

 https://lore.kernel.org/all/20220726220604.1339972-1-jonathan.lemon@gmail.com/

