Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EEC26A08A;
	Tue,  8 Apr 2025 12:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114802; cv=none; b=OnzyP94r9+9Jx7kxCx1iyohqQdNVo1C2I5gpdqcGmH6D/9+glfdMMkzm0XzPFsBknrMH9JCX4V00kv+x5UWaPRjk70LhdCH/vyg6XpX27eCnNYbADurQzpox1zX+WvubfPsxcSZ2XThqKC6NmS37GY2jY2JyFKzR3AT1h4MSM7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114802; c=relaxed/simple;
	bh=0eJ2jWnYO3aOWN2XJg/hSmRstbhN4V4Pk03lIysaPTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0n7d04xgbS659XFhpERGR108+G0heRXXDQDdf2sxjLmnSGbnKxYuM/R7YVv/hGn+Dj2bC4m1Bjv4kVWVBRRRiLEoZ1gp+TDSXVkemwymqBEOl2Sd0d22WNQp8RShbwW97paNSrQ0QgPda7ArQIUVLvW3swfOEzUCcL0OXlw9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsYQ6eve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsYQ6eve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5DCC4CEE5;
	Tue,  8 Apr 2025 12:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114802;
	bh=0eJ2jWnYO3aOWN2XJg/hSmRstbhN4V4Pk03lIysaPTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsYQ6eve2G7EAVoDKZ+4F6Hd8hV7rZ7bXdbm65R13bC6obxt2AF3D49o2NOQrOqQq
	 Sq002WG93Rf3vfaNh0GT8CXFf/TAdW4Pq/idcmlSoD8VXW2vvu3yFhqlOiRKjZwCsv
	 UiDRFvcorrndfR3J+MMJCmAx6LFg4eiB7x8dBw88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 239/499] perf units: Fix insufficient array space
Date: Tue,  8 Apr 2025 12:47:31 +0200
Message-ID: <20250408104857.175993622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cf67629f7f637fb988228abdb3aae46d0c1748fe ]

No need to specify the array size, let the compiler figure that out.

This addresses this compiler warning that was noticed while build
testing on fedora rawhide:

  31    15.81 fedora:rawhide                : FAIL gcc version 15.0.1 20250225 (Red Hat 15.0.1-0) (GCC)
    util/units.c: In function 'unit_number__scnprintf':
    util/units.c:67:24: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-initialization]
       67 |         char unit[4] = "BKMG";
          |                        ^~~~~~
    cc1: all warnings being treated as errors

Fixes: 9808143ba2e54818 ("perf tools: Add unit_number__scnprintf function")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250310194534.265487-3-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/units.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/units.c b/tools/perf/util/units.c
index 32c39cfe209b3..4c6a86e1cb54b 100644
--- a/tools/perf/util/units.c
+++ b/tools/perf/util/units.c
@@ -64,7 +64,7 @@ unsigned long convert_unit(unsigned long value, char *unit)
 
 int unit_number__scnprintf(char *buf, size_t size, u64 n)
 {
-	char unit[4] = "BKMG";
+	char unit[] = "BKMG";
 	int i = 0;
 
 	while (((n / 1024) > 1) && (i < 3)) {
-- 
2.39.5



