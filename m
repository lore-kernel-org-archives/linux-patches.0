Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762C284692;
	Wed, 23 Apr 2025 15:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422401; cv=none; b=W5MLPMW50jxy+00o39vhZa5AVNtOEwBdB9jNmRwM5u1XMo3h+MEUX5t4QZMs4T3YFC1s4Bg8FDFgalRZN9WKlSb2IDa/2/o857Ysi70skxjfnX7uWSnP8oRWQ+6mE6wxZtAQR5jeHCH4Bq4o2ct41Mf8OIgOjXnXEKE50wrOeQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422401; c=relaxed/simple;
	bh=wS+q+tuwb5kMB7zN9skvqNNiu9QDUkcPODfBTIQ1Gks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkPH/OwtDPxWmR2IXfXsQRFlkuMU2enXZwzeEzrgzcorx239wS2wum4qJT7IMlKMNFhome8csec/XupIypnU4xXcrl+Zja+Y4o2Q7MAG3jA1Y1fu/k1zZmTiiPHJ4fpftil11G1eUmUilvpUOiezHtkPOs0PSx/+iZAVqDogM7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYt5IEIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYt5IEIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654E1C4CEE2;
	Wed, 23 Apr 2025 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422401;
	bh=wS+q+tuwb5kMB7zN9skvqNNiu9QDUkcPODfBTIQ1Gks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYt5IEIYVikarPCPzPc47Km2rw2OYxNwQwwq2AWBQNXyDGmWfIsWmNmWQ8RlPxWvy
	 rriWjV3sYEQ2EjbASAdAXivetUIj5bOJ/eTWDY0cgKrA1CMkjItvxvf5zEj6TOLbEf
	 Tprq+PZmPSF2irpbm6OdaM3kpwyvL3wwPhBVONrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	stable@kernel.org,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 6.6 336/393] x86/microcode/AMD: Extend the SHA check to Zen5, block loading of any unreleased standalone Zen5 microcode patches
Date: Wed, 23 Apr 2025 16:43:52 +0200
Message-ID: <20250423142657.214465712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 805b743fc163f1abef7ce1bea8eca8dfab5b685b upstream.

All Zen5 machines out there should get BIOS updates which update to the
correct microcode patches addressing the microcode signature issue.
However, silly people carve out random microcode blobs from BIOS
packages and think are doing other people a service this way...

Block loading of any unreleased standalone Zen5 microcode patches.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Cc: Nikolay Borisov <nik.borisov@suse.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20250410114222.32523-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -201,6 +201,12 @@ static bool need_sha_check(u32 cur_rev)
 	case 0xa70c0: return cur_rev <= 0xa70C009; break;
 	case 0xaa001: return cur_rev <= 0xaa00116; break;
 	case 0xaa002: return cur_rev <= 0xaa00218; break;
+	case 0xb0021: return cur_rev <= 0xb002146; break;
+	case 0xb1010: return cur_rev <= 0xb101046; break;
+	case 0xb2040: return cur_rev <= 0xb204031; break;
+	case 0xb4040: return cur_rev <= 0xb404031; break;
+	case 0xb6000: return cur_rev <= 0xb600031; break;
+	case 0xb7000: return cur_rev <= 0xb700031; break;
 	default: break;
 	}
 
@@ -216,8 +222,7 @@ static bool verify_sha256_digest(u32 pat
 	struct sha256_state s;
 	int i;
 
-	if (x86_family(bsp_cpuid_1_eax) < 0x17 ||
-	    x86_family(bsp_cpuid_1_eax) > 0x19)
+	if (x86_family(bsp_cpuid_1_eax) < 0x17)
 		return true;
 
 	if (!need_sha_check(cur_rev))


