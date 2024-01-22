Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E464E1D7;
	Tue, 23 Jan 2024 00:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969944; cv=none; b=dJLLijQoydX+Y1p4YnrcVng9zG9TC1d74bLqAVIX59JUOmkWqFBvEIkAzNyr8B1LaSGdWumaru2VgngR86hkRmwMDOUq1dCemA6vjS4ivUs5mC1ALjscmxw0Zwx2VVvEPj9xRfJc+5xuDLdZNvzEc1hNMBcRxZK2lG86iEgynL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969944; c=relaxed/simple;
	bh=DIOghlFQ5/9LVrejV/h2ZzO2qf3p+qqfjR/j2w6L/m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1wcBkoLAbnVSfvkCAVdInUgax+EFmEsOLBZc9ZLN7Y0JXk5elXdYLoV3iHrDYwv/sa0VIr9WTbDbcbTUsxMbaVx0+UxfWAAOvCXNMcAnzusIr1QKgAwFSa45231I3pQsIX20/tkpKWxzdKCoboILChvstWoZlztIH44jzeDKMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSk659f8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSk659f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F63C43390;
	Tue, 23 Jan 2024 00:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969943;
	bh=DIOghlFQ5/9LVrejV/h2ZzO2qf3p+qqfjR/j2w6L/m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSk659f8eqKwGhW7Sr74H4mi+DCTPN5uCz82lLEKNE1x/70XKzgxdva4+vXIhy7lK
	 8DXy6DjOxLbTPfA90cDQr/e6EEZcSFIr/IouZ3lXA/rn+xUVzYwzvBAKeazHh6lko3
	 FlFOMe6CxQaOeH8kM1wk4v9wnFHxnlYJJvFKqhgQ=
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
Subject: [PATCH 6.7 509/641] libapi: Add missing linux/types.h header to get the __u64 type on io.h
Date: Mon, 22 Jan 2024 15:56:53 -0800
Message-ID: <20240122235834.003977802@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index a77b74c5fb65..2a7fe9758813 100644
--- a/tools/lib/api/io.h
+++ b/tools/lib/api/io.h
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <linux/types.h>
 
 struct io {
 	/* File descriptor being read/ */
-- 
2.43.0



