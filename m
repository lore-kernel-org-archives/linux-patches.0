Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1F15E8B;
	Mon, 30 Dec 2024 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573969; cv=none; b=V0czcjU5ixr3BRmFEbd2OYvRB4vc0ZmCK+XdQNNwiYTFZLBVbDmS/4Vb/llN+b/5KSiu4yitxz/U6Y6genqo/e/aKkvL7C0YQVa03zi7aSlX/Cd1T9+wIePmcmhtrqkJkSaHZQzedD3nQWk35InCnFgCDfncsZAnqg8x7hU4eFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573969; c=relaxed/simple;
	bh=N5FMmg4HT5secLw1dBEdjC1WlHYa0XG0VUbCS9tv3Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLSJmdZxLZdhRts+zdglvZb+9qreAfjvVisHREpzN6nwsIMPWI/EL6nhqO5uTWANQmejbCGGqzGgyviNyrBkswiHAxCcBNXLOMeguEARP7njLOLOg+QMKeLjlkEgfd1mmslWo5JFUOfWj0Vko9LRyKLAwtHERWtZyLLZbGMeXlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nx/woQSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nx/woQSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81F1C4CED0;
	Mon, 30 Dec 2024 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573969;
	bh=N5FMmg4HT5secLw1dBEdjC1WlHYa0XG0VUbCS9tv3Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nx/woQSeZZaAjL12Jnl26dTAzeyK+YSPrQcJVed+BM50ijP3UOp2u+V+pfTc0bY8o
	 QMsMelCbdpR6GfAzBDYJKueB9LnKpu31uoqTU3FjWNz36igJ5ahUi3KGcYLMxenUxT
	 S47MGEJPmOPILEc8GbwpOIGPewNOjYEr3M7vO1QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 63/86] x86/cpu: Add model number for another Intel Arrow Lake mobile processor
Date: Mon, 30 Dec 2024 16:43:11 +0100
Message-ID: <20241230154214.111296641@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 8a8a9c9047d1089598bdb010ec44d7f14b4f9203 ]

This one is the regular laptop CPU.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20240322161725.195614-1-tony.luck@intel.com
Stable-dep-of: c9a4b55431e5 ("x86/cpu: Add Lunar Lake to list of CPUs with a broken MONITOR implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index b65e9c46b922..d0941f4c2724 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -127,6 +127,7 @@
 
 #define INTEL_FAM6_ARROWLAKE_H		0xC5
 #define INTEL_FAM6_ARROWLAKE		0xC6
+#define INTEL_FAM6_ARROWLAKE_U		0xB5
 
 #define INTEL_FAM6_LUNARLAKE_M		0xBD
 
-- 
2.39.5



