Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBDC3081C4;
	Mon, 13 Oct 2025 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367428; cv=none; b=FSIfqoGu6hVLNaSW1rr8EVOGeNDNOJa4NWnOzzkSFG1SGrM+orY3Z1aC/uzLiuyr78hnYtpMVByBQ4foj1fcY7C76QAHzKZMJVXZPg66rt+GF7dWvLG6Bssqjkln3c6qi34WxoOTBR9q6KkCJdprXaq74wWc5yBMLS8jzu1Gjw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367428; c=relaxed/simple;
	bh=UmJZt8XDlH0uy9nn4SeSNU3MW0UOqi6Hh4FIoeLwE/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPACYTaU/ZuxnNnvt7ruhHAlYUdWejgtt+Lw2fmKgEUK+zd3YT+A4Re87G7y+8XxnrrWQcb9LrrmZfFAMpSnlWoE7p1vEbuxl4DVe2ZG0ZD8kB1WgnZmMLnkOpsk+oUG86r7CU6nSo/Lmx+fCqzEG+k2nnhPBb4vowq05uHqF08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU6BLKam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU6BLKam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A163C4CEE7;
	Mon, 13 Oct 2025 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367428;
	bh=UmJZt8XDlH0uy9nn4SeSNU3MW0UOqi6Hh4FIoeLwE/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CU6BLKamcg9vom7FaHvM3116CzE6/3yw/tM8qKhGCduLcca1WmSJIS5oJwTJSLtSN
	 ZWtFiOopg1mUDE7dBwiX13sbJGYmtEc4MfjGW9wmFEl00yp7FB1vHOufq+65xvJeSK
	 rbga4xHA+hhtwCmK4LsGPLgkW9/F8M5cXwt3zYh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/196] filelock: add FL_RECLAIM to show_fl_flags() macro
Date: Mon, 13 Oct 2025 16:43:12 +0200
Message-ID: <20251013144315.241039761@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit c593b9d6c446510684da400833f9d632651942f0 ]

Show the FL_RECLAIM flag symbolically in tracepoints.

Fixes: bb0a55bb7148 ("nfs: don't allow reexport reclaims")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/20250903-filelock-v1-1-f2926902962d@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/filelock.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/filelock.h b/include/trace/events/filelock.h
index 1646dadd7f37c..3b1c8d93b2654 100644
--- a/include/trace/events/filelock.h
+++ b/include/trace/events/filelock.h
@@ -27,7 +27,8 @@
 		{ FL_SLEEP,		"FL_SLEEP" },			\
 		{ FL_DOWNGRADE_PENDING,	"FL_DOWNGRADE_PENDING" },	\
 		{ FL_UNLOCK_PENDING,	"FL_UNLOCK_PENDING" },		\
-		{ FL_OFDLCK,		"FL_OFDLCK" })
+		{ FL_OFDLCK,		"FL_OFDLCK" },			\
+		{ FL_RECLAIM,		"FL_RECLAIM"})
 
 #define show_fl_type(val)				\
 	__print_symbolic(val,				\
-- 
2.51.0



