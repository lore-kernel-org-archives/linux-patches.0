Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829079;
	b=C3jvN3Jdbb0xbbGPGHlHGZs5UbR1hEKTh0NvbnxT6jEdmUrIMkEWFIVm+HKAGXNdfYkc
	 2UmyAydCesPr4Nm+7eFkwH6UvJWHks201R0Smi5vAlZRUS6lPv/jt4wQbfTkyi5Z2qfov
	 nEj9paByuAkeNeNzMYg7SHhss7ugPErJOhEmXwC80/viat8dUnqo2qSeGmJ/D/YkYWN/K
	 3ImxGS3qZHDMmVQPA6eGsllZEK7kAAOxXT7R9+kiUl/1IgoL2tmFODGk6VHCCtUSs+vM2
	 sEHUyuQJS87JHd6kCmytCXFZoVv7mxVNZueeY5lyYZgwW2zrDL+5O22NetxlYY/wpAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aqeGBaNDNkll2iqaRrxgw/MXwmnRLUJedgoVrHDsoIE=;
	b=I+qfke4M5w2Z6ZTAa+NVuPXbz6UYSt27IJCowRNJ/Auwb1zlImjyePBm1LTEdAonSmSZ
	 Col8I1zTDaLmfpv1uFBhWRx/1jZXosXlpKusilKYfxXRgSlCp83i8TBa5KY4EFOuTYarO
	 sHPICYPf6ouzfkn/lfHZXd/CHvdGOCZWZzjA3z7ZaXwRwItnxo4JNV+44QxvZubJ2FF91
	 30XZlg85ca2/wx0toOSnCRH5dEccTBiXNLUryHn5ZUsO5XgS0P262J+XzJggjZLjGBMI7
	 cM6zbx/cSHJgDYzOEXK7YjEozgxiIhmDRrto1oHCxJhFb7FFyYyapsT62aVNFTjFbxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rgQs/ed5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30AF607032D;
	Wed,  4 Nov 2026 21:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgQs/ed5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7CE1F000C1;
	Wed,  4 Nov 2026 21:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829078;
	bh=aqeGBaNDNkll2iqaRrxgw/MXwmnRLUJedgoVrHDsoIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgQs/ed5AsRU/S/sqwZ8P4tXRXY7/z9Zsw5WwmvPW/MP4qlTcVTpPpCv+Omsz+3d9
	 ZM5Lt47YPW7eD06zgGmUXwSVW1KXV9TF0S4VTFdPwRnLd+6N6GloIEt0+U9Fq0d4X9
	 NDcHIOhu+bsPgROCiAujwKjT73XwuKxSPNphqCjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 429/547] NFSD: Resolve the recall-any mask names in the trace format
Date: Wed,  4 Nov 2026 16:10:13 -0500
Message-ID: <20261104211050.532471774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -358,6 +358,16 @@ TRACE_DEFINE_ENUM(IOMODE_ANY);
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


