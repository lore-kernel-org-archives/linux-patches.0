Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091F6481B7;
	Mon,  1 Apr 2024 16:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989830; cv=none; b=Zz84iF2X42U2CKdlBZw4JBScVUjBRJDH/njXPR6F7mbttLe8IiQpsSQQWoJLzcQ5LuYHbXev6r6E07hAKyeYp5s6vbrh4qjmMHIbMm9AdLhYuumfvMG3KZ2jFKWEXgujPEijhEDRkO/nVfMpCd2TRpvCYBGNACEiCJYnrKfkZpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989830; c=relaxed/simple;
	bh=CoZfXVrhd/kPcoP35+g/xFWEeSLBhfU4CZ6w48bFwOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=algvFz2bjnY80eTUkmBIVRi3qozwp22Yhjw8qkb+VbN7+klbfovaMiWlTkQ2cdThzfC8v0W1tJmZanlQoCUJ4567Hx2iGRvbnjUTG9Yw0B23jUofjniP9m1oUnqS87DLH0HoGTL3IStTiPcj63vALwoRQDkeNvYoHD4/Jvk63GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTyy0+xA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTyy0+xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68184C433C7;
	Mon,  1 Apr 2024 16:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989829;
	bh=CoZfXVrhd/kPcoP35+g/xFWEeSLBhfU4CZ6w48bFwOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTyy0+xAM0hdrnmZfzOfsFkkz1d6Qdapm35mFP3gcc0nDACUtODmhOmoD2QthmGce
	 QEDZvI+72zlYu0n0RnvjV7XD/U3zAZK2jIBjg+1/nyP+VhHmZrv61c7p4wdDn12sEA
	 tboGug8ckRj6V1JdraAf1nP7rcCwSAN1jt09pzmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/396] x86/CPU/AMD: Update the Zenbleed microcode revisions
Date: Mon,  1 Apr 2024 17:43:35 +0200
Message-ID: <20240401152552.890058529@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 5c84b051bd4e777cf37aaff983277e58c99618d5 ]

Update them to the correct revision numbers.

Fixes: 522b1d69219d ("x86/cpu/amd: Add a Zenbleed fix")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bb3efc825bf4f..031bca974fbf3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1006,11 +1006,11 @@ static bool cpu_has_zenbleed_microcode(void)
 	u32 good_rev = 0;
 
 	switch (boot_cpu_data.x86_model) {
-	case 0x30 ... 0x3f: good_rev = 0x0830107a; break;
-	case 0x60 ... 0x67: good_rev = 0x0860010b; break;
-	case 0x68 ... 0x6f: good_rev = 0x08608105; break;
-	case 0x70 ... 0x7f: good_rev = 0x08701032; break;
-	case 0xa0 ... 0xaf: good_rev = 0x08a00008; break;
+	case 0x30 ... 0x3f: good_rev = 0x0830107b; break;
+	case 0x60 ... 0x67: good_rev = 0x0860010c; break;
+	case 0x68 ... 0x6f: good_rev = 0x08608107; break;
+	case 0x70 ... 0x7f: good_rev = 0x08701033; break;
+	case 0xa0 ... 0xaf: good_rev = 0x08a00009; break;
 
 	default:
 		return false;
-- 
2.43.0



