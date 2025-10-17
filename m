Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E3C330B17;
	Fri, 17 Oct 2025 15:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715956; cv=none; b=ehlZBJQsZkp3taJ6FW9K1vWCU8ZK2lCV5Aj2YPD7lQmXzCZAiTft8+BRZLrWfXuJTx9qYiuDCzV/C9snHjGnPH+eW128xuEPdy5HrRlsBnQRgCJH0xx+m+HgU4//48jNEjsDnQXj3iFyv8BeyUiYLkGrId5CXJRXmixAFlpUmoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715956; c=relaxed/simple;
	bh=hu59CXuBHq/wOcdBzC2bWJw093lLqps8jTnxEMl0m8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAsQuxtSUNNA4lCSfjEtZDQlWvEjChEGkikYf/OIkBCwNlcrTinzqU7BzKv3q8kfCUUDaiMQ2j8j0JxN3F3ko22XAUdcjgqfzs8gFMSuqxdPC+djOefMatv8WABGPw4+VKjoXsyHjGY6BtVbGKZ6vBebyyePVxcoQdieYh019Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9UCs+Po; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9UCs+Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D36AC4CEE7;
	Fri, 17 Oct 2025 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715956;
	bh=hu59CXuBHq/wOcdBzC2bWJw093lLqps8jTnxEMl0m8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9UCs+Pod8/zFVKRwcOxYb9h5bwkgK5sXqv5B1gGwOLePoIEA4W4bdvI55cgmy0p2
	 6APdmRQacDxbLHP8uSyH+qwTxh8xZeG63dkWGEdYxI8BpfjUoxsuthBkW4giJ4YuLV
	 vxB2mrgvk03vtkTsok85IvVHU6ZVDuDquSySaQBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/276] filelock: add FL_RECLAIM to show_fl_flags() macro
Date: Fri, 17 Oct 2025 16:51:56 +0200
Message-ID: <20251017145143.250453617@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



