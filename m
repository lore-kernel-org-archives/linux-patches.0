Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0139CCFC;
	Fri,  7 Aug 2026 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117342; cv=none; b=fqcO0BvBgUlEIE0FIeb32PxOLJgZJjdDeLJNyLgUta1ilAtd5D/wxL5119wy07uFSrB/BUe67LT9xob7lfsBjyk+jKZged0GpDfgrb9TBL/z6ZZ6+SwydYSd8A0ksKd5TIS2OjCa+Jz0F8Vh6c0jYgNjFnMxk9trSAQkgxyOjDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117342; c=relaxed/simple;
	bh=pUCzNcJLBwB60rfr6MTnItH3FnvUwl81T31aJrzCnEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghznFWatIEujQcCmb8XHnIfKtfeYdLFcOKYQP2dxhYGuXuVBthrLWwgry7WlDdr2XPevzC/AmTAba0SgS3h1D3vRN9H6iVS1gVsw1Y5mDButmQ24fbppORlo3ruPRuGguGzVZV1dSIgnH8RRMVxuU5WBhb+5xlWvfuL2rZmDF2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9HYzpBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9HYzpBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A3A1F000E9;
	Fri,  7 Aug 2026 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117341;
	bh=sWD8zWPG/4OZpHrQn8ai0QqIdmIVrJQUpkfnWl+HANM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9HYzpBKXUXg0BQT3m8149T9Jn6qS6jN2ZFsmzNhksJuGzKawfK9aH2evOcc/Kjfs
	 C1lArWHqHXgPKg4DUgpvlnvpDrJgKoEKXJbb1EhDog1UJvM1uDksK7UXyYYsXPfTtn
	 0l2m0J3maNDYVXpdG9kgmQAY4+AvAEel64bOsEJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 7.1 285/438] x86/CPU/AMD: Carve out a Zen5 models range
Date: Fri,  7 Aug 2026 16:38:01 +0200
Message-ID: <20260807143434.055416583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>

commit 52075128273ace53e6254e37899a47d40d4baf45 upstream.

Family 0x1a, model 0xd0..0xd7 belongs to the Zen5 generation. Carve it
out from the larger, Zen6 range where former doesn't belong.

  [ bp: Rewrite commit message, add tags. ]

Fixes: b5f53e6d3d32 ("x86/CPU/AMD: Add more Zen6 models")
Signed-off-by: Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260729055459.15904-1-Pratik.Vishwakarma@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -514,11 +514,13 @@ static void bsp_init_amd(struct cpuinfo_
 		case 0x00 ... 0x2f:
 		case 0x40 ... 0x4f:
 		case 0x60 ... 0x7f:
+		case 0xd0 ... 0xd7:
 			setup_force_cpu_cap(X86_FEATURE_ZEN5);
 			break;
 		case 0x50 ... 0x5f:
 		case 0x80 ... 0xaf:
-		case 0xc0 ... 0xef:
+		case 0xc0 ... 0xcf:
+		case 0xd8 ... 0xef:
 			setup_force_cpu_cap(X86_FEATURE_ZEN6);
 			break;
 		default:


