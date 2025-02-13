Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FAD17E00E;
	Thu, 13 Feb 2025 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460559; cv=none; b=JPZsGh4sLjyp7NJm7WUjYKWHY9rEDcd5OljPNOz5gBuKcVaEr2czez/dtKcw9c58aeDBFpdCAFfJz+wwde6e5iata5ERq3FvChK4QGmkz1G17mktXf9GTNNkxOjCTEBvYkxtb4GIZHrEnfM7kBDkG04eAzQiRHVuW9zeLbK8MDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460559; c=relaxed/simple;
	bh=jO7NZt5OmvtLBoMg5PUJ3cGUy3oDsxlpuJ5D7aLcY70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gwqx00yBOQ39siH9FjZRvnrknXeiZF5HrhE0gXHwOuVSZtaHS3XVPdX/nlyyORTVSAZwvueThENr+UGNOHin5icUhhmfzgOobglAV7RYbREvouSczlCq4Sv5GYLTIoUTsiuJrVv07/udOr07A+tR5tz45VSdLpoh4NExVfJaCmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j17v7VGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j17v7VGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FFDC4CEEA;
	Thu, 13 Feb 2025 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460558;
	bh=jO7NZt5OmvtLBoMg5PUJ3cGUy3oDsxlpuJ5D7aLcY70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j17v7VGXJV4GErcfDzbLvjcNS8PHSxbKEneKAv935RVaN5McgEGsPr/I93dGODHO+
	 bvvhL8Dz6uHcmgx3JHdmrTP/CRQLNRY9eARThSuAkiKyLQESXrAP0scMTZOSdfbSsR
	 G5PURMTC//GwWwAwjY5s899kRjdTFBmZcx1sFr7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingcong Bai <jeffbai@aosc.io>,
	Icenowy Zheng <uwu@icenowy.me>,
	Kexy Biscuit <kexybiscuit@aosc.io>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 147/273] MIPS: Loongson64: remove ROM Size unit in boardinfo
Date: Thu, 13 Feb 2025 15:28:39 +0100
Message-ID: <20250213142413.143331569@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


