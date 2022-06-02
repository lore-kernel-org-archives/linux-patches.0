Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483FC3D65
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 19:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFD4C34114;
	Thu,  2 Jun 2022 19:41:15 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Boyd <swboyd@chromium.org>,
	Will Deacon <will@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH] arm64: Initialize jump labels before setup_machine_fdt()
Date: Thu,  2 Jun 2022 20:41:12 +0100
Message-Id: <165419885870.2681883.10934677413962491141.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220602022109.780348-1-swboyd@chromium.org>
References: <20220602022109.780348-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 1 Jun 2022 19:21:09 -0700, Stephen Boyd wrote:
> A static key warning splat appears during early boot on arm64 systems
> that credit randomness from devicetrees that contain an "rng-seed"
> property. This is because setup_machine_fdt() is called before
> jump_label_init() during setup_arch(). Let's swap the order of these two
> calls so that jump labels are initialized before the devicetree is
> unflattened and the rng seed is credited.
> 
> [...]

Applied to arm64 (for-next/core), thanks!

[1/1] arm64: Initialize jump labels before setup_machine_fdt()
      https://git.kernel.org/arm64/c/73e2d827a501

-- 
Catalin

