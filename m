Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BC326B089;
	Thu, 13 Feb 2025 15:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459404; cv=none; b=rFWPPkA7UG6mKWoRUodg3XH+PiTMsuFsWLXwqGeSf1dLNBmahSocK/24a8XrhInqcgiVwfaIdBhe8nou2zE2YvTIFfbVDXWUA3S2hcsiSh1b20CfbzFxqyCCTgTIfdVfmxdzm+LHRIzTMCXmvwbKX1eTooXHSnW1rcruyACsP0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459404; c=relaxed/simple;
	bh=byacqGYzn8R6YJbQwrr6Cd+xXSpALtwqZvuFf7M+foc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7yYZFHA9KABLxSVctsVRtVaH3PV2bkmmcQxd4+xPbCLR6jFhqDQWZiM4nlfBjFhhYduZ/SZY47MG8K/3dIcivs5+hjsvRw5tpC8mPHS85zpR/8DqLYGd8P6Udl3PRZ4dOi7Ko0UTUJ8G/g236Ugo3m6OzKYo5b3c2WTXc6MT5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2vfAGd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2vfAGd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9782BC4CED1;
	Thu, 13 Feb 2025 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459404;
	bh=byacqGYzn8R6YJbQwrr6Cd+xXSpALtwqZvuFf7M+foc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2vfAGd8y7s9iY/kmaxI6Z2kjw9OTfdsZPCnFTEPIFZIS9AO7Uhtkppg7tNP2nhDo
	 tBzBJqGndRFK847mEMVS0h74uCQMjK58k2DPTb/H19UCS96mSpoKgcmNMZOkBsaBcC
	 nkOv5r4ylX/rXxeR+u4job7/zZazIJfsqrCN/qYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Icenowy Zheng <uwu@icenowy.me>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.13 255/443] MIPS: Loongson64: remove ROM Size unit in boardinfo
Date: Thu, 13 Feb 2025 15:27:00 +0100
Message-ID: <20250213142450.456236675@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kexy Biscuit <kexybiscuit@aosc.io>

commit bd2212d658d7659b9d83c7e2f3a06789d4db1e90 upstream.

Per Appendix A.7 in Q/LS 0013-2014 (龙芯CPU开发系统固件与内核接口规范 V2.2,
lit. Loongson DevSys Firmware Kernel Interface Specification V2.2),
interface_info.size is size of this interface, not size of the LEFI BIOS
ROM.

In any case, the BIOS ROM Size just cannot be several kilobytes (KB) on
Loongson64 LEFI platforms.

Reported-by: Mingcong Bai <jeffbai@aosc.io>
Suggested-by: Icenowy Zheng <uwu@icenowy.me>
Fixes: 6c1bfbd9df8c ("MIPS: Loongson64: Add /sys/firmware/lefi/boardinfo")
Cc: stable@vger.kernel.org
Signed-off-by: Kexy Biscuit <kexybiscuit@aosc.io>
Acked-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/loongson64/boardinfo.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/mips/loongson64/boardinfo.c
+++ b/arch/mips/loongson64/boardinfo.c
@@ -21,13 +21,11 @@ static ssize_t boardinfo_show(struct kob
 		       "BIOS Info\n"
 		       "Vendor\t\t\t: %s\n"
 		       "Version\t\t\t: %s\n"
-		       "ROM Size\t\t: %d KB\n"
 		       "Release Date\t\t: %s\n",
 		       strsep(&tmp_board_manufacturer, "-"),
 		       eboard->name,
 		       strsep(&tmp_bios_vendor, "-"),
 		       einter->description,
-		       einter->size,
 		       especial->special_name);
 }
 static struct kobj_attribute boardinfo_attr = __ATTR(boardinfo, 0444,


