Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7838C1F75B6;
	Tue,  3 Dec 2024 15:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240044; cv=none; b=oJk/lGUoyX9MQmTqPS/5RKF1lQU80qt7kKjfCyZMwjJuTX6ubA1zDCE+eypr6NbfaGN8YamxaA8kLFyqV1yuGKcWKkdIbdtd4VxTN+emuLr+L2v0pyCCS9ygbsxNyHT0b24x/9eLTWy5nGPC7D/6Kyysvg2Cw7WQNm6L8ITleH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240044; c=relaxed/simple;
	bh=xqVIpO7FpDnfYz8pABE71cwzm2zyryIn/YooLXY6gu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOX008kz4kaeljScktceg+4zixIUrqXxQp0MT1rJn16CecCDOouGseO891FiRaD+rukHDcLM1W+T6+RZY4XdOPek3uQPxa5WDw9Pfu/uLZDszlxCHLyv1i4z/CNb1tK5DeXHjNHF0JWm261KUmnCgdhrfTknja7doL063YsXQL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWduCAR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWduCAR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3708C4CED6;
	Tue,  3 Dec 2024 15:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240044;
	bh=xqVIpO7FpDnfYz8pABE71cwzm2zyryIn/YooLXY6gu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWduCAR8vaNq7/5v/ILjZwwwv3wrdVuxVXB5ztmntW3szK8rh2WshJeHZ84nad/Yy
	 cSZaW5JV1sGQPjaosXCHKjT1FDXccSns+4vBr0zQCTCec10cODy5jlKHQ52nmFgFvO
	 peF+VQku7HF5zbLKDm+SpfxxNQzv+1ey6Nr2Lgmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 815/817] tools/power turbostat: Fix childs argument forwarding
Date: Tue,  3 Dec 2024 15:46:27 +0100
Message-ID: <20241203144028.268609082@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>

[ Upstream commit 1da0daf746342dfdc114e4dc8fbf3ece28666d4f ]

Add '+' to optstring when early scanning for --no-msr and --no-perf.
It causes option processing to stop as soon as a nonoption argument is
encountered, effectively skipping child's arguments.

Fixes: 3e4048466c39 ("tools/power turbostat: Add --no-msr option")
Signed-off-by: Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index aa9200319d0ea..a5ebee8b23bbe 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -9784,7 +9784,7 @@ void cmdline(int argc, char **argv)
 	 * Parse some options early, because they may make other options invalid,
 	 * like adding the MSR counter with --add and at the same time using --no-msr.
 	 */
-	while ((opt = getopt_long_only(argc, argv, "MPn:", long_options, &option_index)) != -1) {
+	while ((opt = getopt_long_only(argc, argv, "+MPn:", long_options, &option_index)) != -1) {
 		switch (opt) {
 		case 'M':
 			no_msr = 1;
-- 
2.43.0



