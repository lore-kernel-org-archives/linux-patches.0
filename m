Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E78C3A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wL1yaDJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9D3C433C7;
	Wed, 15 Nov 2023 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077947;
	bh=i6tELAZxsMeATyx9qigpt2PpQ/eTp9gDH1mO+Lhh+/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wL1yaDJoIrk7AL0D3zxLTrjdSyb/vuZhPvw9CYbL8G2GiBMPRx83vKuoqhf187TeE
	 ns33jlJj7PpLLN/zTZugPfhPjyP4/RB5M+9zUqZeN2q6ebbUcmtjOcBok7rPEHelsX
	 CsPzofXPDkyH5P4vbbVg3MrtpOOz8Vz9HVm9KFA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/379] x86/boot: Fix incorrect startup_gdt_descr.size
Date: Wed, 15 Nov 2023 14:21:30 -0500
Message-ID: <20231115192646.060326875@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Yuntao Wang <ytcoode@gmail.com>

[ Upstream commit 001470fed5959d01faecbd57fcf2f60294da0de1 ]

Since the size value is added to the base address to yield the last valid
byte address of the GDT, the current size value of startup_gdt_descr is
incorrect (too large by one), fix it.

[ mingo: This probably never mattered, because startup_gdt[] is only used
         in a very controlled fashion - but make it consistent nevertheless. ]

Fixes: 866b556efa12 ("x86/head/64: Install startup GDT")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: https://lore.kernel.org/r/20230807084547.217390-1-ytcoode@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/head64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 6a3cfaf6b72ad..84adf12a76d3c 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -80,7 +80,7 @@ static struct desc_struct startup_gdt[GDT_ENTRIES] = {
  * while the kernel still uses a direct mapping.
  */
 static struct desc_ptr startup_gdt_descr = {
-	.size = sizeof(startup_gdt),
+	.size = sizeof(startup_gdt)-1,
 	.address = 0,
 };
 
-- 
2.42.0



