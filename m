Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E055481241;
	Sat, 12 Sep 2026 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237491; cv=none; b=Ot7yY7zz+Nt/ue9LpSsAOs6nh4Av3eS8XD6NySUIRIiUsw6zg4xRYYsETE5terL0i5BbQDY2+0zZZMICXXDLhq3xIdCFe3MgC6wxOn3lfMVmQ/KjNajtGf/FjJ4/KDe2QxWSfB9evoERT6PFJJ9VApSyGyeH/w1zmjW0VpToubM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237491; c=relaxed/simple;
	bh=dPqleARes6q/DH6AK36b6bgrFlFdwlHTnOAy8H6NuWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHwDLLl0uK2nm+IOiE/bTY1vlGXa9x9GOgO8yxG74RsHF+TDUKzx1NdCrtHgKC6M6v+Ysj83wBEwIBo+IkNNmLnrmvV4qcCEvtIui8ShiZELn5mkp7Vj/5G6JvVx+fOAckxyqe/R02a7e2qEmR7JnWUAaYyR4s41jJEO2exc8PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuFcGYec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuFcGYec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998FC1F000FF;
	Sat, 12 Sep 2026 18:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237489;
	bh=bw4gv/QRsVYnZ+iHnN/IUAaM0up5O2i40mXRqLH56Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuFcGYeczu+hyEiYYkvFpVi1ITaC9Q/4fIR8RK+ppTHHCXFoShN2wSaOgrmtpPLRR
	 YqurzsCHn+VWy+SwqOQF/OC2ufjaHNP6YUVQbU5YWHVYLNSrK9GCTjNO3KtJDeKZXZ
	 opjpPVKU/LKGgR2nQHAY1J7BHj48q6T/ERkr1DfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 270/935] parisc: Fix alignment of asm statements in head.S
Date: Sat, 12 Sep 2026 08:55:00 +0200
Message-ID: <20260912065533.014196406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 04cf68c9a76e3c6b67ad056a66a14923abf85925 upstream.

All assembler statements need to be 4-byte aligned. Prevent a possible
misalignment if someone changes the preceeding string and it's length is
then suddenly not a multiple of 4 any longer.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/head.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/kernel/head.S
+++ b/arch/parisc/kernel/head.S
@@ -104,6 +104,7 @@ $iodc_panic:
 	or		%r10,%r10,%r10	/* qemu idle sleep */
 msg1:	.ascii "Can't boot kernel which was built for PA8x00 CPUs on this machine.\r\n"
 msg1_end:
+	.align 4
 
 $cpu_ok:
 #endif


