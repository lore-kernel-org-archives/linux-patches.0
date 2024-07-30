Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FEA192B81;
	Tue, 30 Jul 2024 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359368; cv=none; b=lY+SRW7DNNDn+WoGkb+jwr0eXkcY+KzKMTBJNyQqyJSWflWwpcvn9SEqWIukvn0zKYWi664QG38UBvw3WX1BoUgwKwE4ZfQA3rMFAMrhcsZRgMsahubr8hKdMo0gIfmW9e0k3MxVtJL+vHUvgaoRdIA83EbipA6w/3vltzqSHwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359368; c=relaxed/simple;
	bh=lusMuYexaR2yZemaSBlgQjkkvmg/yLitTZmLygIG7vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqMP8HO0EZC3SrJEQFF1KuEma5wdZ7clKmnwHGgqiNcTFzivbgRRKQFpH1CMw94LxAPZ0OKp2icbur5qp2mDqnLuBWdWdBY7RuXpq0i1TZ8XqmqMhpKOl8fwKSB1Q3LrlzD7yhZEAn6cBe6ShYSy/fU1oea03Hk8rCsSVsIpUSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOfP8tx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOfP8tx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08116C32782;
	Tue, 30 Jul 2024 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359368;
	bh=lusMuYexaR2yZemaSBlgQjkkvmg/yLitTZmLygIG7vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOfP8tx1DAnQyb5WjZ3fGOOIdFnIXmoD0AiGNKpSUb3edX+wVmBKupswr4uhQdJGz
	 xcfW5Oir+J/uamIr7J7xhDMmTJVj9Ty9Sec5PMUMZHvQPSbSkEzhnJOvDYWaRfYHdN
	 BAPhNyFPWWXQHjIIyrlqSwxWOUu38yKXQj907Ayc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 474/809] MIPS: Fix fallback march for SB1
Date: Tue, 30 Jul 2024 17:45:50 +0200
Message-ID: <20240730151743.457740399@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 2326c8f2022636a1e47402ffd09a3b28f737275f ]

Fallback march for SB1 should be mips64 instead of mips64r1.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407111851.LwDasTcp-lkp@intel.com/
Fixes: bfc0a330c1b4 ("MIPS: Fallback CPU -march flag to ISA level if unsupported")
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 80aecba248922..5785a3d5ccfbb 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -170,7 +170,7 @@ cflags-$(CONFIG_CPU_NEVADA)	+= $(call cc-option,-march=rm5200,-march=mips4) \
 			-Wa,--trap
 cflags-$(CONFIG_CPU_RM7000)	+= $(call cc-option,-march=rm7000,-march=mips4) \
 			-Wa,--trap
-cflags-$(CONFIG_CPU_SB1)	+= $(call cc-option,-march=sb1,-march=mips64r1) \
+cflags-$(CONFIG_CPU_SB1)	+= $(call cc-option,-march=sb1,-march=mips64) \
 			-Wa,--trap
 cflags-$(CONFIG_CPU_SB1)	+= $(call cc-option,-mno-mdmx)
 cflags-$(CONFIG_CPU_SB1)	+= $(call cc-option,-mno-mips3d)
-- 
2.43.0



