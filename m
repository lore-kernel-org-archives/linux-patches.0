Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625071;
	b=Qa+irCyCJfXlNT5bgws6OUWOanOErEXtmTeRzlA6F5gFhnYGvV/ouLTVW4W/dnS+Wkt4
	 kQsA2hrclRTJYcncql4mFzTsE8CvPoDvrBuELLeJP3WSIah3Rda0X01z+u5JeCEAMcM85
	 FsfrOvwh+9Q/iuUVMX5WABoiqYOGt+XTw/NeCMNON2hTAkkywAqbD+qDctC7U+U1kcPIS
	 tVVf5GhytIHXk6l715lF1IMhsEinmsEwB1iQsEJvz31lbWTQ+eC0WOTcoMerGdTzNwsE2
	 YuecZ8OuVXF1mTsRN54T+IS4c+dRJHq2RgqGgDOIjo+XvsnuVvWEoZHg576pUxlhi9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/L68McXKMsTj18Fh5fx5mdm7L/pUtwqJBe1dLrZfLsM=;
	b=XASjFnntVAlj+wiW+LBjiuNk0zEVHY8VfteuVPEuHrZJ4qjez4xONxC2rFuJLeIsnsUw
	 A1djm6V7N0zY54LOnMN4l3vqRsN9WlQVaLm/fdcHUpWD82/t6gmDtVUQzG1bow7pno5f/
	 RvOxtXxLgR1RNWEMeTT754hEtPw0Bdx5dnC6yalgaEJSHibUL6AVGccMhuHgBZfLBGIQG
	 JiifWFKLC7rHo71CKQhGbmwxSdAc3dJeTEZOL+3vEaik15ZaJmZKUbPTZCGdZbOIYQq6B
	 sfeQQImbV9IGSz+fpJZ3LAU/xwqC8u2jD9gwxcKHH1SR2TP+4vJT8K79VG9B0Roc0gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z/ljLrc+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952EA606A321;
	Wed, 25 Nov 2026 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z/ljLrc+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933301F000C0;
	Wed, 25 Nov 2026 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625071;
	bh=/L68McXKMsTj18Fh5fx5mdm7L/pUtwqJBe1dLrZfLsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/ljLrc+FFMiI+7hDCDFzebH/b6cJRk86u/1uRz9zrScYdfAtEuQeSWWm//0VrVMD
	 m+bsxzmffoIUrKZqoqcVNeKgXtQDZTBRzT5GKYRwuBRHc9quLKBIT0MQlryfJ347rk
	 YU9x2hKJu1ycVLQzC+UBnkqqiX/GguBa9xeYqeRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 370/816] x86/cpuid: Mark CPUID function 0x23 as being indexed
Date: Wed, 25 Nov 2026 15:31:58 +0100
Message-ID: <20261125143857.761715821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 108775fa28fe04a16f19a828a779689f3d0ea9f0 ]

Add function 0x23 to the set of CPUID functions that are indexed, as per
the SDM and the many sub-leafs defined in leaf_types.h.

Closes: https://lore.kernel.org/all/213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com
Reported-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261022210134.612848-2-seanjc@google.com
[ sashal: Applied the new case to cpuid_function_is_indexed() in asm/cpuid.h, since the cpuid/api.h header from upstream does not exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpuid.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
index ca4243318aadc..3d37bcf6ac2d3 100644
--- a/arch/x86/include/asm/cpuid.h
+++ b/arch/x86/include/asm/cpuid.h
@@ -179,6 +179,7 @@ static __always_inline bool cpuid_function_is_indexed(u32 function)
 	case 0x1d:
 	case 0x1e:
 	case 0x1f:
+	case 0x23:
 	case 0x24:
 	case 0x8000001d:
 		return true;
-- 
2.53.0



