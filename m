Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FEA1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21301C433C7;
	Mon, 11 Sep 2023 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441854;
	bh=2tpsvFs4U3Ici1GmdJd8B/tbHn68HNdg4iMgOUtvduU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9SRmsH4Y77A5963Rqk33JRKxfQDnH01OJM/SYCt/s5Gx6BRgxgG2vw6YW8QRH3yj
	 fNtGpG2Inv//7L1BJ5RJIbeObmfKvUE0DNnHerlYhU5jVvEfhrlVoIs2mMPxFQZFDl
	 6hzYPdxHb1a1+d4L7zjTl7IbRJXJ3/kFkaNQJRa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 560/739] coresight: platform: acpi: Ignore the absence of graph
Date: Mon, 11 Sep 2023 15:45:59 +0200
Message-ID: <20230911134706.721707970@linuxfoundation.org>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 3a2888aa1f962c55ca36119aebe67355c7bf54e4 ]

Some components may not have graph connections for describing
the trace path. e.g., ETE, where it could directly use the per
CPU TRBE. Ignore the absence of graph connections

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20230710062500.45147-6-anshuman.khandual@arm.com
Stable-dep-of: 1a9e02673e25 ("coresight: Fix memory leak in acpi_buffer->pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-platform.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index 3e2e135cb8f6d..c8940314cceb8 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -669,8 +669,12 @@ static int acpi_coresight_parse_graph(struct device *dev,
 	struct coresight_connection *new_conn;
 
 	graph = acpi_get_coresight_graph(adev);
+	/*
+	 * There are no graph connections, which is fine for some components.
+	 * e.g., ETE
+	 */
 	if (!graph)
-		return -ENOENT;
+		return 0;
 
 	nlinks = graph->package.elements[2].integer.value;
 	if (!nlinks)
-- 
2.40.1



