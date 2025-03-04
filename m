Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D31DB125;
	Tue,  4 Mar 2025 21:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741125312; cv=none; b=rhJcuXEkyfhzudkSe5+6x8JF4J15LMkngt/kPjhfEUxTRdiGu2SRsoRFX9Bm3c6IEVKk8kx8Ri/30wmidWO+kDQiqA/fVGSYKOirOBb3xfCedMK/LDaDQA9n9dUdNmt8B4bGL5oN2OobBtXNf2OQCWgif1cQql2XY7wCHT+DU2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741125312; c=relaxed/simple;
	bh=E+EAnnp4I4YKN8xIDqGi1mGKb4aRTyIjB2wwQ6KnitQ=;
	h=Message-ID:Content-Type:MIME-Version:In-Reply-To:References:
	 Subject:From:Cc:To:Date; b=nJmbEDMHpn3LjiA7Rqg2yMLkEdtVuAyoy0B9exyDg98b3uQ52LpFdvBkTZ/i+tOKmdRulmETuZ8to9pAnK71Iv39DJcHUSSxMCpWelYJR42xiM3mplADsmdRUD3wENhURfFAsGp4OZqrDeWZVDYxvhMBxjjWkWJ7TqEASXIUmUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CmEVpzMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CmEVpzMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62946C4CEE5;
	Tue,  4 Mar 2025 21:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741125312;
	bh=E+EAnnp4I4YKN8xIDqGi1mGKb4aRTyIjB2wwQ6KnitQ=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=CmEVpzMnSSYJ47NrjDjxl7jJNOwYUAc+vvTRZjz1Dd/vFEBoqBs9VeUGHfSm9GXhk
	 hQMnGAUS1TIy2nXcC3fLsQOjS48YPgqw/o8a7Z/jkcRU4e5ypHFLTsiVeOxsQp4v1t
	 Wmphf7JTK7UQdkYrZFM1n5t9ITAGpKPFGL3dB73h6pJiUECJCojeqslDQTRo2H1qMu
	 3KLrSF5w8/DLgd10TtwKvD4xsdeEsw00k8kTVDdebk1WV7+s88u5bbCfJIJrXkqwmO
	 SxE7zT8BIJUTWwKzABdKIkfrqQitZNmICUVlAlx3cJRQ+UO9OctO0RSFs3VrDsbRJd
	 ga4y51xj7AhmQ==
Message-ID: <2f6d1043d90ab901e6d0dfc09dcff358.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250226235408.1339266-1-sboyd@kernel.org>
References: <20250226235408.1339266-1-sboyd@kernel.org>
Subject: Re: [PATCH] clk: Print an error when clk registration fails
From: Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev
To: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>
Date: Tue, 04 Mar 2025 13:55:10 -0800
User-Agent: alot/0.12.dev1+gaa8c22fdeedb

Quoting Stephen Boyd (2025-02-26 15:54:07)
> We have a lot of driver code that prints an error message when
> registering a clk fails. Do that in the core function instead to
> consolidate code. This also helps drivers avoid the anti-pattern of
> accessing the struct clk_hw::init pointer after registration.
>=20
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---

Applied to clk-next
