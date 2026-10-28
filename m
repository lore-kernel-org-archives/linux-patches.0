Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212945;
	b=xtExtAWvYhn1vbKIf4hhxhsNDeQygjYeqCMBr0iZ+HCrW4r2jvKgmaUTaFS/0bW7CqdZ
	 JkgzjO8dwX50PFVy+An0/afWBRBBmjelPoUYamiYVb0BbyfZ1QMcu9ATUUpMqeBpzdppn
	 U/tiY68cXS2NYSQHGJg5GvDWks0GD4/hx+XI6AKcPiyj60hxoqElShhPqIdxQU1yOYbel
	 EfXQ5fw3hk75uAE2fGAH0sDr1WvYdNB5YTPGBqW8LCk1hLrz+LfOA2q80Wq5qpoJQWqJK
	 lVKJgv78pIMsfSR/GiIaeyIksQhGKR5vwGxwptqP6nSyeSf/Xe1CdeCxK5cfHuWwtFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WmIcPK6cs4S1UVYIT04qFxkmUskRLb/M2EPwBrRKBak=;
	b=yNRPTaQTdkI5Udm2vHUF1/mlsk41yygPYXdQ3f/GeIMmph64adrLICKFwr4dBkUAufqv
	 VkPdPcm+NJOfVDmy0NSE5TG+t+oV43BxVbto85VIQbuIjXGhKKEB1xKLyFKuUSFiB+gFa
	 DVAgMuQR7+O5weq5Et397iCFwQilMsxAF+P4RV6fIssBVA77yE6KJsI+JnjHyMly6d/of
	 sk83b9gc199VsPQ9Fmysnal9A2L3ZX6Bpv/6XmJjI77NuiAobnRJmYKsmiWcxZvHh/qmg
	 B6I1RicJkv0IKglURczZBVZR9ddgjx/X+6tkziYHhZX/Hw68DlxTz9ANF/VfdZi8JPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f39+bYIH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C3B606A31C;
	Wed, 28 Oct 2026 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f39+bYIH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FF41F01825;
	Wed, 28 Oct 2026 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212945;
	bh=WmIcPK6cs4S1UVYIT04qFxkmUskRLb/M2EPwBrRKBak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f39+bYIHxXWUeLsTWwglkndZipbD38yKWRax1QCfqeQAft1E7yUUnUQ+8CZR10fCS
	 +RsiSsJaJNejq5VeWz19rcpzzYkJUciV7jdxRq8BkcWFFf5uYK2LFQKGM8vDL56R1u
	 iS611pTnxSkCNmNiaOgoTDo4QAOk55TFJ8fUisvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 0331/1887] thunderbolt: Reject oversized XDomain properties responses
Date: Wed, 28 Oct 2026 17:40:27 +0100
Message-ID: <20261028170506.763131376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit 80756e263846ab694984e749e8c626897331438f upstream.

tb_xdp_properties_request() allocates room for 45 data dwords in its
252-byte response buffer.  The XDomain length field is six bits wide,
however, and a malicious peer can set it to 63.  After the fixed response
fields are subtracted, the driver treats this as 48 data dwords.

Commit 322e93448d90 ("thunderbolt: Clamp XDomain response data copy to
allocation size") only bounds the copy against data_len.  If data_len is
at least 48, memcpy() reads 192 bytes from the 180-byte res->data array,
causing a 12-byte heap out-of-bounds read.  Commit 4db2bd2ed478
("thunderbolt: Limit XDomain response copy to actual frame size") limits
the earlier copy but does not constrain this header-derived length.

Reject response data lengths that exceed the allocated source buffer
before copying them into the assembled property block.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -377,6 +377,10 @@ static int tb_xdp_properties_request(str
 
 		len += sizeof(res->hdr.xd_hdr) / 4;
 		len -= sizeof(*res) / 4;
+		if (len > TB_XDP_PROPERTIES_MAX_DATA_LENGTH) {
+			ret = -EINVAL;
+			goto err;
+		}
 
 		if (res->offset != req.offset) {
 			ret = -EINVAL;


