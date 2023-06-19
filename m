Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E48BE71;
	Mon, 19 Jun 2023 09:29:28 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F30A12FC;
	Mon, 19 Jun 2023 02:30:11 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E52893F64C;
	Mon, 19 Jun 2023 02:29:25 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	james.clark@arm.com,
	patches@lists.linux.dev,
	llvm@lists.linux.dev,
	mike.leach@linaro.org,
	coresight@lists.linaro.org,
	quic_hazha@quicinc.com,
	leo.yan@linaro.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] coresight: dummy: Update type of mode parameter in dummy_{sink,source}_enable()
Date: Mon, 19 Jun 2023 10:29:19 +0100
Message-Id: <168716691768.483231.16849638798350952643.b4-ty@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616-coresight-dummy-fix-kcfi-warnings-v1-1-c55c64f8f0f5@kernel.org>
References: <20230616-coresight-dummy-fix-kcfi-warnings-v1-1-c55c64f8f0f5@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 16 Jun 2023 09:41:30 -0700, Nathan Chancellor wrote:
> Clang's kernel Control Flow Integrity (kCFI) is a compiler-based
> security mitigation that ensures the target of an indirect function call
> matches the expected type of the call and trapping if they do not match
> exactly. The warning -Wincompatible-function-pointer-types-strict aims
> to catch these issues at compile time, which reveals:
> 
>   drivers/hwtracing/coresight/coresight-dummy.c:53:12: error: incompatible function pointer types initializing 'int (*)(struct coresight_device *, struct perf_event *, enum cs_mode)' with an expression of type 'int (struct coresight_device *, struct perf_event *, u32)' (aka 'int (struct coresight_device *, struct perf_event *, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
>      53 |         .enable = dummy_source_enable,
>         |                   ^~~~~~~~~~~~~~~~~~~
>   drivers/hwtracing/coresight/coresight-dummy.c:62:12: error: incompatible function pointer types initializing 'int (*)(struct coresight_device *, enum cs_mode, void *)' with an expression of type 'int (struct coresight_device *, u32, void *)' (aka 'int (struct coresight_device *, unsigned int, void *)') [-Werror,-Wincompatible-function-pointer-types-strict]
>      62 |         .enable = dummy_sink_enable,
>         |                   ^~~~~~~~~~~~~~~~~
>   2 errors generated.
> 
> [...]

Applied, thanks!

[1/1] coresight: dummy: Update type of mode parameter in dummy_{sink,source}_enable()
      commit: 185891f03f712639c082e08fc9986ff214b5d617

Best regards,
-- 
Suzuki K Poulose <suzuki.poulose@arm.com>
