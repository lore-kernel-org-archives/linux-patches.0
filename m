Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774458;
	b=GbN8K4P+pGsyAzvlCnxzgCCAzZFw9bKKKHdrtDEFPtFHAwDlkvuCzYzRZiSAqXViYw67
	 bfJjlUnZvb7iyRG03KLE000b7WaKJu+ZJzdHCOliQ8VGyqOeDZQH1EZSyBDNU8dMI3sVL
	 mwHqvm+pJ0m2lcHxqA5O+wIfpaROXCbDGFiGnr6YSXWwgE1kba9RtEyp4JLL8UNLnxKlR
	 OKUe18ZXC8LHtjmHPK1IuX9SnpjYEkEOvx7DDeW7qT21BlYH+lLn/tBCMis+luxZs2w2v
	 cQ5oj2F/QHg3+Rhe9hn9lsXilcLnqUg8iRZ73qag6XVrjSbETMi7FTrQsljDRfVF9mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LeWZvvk9zmemu16i3gPpEAuwp+5GGOawoc+wFmm1ah8=;
	b=kLrL1lXyLtjPefsYU1TZWshhIbYBZ9c5uFmnfogGy24vEUz12ep6aQt5HA7FoemZhmVJ
	 1x7NlDS+Qz0ygO21H5sTn0llhs/r+/0T1BcITyPTTutT+Lvq7nSxAd2t1b81O2qR86K1Y
	 ZVoJPD1+QXGu18qaG/yIMeHrGLv197XISg2t2z2pb8LqfgioS6hKTCqiAojkcBf44eubg
	 YmHlauN1qzWvPbkwi8ZQ+fkqtTudVx12M4M5cyvOUaT4F8whwIIKrkL6sSNzdGEeu6wWn
	 Hb5TZlg2QX/LxONeTerfVn57X01EZGbxHlco0Zun/Dg0Wqmx0nZ+j2rVlm/Vvg78t2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRLsLrEJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E38606A31B;
	Fri, 23 Oct 2026 16:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRLsLrEJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C11C1F01825;
	Fri, 23 Oct 2026 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774458;
	bh=LeWZvvk9zmemu16i3gPpEAuwp+5GGOawoc+wFmm1ah8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRLsLrEJme2IVq/ItUkN+uDc1XA66Of4jYucfdwzgWMD8QA8ovXmZ6I2iLf6aHgzM
	 M8o8db2ezMbF6lJk954pGLT5lw+1gxx//szmBfBoRt0HgWxt4qBMNFZSDMVtr24loN
	 6/sZmY9s8hujJq7JD+uqTXUNykHj4fR8lRiwirg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Tianyu Lan <tiala@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 009/242] x86/hyperv: Avoid using per-cpu output page in hv_apicid_to_vp_index()
Date: Fri, 23 Oct 2026 18:37:31 +0200
Message-ID: <20261023163714.020983452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit 7b74c117e2aac78e0f723e1c9c3644451c56b0d9 ]

hv_apicid_to_vp_index() currently uses the per-cpu hypercall input
and output pages. This function is called when running in VTL2 and
when running in an SEV-SNP CoCo VM with no paravisor. In the former
case, the output page is allocated, but in the latter case it is
not, so the hypervisor stores the output VP index in memory that has
not been allocated by the guest.

Fix this by using the input page for both input and output. The
hypercall has very small input and output, so sharing the same
page for both is straightforward. An alternative fix is to
allocate the per-cpu output page when running in an SEV-SNP CoCo
guest, but this uses significantly more memory, particularly
with larger vCPUs counts.

Fixes: 86c48271e0d6 ("x86/hyperv: Fix APIC ID and VP index confusion in hv_snp_boot_ap()")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 55a8b6de2865a..2d3095a338c1d 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -726,7 +726,8 @@ int hv_apicid_to_vp_index(u32 apic_id)
 	input->partition_id = HV_PARTITION_ID_SELF;
 	input->apic_ids[0] = apic_id;
 
-	output = *this_cpu_ptr(hyperv_pcpu_output_arg);
+	/* Treat input as having 2 APIC IDs so output is 64-bit aligned */
+	output = (void *)input + struct_size(input, apic_ids, 2);
 
 	control = HV_HYPERCALL_REP_COMP_1 | HVCALL_GET_VP_INDEX_FROM_APIC_ID;
 	status = hv_do_hypercall(control, input, output);
-- 
2.53.0



