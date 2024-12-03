Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186991F8AC1;
	Tue,  3 Dec 2024 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242450; cv=none; b=WfeIg0GCIKJI7o7O5JMYAaXBCqtJ1ai5E87Dw4aaM0SO5fWc6cc1NhbDWQ0b3rohTcbswDQDKdOio2Sru3c6yvgu+xn9LYuC+ezVeALU7WINRRG7K2A54auG4/usc3OkeDRHXbrGmWMgyA/i60CzylGvCDgr55NBBOY+BzIofC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242450; c=relaxed/simple;
	bh=/IdRcZXmv0p69h2srg6/cN7kkmBHpczsbV2flJikA0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNu4U7YvXxYUA0A/8q+o0xFR49pEE+IMawhfH6Y7Jtt0utJJ0WzO7N1bUZ1ZQSpPrWdp7FZYHLiDM4OweKShFV7KOeONVwfW5JJBu+P4qTRCP1SAArEkSDxEX6fb0tfjpyQy8haJhf8EFyWeust6ePUJKJuFO1ZYASircCroo88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVBPU9ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVBPU9ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87291C4CED6;
	Tue,  3 Dec 2024 16:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242450;
	bh=/IdRcZXmv0p69h2srg6/cN7kkmBHpczsbV2flJikA0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVBPU9ulZFdj3Gp70bkW4PfrpkkNiesQ+/sBdYqWEUnNf+8YIF6/UzysgYPr6bVT+
	 SfUMk/9RTf5vQINcLxIl0BsxaviHjqqYxl85XqHnGBl7j2m0VIcu67m1qBifqV9hgZ
	 SEvBhf7Ii2T+RbBUMcwcBRDcdKKlRxSWCJurnK0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.12 707/826] x86/CPU/AMD: Terminate the erratum_1386_microcode array
Date: Tue,  3 Dec 2024 15:47:14 +0100
Message-ID: <20241203144811.339229999@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kernel/cpu/amd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -798,6 +798,7 @@ static void init_amd_bd(struct cpuinfo_x
 static const struct x86_cpu_desc erratum_1386_microcode[] = {
 	AMD_CPU_DESC(0x17,  0x1, 0x2, 0x0800126e),
 	AMD_CPU_DESC(0x17, 0x31, 0x0, 0x08301052),
+	{},
 };
 
 static void fix_erratum_1386(struct cpuinfo_x86 *c)


