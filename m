Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C063624B34;
	Mon, 14 Oct 2024 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916634; cv=none; b=T74Vqx9pNbSPMLZjGRvUwGHVTtoLe7JA5eNb/I7nLREXYD7y9ge1g4iruwp9CtE1mBbOq8XITHMvkNjIHFHhimcgGDsQlISaDLKLYLVY3TqlWDgdjKp5imKteJuwwwolYpdPEIssZ0lDqF2v5eAlWFlUIZjWISe8tv2ngKzEaN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916634; c=relaxed/simple;
	bh=C49t4bjwpfWh6VmK+YuFqT9JE/ewg7xZKh4lhu+vNJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KA6Vto9Q/U629YOv6yuPjLhGkyz9wXyi3X+9Xzts02cR68sLdvlvcKGbEOFv9xMDpC9Z7NK6Mef/WzK87zcLGZ9p0MhJV9t/cgCxIBs89mnPz6AWjwy6vwzA1xbEwJPHI2CejGa33RSwM7z6NLo59aqLOQRjebvaJhdqR3uxvVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gh75+DTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gh75+DTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAFCC4CEC3;
	Mon, 14 Oct 2024 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916634;
	bh=C49t4bjwpfWh6VmK+YuFqT9JE/ewg7xZKh4lhu+vNJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh75+DTQ/DQr0fzWNAP9avQfI2wjgrl+04CW4IdycZVwEB+CWNrFj2Sbf7lYMl8Yj
	 4EFQRqlKgVYLayh08sajfOYMEmP0Q83Gt7ktZ67/5+Aq46qsLmkYhzjhdAnV2XAE1B
	 aQhupTQTCNJEgXgHPrhdoZ1769L+WUdovbs4MOu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoff Levand <geoff@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/213] Revert "powerpc/ps3_defconfig: Disable PPC64_BIG_ENDIAN_ELF_ABI_V2"
Date: Mon, 14 Oct 2024 16:18:48 +0200
Message-ID: <20241014141043.853517012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoff Levand <geoff@infradead.org>

[ Upstream commit 914d081ead115f7ba685ab57f977716bdd09c894 ]

This reverts commit 482b718a84f08b6fc84879c3e90cc57dba11c115.

The preceding commits by Nicholas Piggin enable PS3 support for ELFv2,
so there's no need to disable it for PS3 anymore.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/983836405df1b6001a2262972fb32d1aee97d6f5.1705654669.git.geoff@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/ps3_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index aa8bb0208bcc8..2b175ddf82f0b 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -24,7 +24,6 @@ CONFIG_PS3_VRAM=m
 CONFIG_PS3_LPM=m
 # CONFIG_PPC_OF_BOOT_TRAMPOLINE is not set
 CONFIG_KEXEC=y
-# CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2 is not set
 CONFIG_PPC_4K_PAGES=y
 CONFIG_SCHED_SMT=y
 CONFIG_PM=y
-- 
2.43.0



