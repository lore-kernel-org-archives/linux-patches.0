Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986EB18454A;
	Tue, 30 Jul 2024 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359696; cv=none; b=ksmcsWt1Ylr4IsXnylqeCrlMouINavwdJXq1rQlyCvKfJrn87HWPSwG9lJNfYSSIQGWIMrU69EyAlv0YOTmjvb3roMSAtnpL9Wrf36oBYHqm7cGcDv+5BggHQwadEhR3veVllhQ0weO7W0HfYdlZnRvwGaOQfyNpHhpIvnH4BVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359696; c=relaxed/simple;
	bh=QbehZqxMiyZ+4u6EQ5KtmcqhSIDXxpXXmeAySNc3zD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcMVACb1U8mM4W5srEmBsJBP/klGPOlfd8D9CQwdOAWG74KrdKXByuxPbsnrf0iMjiSmDmD0RicxLPr4LiJHfXY9pVLu1Dipte6G3W47IuDImk8IpwV4ncS6CnRFt+Mjzcef6Tw4MUlLNaqgVwAF1ypWjNHmDJpiOZB3S/fsAHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKIzCOSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKIzCOSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDB3C32782;
	Tue, 30 Jul 2024 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359696;
	bh=QbehZqxMiyZ+4u6EQ5KtmcqhSIDXxpXXmeAySNc3zD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKIzCOSJbqKAt0seujUkSS1ZvJ4q6zbresgKWnx5CmZJuzEeHVT+9Z8uEsvJSCUeI
	 FKpBIteoaGBRFi4QY/TQOuDsQcwHSdl0G3SR4Hs6wi81XfuT/STJbJCpvU/DTFD+ab
	 YDaPMkcNKgOP/pvWDqxG0LfqQkbC70sc7PMNkIDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <keescook@chromium.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sourav Panda <souravpanda@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 520/809] lib: add missing newline character in the warning message
Date: Tue, 30 Jul 2024 17:46:36 +0200
Message-ID: <20240730151745.277909285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit 4810a82c8a8ae06fe6496a23fcb89a4952603e60 ]

Link: https://lkml.kernel.org/r/20240711220457.1751071-1-surenb@google.com
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/alloc_tag.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index abd24016a900e..8c61ccd161ba3 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -122,7 +122,7 @@ static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag
 		  "alloc_tag was not cleared (got tag for %s:%u)\n",
 		  ref->ct->filename, ref->ct->lineno);
 
-	WARN_ONCE(!tag, "current->alloc_tag not set");
+	WARN_ONCE(!tag, "current->alloc_tag not set\n");
 }
 
 static inline void alloc_tag_sub_check(union codetag_ref *ref)
-- 
2.43.0



