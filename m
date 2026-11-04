Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831806;
	b=tCLw6eB05IgMu04wN7UeKB/0beipxH0dTR60w0bfNH7DjbDX2V2ecDR7aGkYyjgyIqL/
	 gB3hcZg0VdUZY9/2yfudTr5qECS4kf7O+CuLrAtEeZhgiDbfYfWC4pbz8/OIxlHiVbReS
	 +nPZyVC/pweB0x0jUdUKRJYuME6CYqWe4jdoaUe9wnl6icEi1otHS1Ed3REs5PlbdaEcB
	 BOQpVlTvtxKnM5bn0seT4bJnPCjLQi3LnpDeuemcSyTZjwFcswGjv+cVwd4eqvSI+hpXF
	 ywThGajO3Zx8P68QmzYRWpJZBQMpK3QC1HghdYACFnXl48ilr4Q/ggO1oWVgN5vAoig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ykv065ZGtlKQ+fhAkRS8DC6a4DUXfS/wsBQAR1Qkm6k=;
	b=p8unU+rwiMCbiLjzdvqYKkGdJ9Du44zT6igEapUK2xe9HoG2SaxBUmFieHdbmtET5L+g
	 Xoh6/iwALyKd0YCVs7zx481PeXOm1G6aipXWFr/qqKHw1mNyiWal3YIFyI2Mcwol79ItZ
	 A6V2kT/qfeauVvK7vh2dG1UCc+mSsGvuVBcCxIxpUFyDelcBwu12L0wIoBh51BtkFta6N
	 N4RNTQCbYw8qi1iTtzsF+ZDCQO5WrWvnf18UkhWFr7xS1pP/knGLYGbGDBHo5+CBLltxT
	 cQvKjoFGIIaLztcNRaldBJJBhQWdwWNi1q6+0bbCbN0THO8Mx6JOsXYz7cZ7/Iauxrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSrHx4hq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB55B606A336;
	Wed,  4 Nov 2026 22:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qSrHx4hq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495951F000C1;
	Wed,  4 Nov 2026 22:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831805;
	bh=ykv065ZGtlKQ+fhAkRS8DC6a4DUXfS/wsBQAR1Qkm6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSrHx4hq/+JuaqHwD30TYVOFxq8BAOAuNOZTILeov8s+DZVF8JuKjYDx54Xn5Z6F1
	 P8IxE7Q2U/Bs58E1qt1xGGGbSgiFfkkLBdDaLM1dE78bK0lHdv7qHESPS9XXXGEMwn
	 NCpNqDUkXaW7vaPxYVwDj2GZHYGsPU9rhxf4Quys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 0923/1005] x86/cpuid: Mark CPUID function 0x23 as being indexed
Date: Wed,  4 Nov 2026 16:10:56 -0500
Message-ID: <20261104211109.001468285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 108775fa28fe04a16f19a828a779689f3d0ea9f0 upstream.

Add function 0x23 to the set of CPUID functions that are indexed, as per
the SDM and the many sub-leafs defined in leaf_types.h.

Closes: https://lore.kernel.org/all/213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261022210134.612848-2-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpuid/api.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/cpuid/api.h
+++ b/arch/x86/include/asm/cpuid/api.h
@@ -180,6 +180,7 @@ static __always_inline bool cpuid_functi
 	case 0x1d:
 	case 0x1e:
 	case 0x1f:
+	case 0x23:
 	case 0x24:
 	case 0x8000001d:
 		return true;


