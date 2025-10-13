Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895AC30BF7A;
	Mon, 13 Oct 2025 15:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368776; cv=none; b=JlzHBiKMhEuGTZifXP7/YOlNZF7I9KC3IxwIOKS8jeibsSUjv3nFwacboX+URBJRRQpIy6M3GI2R/X6Ek+Rq7WaNVVTc2Wj4ZwsotFH3duSZy6G7TSO7AEkJj9MV4Nqap5i3oGyuIA8koVdIcTiW0UZf57eR5QUajYUWAPR+eK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368776; c=relaxed/simple;
	bh=wuS2QM4fmYhe1GgCMB/vPqu+8KISjuB7oP+yhKkY4Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0m1+HHgpkvFQCu3fdTZojj8mvqam1JhSdCIBPmlyWEE5Sri0ggWI+4m0YhWXUPtToLWPCr7XilLXfgiZv32stlJlYu5J5Dq+yrHQV6IKknDn8X/TukNvwnU3UEkIohDzB/T+wIHHGhIAr2/U2HpWsxuH+rPEBMMVgSBsDBbDqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFDVuVl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFDVuVl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA38C4CEE7;
	Mon, 13 Oct 2025 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368776;
	bh=wuS2QM4fmYhe1GgCMB/vPqu+8KISjuB7oP+yhKkY4Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFDVuVl7PMeiuzQhpTTkVvA/sF487gRb1zC2owSvCHCESwXQJQU7PkQElsyOC7XbZ
	 qu0C3BGZOxcvFU7/PXyxs4CMYu4G2QzeeADP8reLj6DqUcMvv3jJUOvCe7/2yonpJY
	 ac75G+aWA7bEqiyzidvSgngU+rASLnM2GLZbivfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 002/563] filelock: add FL_RECLAIM to show_fl_flags() macro
Date: Mon, 13 Oct 2025 16:37:43 +0200
Message-ID: <20251013144411.374294839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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



