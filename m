Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5EB1F4276;
	Tue,  3 Dec 2024 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239719; cv=none; b=rNDbTBwR0XvSlpQWGv+v43MATU2CQ3Kxb58ZI1tDhcdSY1DNFI0OVEJqAXkmwgDUQun570TMqmFNzXU3pMqNPZ4D8RoU7FzYWPiAoLT4sD4c1h1ib6CL7bIIS/psNTX5JLCSq/y+TYrf2KLPCJN/XWOqo6FSsnehsk7guKMiyVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239719; c=relaxed/simple;
	bh=Zp+a4CpZPzKlldtacAmbQor+hiRiFHCDJmuKG64y3RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJvPsGvYVJ/HYCP4KlYSwE2/rqUqsUTwK+ZBajTroVLW89PhmUgRsGbA/9/ZaF8Nz6XDTIrHaM/xfXVGTqpKd9g5A/Ck51xgHLBSa/lf9+z5WnO+61XZNZXThsGD5cCQz758M1nr5uMi7YCdcw6A9LIcQgKN92LJmiTSa8zT7fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0M5M+9z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0M5M+9z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DB2C4CECF;
	Tue,  3 Dec 2024 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239718;
	bh=Zp+a4CpZPzKlldtacAmbQor+hiRiFHCDJmuKG64y3RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0M5M+9zFRy74Tk/Iyr+HwXUmWL+/mXIhG7b/CJblEHVmbFaMUwFcCqZxYoe1Fsm1
	 ecWY2rXOhwZ0xT4eauUHnYnQx/E1tRU8P9Cbz4o6VK2AGnMPIdb3unodv/6rRP6Xfp
	 sg3dsla2githr3Yp0o/vAy1YFJ2TbbtxFMWU4ESE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.11 709/817] x86/CPU/AMD: Terminate the erratum_1386_microcode array
Date: Tue,  3 Dec 2024 15:44:41 +0100
Message-ID: <20241203144023.658546165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit ff6cdc407f4179748f4673c39b0921503199a0ad upstream.

The erratum_1386_microcode array requires an empty entry at the end.
Otherwise x86_match_cpu_with_stepping() will continue iterate the array after
it ended.

Add an empty entry to erratum_1386_microcode to its end.

Fixes: 29ba89f189528 ("x86/CPU/AMD: Improve the erratum 1386 workaround")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20241126134722.480975-1-bigeasy@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 823f44f7bc94..d8408aafeed9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -798,6 +798,7 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 static const struct x86_cpu_desc erratum_1386_microcode[] = {
 	AMD_CPU_DESC(0x17,  0x1, 0x2, 0x0800126e),
 	AMD_CPU_DESC(0x17, 0x31, 0x0, 0x08301052),
+	{},
 };
 
 static void fix_erratum_1386(struct cpuinfo_x86 *c)
-- 
2.47.1



