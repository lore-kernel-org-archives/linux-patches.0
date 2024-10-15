Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9E21D515C;
	Tue, 15 Oct 2024 13:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998436; cv=none; b=OSNFJWHA41DWUjQ7/ZBDHRH18TYaF3PfJ83Bkw6zeEeHw4+mwhEdsPRHPZKJxjNYjMQaduM+Hkdnjiy8gF2GEIGOvza5Oyr+o/wUIBC+4GX3lE/WKmJJ2N+C3dVmRiI9Do5N21eLTCtKP1lWNQzEFz1gdIkYpSemvjeA7IsZ1pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998436; c=relaxed/simple;
	bh=a+24XAy/kKAysv3DpjCscm4b4APuSmcjOQgOX23KDgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fi4zsmFYfuGCxHNZbF15AC/7JZQoz7WC2co+4z1o5aDsnEYBQ1wa2JI/zoooGYhS0QezBcfHf9Xm9LQc5cYqtHiEllv029Lx1Nli9+45IflYlZMECw7stOkSeVkOHnGff19BhFlFkW19XCVTUgldaUNHScQu8lW0vwFtI+11UP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUz4lTsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUz4lTsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D2DC4CEDA;
	Tue, 15 Oct 2024 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998436;
	bh=a+24XAy/kKAysv3DpjCscm4b4APuSmcjOQgOX23KDgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUz4lTsJpB3befBllFkG3m6x385VrD1rqnajlQTK4J/+80x6E9C+vBCF7a17FISys
	 y7pCgMg9jGNKL/0DDZzasiOY7RlzAlX8ZgS+wC4x742bRrYP+MfvWbKPx5JLbRnGwS
	 cS9JigPn7HuLHqHM2T0w06z3PBXu5U0Ir6BAL6Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Markus Boehme <markubo@amazon.com>,
	Sherry Yang <sherry.yang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 445/518] kallsyms: Make module_kallsyms_on_each_symbol generally available
Date: Tue, 15 Oct 2024 14:45:49 +0200
Message-ID: <20241015123934.180932979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

commit 73feb8d5fa3b755bb51077c0aabfb6aa556fd498 upstream.

Making module_kallsyms_on_each_symbol generally available, so it
can be used outside CONFIG_LIVEPATCH option in following changes.

Rather than adding another ifdef option let's make the function
generally available (when CONFIG_KALLSYMS and CONFIG_MODULES
options are defined).

Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 926fe783c8a6 ("tracing/kprobes: Fix symbol counting logic by looking at modules as well")
Signed-off-by: Markus Boehme <markubo@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 329197033bb0 ("tracing/kprobes: Fix symbol counting logic
by looking at modules as well")
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/module.h | 9 +++++++++
 kernel/module.c        | 2 --
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index a55a40c28568e..63fe94e6ae6f1 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -875,8 +875,17 @@ static inline bool module_sig_ok(struct module *module)
 }
 #endif	/* CONFIG_MODULE_SIG */
 
+#if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data);
+#else
+static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+						 struct module *, unsigned long),
+						 void *data)
+{
+	return -EOPNOTSUPP;
+}
+#endif  /* CONFIG_MODULES && CONFIG_KALLSYMS */
 
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/module.c b/kernel/module.c
index edc7b99cb16fa..7f3ba597af6c1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4444,7 +4444,6 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	return ret;
 }
 
-#ifdef CONFIG_LIVEPATCH
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data)
@@ -4475,7 +4474,6 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	mutex_unlock(&module_mutex);
 	return ret;
 }
-#endif /* CONFIG_LIVEPATCH */
 #endif /* CONFIG_KALLSYMS */
 
 /* Maximum number of characters written by module_flags() */
-- 
2.43.0



