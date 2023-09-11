Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7891170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB86C433C9;
	Mon, 11 Sep 2023 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441459;
	bh=gRKNJAI1Vcwkq6tZ2Lv9YjAWjziSku13HY8Zi+yXvxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahw6X+GO8CMhgayb0FO8Gy4TGW/cjgivH4v4U7rQNzq5bq+Ydg5z1VDISSj1E1blt
	 eCQ0mIZNR3qsJrKP/x5NksZPt03/VVSDt+Cx+E/T6m5SMAm136E7GvEOx7rAaYK9oU
	 ZsAnJCIIpX5odClqddooEwAOBu8JL2VKMh2OT49g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 420/739] powerpc/fadump: reset dump area size if fadump memory reserve fails
Date: Mon, 11 Sep 2023 15:43:39 +0200
Message-ID: <20230911134702.908137778@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit d1eb75e0dfed80d2d85b664e28a39f65b290ab55 ]

In case fadump_reserve_mem() fails to reserve memory, the
reserve_dump_area_size variable will retain the reserve area size. This
will lead to /sys/kernel/fadump/mem_reserved node displaying an incorrect
memory reserved by fadump.

To fix this problem, reserve dump area size variable is set to 0 if fadump
failed to reserve memory.

Fixes: 8255da95e545 ("powerpc/fadump: release all the memory above boot memory size")
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230704050715.203581-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index ea0a073abd969..3ff2da7b120b5 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -654,6 +654,7 @@ int __init fadump_reserve_mem(void)
 	return ret;
 error_out:
 	fw_dump.fadump_enabled = 0;
+	fw_dump.reserve_dump_area_size = 0;
 	return 0;
 }
 
-- 
2.40.1



