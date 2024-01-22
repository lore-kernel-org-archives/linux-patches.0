Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E99133419;
	Tue, 23 Jan 2024 01:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971853; cv=none; b=PAl7DpELQ44SOXfuQWwCzGy4TXs6mFOhmZRfvnY861vt3hkq7nk11anfszYaVVR8sN1D8lJLx+huf7K4Cu0rBZDuCjdq2SoA+mPe/wWKjJiUN72lKtvaw5/9hnRb6sHhAqav6fJTZukgXMILibd54w63Y0iXcfzFxgnitRxmV6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971853; c=relaxed/simple;
	bh=6eLs79bqc0S3ADdftTsq0hJHhYbBg/hKnWmWE1LdC1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMWOStoxFEEJitwkNkZlQVIEZ3D88s0/R/FDPKlQxseJE2imls5/pFnWM0OEwVIviMwc3vkVLROkOoNyDownC1P/z46vCgXd9O45aY7L0UOEpCSGZmGOkIYbW5AEIQ8F6tLAAs7SyQa2p7BxY8edZ+hs8xT888vAuNRdnLJ6uOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrYBvlCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrYBvlCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100C1C433F1;
	Tue, 23 Jan 2024 01:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971853;
	bh=6eLs79bqc0S3ADdftTsq0hJHhYbBg/hKnWmWE1LdC1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrYBvlCJAsl1NhJAkUFe6uOORWI/dpWfEhfcXFc8Rj9N6XTCCG9RzRx1ilEtESnvq
	 Yoba+/KK5HiHr3ATHxNfuFC3cmozxf/pV9AEjbSeDZfenBFLyB3X9mO935iZfInY1K
	 LsD2bvllOaeFwqCqQx8chdXgHgrWAfzDGbdLxAT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/286] libapi: Add missing linux/types.h header to get the __u64 type on io.h
Date: Mon, 22 Jan 2024 15:59:10 -0800
Message-ID: <20240122235741.457859217@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit af76b2dec0984a079d8497bfa37d29a9b55932e1 ]

There are functions using __u64, so we need to have the linux/types.h
header otherwise we'll break when its not included before api/io.h.

Fixes: e95770af4c4a280f ("tools api: Add a lightweight buffered reading api")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/ZWjDPL+IzPPsuC3X@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/io.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/api/io.h b/tools/lib/api/io.h
index 777c20f6b604..458acd294237 100644
--- a/tools/lib/api/io.h
+++ b/tools/lib/api/io.h
@@ -9,6 +9,7 @@
 
 #include <stdlib.h>
 #include <unistd.h>
+#include <linux/types.h>
 
 struct io {
 	/* File descriptor being read/ */
-- 
2.43.0



