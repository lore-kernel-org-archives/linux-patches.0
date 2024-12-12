Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88898215178;
	Thu, 12 Dec 2024 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025039; cv=none; b=nLDwgsG+gdUfSZqIKEuCxl0kTQ/9pjchDDnobCs+t1zw+Zsfr94cnEj7KpgDn45ds+9QMZV+FTQkszYzNVWx3mjdGhfyhXw596JWPk9AoQXf9IQzogqo9HhJ7SRlrCTq21LxXusmW73ODot+FMdFOzdNXPF6Y+ETPauo//BXKjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025039; c=relaxed/simple;
	bh=OlObgQETfXfwKBdE9vzpzuvYr8rd0WwYpftTStGu7Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRKfLTTXfnhbm3f8+Ubw9GqoLc6gGTYGNcQW8CXomHT2pFCEYiZO99DYe9eS6s1652jHjvF3Ufk5V9xh+Y/B5fRke//8dDJtSgdzlc15bxDEgp6lbYpbU/0EVqTWRmZwoh8bbdDZzVkrjwj7MCxjy/D32YWj/U3HdElby1XG5s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajM3viv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajM3viv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0332C4CECE;
	Thu, 12 Dec 2024 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025039;
	bh=OlObgQETfXfwKBdE9vzpzuvYr8rd0WwYpftTStGu7Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajM3viv9HZJJ+aOjVGkFtr6tkt0ckQdpSF21HgKrXaY4Jq86rtyfif+EwUqARhERx
	 08/wmOJXtP6UgMpAwIokG5qYssIYl2qhao+kVsXX54510Y/8pw6ndESGzPGo0jSPIK
	 geqoZmMLCH/lVh3fAWxNuMs8AQxogfkbvJq6FpGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/321] acpi/arm64: Adjust error handling procedure in gtdt_parse_timer_block()
Date: Thu, 12 Dec 2024 15:59:13 +0100
Message-ID: <20241212144231.389820572@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 311419d1d6b05..b00724700f552 100644
--- a/drivers/acpi/arm64/gtdt.c
+++ b/drivers/acpi/arm64/gtdt.c
@@ -283,7 +283,7 @@ static int __init gtdt_parse_timer_block(struct acpi_gtdt_timer_block *block,
 		if (frame->virt_irq > 0)
 			acpi_unregister_gsi(gtdt_frame->virtual_timer_interrupt);
 		frame->virt_irq = 0;
-	} while (i-- >= 0 && gtdt_frame--);
+	} while (i-- > 0 && gtdt_frame--);
 
 	return -EINVAL;
 }
-- 
2.43.0



