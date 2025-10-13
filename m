Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB0030FF30;
	Mon, 13 Oct 2025 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367998; cv=none; b=akauGAUUmBUlcjX7NIqXtc5PeMOjHMazdvbEC81NDBusk1Ah1+cyq0/tNeWcuFDJFBvj17HlxzbzuWVkCxVwTkbvOGL0Onqdn4lbxxYwdq369kqgeScntqXIEoYH+LN5+p+WWNotnnuHCpcXMjBn08wZbDT/B6N6kfXWvAhkcv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367998; c=relaxed/simple;
	bh=HXMzytvILtbJWDkfmBPcC5ppuj+VZ0xUWZHgQjse+FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PAf0sD3Job+gME2XsgLDxE5T01Bz4GDO8491a0yeeOVmtseaQ+V1H0nkKLF0x+n5aYM/T1sI0FX9gTq5s5dsxY34Jp6Uy7LmoIre5lV3RMHWtlPm7so10+sxxNAWBUT3WpblE+zbNEOH+I5oIkEuWJlLmZFQmRPCh7K3nDrzchc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfXCWB5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfXCWB5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270C1C4CEE7;
	Mon, 13 Oct 2025 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367998;
	bh=HXMzytvILtbJWDkfmBPcC5ppuj+VZ0xUWZHgQjse+FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfXCWB5q46VTIK6FkDlHLGwoPqt/Eec0wdjX0y0G1+L9/bd3pa573RtxRMcSJGTV9
	 OTSVFs/kgl1kUBIwuMvXnQqMPN5ocTliJ40GdXRz+FpIOPkcJL1y2P17FkkMTytYEl
	 UshZvEGfWlS8a+d4JVe8sbecHP2xWLOGKEjT5LVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 001/262] filelock: add FL_RECLAIM to show_fl_flags() macro
Date: Mon, 13 Oct 2025 16:42:23 +0200
Message-ID: <20251013144326.175103458@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b8d1e00a7982c..2dfeb158e848a 100644
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



