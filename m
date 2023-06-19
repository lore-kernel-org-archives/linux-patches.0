Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3678EBE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBE4C433C9;
	Mon, 19 Jun 2023 10:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172197;
	bh=FCA6QZUmxeEAPoO/HYBDu+l72JcuM+mzPUZVjnTKZ8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4tpIngCHRo+l0O5D9FG12t1qaKLCHrobZknfU1PPWql1za82WqCzGx29xi+nfl0o
	 SX4IVHjKsO1338BlQNuRkrzmfbE21rh2oB8NojtkiMtuBobIG4U0M73qIopLs+ok7y
	 LQSAq0KGVM6L7ymFQ79ER7O6QcTcZf6No/BpI3eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Maftei <alex.maftei@amd.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 72/89] selftests/ptp: Fix timestamp printf format for PTP_SYS_OFFSET
Date: Mon, 19 Jun 2023 12:31:00 +0200
Message-ID: <20230619102141.543942099@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Maftei <alex.maftei@amd.com>

[ Upstream commit 76a4c8b82938bc5020b67663db41f451684bf327 ]

Previously, timestamps were printed using "%lld.%u" which is incorrect
for nanosecond values lower than 100,000,000 as they're fractional
digits, therefore leading zeros are meaningful.

This patch changes the format strings to "%lld.%09u" in order to add
leading zeros to the nanosecond value.

Fixes: 568ebc5985f5 ("ptp: add the PTP_SYS_OFFSET ioctl to the testptp program")
Fixes: 4ec54f95736f ("ptp: Fix compiler warnings in the testptp utility")
Fixes: 6ab0e475f1f3 ("Documentation: fix misc. warnings")
Signed-off-by: Alex Maftei <alex.maftei@amd.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20230615083404.57112-1-alex.maftei@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptp/testptp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index f7911aaeb0075..aa474febb4712 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -492,11 +492,11 @@ int main(int argc, char *argv[])
 			interval = t2 - t1;
 			offset = (t2 + t1) / 2 - tp;
 
-			printf("system time: %lld.%u\n",
+			printf("system time: %lld.%09u\n",
 				(pct+2*i)->sec, (pct+2*i)->nsec);
-			printf("phc    time: %lld.%u\n",
+			printf("phc    time: %lld.%09u\n",
 				(pct+2*i+1)->sec, (pct+2*i+1)->nsec);
-			printf("system time: %lld.%u\n",
+			printf("system time: %lld.%09u\n",
 				(pct+2*i+2)->sec, (pct+2*i+2)->nsec);
 			printf("system/phc clock time offset is %" PRId64 " ns\n"
 			       "system     clock time delay  is %" PRId64 " ns\n",
-- 
2.39.2



