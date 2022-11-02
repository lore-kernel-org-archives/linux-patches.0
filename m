Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41887E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC900C433D7;
	Wed,  2 Nov 2022 02:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357630;
	bh=7nOvcIbjmgEsvxw+Mokmwn6C/dpnsiSulQDYgZS+Qq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNeCojiVs1/fALsKd79WCujMFckM1eMadBRaDD2UWkZy03bSE4SFylVzn+w4TcD/e
	 Ek2YTPb++ZoXKQzOe6RD1r4LSDZsKo3oLNb1cuPdZpI6m4N5hIer9MeGbvIddxtz5o
	 uTQ6YV9umPVkPPl5huUO7i+c9LcE8Ddm+1whxU9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 202/240] perf list: Fix PMU name pai_crypto in perf list on s390
Date: Wed,  2 Nov 2022 03:32:57 +0100
Message-Id: <20221102022115.964491627@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 5a6c184a72a375072cffe788d93ad6052c48f16b ]

Commit e0b23af82d6f454c ("perf list: Add PMU pai_crypto event
description for IBM z16") introduced the "Processor Activity
Instrumentation" for cryptographic counters for z16. The PMU device
driver exports the counters via sysfs files listed in directory
/sys/devices/pai_crypto.

To specify an event from that PMU, use 'perf stat -e pai_crypto/XXX/'.

However the JSON file mentioned in above commit exports the counter
decriptions in file pmu-events/arch/s390/cf_z16/pai.json.  Rename this
file to pmu-events/arch/s390/cf_z16/pai_crypto.json to make the naming
consistent.

Now 'perf list' shows the counter names under pai_crypto section:

  pai_crypto:

    CRYPTO_ALL
         [CRYPTO ALL. Unit: pai_crypto]
    ...

Output before was

  pai:
    CRYPTO_ALL
         [CRYPTO ALL. Unit: pai_crypto]
    ...

Fixes: e0b23af82d6f454c ("perf list: Add PMU pai_crypto event description for IBM z16")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20221021082557.2695382-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pmu-events/arch/s390/cf_z16/{pai.json => pai_crypto.json}     | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/perf/pmu-events/arch/s390/cf_z16/{pai.json => pai_crypto.json} (100%)

diff --git a/tools/perf/pmu-events/arch/s390/cf_z16/pai.json b/tools/perf/pmu-events/arch/s390/cf_z16/pai_crypto.json
similarity index 100%
rename from tools/perf/pmu-events/arch/s390/cf_z16/pai.json
rename to tools/perf/pmu-events/arch/s390/cf_z16/pai_crypto.json
-- 
2.35.1



