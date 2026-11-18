Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044578;
	b=p+aGYoPMhGS0brZu6yj4D/x3n4qG0yYGo98OQEVt2cLMGwqngT7//pyv1G0akc21do6n
	 GObsWRtaMpuZPrMc2UYM5ba8yvNUrqvZSim9yUS/4AR8Ye7ZgDeMW6T7kVjmGKu0ES0jE
	 9tv1qSf8UlK56hd8UPOIuZ3UZAuPPOscDQ6J1hlmz4zr9cMVFYX5nw6ynIJzM6B9Rt7Pv
	 82+KX9F7p1zC1eaaeMvyyNos9OdPZUssCxSooECMoSBjieo5QuPZ5ZquO1wzyqIHKHg+Y
	 LEPu1aoDg+H3fHXK5JgnIaqA1XUJSSoQKqy5STPYmJqsO3uzT0RWvnFAtkhImzCAA4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lDUFh56MAEW2iBWWS7AUN2OntFtxxpgBdUYLZimGq24=;
	b=OhOvCr3/o3hlhqa8/wppXS2K+6GMYT9KYZO7ol+nwul1Bw4OVJzq7mD3r2UnFhkxsLcq
	 Jnp3fzBBkeQhdcS38vebbX2jYB1yNSyKO4Xuh1AR1r3xGTuu1+oUNpqaOm0fG04wD3CSW
	 pHsPecl+FnrTIQM/25LX71sr6mz89/SlmhNwzMifb4B0UwA5DM3gMrw0gjmYl11hlpP+t
	 WDw/DPWWtg/Ip4MV8TA51Sq5VuWHDAVMw+Jyo9dnNanBFczCmIECLQk40BLLY6I+XT6SO
	 QipwaxqMdB9lX76EMieEV+7GqJhvw7aT8RPhAqjNSEyiIpwpCD/RYv7cKN0tQP39D/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bm7J7cjO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F33C606A320;
	Wed, 18 Nov 2026 23:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bm7J7cjO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB9D1F000C4;
	Wed, 18 Nov 2026 23:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044578;
	bh=lDUFh56MAEW2iBWWS7AUN2OntFtxxpgBdUYLZimGq24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm7J7cjO4OCFXJ6c/0jXrqFyeZGQSi/JSa6KsilYwop1A3xvuBmaHXeoocuNCJX2r
	 tIxpchaP+4aDbu6Ipta+fxKYjarWOB1pWP4sICl/e3D3ilD1WoxKL7j6nKKgXPfcO3
	 BNdkW8BZB7lGTPCUkegWp6o0jKkrTN+2Yk3LtM3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0615/2857] NFSD: Resolve the recall-any mask names in the trace format
Date: Wed, 18 Nov 2026 15:27:29 +0100
Message-ID: <20261118150223.636431624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


