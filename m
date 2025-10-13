Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A1630CD82;
	Mon, 13 Oct 2025 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369101; cv=none; b=h1O+fdANQB5J+QhQk8p17N6mRIMFQlEgPiOSc0vMHEvYVSHe3xC5eK5M6SBys328fly7vpG0v082fN0OpQiUWZkN7CG8YF+lOmI6xKdsJWgL7RSx1RtzCNr7a64xorbLae3mARMyQ217XeaMCCRWd0fhWaFq0IU+SooFOcOUj4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369101; c=relaxed/simple;
	bh=hemfGLBTH6BcQVQI5v8hVZ05hye5a8wfJBxhtA1SMhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KK8h8puEFfUlim672vMHYOyH0s+IO1kzj5+gI4gmwyf9+VV2K2WUDGwWngyZ1qwOt5qDwr5NpJPRaAhvK0CGtfutwK2M6AiPkTZK3SCxyskzEqIIC8crMUkAx+Y/dmFFTISwoT+EPnDp7YRPE2jkkuR3ggOU/8W0DgQx53Pk1Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xas9Gnz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xas9Gnz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF73FC4CEE7;
	Mon, 13 Oct 2025 15:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369101;
	bh=hemfGLBTH6BcQVQI5v8hVZ05hye5a8wfJBxhtA1SMhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xas9Gnz2hUvke6eWh+zgptoI9geRMOtY/D6yDjG7H4iD2Fn0f4yIyKfxslR37bd4D
	 UeKbgr5C25TK+7+cWLPellCd4HqwLjtooEYHmVKeQhyC3Cg3KgURlQ0zF00tWazdFp
	 w6tgtwLSLzQIIjvd78hCAwcfQ7zMonloi4B+NW5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 095/563] vdso: Add struct __kernel_old_timeval forward declaration to gettime.h
Date: Mon, 13 Oct 2025 16:39:16 +0200
Message-ID: <20251013144414.737176071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



