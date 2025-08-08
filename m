Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B5F284B51;
	Fri,  8 Aug 2025 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667068; cv=none; b=cX2XiIOcDYzj+yVc2hqH6MYRasBeeXGiNyBLunZJYlE4dx6OGj3JpZdjzAjMX+L1zTf9vctAKx1ZJHaLwHFinegm+awKYe4H0w03t4xgjVhZo49y+yz0awcNGX8JPNstdnd4cjEb7BJLuMhRghLVGWDn1mfsvPtC8w4nKh4Oz2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667068; c=relaxed/simple;
	bh=uvXvdqCtcDLr9TJV+3JSLTg+Qsmj24HevLK5HBH2JNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tu8pKGhzza5EisaMBMkbrdq2FEfAq3ivovTG8lPBkLHWp0fV0KKphna33/ASuL1w9bOQ6oahgQ7TVMEsrrZWCYjXNzic8kGrwL8Y+FOqQSNDikoSnhUGjDOyeEPEsJI/ylAjZ+1BD2kQwOPv1wy9wM38j5sc6sUmbX0CfDZskpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YtH5F5g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtH5F5g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC29AC4CEED;
	Fri,  8 Aug 2025 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667068;
	bh=uvXvdqCtcDLr9TJV+3JSLTg+Qsmj24HevLK5HBH2JNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtH5F5g7f2l+hwMXj4nn7vWmfIJf8VJpscmPf33Rl3+Ozb83Bk+RG3oDaZObqvwq7
	 wEJN+bvWBJ3oC61U3EDC75upXLJ6saOcvrVP29C0qw7hARTQ8Bi531ZpZ/RUygPE2f
	 FNaoM5uRjCe77hTdmXEv3Xlyx+Cd0UwWS7Oz4jOjad8aT+yhRQAktUhnj+X57q+jL8
	 lSaJeWs/7WbNmgK2NsACJnzhedlE88ugW5SWR5O5QnuuBDKOD+XG094xpAtqisMWLw
	 oxPw56Jw/nzR7roxCREfzufutDKMg40QqPDzriVu8CJ5+EBEFE/EZd1H7jf27TjNCv
	 nyjPiXmHVwDmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
	kernel test robot <lkp@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-i3c@lists.infradead.org
Subject: [PATCH AUTOSEL 6.16-5.4] i3c: add missing include to internal header
Date: Fri,  8 Aug 2025 11:30:46 -0400
Message-Id: <20250808153054.1250675-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 3b661ca549b9e5bb11d0bc97ada6110aac3282d2 ]

LKP found a random config which failed to build because IO accessors
were not defined:

   In file included from drivers/i3c/master.c:21:
   drivers/i3c/internals.h: In function 'i3c_writel_fifo':
>> drivers/i3c/internals.h:35:9: error: implicit declaration of function 'writesl' [-Werror=implicit-function-declaration]

Add the proper header to where the IO accessors are used.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507150208.BZDzzJ5E-lkp@intel.com/
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250717120046.9022-2-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real build failure**: The commit fixes an actual
   compilation error where `writesl` function is used without including
   the proper header (`<linux/io.h>`). This is a concrete build
   regression that prevents kernel compilation in certain
   configurations.

2. **Minimal and safe change**: The fix is extremely simple - it only
   adds a single `#include <linux/io.h>` line to the internals.h header
   file. This is a one-line change with virtually no risk of introducing
   regressions.

3. **Detected by kernel test robot**: The issue was found by the Linux
   Kernel Test Robot (LKP), indicating it affects real-world build
   configurations that are tested regularly. The error message shows:
  ```
  drivers/i3c/internals.h:35:9: error: implicit declaration of function
  'writesl'
  ```

4. **Affects core I3C infrastructure**: The internals.h header is
   included by core I3C files (master.c and device.c), so a build
   failure here can prevent the entire I3C subsystem from compiling.

5. **Recent regression**: Looking at the git history, the
   `i3c_writel_fifo()` and `i3c_readl_fifo()` functions were recently
   added in commit 733b439375b4, and are already being used by I3C
   controller drivers (dw-i3c-master.c and cdns-i3c-master.c as shown in
   commits 6e055b1fb2fc and c20d3fa70491). This missing include is a
   regression that breaks builds after these recent changes.

6. **Clear stable backport criteria**: This meets the stable kernel
   rules perfectly:
   - It fixes a real bug (build failure)
   - It's obviously correct (missing include for used functions)
   - It's a minimal change (1 line)
   - No new features or architectural changes
   - Zero risk of functional regression

The commit is a textbook example of what should be backported to stable
trees - a simple, obvious fix for a build regression with no side
effects.

 drivers/i3c/internals.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/internals.h b/drivers/i3c/internals.h
index 433f6088b7ce..ce04aa4f269e 100644
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -9,6 +9,7 @@
 #define I3C_INTERNALS_H
 
 #include <linux/i3c/master.h>
+#include <linux/io.h>
 
 void i3c_bus_normaluse_lock(struct i3c_bus *bus);
 void i3c_bus_normaluse_unlock(struct i3c_bus *bus);
-- 
2.39.5

