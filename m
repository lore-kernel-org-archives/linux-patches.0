Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0224A198AA
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 23:33:06 +0000 (UTC)
Date: Fri, 25 Aug 2023 23:32:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
	s=protonmail2; t=1693006370; x=1693265570;
	bh=zRwWsMDd5Kf2yQpedEA3Ka2dLpgNvYvwuOL0uYq4mxY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=nZFuiL4fW85fX+J1npo65OvHYrgHnoS8wSxqWSLrKmoviM0c6e46mqRMzqtH9/MWu
	 Vby1zVLEV0v/ulasBpcymNz1VfCpTci/snqcsPRf5HetuWyoT192nAqyslEZTGXVBm
	 qQEZzX/jRVgKdtvqS8j220WQfCl7vsOeojSW+cUAESI7H86M5acLyHKT2ym01QEojV
	 0H9Z1Sf9+IzBBykN4SLirksIOs6h5MkowLtmccM1RA2sesJXM3MKtTal8HGNPLCDuw
	 w+pqX7j7stkvcSKTbFHEQgDUzFkJHctAIZbQIIUO8A1aM+EYeAI+W3EFFqrF+PxMcN
	 fJYTsLcLeC7nQ==
To: Stephen Boyd <swboyd@chromium.org>
From: Simon Ser <contact@emersion.fr>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, dri-devel@lists.freedesktop.org, Pekka Paalanen <pekka.paalanen@collabora.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/connector: Add newline to debug printk
Message-ID: <sqyPw9vZ5TuRr6bQT59K00AB1wM5QdkEdK-qUEWeesjx_nin5LzSAL1NSIOIV5PD0pKqpzqscQs0FRAjMmD98L3WcNMt4-l7J0mxqIMr7zQ=@emersion.fr>
In-Reply-To: <20230825233118.2689222-1-swboyd@chromium.org>
References: <20230825233118.2689222-1-swboyd@chromium.org>
Feedback-ID: 1358184:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Simon Ser <contact@emersion.fr>
