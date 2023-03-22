Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8717C
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 12:33:59 +0000 (UTC)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4PhSR23Twmz4xFZ;
	Wed, 22 Mar 2023 23:27:26 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20230310232850.3960676-1-mcgrof@kernel.org>
References: <20230310232850.3960676-1-mcgrof@kernel.org>
Subject: Re: [PATCH 0/2] ppc: simplify sysctl registration
Message-Id: <167948793444.559204.3802967683451092052.b4-ty@ellerman.id.au>
Date: Wed, 22 Mar 2023 23:25:34 +1100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Fri, 10 Mar 2023 15:28:48 -0800, Luis Chamberlain wrote:
> We can simplify the way we do sysctl registration both by
> reducing the number of lines and also avoiding calllers which
> could do recursion. The docs are being updated to help reflect
> this better [0].
> 
> [0] https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u
> 
> [...]

Applied to powerpc/next.

[1/2] ppc: simplify one-level sysctl registration for powersave_nap_ctl_table
      https://git.kernel.org/powerpc/c/bfedee5dc406ddcd70d667be1501659f1b232b7f
[2/2] ppc: simplify one-level sysctl registration for nmi_wd_lpm_factor_ctl_table
      https://git.kernel.org/powerpc/c/3a713753d3cb52e4e3039cdb906ef00f0b574219

cheers
