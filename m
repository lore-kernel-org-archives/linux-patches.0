Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146A91F4294;
	Tue,  3 Dec 2024 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236446; cv=none; b=oEY1TbHcaGu2N6NZt4A5E2lJ+20Q3PlBWLsojsP+o+a2tEabevw3exit76hzGfVPvMUHSNhM4vvchjiAzcs22IedL2ufJHnKJWfpxkfXfsyeui3oSs0VRYg5cgk7yNxI3ArRS9JoB2sP95YWIgHLSWApjnJL82cZOOSx8whfuXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236446; c=relaxed/simple;
	bh=V/OfBy2p852UVrCIrEHQndCQ9daBRNpPOB/MA00ftE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0MaYWETpkkuKMJ/DyywBy/7dYy4ip30p7IXQ0TjALYam17TUCHpRlVbnl6iT35BqkfYOMDOGzKN4Rsv7v/Plc+bDnj4BJOW+DsRVscSvUGCI9LF4JnwZrt3yd6GhPX9HzOvFmVlI0JnF0UmGOPRrbn77250dZBq0f3lFiVqWfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rezMwFwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rezMwFwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C32C4CECF;
	Tue,  3 Dec 2024 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236445;
	bh=V/OfBy2p852UVrCIrEHQndCQ9daBRNpPOB/MA00ftE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rezMwFwoVhQk2Fy2olSTqUWbHSon3yh57WtmtQzZetDyKOqYB22HTD/ZkGjkmN/Hn
	 qJL3lgCfYlwU/Y0e/iaAN/ESmjazC6a/aDMFhsBpIWonDzih+W4u4LjRGsL33ASvx8
	 I6ci9YwQbVY09fvmsdYOU/WSHLFPRseTqX1HobGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/138] acpi/arm64: Adjust error handling procedure in gtdt_parse_timer_block()
Date: Tue,  3 Dec 2024 15:30:50 +0100
Message-ID: <20241203141924.356469752@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 1a9de2f6fda69d5f105dd8af776856a66abdaa64 ]

In case of error in gtdt_parse_timer_block() invalid 'gtdt_frame'
will be used in 'do {} while (i-- >= 0 && gtdt_frame--);' statement block
because do{} block will be executed even if 'i == 0'.

Adjust error handling procedure by replacing 'i-- >= 0' with 'i-- > 0'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a712c3ed9b8a ("acpi/arm64: Add memory-mapped timer support in GTDT driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://lore.kernel.org/r/20240827101239.22020-1-amishin@t-argos.ru
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/gtdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/arm64/gtdt.c b/drivers/acpi/arm64/gtdt.c
index 7a181a8a9bf04..a8aecdcdae7e6 100644
--- a/drivers/acpi/arm64/gtdt.c
+++ b/drivers/acpi/arm64/gtdt.c
@@ -286,7 +286,7 @@ static int __init gtdt_parse_timer_block(struct acpi_gtdt_timer_block *block,
 		if (frame->virt_irq > 0)
 			acpi_unregister_gsi(gtdt_frame->virtual_timer_interrupt);
 		frame->virt_irq = 0;
-	} while (i-- >= 0 && gtdt_frame--);
+	} while (i-- > 0 && gtdt_frame--);
 
 	return -EINVAL;
 }
-- 
2.43.0



