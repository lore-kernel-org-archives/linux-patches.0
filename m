Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043862;
	b=ZOWfNcEwPmX+Z4kgiKGc79KSNfDtUHFAUZtM3p0gSxw0O3KKSpzCEj662Hty5CxhrCfm
	 BhaWWE0JH3HUc07goI5MWhNYSLnWAUYrhNL99w6Hn5hfQriLkzk6PyCmTMrUQbmq08EBP
	 n5s7dsKy9rkMGJlNZPdO8y5cnyazEfnIkZvNPe6EfoYXi5WyGM3SztC16bHCpMkThE/LB
	 HGlkv3wu5NtaVbbuU7tHsxBed5yk6AUB6onbKScEss0Hv23cw4cfqhYArgKMgtbrNl8Oo
	 iYyRKYSXI6A7zx0UsPiiyQJH10qFMsKPkVo4hnoZ7kRNA937Wy0CEIc7NupPEvsKRmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lhPe+kxNYaWQvZzJEiAZcHjfOWYwcXOi093QTBaI36Q=;
	b=jSqOSJtps0q4PvCCNYNXVDXhYNCQ4rPSLtLu/IlPm6JiuMt1UOv6KTWCY4mNxyCCcDTv
	 4Tovt5IjzJ3OvdayKK1asa/Hv4Y0XoXNTkKnh7aj6Bq+V4n89vnH1r6WUqRcVmVDMIVP4
	 W7K+/X6vbfLDw6JALOibCX8zQC7cMc8doWHBE1mOy7e4QsnPT5S6C916VJROHpsb90tM5
	 695aDX/RHOmD8P/ZUmSA0JdSXJvWY80JZbPNE5aYM5FNo9E+j0tdC8hi5AwhUVSd8ztkF
	 dLQmdmo1RvDziN6J0ApKZNG20X8zqrYBfBCKtTwp1Nb+oP13LCQDTVptx6z0NrgE/uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvPz1CtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C06606A31C;
	Wed, 18 Nov 2026 23:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvPz1CtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724451F000C4;
	Wed, 18 Nov 2026 23:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043862;
	bh=lhPe+kxNYaWQvZzJEiAZcHjfOWYwcXOi093QTBaI36Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvPz1CtAo3nTahgwxtLdYZoTETn+CznvmDj9cn/S534MjbT3cGXJ9373z/OFRh+fe
	 OTE/gQAC+Iw4zIukicNzpzmuX0AB4y0CLuci8S53h/oW2La75voTfCs4fRUMSv46S+
	 mDdhuyTySmk5qqiIyF/u1GB9hzeE1Zc1yMuavJa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0360/2857] lib/string_helpers: Add kstrdup_and_replace() helper
Date: Wed, 18 Nov 2026 15:23:14 +0100
Message-ID: <20261118150214.398773396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 045ad46441a1cf2ff358af0126f8c57f337804fa ]

Duplicate a NULL-terminated string and replace all occurrences of
the old character with a new one. In other words, provide functionality
of kstrdup() + strreplace().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230804143910.15504-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 54745d563114 ("platform/x86: think-lmi: Fix current password length check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/string_helpers.h |  2 ++
 lib/string_helpers.c           | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 8530c73282692..7a1304f71f644 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -103,6 +103,8 @@ char *kstrdup_quotable(const char *src, gfp_t gfp);
 char *kstrdup_quotable_cmdline(struct task_struct *task, gfp_t gfp);
 char *kstrdup_quotable_file(struct file *file, gfp_t gfp);
 
+char *kstrdup_and_replace(const char *src, char old, char new, gfp_t gfp);
+
 char **kasprintf_strarray(gfp_t gfp, const char *prefix, size_t n);
 void kfree_strarray(char **array, size_t n);
 
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index df3ecc167ccf4..2f975395b49e5 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -719,6 +719,21 @@ char *kstrdup_quotable_file(struct file *file, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(kstrdup_quotable_file);
 
+/*
+ * Returns duplicate string in which the @old characters are replaced by @new.
+ */
+char *kstrdup_and_replace(const char *src, char old, char new, gfp_t gfp)
+{
+	char *dst;
+
+	dst = kstrdup(src, gfp);
+	if (!dst)
+		return NULL;
+
+	return strreplace(dst, old, new);
+}
+EXPORT_SYMBOL_GPL(kstrdup_and_replace);
+
 /**
  * kasprintf_strarray - allocate and fill array of sequential strings
  * @gfp: flags for the slab allocator
-- 
2.53.0



