Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61A72F5E;
	Tue, 12 Aug 2025 18:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022415; cv=none; b=mwx0273DGT+7cTvDxoW7HD4bvfrueoBBacojtd3vajxOPpTpMccq+1xOw8p8Psb1nhCVcutvq3rvN94kL+5xpRSW46shudZxvpind5duGVcNXrKoI5EL6zEtQNIviD51UujIa+Eh62a07MKnCSNuMFCn2aqRpps+O+oW2gQdbRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022415; c=relaxed/simple;
	bh=bm9Xe3dT+ZO5ckV1+3TfQ3lGRruGE/rNlLyBE85HCgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7zZ8qkHS9AivPNMRLIYL+/80QXnjs1KGfWLIeJuk179BfcnyckC1Rvyn1UjF10jhPZ2Jxmo/8BQ7cuKuVWMZRVG0evrt7qT+/EA9r1j5h5afyszyjXPWan5Yetp8AsYvELmz3MjwAf1hyepUy76wFb+MPVBrPCpjkvvQGlFzEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBQatSTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBQatSTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49099C4CEF1;
	Tue, 12 Aug 2025 18:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022414;
	bh=bm9Xe3dT+ZO5ckV1+3TfQ3lGRruGE/rNlLyBE85HCgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBQatSTSBhaW116Z507CmeK2NXExC+8RgMxEgvBhpFuo11qWJfypIBETG86cDQY3t
	 XUAsxB11vmGjcOoYX7HTfraULaPxJDLjJ6cKIzFbTkBd736Uib9quQ4XJuikcqNnAI
	 LyTs5xVfHcnkVSqEhz9ObYtxSx4SJkZy0A4kij/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/369] bpf/preload: Dont select USERMODE_DRIVER
Date: Tue, 12 Aug 2025 19:27:26 +0200
Message-ID: <20250812173020.386638099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



