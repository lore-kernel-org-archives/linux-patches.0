Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352C323182D;
	Tue, 12 Aug 2025 19:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025456; cv=none; b=d2nxtwjnB5nsESIWHPazSx2rKSCN3RdrpSExDBppcOZM+wd2w2d5DZ1zC/HGxpYguhYhgc7Cnqc0zizb64Gbq+gwJFofbG3GsLxylq1sGxfr+EGIIj59a1ap24jjneuDNAqWF7d/VUx5wBuycceJF5RDgk3PxJRA5QkqNcEsImA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025456; c=relaxed/simple;
	bh=D9tzPZuO6cciqtNyFIk91aWioBRGv3ZNGNJAQfFfVc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p70dajGMBDWqVp/fQty8zvhcIuE2rDg3iGw8lX47lDAa38iO8Ko0M880bS0aZLEh0HbNyc7b5+h5xxgojNNNPT2wABTGw5gXKiMSwU0u76D5HtnCjQ+Cu2TwbwyXWfkgMgjgS75ccNqBTFISXReI99o8yNMaGGOTwvlsKF/5fQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4KEKlUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4KEKlUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985D4C4CEF0;
	Tue, 12 Aug 2025 19:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025456;
	bh=D9tzPZuO6cciqtNyFIk91aWioBRGv3ZNGNJAQfFfVc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4KEKlUhGUQH25E54MhdyM4wJ0E+jdH5K23ETJdALiP0vMOplSbZp17z+xGUDhvAB
	 oaolxNgMwO1N69fLdSjseFwAo+gVyprog3kMnRsvmuPaL42zXgkIIRtPLHkvbzxuUe
	 bueqv4tuNlk4fGQunPx9TERsYM/d/7AbQONc9pbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 012/480] selftests/landlock: Fix readlink check
Date: Tue, 12 Aug 2025 19:43:40 +0200
Message-ID: <20250812174357.813583204@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

[ Upstream commit 94a7ce26428d3a7ceb46c503ed726160578b9fcc ]

The audit_init_filter_exe() helper incorrectly checks the readlink(2)
error because an unsigned integer is used to store the result.  Use a
signed integer for this check.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/aDbFwyZ_fM-IO7sC@stanley.mountain
Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Reviewed-by: Günther Noack <gnoack@google.com>
Link: https://lore.kernel.org/r/20250528144426.1709063-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/audit.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/landlock/audit.h b/tools/testing/selftests/landlock/audit.h
index 18a6014920b5..b16986aa6442 100644
--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -403,11 +403,12 @@ static int audit_init_filter_exe(struct audit_filter *filter, const char *path)
 	/* It is assume that there is not already filtering rules. */
 	filter->record_type = AUDIT_EXE;
 	if (!path) {
-		filter->exe_len = readlink("/proc/self/exe", filter->exe,
-					   sizeof(filter->exe) - 1);
-		if (filter->exe_len < 0)
+		int ret = readlink("/proc/self/exe", filter->exe,
+				   sizeof(filter->exe) - 1);
+		if (ret < 0)
 			return -errno;
 
+		filter->exe_len = ret;
 		return 0;
 	}
 
-- 
2.39.5



