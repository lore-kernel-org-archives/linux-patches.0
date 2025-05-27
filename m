Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ACF278754;
	Tue, 27 May 2025 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367277; cv=none; b=blmnKK4LqbvtxWgaVofpwu7hmBcY/ZKg4c2zwfYdSEGZBR7fvbCC17uKebCC6saAVcQS3INCIGh63tvu0lFUDcLyi5JxEa0If5Vkwq6GHe1FNIbIK7mDk+1ucMsihVDs6Y/WT54CSvKhLGRqSLxdQUeHuOA73RXbwtFdj1Kt/UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367277; c=relaxed/simple;
	bh=JCcYiFXz9flKRsLEt/7dfOyBV9/1lkxlz0/RyJAT2aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTgCDLxZ0JgypvUhg3tXX4z+ghUs16mbv7uIqtfWPAAVPNfbZGkrqh+kJfA6Sveoi60e95r6z3vZloI1B3vVbbB2zIVUPgHz6hdpku7ySJYXNGCLl8t+B1sGYncpv7LHuEhsy02wUgmzCT2pjg5bofquqSJpIiFtJKrK3xTAE4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PS5lcDtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PS5lcDtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6227C4CEEA;
	Tue, 27 May 2025 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367277;
	bh=JCcYiFXz9flKRsLEt/7dfOyBV9/1lkxlz0/RyJAT2aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PS5lcDtTmIZXGN+IzH8cOG8GiBQT8VhqQlFpcL+T8m6kRSgdVahOQJuFfuKrhGCVa
	 N1g7YL0OY4VZMOGXzScFsGHvd+MOBMGzLPpHagiu34Iz0CpK92WvbntBdPjpzJTipR
	 nGH/qOk1FjpHB5ADmTllIlPaW+h/smwohZ8o0/sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Daniel Gomez <da.gomez@samsung.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 335/783] drm/xe: xe_gen_wa_oob: replace program_invocation_short_name
Date: Tue, 27 May 2025 18:22:12 +0200
Message-ID: <20250527162526.702179186@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gomez <da.gomez@samsung.com>

[ Upstream commit 89eb42b5539f6ae6a0cabcb39e5b6fcc83c106a1 ]

program_invocation_short_name may not be available in other systems.
Instead, replace it with the argv[0] to pass the executable name.

Fixes build error when program_invocation_short_name is not available:

drivers/gpu/drm/xe/xe_gen_wa_oob.c:34:3: error: use of
undeclared identifier 'program_invocation_short_name'    34 |
program_invocation_short_name);       |                 ^ 1 error
generated.

Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250224-macos-build-support-xe-v3-1-d2c9ed3a27cc@samsung.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gen_wa_oob.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gen_wa_oob.c b/drivers/gpu/drm/xe/xe_gen_wa_oob.c
index 904cf47925aa1..ed9183599e31c 100644
--- a/drivers/gpu/drm/xe/xe_gen_wa_oob.c
+++ b/drivers/gpu/drm/xe/xe_gen_wa_oob.c
@@ -28,10 +28,10 @@
 	"\n" \
 	"#endif\n"
 
-static void print_usage(FILE *f)
+static void print_usage(FILE *f, const char *progname)
 {
 	fprintf(f, "usage: %s <input-rule-file> <generated-c-source-file> <generated-c-header-file>\n",
-		program_invocation_short_name);
+		progname);
 }
 
 static void print_parse_error(const char *err_msg, const char *line,
@@ -144,7 +144,7 @@ int main(int argc, const char *argv[])
 
 	if (argc < 3) {
 		fprintf(stderr, "ERROR: wrong arguments\n");
-		print_usage(stderr);
+		print_usage(stderr, argv[0]);
 		return 1;
 	}
 
-- 
2.39.5



