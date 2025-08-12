Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC62A2F5E;
	Tue, 12 Aug 2025 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022654; cv=none; b=XXcv6Psz/NYOMCUvPR+GSQrpIfNYzY/ls0kPmwi/z/HhMhPsziI5d+/VwsYgh3kGN03/OrOfAQs98MDRJ1BDWOFbBxtLOTysx7ZCimml/V4nq0ae++jc6oG005VHxRhq5TUHFE7NTFntm1+gHEk8g21pgzRT3azpDp6edVblsVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022654; c=relaxed/simple;
	bh=AooOgB3AvZ5zXp7nRnHcIEC5PyD4aB8NqN8RE56oaUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6vIqJOOM6gCXYdd/cQ79irQbu4mq7Xu5vWBw6XIFYTHt7zmyRf2kbfco0YKyMqdQDb3hDmXp045d9gs/5vIZmCUzdW+05I3N5Ln2HSbbcX/nnOhdcyspKSnAB5xFKJuSiHBNGUMrjpQVlVkLc/WBQ3O3hv9nnZ2QN8yTdrHYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFB0g2Vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFB0g2Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04799C4CEF0;
	Tue, 12 Aug 2025 18:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022654;
	bh=AooOgB3AvZ5zXp7nRnHcIEC5PyD4aB8NqN8RE56oaUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFB0g2VbAx1RpezIrG9B13y/UoNhnRXdIv5gCzpWgJ7wsDTebWfAYFFzFvKwVji+l
	 GvFsfnFZ1SDLnG8nRZbQDDajaCRxBFRBUSPHoBZGLwD2NkVJ594HYNcr1w/7JuyHxH
	 ETOrKx62bPfB9puo0Vd4+naOxUrbea7Q2qp1WmyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/369] perf tools: Remove libtraceevent in .gitignore
Date: Tue, 12 Aug 2025 19:28:37 +0200
Message-ID: <20250812173023.035324501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit af470fb532fc803c4c582d15b4bd394682a77a15 ]

The libtraceevent has been removed from the source tree, and .gitignore
needs to be updated as well.

Fixes: 4171925aa9f3f7bf ("tools lib traceevent: Remove libtraceevent")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250726111532.8031-1-cp0613@linux.alibaba.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/.gitignore | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index f5b81d439387..1ef45d803024 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -48,8 +48,6 @@ libbpf/
 libperf/
 libsubcmd/
 libsymbol/
-libtraceevent/
-libtraceevent_plugins/
 fixdep
 Documentation/doc.dep
 python_ext_build/
-- 
2.39.5



