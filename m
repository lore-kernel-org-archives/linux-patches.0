Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2A578B61;
	Tue, 27 Feb 2024 14:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043533; cv=none; b=Y79kPdirogpNV+DJjeoPRQPG8NnWI1sSTv6e6/NygJ6xXCam1dUWhe9VyVHrm5LgXWmXSXv+Jjx7niLMiGPnFgPxBufXFRb1d1+DXXsqw8+eFDSZH033+AOJTXlO1kD3XkHGUWHNJVc9YGlJ8koEO5vFwFuLNKvDpAlKfPU8xSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043533; c=relaxed/simple;
	bh=abSmuRp/gPjt/PakOOPXFqKQBtPWBqw5oEEZj2UZvTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV27PteqvAm4kWV6WiQTHJhgkQJmBz8W5DmbhPLWtrFabZCUtRP1SSaF4FXtIcPOElSa9yxcqBIqPDh/PztgAfoX3zuGpg0T7WTCHs4trAFAmKRz8U4yVjmHNr9kLal9IENNewZqXt2mVSt5m5CuKNFB5X6Kbu+ZUXvOjJAS7W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07uOFTuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07uOFTuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19710C433F1;
	Tue, 27 Feb 2024 14:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043533;
	bh=abSmuRp/gPjt/PakOOPXFqKQBtPWBqw5oEEZj2UZvTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07uOFTuZD5KcyXNC+i5JVrOk6PJ1l5bXLvkvZpiouxFl1CetDDa2kpF/wJF8cAIje
	 Zf9xr15BV4YOAxHMOXu35+rzckQ1iFz050fmmG1Yqqi/xnhYy5Up8ukdgKhu7KpyTE
	 WQpFBjuVHeMHcZ17q4OD+IRv8sFNslTcBO+zWzHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianmarco Lusvardi <glusvardi@posteo.net>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/195] bpf, scripts: Correct GPL license name
Date: Tue, 27 Feb 2024 14:26:44 +0100
Message-ID: <20240227131615.149857706@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianmarco Lusvardi <glusvardi@posteo.net>

[ Upstream commit e37243b65d528a8a9f8b9a57a43885f8e8dfc15c ]

The bpf_doc script refers to the GPL as the "GNU Privacy License".
I strongly suspect that the author wanted to refer to the GNU General
Public License, under which the Linux kernel is released, as, to the
best of my knowledge, there is no license named "GNU Privacy License".
This patch corrects the license name in the script accordingly.

Fixes: 56a092c89505 ("bpf: add script and prepare bpf.h for new helpers documentation")
Signed-off-by: Gianmarco Lusvardi <glusvardi@posteo.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/20240213230544.930018-3-glusvardi@posteo.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/bpf_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index d5c389df6045e..4de98b7bbea95 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -495,7 +495,7 @@ eBPF programs can have an associated license, passed along with the bytecode
 instructions to the kernel when the programs are loaded. The format for that
 string is identical to the one in use for kernel modules (Dual licenses, such
 as "Dual BSD/GPL", may be used). Some helper functions are only accessible to
-programs that are compatible with the GNU Privacy License (GPL).
+programs that are compatible with the GNU General Public License (GNU GPL).
 
 In order to use such helpers, the eBPF program must be loaded with the correct
 license string passed (via **attr**) to the **bpf**\ () system call, and this
-- 
2.43.0



