Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83C16166D;
	Mon, 29 Jan 2024 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548075; cv=none; b=KFuZ5dDikgiJ81pit3ZjRwgcoO9mPUVpW5lccDH7RCzJlEpuh/fjSMrxe72Wk9yI3GmwR1U6rp+AQSyuKdfKkiXhcuGplGJ/nusWfF+6n4UZeB8bG7OQ4hlKt1md1bgRo5dVmjJ2FU0Rr7aNV2X98nLN/ibe4QKh3mZ5pGdFofs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548075; c=relaxed/simple;
	bh=OLzm58K98ORF4A+bQmFOL5aUyULLT4Fn27JaU8mzhxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHkK502G3dzKcfkttFgY+gbRV7/eusSWPd8GIoTp084ZyqO6oKMPpYU0cSlrzTsu6XzcwAOaPbtUlvffRH9WoD6QXmKXHIF/jUsyLjWZcI7kYZZYongQCdO842Pjai5ooHT5JiM0axHJb17M+yskIdOPQyWDudNC94aDM/tdGiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7851pvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7851pvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D6BC433C7;
	Mon, 29 Jan 2024 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548074;
	bh=OLzm58K98ORF4A+bQmFOL5aUyULLT4Fn27JaU8mzhxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7851pvM2avIplyBQbfmFuXCosdPdCCyYigPm9CyO8Ln9L+8ACYRzL7b0hLAfNyLR
	 lL0E3AUQ5g5CA2s34Y/1v8XdtD7bt7+rq+NWFkmUD9ykWlQ3KZ5OcMLv88zSZ++T3g
	 HN84VGTZLPtt/HcJbGSSJCWea4Ki5VakTtwpaAxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	kernel test robot <lkp@intel.com>,
	Julia Lawall <julia.lawall@inria.fr>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 058/346] riscv: Fix relocation_hashtable size
Date: Mon, 29 Jan 2024 09:01:29 -0800
Message-ID: <20240129170018.103534793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

[ Upstream commit a35551c7244d9d061643a01eb96cc3ba04eaf45c ]

A second dereference is needed to get the accurate size of the
relocation_hashtable.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Fixes: d8792a5734b0 ("riscv: Safely remove entries from relocation list")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202312120044.wTI1Uyaa-lkp@intel.com/
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240104-module_loading_fix-v3-3-a71f8de6ce0f@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 91f7cd221afc..c9d59a5448b6 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -764,7 +764,7 @@ initialize_relocation_hashtable(unsigned int num_relocations,
 	hashtable_size <<= should_double_size;
 
 	*relocation_hashtable = kmalloc_array(hashtable_size,
-					      sizeof(*relocation_hashtable),
+					      sizeof(**relocation_hashtable),
 					      GFP_KERNEL);
 	if (!*relocation_hashtable)
 		return 0;
-- 
2.43.0



