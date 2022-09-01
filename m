Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E582746C;
	Thu,  1 Sep 2022 20:02:01 +0000 (UTC)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
	by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 281Jl6l3004365;
	Thu, 1 Sep 2022 14:47:06 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.14.1/8.14.1/Submit) id 281Jl50a004364;
	Thu, 1 Sep 2022 14:47:05 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 1 Sep 2022 14:47:05 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        kernel test robot <lkp@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Tom Rix <trix@redhat.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc/math_emu/efp: Include module.h
Message-ID: <20220901194705.GI25951@gate.crashing.org>
References: <20220831152014.3501664-1-nathan@kernel.org> <efd56f3e-bc8c-5da5-559d-e0bc6b21fa5b@csgroup.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efd56f3e-bc8c-5da5-559d-e0bc6b21fa5b@csgroup.eu>
User-Agent: Mutt/1.4.2.3i

On Thu, Sep 01, 2022 at 05:41:33AM +0000, Christophe Leroy wrote:
> I think it would be worth a GCC bug report.

We need a stand-alone testcase for this.  When you have created one, at
least 98% of the time you discover the bug is in user code after all.

Which is a very good thing, it means the problem can be fixed simpler,
cheaper, and a lot faster :-)


Segher
