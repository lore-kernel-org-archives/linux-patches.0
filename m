Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119233C276E;
	Tue, 21 Jul 2026 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655099; cv=none; b=eJfE5MV2TKRlkDwg87PDD0sFQbUOLUMVMBrBUAPLaQDtlWfDTyYQEUVyrLXVOWaKquaXEUL02KqUdecyOQsvcpTPz5gqOpJHrMaIkdfrG+m/OPbOrRoCFG/vdaQpxc9KvMXUZqiNHRiRVYFyB932Yy0ZNBbaNNzJY5eHYCFR2Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655099; c=relaxed/simple;
	bh=DgkOBmHbT30ZnM3Au0XLOJq3DforLIrlnRaEj0RB/sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPtELbKDeT3ZpsNplhxTKX+fFCYgCYDD2H6SMhZhcJbPkIuQj5OSz9lO2uDCxwLzkYz3Iml3RwhqMvgHb2ueDIFLBAVzeZuShG6ElbFUNzF9oiumgObguleINjjI/LtDxDMfUSZbtmegq4pqwCzjdKtA7IYzrhs2PHkZE6ZC+Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lz8/8cYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lz8/8cYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA2E1F00A3D;
	Tue, 21 Jul 2026 17:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655097;
	bh=x01tF5bq56I+fPdzcfc5pdLFQ3bK8QjWBhTTAUHO4h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lz8/8cYv0gVpJn7QRCT3nQ/3qb/7UTohIVDENM3upbOJKxRM8Ku3c5kl3HtrjZKM4
	 pb2gibUhu1E/PDSPcMy/FK/jLwcArowxYiVxfeZt3HLPRS5MWvW0OERdW10vfuqBEJ
	 +bvVscDJ44mj5g0cG7lkTdoumLrq1Jt5ybPAWX94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 1938/2077] LoongArch: Fix nr passing in set_direct_map_valid_noflush()
Date: Tue, 21 Jul 2026 17:26:51 +0200
Message-ID: <20260721152638.418765216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Wang <wangxuewen@kylinos.cn>

commit 70378a710598432f13509bdc16a1c0f06b3ecb53 upstream.

set_direct_map_valid_noflush() incorrectly passes 1 to __set_memory()
instead of nr. This causes only the first page's attr to be updated when
nr > 1.

Other architectures all pass nr correctly.

Cc: stable@vger.kernel.org
Fixes: 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -234,5 +234,5 @@ int set_direct_map_valid_noflush(struct
 		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
 	}
 
-	return __set_memory(addr, 1, set, clear);
+	return __set_memory(addr, nr, set, clear);
 }


