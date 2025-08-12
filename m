Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0712FE57E;
	Tue, 12 Aug 2025 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024152; cv=none; b=Y+jHvqpK6elBZviXoOXYBRSV0s4nXG8h8uiMMcUUWtrTyFcBPy2/E6g4XMZ5dixyk8aZsb0nsHb9H6gnvCxNwHtiD/RnxaE2La4e5hETr9BGpc18DWJEjuskb/mMwMwhMg5MLAhU9zIqcjAwO4HnKvt0mylGNabbz7eBzcFvttQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024152; c=relaxed/simple;
	bh=Ksxk4+5W5V5Z1fJ5Mlg8emHAStuaBhn2Q86BvHKFMd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LqGP3RC5d5MaLyIzDh0pxDi03n8EwKscUZ30JZjCliIXGm8clMK+Ss7LMzl2GSaF/nFSRzh4KzY1r88AKt031i4kGdKhthB6+TMtF+2lTBBe8FmChN0ZBPoBxghF9OGzYUBOOScy9R+twXBZQdx0DhiNrb3UueAXBJS7AksBXJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/bIXY5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/bIXY5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83092C4CEF0;
	Tue, 12 Aug 2025 18:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024152;
	bh=Ksxk4+5W5V5Z1fJ5Mlg8emHAStuaBhn2Q86BvHKFMd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/bIXY5AwDiKbzarWyR/U9zyRgjdrf4uKa6pZvIaxPa2/mhqGAmPWz95DfL96s1AV
	 yl8td9MxzKx86MdtfkQDBoInQSx2du4JXsLuTAGYki4w+tm1kzCXCRyhHVjJWu6QSx
	 RrMgU0uJenhTkewmpFHyvwH4X+fYS/2DeL9hPg7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 290/627] bpf/preload: Dont select USERMODE_DRIVER
Date: Tue, 12 Aug 2025 19:29:45 +0200
Message-ID: <20250812173430.345581753@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 2b03164eee20eac7ce0fe3aa4fbda7efc1e5427a ]

The usermode driver framework is not used anymore by the BPF
preload code.

Fixes: cb80ddc67152 ("bpf: Convert bpf_preload.ko to use light skeleton.")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/bpf/20250721-remove-usermode-driver-v1-1-0d0083334382@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/preload/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/preload/Kconfig b/kernel/bpf/preload/Kconfig
index c9d45c9d6918..f9b11d01c3b5 100644
--- a/kernel/bpf/preload/Kconfig
+++ b/kernel/bpf/preload/Kconfig
@@ -10,7 +10,6 @@ menuconfig BPF_PRELOAD
 	# The dependency on !COMPILE_TEST prevents it from being enabled
 	# in allmodconfig or allyesconfig configurations
 	depends on !COMPILE_TEST
-	select USERMODE_DRIVER
 	help
 	  This builds kernel module with several embedded BPF programs that are
 	  pinned into BPF FS mount point as human readable files that are
-- 
2.39.5



