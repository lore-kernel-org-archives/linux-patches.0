Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55259336EDC;
	Fri, 17 Oct 2025 15:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715216; cv=none; b=fgC5PVTJuvVImYJGJXnRwr3nL2r/mPuiyi6MN1Clr4ns56c6Uv5bAVz6IID10Z8sbmexk9RtLEKjzmHEr5q1Kcv1HWAYNwFZP0h8+4BWUaEDA9QBopwQQhaQcVi42slZyfZVtzQSkV2A8pxxs/jXQ1jeoRwZW1kNVvZIjhO+6hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715216; c=relaxed/simple;
	bh=pFob4Wmzy/DZp59g1gYH+xfIa8bfUH5pwIkLw198wpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5FPiynR0ZQ7FioS+Bmvv7WU6DDZjg9ou0EFhU2Naup7azVjRCQ6np3FrUuwXoBKWtT5k/nS4PIGay1L/p7ZhtM358/Wh7vRaoO3XjGGh0tRSmed0plC0sIX045wREFI3ID09VNYOjpFqKBPMVKbipcOy14bIP1TipFLcFVGbNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZbTB2Eh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZbTB2Eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57FBC113D0;
	Fri, 17 Oct 2025 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715216;
	bh=pFob4Wmzy/DZp59g1gYH+xfIa8bfUH5pwIkLw198wpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZbTB2EhaDXaW2rkFqI2tOc1WeczlPd+XFPnFymiqm0uKb+ebd8KGSycLPM2g4f+o
	 zHLV0fuSjuEnNiVGnQ428SJOmbDRY9BnRKNTb6G5QuOEPZyXfgd/cdhmcrMkQzNPBo
	 HoNzK/+cWdi11XLzGfszT129TcZRgOkOIBPYigho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Ahmed Salem <x0rw3ll@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 139/371] ACPICA: Debugger: drop ACPI_NONSTRING attribute from name_seg
Date: Fri, 17 Oct 2025 16:51:54 +0200
Message-ID: <20251017145206.963242018@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Salem <x0rw3ll@gmail.com>

commit 22c65572eff14a6e9546a9dbaa333619eb5505ab upstream.

ACPICA commit 4623b3369f3aa1ec5229d461e91c514510a96912

Partially revert commit 70662db73d54 ("ACPICA: Apply ACPI_NONSTRING in
more places") as I've yet again incorrectly applied the ACPI_NONSTRING
attribute where it is not needed.

A warning was initially reported by Collin Funk [1], and further review
by Jiri Slaby [2] highlighted another issue related to the same commit.

Drop the ACPI_NONSTRING attribute to fix the issue.

Fixes: 70662db73d54 ("ACPICA: Apply ACPI_NONSTRING in more places")
Link: https://lore.kernel.org/all/87ecvpcypw.fsf@gmail.com [1]
Link: https://lore.kernel.org/all/5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org [2]
Link: https://github.com/acpica/acpica/commit/4623b336
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Ahmed Salem <x0rw3ll@gmail.com>
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/acdebug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpica/acdebug.h
+++ b/drivers/acpi/acpica/acdebug.h
@@ -37,7 +37,7 @@ struct acpi_db_argument_info {
 struct acpi_db_execute_walk {
 	u32 count;
 	u32 max_count;
-	char name_seg[ACPI_NAMESEG_SIZE + 1] ACPI_NONSTRING;
+	char name_seg[ACPI_NAMESEG_SIZE + 1];
 };
 
 #define PARAM_LIST(pl)                  pl


