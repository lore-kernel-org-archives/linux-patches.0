Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EAE3B71C9;
	Sat, 17 Oct 2026 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255566; cv=none; b=iVhAXZRKNgVRnsCStMas8S8V49cSQtmLSDYSI9p5HKNRelZlIljOYW5v/jJ4Jj0BsqQHRhvlN/2OgFA2k5KiBmt/MXpYwkm7T4npF1x3bLVI9LGDErfTY0ObmYq8B8Z2ysECzbe94TenhYtMFrudwmpQKRliJVYYoa7CNJ23ZjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255566; c=relaxed/simple;
	bh=Cmrt9Xf524pxzaQdwQnSdgokbx4DRynVUk5eUse0ccE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVmVh4NsrBA6lk4tKyekICeJpGusesH69Qq9nYHpAGEyVpttEOChQi4r/DawMQe5CovVeQtfJwn24e8UfGxql4oUkNxzSkUpLvy+DMcjhP3VPIrXoy09H015qW4Todsns79mJ/9hyDKTnKqDUJA09vO47t34kfufEMPAW9Pvrz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eS1gUWpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eS1gUWpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B6E1F000C4;
	Sat, 17 Oct 2026 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255565;
	bh=GrfxMwQFF3SENSCWXHfoDdZFQHmBlQPfL1BONwe/994=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eS1gUWpPRbRZgZArZGOK3yQcu+LO11Wguooy/7bQCGFNr54QAhezwdmJst6PbWpd5
	 IHgIkVq1vQtPVb0suRWaKnOpxRgz6BI57WcVHfZu3gGr7kVj+T7GMAcjbCShAXLeqY
	 APDceQ2jZjmfGsM1XQB+6WVe7MhqhsEIRa4Of964=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 818/869] xfs: remove unused trace event xfs_dqreclaim_dirty
Date: Sat, 17 Oct 2026 18:00:59 +0200
Message-ID: <20261017160057.860844527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit b9adb86b9045e6e912035e5991d370ac769be0b8 ]

The tracepoint trace_xfs_dqreclaim_dirty was removed with other code
removed from xfs_qm_dquot_isolate() but the defined tracepoint was not.

Fixes: d62016b1a2df ("xfs: avoid dquot buffer pin deadlock")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 526920b41766b..af12e4c7ecd2d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1097,7 +1097,6 @@ DEFINE_EVENT(xfs_dquot_class, name, \
 	TP_ARGS(dqp))
 DEFINE_DQUOT_EVENT(xfs_dqadjust);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_want);
-DEFINE_DQUOT_EVENT(xfs_dqreclaim_dirty);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_busy);
 DEFINE_DQUOT_EVENT(xfs_dqreclaim_done);
 DEFINE_DQUOT_EVENT(xfs_dqattach_found);
-- 
2.53.0



