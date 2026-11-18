Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053170;
	b=PAzmlqQoSYpiGK1QKsfzP5weAJ9S5bNPpdTAQXCyK8TykSWYWhMlj1489xglX8QPSrKB
	 uU+gEhxCZ8lFooME2FmQBwWJJJiCncGHBF1uiMo79+WVvXYYCa7VIHPoI04lbY3431q4s
	 PZCyZRF21ShZQgdM0qiXWnqfg98/KYjCgrmmjZ7XQbjIrnrIomHJXHOMF1J8GETXJygsM
	 ZJeSQBuo++TiN2GfIMcvBuRZjJm/cLKSAZdowjm1ULQqkc+ev0dqDkiTqRMx1MS2fTqdp
	 veP+O8iN9aTTPo35Roj5PVJqtsP56oGjiuSn3rcEjBDHIiZJ0eNL0bnB6UzTEOQhE/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=44vVyU6na2JNQ5W5BxbO9hZRBrE7zHifyrVCa9N9I4g=;
	b=HtD6BWLSU7sl+KHJFJkdx3XCENduj5s6ufOn6umJAaTPSSi+dz908m9TWP3dX4d1Cw3o
	 Wrz0NY1MfRLBu94w6J7xN421iwZn9rDcH5UpJS0yDdXKN0S//Bv2J26BVIGvkgZ5jziUH
	 dXEphnzVVc+MkTmQT+agRjUniU/HLYX4HT8F2oam9uZBzPVrym8zd+zonKhkvABAI2Ewy
	 8O1f/2IdidrgQ5fsaRln9E+1Svr2+B4RYp+TJx9dBBdDYOR7+MAlIjwnnI5x0fJG8ZP1x
	 iOJGv9ghNSM7Hkxk/D1XnYk/Oes6NanDwy023+AJyMz5gJ80NyiQimaPYPIK7Qsvepw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZy6vEyj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0F7606A320;
	Thu, 19 Nov 2026 01:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZy6vEyj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81191F000C4;
	Thu, 19 Nov 2026 01:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053170;
	bh=44vVyU6na2JNQ5W5BxbO9hZRBrE7zHifyrVCa9N9I4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZy6vEyjDA4l3bId5FDPGC7aWCwnb49iWtwzvShREEg8nwg7iAqXS11f6Y7y/vmrM
	 kEA7lxS7x4BtO1HLXnOdzXVhGgy5iXXs+VANp5zhMD1mXM3nfxpvDiwXrqL3FN0jx2
	 L0xXkjLQ3Mo2mNzFWbXdeHK85lcX/+HmCf9YhSmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0823/2214] NFSD: Resolve the recall-any mask names in the trace format
Date: Wed, 18 Nov 2026 15:41:39 +0100
Message-ID: <20261118150044.628339413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit c563a1f0679566d7d586802e5346591d0af8da78 ]

RCA4_TYPE_MASK_* are enum constants, so the preprocessor cannot fold
them into the print format that show_rca_mask() builds for the
nfsd_cb_recall_any event. Nothing declares an eval map for them
either, so trace_event_eval_update() has no substitution to apply at
module load, and the event's format file ships the enumerator names
verbatim. trace-cmd and perf cannot decode the bmval0 field.

Declare the eval maps for the nine mask bits show_rca_mask() decodes.
The format then carries the shift counts as integers, the same shape
the SUNRPC trace points already emit from their BIT() flag decoders.

Fixes: 638593be55c0 ("NFSD: add CB_RECALL_ANY tracepoints")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260818184151.31180-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/misc/nfs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/trace/misc/nfs.h b/include/trace/misc/nfs.h
index 7d336ba1c34f7..0cf1fb805d33e 100644
--- a/include/trace/misc/nfs.h
+++ b/include/trace/misc/nfs.h
@@ -359,6 +359,16 @@ TRACE_DEFINE_ENUM(IOMODE_ANY);
 		{ IOMODE_RW,			"RW" }, \
 		{ IOMODE_ANY,			"ANY" })
 
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_RDATA_DLG);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_WDATA_DLG);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_DIR_DLG);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_FILE_LAYOUT);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_BLK_LAYOUT);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_OBJ_LAYOUT_MIN);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_OBJ_LAYOUT_MAX);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_OTHER_LAYOUT_MIN);
+TRACE_DEFINE_ENUM(RCA4_TYPE_MASK_OTHER_LAYOUT_MAX);
+
 #define show_rca_mask(x) \
 	__print_flags(x, "|", \
 		{ BIT(RCA4_TYPE_MASK_RDATA_DLG),	"RDATA_DLG" }, \
-- 
2.53.0



