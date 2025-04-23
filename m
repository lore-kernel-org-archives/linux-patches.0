Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ED6280A4F;
	Wed, 23 Apr 2025 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420479; cv=none; b=KO//VeIJtnCRkQVaXGFhhG4Mq7H1CgZcAQEK/Rsv+yRPv2lyQVDKQfugDZm8HSHbYo/HBXbE5mYQuch7iEWVYVz/agHZh0ToyDs3Ue/V0AfyvNr+PMSelRibq6OTA2FJX9dXRmCHQpbeWu8sH0KK7c5SiQMVa/7AkSOCmB3u8PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420479; c=relaxed/simple;
	bh=16+1F53NjAPN2AMalJR8Kf2Ug5MD3j9oEg5gdIYURM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8pI3ImhY7GQBSs9NFsG7vdpZpYbwd3MYN4cL1ez8NQXqiWX6GQJ3s2mJgkPU7SZOv6sEZzVHXAlqvmlbXqd+o6Z4Bh1Xsq0roVewFQzezdmzYrzSfAKP9pZ63xhMtnWX5TYdF2rhjU1Rpw3e/UjhTfgVeVytcMKrtzDGDi55Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLfcFybT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLfcFybT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50758C4CEE2;
	Wed, 23 Apr 2025 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420479;
	bh=16+1F53NjAPN2AMalJR8Kf2Ug5MD3j9oEg5gdIYURM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLfcFybTxS1zaHGkMrnk0iDXTjwdZpBlGcLwM48Guyw/1A5iibjuBTgglTWS7glTS
	 wgb6mxMjEtD2rmrBHpQ0lFtrfrHE4m7Rp/H987cQXBpLDWo2ABZapXj4md5iUkZstx
	 dhvfUOlsY0O7iU4h9DoKo61fj0FvB9WbD1WAqY1I=
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
Subject: [PATCH 6.12 135/223] x86/microcode/AMD: Extend the SHA check to Zen5, block loading of any unreleased standalone Zen5 microcode patches
Date: Wed, 23 Apr 2025 16:43:27 +0200
Message-ID: <20250423142622.591037913@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -199,6 +199,12 @@ static bool need_sha_check(u32 cur_rev)
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
 
@@ -214,8 +220,7 @@ static bool verify_sha256_digest(u32 pat
 	struct sha256_state s;
 	int i;
 
-	if (x86_family(bsp_cpuid_1_eax) < 0x17 ||
-	    x86_family(bsp_cpuid_1_eax) > 0x19)
+	if (x86_family(bsp_cpuid_1_eax) < 0x17)
 		return true;
 
 	if (!need_sha_check(cur_rev))


