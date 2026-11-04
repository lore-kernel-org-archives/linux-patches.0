Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829109;
	b=4lpLlMY499jeMbB4tMFmB5w1ZjwZXbECATYwtyoK+tkZw8Jor8r/DeMSHYb4ADldP1tt
	 amFTYDQL7n1R3bmOhRTDzNGHVv/If7LOwv59JoB8+xwWPnCEYcZ0FbHh794l6WwqD7P4T
	 StFbau5KLaCVL+crd7DXMaO5Ph8Pxast2F4kMEAymJrFUab+zXcMtVrkqh2Xpc/RLnUWr
	 yqcPXP8ByV6O1XCgsle1WJ1xj0uger8Ul5S/3eAB/gC61oZLvopOrS7BEgFQx7VDgUUAR
	 VT+ZqxhuoMWEbm+EM2+tnv4kFbTUdXSoYeXOQvi9JFZcpX8vg4SsTFxl8h7csIvlOeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BDOGAd8tcaJlvgCDl6vZR1m+tBTTr+G3/WiBKHK6GTA=;
	b=oSMBCCwRLbZApGPk/K/Eo7jBzRZgpm5zGUdHc4UDcNZJ1jSElxpVJ8DIyjPp3topk8pb
	 UD2FznhcK6feOMhkqETpgePmo3YmJ4ZvR1Fdcawe1fAMY26oenezqt8Z6PcNXRnmBKKuD
	 lO9THKiJOHbP/QQCkDGHqcQ1gTJaiYa3+c6rv72e6HBXvXSFpH9dfFkoSCK5V1ELULWm1
	 TLstHGnmiRrQAD4W9VKVyXvoAqdvygdbp1JEUKhW6nP4Rv1vi3Pi7hB2DR+23S1njAwx7
	 vKSHbAOn2Llq7GLWzYGdWmSX9rvJ0j5pJJ1r4a4fqWQcE9uUAhDE88gRloVTw+Pejcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppYacZej;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D716072FB2;
	Wed,  4 Nov 2026 21:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppYacZej
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A98C1F00A18;
	Wed,  4 Nov 2026 21:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829108;
	bh=BDOGAd8tcaJlvgCDl6vZR1m+tBTTr+G3/WiBKHK6GTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppYacZej1/CzvL3YoayG9r66L23O7yDR8FL8vo45JCq6hpITEi+Wg7VBTLFDY7lkV
	 KEggWrKI7N8a9EiUACvyWcQoTdLoH/MGpitLUUN/VETWrjSsIX66VaA9FT7H+nU5FD
	 nqMd6I/A3kVSFSKnkjlqkxk1MWyRjTNPln0ddeAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 7.3 451/547] x86/cpuid: Mark CPUID function 0x23 as being indexed
Date: Wed,  4 Nov 2026 16:10:35 -0500
Message-ID: <20261104211051.167816105@linuxfoundation.org>
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
@@ -181,6 +181,7 @@ static __always_inline bool cpuid_functi
 	case 0x1d:
 	case 0x1e:
 	case 0x1f:
+	case 0x23:
 	case 0x24:
 	case 0x8000001d:
 		return true;


