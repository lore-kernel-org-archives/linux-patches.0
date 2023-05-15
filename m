Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2141FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F4AC433EF;
	Mon, 15 May 2023 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171227;
	bh=L8hsJ148mhTqbR9e5JMoXQW0eQTs/fqiByvGzhJ+Wf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcyD7994G23zlGWvJjp8GsS1DJ9dBUYKyc0NkX7Pa3564LNlY6fJYcpOpkSqRXI9q
	 7h1ILZ+LQRcgwtBN+UQ7evQQl3X1Q18mZ48B895VIqo7nm+47+vQ534lzr4U42KzAC
	 9lMZUmuqDG3wyQuJuJ0WHAzgl1X7h+mivShq5VUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 102/242] perf pmu: zfree() expects a pointer to a pointer to zero it after freeing its contents
Date: Mon, 15 May 2023 18:27:08 +0200
Message-Id: <20230515161724.963850503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 57f14b5ae1a97537f2abd2828ee7212cada7036e ]

An audit showed just this one problem with zfree(), fix it.

Fixes: 9fbc61f832ebf432 ("perf pmu: Add support for PMU capabilities")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 2bdeb89352e7a..be49be366c05c 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1833,7 +1833,7 @@ static int perf_pmu__new_caps(struct list_head *list, char *name, char *value)
 	return 0;
 
 free_name:
-	zfree(caps->name);
+	zfree(&caps->name);
 free_caps:
 	free(caps);
 
-- 
2.39.2



