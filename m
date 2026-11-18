Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035493;
	b=ii/rZCTnc93FRDQVn1J/w6m6s7UlWjOWGQY9/yo9aYkbpKIfxFoNpBRq8qXQU63GSbzX
	 8MfTmQwTdGqPoBd4Qxl/Tnz7l0ydCW0isPpLo8V7wRw56bga8lF0LSblXGUarHacQePmr
	 5n/EDrd6Jc37qxDHGYhhF66ynhGVV7+tlHpWU5ZxLdjvH8KKUjzGYD5DBBdXaOufJJyYP
	 qle0JET2WYLhzY3UoSik/7gKVtmptvSSubipvEbsXEVo1yvv8kvTUKiKsX1L2lRwfwfqB
	 VvmdhVCOHTteF4Do6vr4el9Sa5M67SiA6z16kOOYtZ6uae6b5f/4ndpDFttMUzRNYhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ewV3l7cyUs0yWTjVeBjNk8uipTvYIsfgS4Rh3HY0mW8=;
	b=b0nH8ONtO8PktxCWkodQ4KJXVjzgs0bLln40HXCoJoE7VaoExJBFUrQlMfT2Er2fGhyF
	 Bg0KLd9auAgb/3PzYUuamW1EnxJMUvp8IpNklgvcAs52w531SYedXzd+JvLJ90XSjtiX7
	 hw+u+9ObPprGy2+TtC2ZnFGwrRE2GYCbXEMX/sGYrSPMNNDmorSCZS229VqKJKPcBbOaw
	 MtT3Cgx/Jo+RpBgKaNv2qoCv1FWkFgukpIieDoKh0Z0lQ4iSBZo3nfn54Gt0WmoRmwy1v
	 JNvyL1wSKW4ZnNem/1JhzLJwmjNCDzJB+Qbi2Mx63eNhDdCqzN5Pm4XQnVuOuZXyU3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MA22jduo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF4D606A31C;
	Wed, 18 Nov 2026 20:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MA22jduo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D0C1F000C4;
	Wed, 18 Nov 2026 20:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035493;
	bh=ewV3l7cyUs0yWTjVeBjNk8uipTvYIsfgS4Rh3HY0mW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MA22jduoMKgCJN9fbaQPcNr1cWsTgn7FUgjbtdnNTK6g6VpxT7ovr4oZBfFUSEgoO
	 NEZXYhex1A7JUCkAOVWOvMbm5kIMLJ5w7f++J0hDayWy4YUnD6tc/NG8TTWjwmNPh4
	 F7NRhYu48LyvTqFQbeKf5mEjlC4s+dWufTr+4PXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0697/3318] NFSD: Resolve the recall-any mask names in the trace format
Date: Wed, 18 Nov 2026 15:21:59 +0100
Message-ID: <20261118150339.251959107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit c563a1f0679566d7d586802e5346591d0af8da78 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/misc/nfs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

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


