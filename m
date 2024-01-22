Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E99E77638;
	Tue, 23 Jan 2024 02:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975511; cv=none; b=XryuOJ+/hRfRRM2Nzgboo02Yl7aIQofxqHcZ7E6xP5XReFyGXX34eb74W5aB94EeKuy6eJ7Z4pF5BFgnht3+q62LA8Lb1v86PHwJM5OyfzwEXksW6O/hAAa6nyMGo/ENgC5o240ooAO0i/zJqo2PNwk9VGCnAr8folqwum1UU6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975511; c=relaxed/simple;
	bh=SwyqXmuOoQW6FJPMjn3b7CWo7FJrRw/8eOMMvwiXwS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz0P/nLx8FcibU8J3fbzG7IZWZ9LyK8tOlzRkjJ4G4XSBy1Y57OQHJro53rOPc8F0ulNCtvz9jTCr3cnoaoQj/gwLUyV8z4t8AUs1LyU7kL5Qe5E5sP8/2Dst/g9Gydlmhmpe2trIVEG0qawaNcPfR3gDgF181xjTpKJuBb8sVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ho0gm5Af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ho0gm5Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76BFC43390;
	Tue, 23 Jan 2024 02:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975511;
	bh=SwyqXmuOoQW6FJPMjn3b7CWo7FJrRw/8eOMMvwiXwS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ho0gm5AfwOeu+IGXLqbIWIVfsyM+jTn2ipn/QDZjLDn87XeGqft4Bbq0aIkZf+ZD2
	 GFeROP97+n1kMUJrTDazpJFmmBHtM2jdfx2faVNylfmxIT/GruqXV6cSbaXyArzwwj
	 nrVKXoiw4oob3rLztPlqulijQLtjj6Nrlu3yqFIY=
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
Subject: [PATCH 6.6 463/583] libapi: Add missing linux/types.h header to get the __u64 type on io.h
Date: Mon, 22 Jan 2024 15:58:34 -0800
Message-ID: <20240122235826.141485234@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9fc429d2852d..f4a9328035bd 100644
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



