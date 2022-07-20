Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D73602F
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 17:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DB1C3411E;
	Wed, 20 Jul 2022 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1658338407;
	bh=AlCVyqePMWA/Uq/AUEmB8MH6pUSLkHb6SyeBdJEX6K4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XiEE3XCMjEqFV9nhuFZYCNOOaK6Zoh28t4Ghv1VvBBuxYamPEzF8PQxUH/z3UHURv
	 CycvnpRSwJejpFm8+ytCtWLmwrYLxIGmSB+ESD7LwpxaCl8DcDhbBARXI3p663sGP0
	 y9TmgBxEMstMqimH1CLHs4kIoWumtsZoy41iIDZN4i6PcEOz02W5W3V0eivOVVbgl3
	 SYtcMC87KXZeYpfNj2fIljhcDATLzvWqBHMKtZkaL8xTLgLwlo24K1c40BUv0fqwme
	 896s7FHJpgQeo4E7RbfWhtZSBoXIIbJ6JpzkISMAhWY+NN94A3FSuXTMwk3ijP/jhi
	 Hsz+gS4rfL6eg==
Date: Wed, 20 Jul 2022 13:33:25 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linux Patches <patches@lists.linux.dev>
Subject: Re: [PATCH v2 2/3] MAINTAINERS: set Kahless as ultimate maintainer
Message-ID: <20220720173325.pc65ybkpylk7thip@meerkat.local>
References: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
 <20220720-claim-for-kahless-v2-2-ddbde3dd27ea@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20220720-claim-for-kahless-v2-2-ddbde3dd27ea@linuxfoundation.org>

On Wed, Jul 20, 2022 at 10:17:35AM -0400, Konstantin Ryabitsev wrote:
>Reviewed-by: General Martok <mricon@kernel.org>
>Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

I tested it to see if anything would gowron.

Tested-by: Gowron son of M'Rel <devnull@kernel.org>

(Intentional sender/trailer mismatch test.)

-G
