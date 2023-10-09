Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4857168D5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFEOvuK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FEEC433CA;
	Mon,  9 Oct 2023 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857086;
	bh=XyJ0H08b1dWwIi5Lp3Aeif7zeOyOa7F5ZkZEA2lBAHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFEOvuK8a1dZR6vQku5EbuvpI7wokgtf4iKTT0UIzuGAYvR33PIJNj65mVmQqXk09
	 qcvsGa0d+qvRSASP9B+Pesp4IRrJwisBkp72GUNpFk9jL0CYwnbWE0Q0m2VeyBxnAe
	 vEtJe6s8Bu3wiJbQuP98vGYXVZHXdSggkvlG4eP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 065/163] rtla/timerlat_aa: Zero thread sum after every sample analysis
Date: Mon,  9 Oct 2023 15:00:29 +0200
Message-ID: <20231009130125.840286791@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 02d89917ef68acbe65c7cc2323f1db4429879878 ]

The thread thread_thread_sum accounts for thread interference
during a single activation. It was not being zeroed, so it was
accumulating thread interference over all activations.

It was not that visible when timerlat was the highest priority.

Link: https://lore.kernel.org/lkml/97bff55b0141f2d01b47d9450a5672fde147b89a.1691162043.git.bristot@kernel.org

Fixes: 27e348b221f6 ("rtla/timerlat: Add auto-analysis core")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_aa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/tracing/rtla/src/timerlat_aa.c b/tools/tracing/rtla/src/timerlat_aa.c
index e0ffe69c271c6..dec5b4c4511e1 100644
--- a/tools/tracing/rtla/src/timerlat_aa.c
+++ b/tools/tracing/rtla/src/timerlat_aa.c
@@ -159,6 +159,7 @@ static int timerlat_aa_irq_latency(struct timerlat_aa_data *taa_data,
 	taa_data->thread_nmi_sum = 0;
 	taa_data->thread_irq_sum = 0;
 	taa_data->thread_softirq_sum = 0;
+	taa_data->thread_thread_sum = 0;
 	taa_data->thread_blocking_duration = 0;
 	taa_data->timer_irq_start_time = 0;
 	taa_data->timer_irq_duration = 0;
-- 
2.40.1



