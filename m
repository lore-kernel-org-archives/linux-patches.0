Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402DC3112BE;
	Mon, 13 Oct 2025 15:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368093; cv=none; b=uaPLLLyznx+ACfqFla1ahFjIWvg2WWOBsYNkc2Jpy+QzkNHWfoNQ9hntI7vqAQB3l0K7NggU1yZN2gn6O35HxpsDV76ekGPkhIe//dMPZ01SjsZP98iwud93Fdi2+1nE207GCGdjo0O7CiNCvlWmE8n+IrqE+t8KmuNTI1F6o+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368093; c=relaxed/simple;
	bh=8zrh3NYIh7q0KM9Ad7J82K8f+3NTPVCXERFTTr4Sl34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBa0HBBUT8JrTI8PITcjEZWFzYK4BQNi/AyQrP2oq3/nCn9+cNXnHcDwxTSgN64x3zRMrLcmJ3ttGgpIDcK8pWRonL9AXpTjwAR7n946ndTIe1y4mRlip7knmGEzv6BbisngDwVc51Fd36FpoAnn2cWVQ8pT7RPXt4KHNx4k3TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOyPp33T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOyPp33T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5226C4CEE7;
	Mon, 13 Oct 2025 15:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368093;
	bh=8zrh3NYIh7q0KM9Ad7J82K8f+3NTPVCXERFTTr4Sl34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOyPp33TkvD6wbIzTx4xj+1UwpD/SGbZ/B+vi4dksBHyjPHuwbjyyohmfw4Jp4zd1
	 5RhJz2jwcL0CNlIHggMM/2aLT5VnnkAY29Fo+rKfC6x4sI24cpXXK4J4Uwe1Eq9O+B
	 o1PApcFNo8+XxGDEbviV5bRpxoYWUHQb0SNZiTXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/262] vdso: Add struct __kernel_old_timeval forward declaration to gettime.h
Date: Mon, 13 Oct 2025 16:43:04 +0200
Message-ID: <20251013144327.646677871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 437054b1bbe11be87ab0a522b8ccbae3f785c642 ]

The prototype of __vdso_gettimeofday() uses this struct.  However
gettime.h's own includes do not provide a definition for it.

Add a forward declaration, similar to other used structs.

Fixes: 42874e4eb35b ("arch: vdso: consolidate gettime prototypes")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250815-vdso-sparc64-generic-2-v2-1-b5ff80672347@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/vdso/gettime.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/vdso/gettime.h b/include/vdso/gettime.h
index c50d152e7b3e0..9ac161866653a 100644
--- a/include/vdso/gettime.h
+++ b/include/vdso/gettime.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 
 struct __kernel_timespec;
+struct __kernel_old_timeval;
 struct timezone;
 
 #if !defined(CONFIG_64BIT) || defined(BUILD_VDSO32_64)
-- 
2.51.0



