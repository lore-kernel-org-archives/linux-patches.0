Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AF21AAA32;
	Tue,  8 Apr 2025 12:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115790; cv=none; b=h5acrdMJ7XmQFUIgYvDs+eTlj+mw0dfbZSpPSFIDV5uowidmXelWty1Ef+5HHoNJ/nsPIVHnPHDbmmBvHccGZJ5+dkgaUp2ubpW14t4PKeQBw9YQBCbeioKHxrwuS3QM6dzYM5py98HY9iUvJDtCK6n+TwnWYQztbJcbL0UI0oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115790; c=relaxed/simple;
	bh=f/lNBnP38XS/u/yQmFZzIgL1fJSnVC3D9KsyXQlkXzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slque0WVMFlW4SeINtZr+R891S9EfUW/FJ9vtrypTTOI2SroizeaFjUkYHWO3YeBSFuYM6TDvvFDUSkQCERYBkwKBVVCDodWvewlgWoUJLuB5TNtvWmslWz9klj/+EX5uCWjUNJ1FXMjd12zL+4CStjKgzEBrXz/kSR4xF44iII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cStclAe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cStclAe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D13C4CEE5;
	Tue,  8 Apr 2025 12:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115789;
	bh=f/lNBnP38XS/u/yQmFZzIgL1fJSnVC3D9KsyXQlkXzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cStclAe0Iaw3fjbCkLCyyPT2gCkb2WuCPdnkxeLzZWe5Df43Kn6ZnGyPVeiSW39ac
	 27eifEmFVn0jlhtr2dK1AXN207mk1CgxX83b8DPbQCXaa3FyjsQ9fMfc2DuQoWh0FW
	 zRlMs+oN6IPemJG1/f7PZjRVMAOVK2wcMGmiRkh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/204] perf python: Fixup description of sample.id event member
Date: Tue,  8 Apr 2025 12:50:34 +0200
Message-ID: <20250408104823.387341969@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1376c195e8ad327bb9f2d32e0acc5ac39e7cb30a ]

Some old cut'n'paste error, its "ip", so the description should be
"event ip", not "event type".

Fixes: 877108e42b1b9ba6 ("perf tools: Initial python binding")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250312203141.285263-2-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 5be5fa2391de2..9ae5ffea91b48 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -181,7 +181,7 @@ struct pyrf_event {
 };
 
 #define sample_members \
-	sample_member_def(sample_ip, ip, T_ULONGLONG, "event type"),			 \
+	sample_member_def(sample_ip, ip, T_ULONGLONG, "event ip"),			 \
 	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
 	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
 	sample_member_def(sample_time, time, T_ULONGLONG, "event timestamp"),		 \
-- 
2.39.5



