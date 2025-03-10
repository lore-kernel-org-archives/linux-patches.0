Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BE922F164;
	Mon, 10 Mar 2025 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629507; cv=none; b=aZVZfd/hNrPQYMhwaZ4oC3Dg6WIRaCasPcHgsw3nCxsog57GV10HorxWEZUGCJpsJQZ9uy3WGnR2ol/NhCoZNQJB/gNW1jNv1Rb+0qpTzgjYBEsCHW/rrccg3Kcc07b01u9D4qyPj2ecb6k1PnVsbJEmtLnFJQ1IW5SW6PCEanA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629507; c=relaxed/simple;
	bh=qt1dIShJdjLD1Yy/4x7rZ8UfA+BKeINNlNHEpXORxps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cTSbPjt3n9gs3iBxo4AKPLvckQNPORXrmAErL0Xe9h0JSVaQpaGW6qnLIOvMrlfPMSUuLea9VA03riodIQl4Bre4e7sIRYWpfrq0Q82RVF6D7PzhdU6QiDXPRUFEQmriLGALLiGmtkmckjL71NxoZES9y4GLYTYotyBw3wn0Chw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxBHmMnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxBHmMnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0AAC4CEE5;
	Mon, 10 Mar 2025 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629507;
	bh=qt1dIShJdjLD1Yy/4x7rZ8UfA+BKeINNlNHEpXORxps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxBHmMnnmOiLf58mQTB0of+egGWX+YEE7K+MdHXYZ/BRHgaumIO5OQbFuMJ/a68Lm
	 Sia3Zuz0A5/uFkW19NWtPqGAfuvXDrQNxZTZuG0JBX6yBlwwNQ7XVuSw2Ziv7UOAyK
	 LISq3bKYyYiOFD6np8W5/2f9HQWTwJEb6VAPy0+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Icenowy Zheng <uwu@icenowy.me>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 287/620] MIPS: Loongson64: remove ROM Size unit in boardinfo
Date: Mon, 10 Mar 2025 18:02:13 +0100
Message-ID: <20250310170556.941218594@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


