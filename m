Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061892;
	b=48yJ+w1rNfugR69ZYESu6Sm47xUE1UO661Tb+fkNs/F2m4PPxAxDHpX5gfnUhyxeh4PQ
	 oh5pBAWUGr1pncilmy8jo8g9DZdMRNyaJnnHfvzvOSwJorv606MXFaIAj2LkC5Wxy0wHz
	 XpfyJ3YH/Dv1X+G9Q8LIzn3qeXcFvBo1qzWxd4OfdwCdnBGpTLGCpg1s56AaXeVNwx6Qm
	 uegjmmBi8KpVo6KIHfeyNhDEqv+l94v/YvrPmtu/AqeruEp9c5uAzon2Ain60mELAlYPr
	 tjeeqsDaZg1kATimje7bBY7j1IaYr88zFGa2t8tdFLqQirXnmQSmS6dsqBFy2F0uE5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lOPapeXmtXgUUygB8mP2L6EypOBtkGOthY2kqtbB8gk=;
	b=Lm2g0Y8+OOtpL3HHlQ3FKiYzbpThPWWgfoGHNP9cC8cUvUkpSOVjKhkbnM94vwy/CFmZ
	 0RcirqYBS0ZxKp2ntsukrnB9KHJSvY/ajPFKDoVWapmH5ERRGv24rlYrlGStfHR5GlLIn
	 RYA+B48gvBibYYyovt/3VV0BuQPIgwGLDV+3OJaF1FqunMSlN1NqojqJcpj6V7oURWKly
	 EEcVbJo0LstFZzLSV1aheKtYl3gmy8SD6VvjeEqbguCyrZM7NBsukD/ULGuijGl2o0b2F
	 KekBhbhs15958BWCk0GEBURiiK4ne/k0iIKAQqWk3Ek4/hcLIXvpB5t7AUwB3vSNeAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4vRsw7B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AE9606A326;
	Sat,  7 Nov 2026 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4vRsw7B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D521F008A2;
	Sat,  7 Nov 2026 14:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061891;
	bh=lOPapeXmtXgUUygB8mP2L6EypOBtkGOthY2kqtbB8gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4vRsw7Br22erjPJvfQASZlTfQt9gQykLEQG7R9cJm5sTgDm0NnB+B7SnxBBr70Uj
	 UE/nAbr6eatY8KdxeQ5eBzxcHee7V6cchhUNT0erdjzbXnl7uua58Cbmr3Dn038e9s
	 X4Oop7cLxdqhY15ymVhyKOjsRN9jTfWqH0/iPqk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Michal Simek <monstr@monstr.eu>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0902/1536] microblaze: Fix MB_MANAGER build with older binutils
Date: Sat,  7 Nov 2026 08:48:38 -0500
Message-ID: <20261107135022.967005040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 79c8aa4da3d5453dd956d2170d1c9c716311ea06 ]

Commit 88707ebe77e2 ("microblaze: Add custom break vector handler for mb
manager") added the suspend mnemonic to the MB Manager break handler.

GNU as only learned this mnemonic in binutils 2.42. Linux supports
binutils 2.30, where enabling CONFIG_MB_MANAGER fails:

  arch/microblaze/kernel/entry.S:946: Error: unknown opcode "suspend"

The suspend mnemonic is an alias for mbar 24, and both encode as
0xbb020004. Use the underlying instruction, which GNU as 2.30 already
supports.

Fixes: 88707ebe77e2 ("microblaze: Add custom break vector handler for mb manager")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310310151.UhB396Qs-lkp@intel.com/
Suggested-by: Michal Simek <monstr@monstr.eu>
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260813024026.5402-1-kmehltretter@gmail.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
index 582d7256d8154..ad44341a5dbc7 100644
--- a/arch/microblaze/kernel/entry.S
+++ b/arch/microblaze/kernel/entry.S
@@ -943,7 +943,7 @@ ret_from_break:
 	mbar	1
 	mbar	2
 	bri	4
-	suspend
+	mbar	24 /* suspend */
 	nop
 #endif
 
-- 
2.53.0



