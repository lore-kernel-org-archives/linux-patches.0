Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032871946C8;
	Fri, 17 Oct 2025 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715208; cv=none; b=cQEy+AQz0mxhp5veMRmlPLR7Gyhiz98SMCKCJCQ4hbbCqfT8u4e4onRG3rqGvHxU6KHsV3szA9LZBnpS2MMYVDcGmqClkzLIOlZN5u7mGYCkmFjuXGJLeX0+uy0tWLAeyLtfjYeIbh3y8CU22FbASiVOXBXpaqXy7D/XOsuKdzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715208; c=relaxed/simple;
	bh=48AoGztM5cfLKnNy3g3BBvbCMqeVp5yjkapTG709wJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHdtTB0UOvoilYgntCYZQZD2stQdTTic3E5HTBja1N47Fjd/+QvmyBddA3RhBe2HJshcwGFLyOf4kuO8dtjCIZamdcUgyHNIFG2tri0SQQf9Trf5K6/r7N2tXgXZSq35LUbPu9LcT3T6MeSC5701fHD71s4d+LR8Yg6ru9WsrUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlMXN1Tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlMXN1Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B34C4CEE7;
	Fri, 17 Oct 2025 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715207;
	bh=48AoGztM5cfLKnNy3g3BBvbCMqeVp5yjkapTG709wJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlMXN1TxQ1adnBKI+3V4nyksd93SbzNzzjxg8r1yjMJa7HriF7zJe6EUT8k1WWqyz
	 I9H76PZSHAa5FqZQ1h6kLg8H24XVnit7AdqhtblUxcGtVQQ1mPI43hZzocj0qzBHLj
	 mHKHy1m+Bpkx+nq1Ydplt0gGatKu1aLw5YXOh2Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Collin Funk <collin.funk1@gmail.com>,
	Ahmed Salem <x0rw3ll@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 136/371] ACPICA: acpidump: drop ACPI_NONSTRING attribute from file_name
Date: Fri, 17 Oct 2025 16:51:51 +0200
Message-ID: <20251017145206.848314332@linuxfoundation.org>
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

commit 16ae95800b1cc46c0d69d8d90c9c7be488421a40 upstream.

Partially revert commit 70662db73d54 ("ACPICA: Apply ACPI_NONSTRING in
more places") as I've yet again incorrectly applied the ACPI_NONSTRING
attribute where it is not needed.

A warning was initially reported by Collin Funk [1], and further review
by Jiri Slaby [2] highlighted another issue related to the same commit.

Drop the ACPI_NONSTRING attribute to fix the issue.

Fixes: 70662db73d54 ("ACPICA: Apply ACPI_NONSTRING in more places")
Link: https://lore.kernel.org/all/87ecvpcypw.fsf@gmail.com [1]
Link: https://lore.kernel.org/all/5c210121-c9b8-4458-b1ad-0da24732ac72@kernel.org [2]
Link: https://github.com/acpica/acpica/commit/a6ee09ca
Reported-by: Collin Funk <collin.funk1@gmail.com>
Signed-off-by: Ahmed Salem <x0rw3ll@gmail.com>
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/acpi/tools/acpidump/apfiles.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/power/acpi/tools/acpidump/apfiles.c
+++ b/tools/power/acpi/tools/acpidump/apfiles.c
@@ -103,7 +103,7 @@ int ap_open_output_file(char *pathname)
 
 int ap_write_to_binary_file(struct acpi_table_header *table, u32 instance)
 {
-	char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
+	char filename[ACPI_NAMESEG_SIZE + 16];
 	char instance_str[16];
 	ACPI_FILE file;
 	acpi_size actual;


