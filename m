Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C112AA3F;
	Mon, 20 Feb 2023 03:51:44 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4PKpPq0f4Hz4x8b;
	Mon, 20 Feb 2023 14:51:43 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Nathan Chancellor <nathan@kernel.org>, benh@kernel.crashing.org, mpe@ellerman.id.au
Cc: llvm@lists.linux.dev, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, patches@lists.linux.dev
In-Reply-To: <20230215-windfarm-wsingle-bit-bitfield-constant-conversion-v1-1-26415072e855@kernel.org>
References: <20230215-windfarm-wsingle-bit-bitfield-constant-conversion-v1-1-26415072e855@kernel.org>
Subject: Re: [PATCH] macintosh: windfarm: Use unsigned type for 1-bit bitfields
Message-Id: <167686495882.2406274.8062976789775517076.b4-ty@ellerman.id.au>
Date: Mon, 20 Feb 2023 14:49:18 +1100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 15 Feb 2023 10:12:12 -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   drivers/macintosh/windfarm_lm75_sensor.c:63:14: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
>                   lm->inited = 1;
>                              ^ ~
> 
>   drivers/macintosh/windfarm_smu_sensors.c:356:19: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
>                   pow->fake_volts = 1;
>                                   ^ ~
>   drivers/macintosh/windfarm_smu_sensors.c:368:18: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
>                   pow->quadratic = 1;
>                                  ^ ~
> 
> [...]

Applied to powerpc/next.

[1/1] macintosh: windfarm: Use unsigned type for 1-bit bitfields
      https://git.kernel.org/powerpc/c/748ea32d2dbd813d3bd958117bde5191182f909a

cheers
