Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB43E381CC;
	Thu, 26 Oct 2023 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A592EC433C7;
	Thu, 26 Oct 2023 16:36:16 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: will@kernel.org,
	Nathan Chancellor <nathan@kernel.org>
Cc: mark.rutland@arm.com,
	ndesaulniers@google.com,
	trix@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] arm64: Restrict CPU_BIG_ENDIAN to GNU as or LLVM IAS 15.x or newer
Date: Thu, 26 Oct 2023 17:36:14 +0100
Message-Id: <169833816807.245777.14959433723138237512.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231025-disable-arm64-be-ias-b4-llvm-15-v1-1-b25263ed8b23@kernel.org>
References: <20231025-disable-arm64-be-ias-b4-llvm-15-v1-1-b25263ed8b23@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 25 Oct 2023 10:21:28 -0700, Nathan Chancellor wrote:
> A recent refactoring in the arm64 tree exposed an assembler bug in LLVM
> with regards to the generation of NOPs for arm64 big endian, resulting
> in near-immediate crashes on boot in QEMU.
> 
> Restrict CONFIG_CPU_BIG_ENDIAN to a known good assembler, which is
> either GNU as or LLVM's IAS 15.0.0 and newer, which contains the linked
> commit.
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: Restrict CPU_BIG_ENDIAN to GNU as or LLVM IAS 15.x or newer
      https://git.kernel.org/arm64/c/146a15b87335

-- 
Catalin

