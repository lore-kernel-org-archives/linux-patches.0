Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060692;
	b=N9qj3mMNIypE99R3NCnrJ7Qt6WPYzGm04XnBchi0lmp+aOvVPe+aBo0OyOZwQA2JbjS9
	 U1iDHvNG9TEOV91ogyjxdKRgs6okX+Ti0ftq0c993nT6BWVej800xvu4wDldYIkG71nTf
	 CSGNvxXlJ4NwvICqEPyTdrDa+bSLF5aVi1zjzeohGQUmIbGP1gCBCkGi/twvFZpanZOuv
	 iIFSphCzMviU+lGy8ho1PYuc5iw1JTM30esvtn5L+z/lWrWSefG9cO5SoboXbv35xwpKO
	 ZygRDrX0FSfIXVENACQT/NFlxMmeWao0XnlyAE1fiCFUXPBfGm7fmcJGSHWiRlXm7sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LzOBUyXc12OQ4iPODB9jOPdBLYnKpLxoTX2wJPtD6QY=;
	b=Tv4ctNqdq6672kRH8GZoU2N34a1OLzLnamGbbPWhQa0lFlc1AyAUSVRx+Buv8UFUi8qO
	 vBVrPLhSxi909O6HtMyQeAmCXNJavj12aDTH7CQZvqm+KuLnLCnoGTe1R4CH94WWzDiGL
	 1Z/frngc7sYTtUHytbHmIMDTZM0I6klsLl1dLgfSR/WdxFii7XWhlSKvOg6dF1cSNUHTC
	 sgqgSNKX5tOQ6oOeIdZPrib1wdmhfSxfthrYckH++0R/a0LuaRQlkKfzbsbsnnIwm3Vis
	 vcPU8pnWYkECbYggBxlC07k2cnb5F3LHDa8Z431Zmdc5e6u9JxJBuJ1Q+jb1RDsM1Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o4sr1oX/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4F5606A320;
	Thu, 19 Nov 2026 03:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4sr1oX/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61E11F000C4;
	Thu, 19 Nov 2026 03:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060692;
	bh=LzOBUyXc12OQ4iPODB9jOPdBLYnKpLxoTX2wJPtD6QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4sr1oX/MsCzknv4aZ51Xh2OE2MN9LTQKJPFOmt4AYQCKR3LsO/cXeH59QVqA9Ux9
	 G8RrWdNK6oNAopsZKbSuLi4GvK8QDzejhSIOn4pE38wd/sQElRvvWwTrQBXCyDakzS
	 OMKeK4CW0y8AHL6aDNzYIHIgjwHEbN6t2umxuekI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	David Gow <david@davidgow.net>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1248/1848] microblaze: uaccess: Zero out destination on failed get_user()
Date: Wed, 18 Nov 2026 15:54:46 +0100
Message-ID: <20261118150012.045801594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 54c35131e628e1a18f02365495a24a73a1fb515e ]

On failure get_user() is supposed to zero out the destination variable.
This is documented in the kdoc of the microblaze get_user()
implementation and validated in lib/tests/usercopy_kunit.c.

Currently that zeroing is missing.

Add it.

Fixes: 0d6de9532663 ("microblaze_mmu_v2: uaccess MMU update")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: David Gow <david@davidgow.net>
Link: https://patch.msgid.link/20260914-kunit-microblaze-v2-1-7d5756e858f8@weissschuh.net
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/include/asm/uaccess.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index 7c5d92e2915ca..da376aa705a31 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -162,7 +162,8 @@ extern long __user_bad(void);
 #define get_user(x, ptr) ({				\
 	const typeof(*(ptr)) __user *__gu_ptr = (ptr);	\
 	access_ok(__gu_ptr, sizeof(*__gu_ptr)) ?	\
-		__get_user(x, __gu_ptr) : -EFAULT;	\
+		__get_user(x, __gu_ptr) :		\
+		((x) = 0, -EFAULT);			\
 })
 
 #define __get_user(x, ptr)						\
-- 
2.53.0



