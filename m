Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E55412279;
	Sat, 12 Sep 2026 08:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202194; cv=none; b=T6dK0vTcnb/K3jV8mvTw+UOLvPNVdy57PnUmYqNPJ2jhagXSwKRrIeNR0Zo9fYSt1CMzim201H+YnFeitIzlHaukusme0nWLqBpR0hY38Kan2q6QicPGoRf4D2mhvq0X0fL1g2NmuDQYGRpZ0CYGvP4BxueUstEtutYKdhqs1BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202194; c=relaxed/simple;
	bh=FCvtddeS52R1oGjdlVNa7x6BnY7R316zDTcxEq0huiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqlHhlRdZNjHXeX/jIDGCHJ/WGJFwIT08pYSoQC6PyVzqO63CPlr4GP9U4OqhGsQK02/K15UZF8HjDblYcjK85ExifMS/xjhoucDh5BgTqkY5hkcRJtWO/U+62CrRrf+JFIr6JfZ46a+A66iNomNxcYAneXtZZhfVP1hI3UT+4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPEtb46m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPEtb46m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF661F000FF;
	Sat, 12 Sep 2026 08:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202192;
	bh=s00mPdV2+EKIYSJ5xQsQzAboeYRCKHyoGRJnRmOjQGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPEtb46mE81UuUTVDwSnPLfZ5jkgSXJXm/IssIemUSeoM4H+bV9UK448mZ0nKUSS5
	 kl9lL2YEHxELy2EZBfvPVrtKzPDQxn/l04Gv2yIGTRx1ZfLeceIgtMY1+wQj2wW26z
	 gj7z9c5305BcdYf3G7lPRkHJpt3lmJPt3Hz7uIDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1153/1815] tools: Ensure tools copy of linux/filter.h exports the UAPI
Date: Sat, 12 Sep 2026 08:48:23 +0200
Message-ID: <20260912065716.080556975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 7a1f400ff5e57f41e23c8145a54ea084039b023c ]

Normally when there is an include/foo.h and an include/uapi/foo.h the
non-UAPI copy includes the UAPI copy.  This is the case for the in
kernel copy of linux/filter.h but not for the copy in tools/ which
results in build breaks for the newly added arm64
seccomp_ptrace_x0_bypass selftest.  Add an explicit include of the uapi
to fix the test and avoid future surprises.

Fixes: 2fcbc4adf997 ("kselftest/arm64: Add seccomp ptrace x0 bypass test")
Fixes: f143c11bb7b9 ("tools: bpf: Use local copy of headers including uapi/linux/filter.h")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/filter.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/linux/filter.h b/tools/include/linux/filter.h
index bcc6df79301ae..4ead4e72097c1 100644
--- a/tools/include/linux/filter.h
+++ b/tools/include/linux/filter.h
@@ -6,6 +6,7 @@
 #define __TOOLS_LINUX_FILTER_H
 
 #include <linux/bpf.h>
+#include <uapi/linux/filter.h>
 
 /* ArgX, context and stack frame pointer register positions. Note,
  * Arg1, Arg2, Arg3, etc are used as argument mappings of function
-- 
2.53.0



