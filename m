Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FB133993;
	Thu, 15 Jan 2026 17:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496929; cv=none; b=Y8pXequO9bOW4a2vE9ytir6IYiBSqaCLbEIrVBBf2VsiCx4w0RFMWS+0uz+kkqkatfexoxi412rCvmXCbefCjefrh5Y0VzEdsKwvDtg8J4PCnrzoj27ng3YKKxNkWZPJg5fWQlCB/5dMWGH70yE7es514B3G44KS1MxrBcYaYhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496929; c=relaxed/simple;
	bh=z1cQXLKQQ4ekzACrUthQ9XDMEXfA1vc7AsqRn2OFkWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOm1t+8siJwQew3fYj9HqAOukuOOO4xzgti0IriIfKRKzmW0nbE65M8SAXwLPPTLnjFfh3pFNlEYKBEQsA5ZWOYiZsZ36YCYutK5ZDWQPZqfCMFuB/xc8VV/yDDgJndHH71CljCF0fysz9JNg9n5dzabbgO5+Vzvlb5IwH3Tk3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xktGfn01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xktGfn01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16067C116D0;
	Thu, 15 Jan 2026 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496929;
	bh=z1cQXLKQQ4ekzACrUthQ9XDMEXfA1vc7AsqRn2OFkWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xktGfn01EywFwPewEPmdb4Or6zlXp8PSkypgyUWwfc45bDXFJfy6vql9d61XhlYCX
	 7XMhic5ZG15ow8TcR0ggWN1Lom7HH/TirMlrBjsBuF4AmyAqhuUxF3esEUUrjj8De6
	 tg6BH906CD1mmibmT52X3BxRlR+ZLXDudvf6Y3SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 65/88] LoongArch: Add more instruction opcodes and emit_* helpers
Date: Thu, 15 Jan 2026 17:48:48 +0100
Message-ID: <20260115164148.663413944@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: Hengqi Chen <hengqi.chen@gmail.com>

commit add28024405ed600afaa02749989d4fd119f9057 upstream.

This patch adds more instruction opcodes and their corresponding emit_*
helpers which will be used in later patches.

Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/inst.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/loongarch/include/asm/inst.h
+++ b/arch/loongarch/include/asm/inst.h
@@ -65,6 +65,8 @@ enum reg2_op {
 	revbd_op	= 0x0f,
 	revh2w_op	= 0x10,
 	revhd_op	= 0x11,
+	extwh_op	= 0x16,
+	extwb_op	= 0x17,
 };
 
 enum reg2i5_op {
@@ -556,6 +558,8 @@ static inline void emit_##NAME(union loo
 DEF_EMIT_REG2_FORMAT(revb2h, revb2h_op)
 DEF_EMIT_REG2_FORMAT(revb2w, revb2w_op)
 DEF_EMIT_REG2_FORMAT(revbd, revbd_op)
+DEF_EMIT_REG2_FORMAT(extwh, extwh_op)
+DEF_EMIT_REG2_FORMAT(extwb, extwb_op)
 
 #define DEF_EMIT_REG2I5_FORMAT(NAME, OP)				\
 static inline void emit_##NAME(union loongarch_instruction *insn,	\
@@ -607,6 +611,9 @@ DEF_EMIT_REG2I12_FORMAT(lu52id, lu52id_o
 DEF_EMIT_REG2I12_FORMAT(andi, andi_op)
 DEF_EMIT_REG2I12_FORMAT(ori, ori_op)
 DEF_EMIT_REG2I12_FORMAT(xori, xori_op)
+DEF_EMIT_REG2I12_FORMAT(ldb, ldb_op)
+DEF_EMIT_REG2I12_FORMAT(ldh, ldh_op)
+DEF_EMIT_REG2I12_FORMAT(ldw, ldw_op)
 DEF_EMIT_REG2I12_FORMAT(ldbu, ldbu_op)
 DEF_EMIT_REG2I12_FORMAT(ldhu, ldhu_op)
 DEF_EMIT_REG2I12_FORMAT(ldwu, ldwu_op)
@@ -695,9 +702,12 @@ static inline void emit_##NAME(union loo
 	insn->reg3_format.rk = rk;					\
 }
 
+DEF_EMIT_REG3_FORMAT(addw, addw_op)
 DEF_EMIT_REG3_FORMAT(addd, addd_op)
 DEF_EMIT_REG3_FORMAT(subd, subd_op)
 DEF_EMIT_REG3_FORMAT(muld, muld_op)
+DEF_EMIT_REG3_FORMAT(divd, divd_op)
+DEF_EMIT_REG3_FORMAT(modd, modd_op)
 DEF_EMIT_REG3_FORMAT(divdu, divdu_op)
 DEF_EMIT_REG3_FORMAT(moddu, moddu_op)
 DEF_EMIT_REG3_FORMAT(and, and_op)
@@ -709,6 +719,9 @@ DEF_EMIT_REG3_FORMAT(srlw, srlw_op)
 DEF_EMIT_REG3_FORMAT(srld, srld_op)
 DEF_EMIT_REG3_FORMAT(sraw, sraw_op)
 DEF_EMIT_REG3_FORMAT(srad, srad_op)
+DEF_EMIT_REG3_FORMAT(ldxb, ldxb_op)
+DEF_EMIT_REG3_FORMAT(ldxh, ldxh_op)
+DEF_EMIT_REG3_FORMAT(ldxw, ldxw_op)
 DEF_EMIT_REG3_FORMAT(ldxbu, ldxbu_op)
 DEF_EMIT_REG3_FORMAT(ldxhu, ldxhu_op)
 DEF_EMIT_REG3_FORMAT(ldxwu, ldxwu_op)


