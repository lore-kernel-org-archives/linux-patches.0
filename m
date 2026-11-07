Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061733;
	b=RWxr+W6JAHiGJx1/540HYWBwfzddZ1qiC1TSuxSN9YXoAew9aRHW/yBmTdHGV3penN+S
	 vldNSevz/7ek5QNOGBCdY1/LsD9XcWiCpZuCT4o26F+9yWtNeuRuICziqKR1qpf4v2ZEy
	 ISlyw7h5gj1QeHlfMrRJmf29sX9ukcM2hUj4bH0hkrz1l+QI7+JCOfHE2hBZYiM9QE4eq
	 L0hoKVfOXdwk8RHQUgs22P/Wo+j106Ahcvk2gHwWeqUs6Qy5RIRJVxMFscApZY71LDcr5
	 yJ9EkJkU89fTKt5DvfIMjUtRXRDfE2IEexN0HAygOl0uAQi2ci7uscthX5tJiyMONeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xPczKp8X0mG2XmzKN5iwbPdFU+qKCMK4KkMmR/6NoHg=;
	b=O6mSohymW4bWVWZlv3oMP2htMs4TLhfHf2txLTwIdP2gP5sKlp3VLrBdEkVGcJy8Qxpg
	 pGZ1Lr5KvjkEciVnektLcjvbKrq+TyHHY8VJDVjCOggAMAqjA97rz0LSPRzE9TdFMa2VG
	 fUYZAY0+a5ZEdKBq2mM4hBnjSAhPvYkUIwF3HgE6eAjKnwr8UXgPhQiHEk3oqS7JGjyNy
	 aTTSIUIgFSn1CcVHEVPrD3pqIyMpu1jqtoL6SkRLg9k8FchWOxexG3A7xWefJXIhVNBLo
	 slurovulTi217FrU3FKEQOO8btIf0J3H+ROCoYSniANpJONcyMcgFFXzX+2ao4ZlRdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o67OtZx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF4A606A326;
	Sat,  7 Nov 2026 14:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o67OtZx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999711F008A1;
	Sat,  7 Nov 2026 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061732;
	bh=xPczKp8X0mG2XmzKN5iwbPdFU+qKCMK4KkMmR/6NoHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o67OtZx43dn4j1Z6u8aw3JSaFLR4JsKd8Px6fx3c1K8HZjvQU0c+YVxDDoHGW1+Yk
	 yu9iw5ftmV2RutUjZM1dCjCypbxidFAbawmCwpy/ztrlVaOeigOuxHDwl2gffWhrPJ
	 WhCVQdHg8pr5W6Y2knCvHBEkoOcF7lHBBanuwtSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0774/1536] NFSD: Resolve the recall-any mask names in the trace format
Date: Sat,  7 Nov 2026 08:46:30 -0500
Message-ID: <20261107135019.270006586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


