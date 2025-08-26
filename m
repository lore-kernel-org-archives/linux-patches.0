Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5B2350D4D;
	Tue, 26 Aug 2025 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217895; cv=none; b=GeTV0n7GtuFwKL5LjftPjppy6rxa8cSW9II8nS35R4R8S9bFvgK9ECL7gKYRG+j0yLvKUSSbkEJRjILPJ/My+nHjv0NPtXs+RMlWNE/wHNP1TmDVLWq/1sfJ2ee0Amv+BuJDmOhMkLvglBtADjeX3z3lQRTHHzq71HjZ7Q7irng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217895; c=relaxed/simple;
	bh=0M0IkxDi8vuceObu25NDBa3YVVEg2eI/UZMBkBlKF/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2iavCEDJAG7I/BJ/iflIKbzfaRm34kejcjTfzEzpOFOH+uC5BXrac7/KbrZ67LkweIDudIHAVNMQ8wUF0lMdkXWBlInchZBrNdYzvZhIX4bX9HvYU8C5aBDvQfKMgHtxIo7ycqiGtBm2H9XI2QbE0WgpKxYKC4h5mcg6zeK5u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKOPzGVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKOPzGVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE26C113D0;
	Tue, 26 Aug 2025 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217894;
	bh=0M0IkxDi8vuceObu25NDBa3YVVEg2eI/UZMBkBlKF/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKOPzGVFopfM+0yYhzJtezJmnv7T6GqsuT7sZCqyi0gL+1A+rdP2yPRjf2Vy7vGeU
	 dvK6aP+I40mRhwONapmvk7uy7a4RBzn/MPMZh+qRuCf3lDXTFi4XYMVnNtBVHnH4r+
	 qMwc+WPxWj5l3WShEu7fuxopcaRVU4sjXslnmtHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/523] i3c: add missing include to internal header
Date: Tue, 26 Aug 2025 13:08:46 +0200
Message-ID: <20250826110932.257287028@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/i3c/internals.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/internals.h b/drivers/i3c/internals.h
index 86b7b44cfca2..1906c711f38a 100644
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -9,6 +9,7 @@
 #define I3C_INTERNALS_H
 
 #include <linux/i3c/master.h>
+#include <linux/io.h>
 
 extern struct bus_type i3c_bus_type;
 
-- 
2.39.5



