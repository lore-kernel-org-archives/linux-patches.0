Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620811;
	b=ABmW5Rg08yGm4UPsLhGL5B62aIiRbNE2JaNdaOOSN09gjGj5ppTmw4znHGr/0ySdKvN6
	 c3a9ExORw9QHiGJznxTqwRI2H8clijHuKqtYtqbPPiy0sRLmO6VtBdu7reXnj5UCph/Wj
	 Vbr/iX1ufekuPqq7pivAlnGk/irp6x7x8iRAZTiaG/r5tAuTn7I4n6CZLnllvtHfJUSTw
	 8UkEVK7Sa+U06z9rmUO/gqhOfM5gHXn9djO9B/a2E1Lm4QXvByf6b2f6Z4loNvjcw0jXx
	 YiVtQ4dyD95mEC8ae7coUPIvwim7nHGuP3aEEXMs0aWAvVu+petehvnMlpTeH0xPBmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oSp7ClRe11bXIk7n3bJV9laifQ/BcABJN3RW7dVfiHw=;
	b=pVpN7/e93dXfFO3wL/Iq3Hh5UrFy3SMO4WMW26OyLeRwrjeY0wGx/dCqOyE664uvsqPQ
	 V7JwsQy5AS7ktB9G70QlpQV51gpt5nAmL+DKI5zzBbmFXkNRd+5klT5CFSGVVHjMx9emB
	 1OvcsGeDrKSHVngEsOPd42MRqst8f6jIrGI7oAngvHWV3PAGkpVJ2DfTaTh8WJtqsunov
	 4/sQ/XctTNnNr0ZI5zaDoTqgGH+6gh6apYybCIAsB5OzIEVKQuKBVwBjqHFdLlvt1bdvA
	 7wZPXHqX/DS4cYLE+tU2tUfb95hITd27crfvCRxCtflostW9L7Y1KAC2n32vOtJ8hfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmBY9xbi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DD6606A321;
	Wed, 25 Nov 2026 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmBY9xbi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D811F000C0;
	Wed, 25 Nov 2026 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620810;
	bh=oSp7ClRe11bXIk7n3bJV9laifQ/BcABJN3RW7dVfiHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmBY9xbihCVZqxhQL0roPtoyMnDkBqkWuZeaFRPAPpeIQ3+tonVB9K3WZqCgH9Qch
	 1Fc98Vx16LEj1GOUK2M0+127Gp9MCtxLVtTlc/9nIoQyVGqUreG/I6KN1fWQUS48DM
	 JRE0NoZgzGfbLrzfyzmWrG5FrMZxOwdKblWuLa5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/990] fbdev: clear fb_info->mode before deleting a videomode
Date: Wed, 25 Nov 2026 15:23:18 +0100
Message-ID: <20261125143822.818147400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melbin K Mathew <mlbnkm1@gmail.com>

[ Upstream commit 95e647d2a5304a8fd11f1ba3c8502de700650131 ]

fb_set_var() can delete a mode from info->modelist when userspace
passes FB_ACTIVATE_INV_MODE through FBIOPUT_VSCREENINFO. The code
checks that the mode being deleted is not the current info->var and
that fbcon is not using it, but it does not check fb_info->mode.

fb_info->mode may still point into the modelist entry being deleted.
If the entry is freed, later mode sysfs reads through show_mode() can
dereference a stale pointer.

Clear fb_info->mode before calling fb_delete_videomode() when it
matches the mode being removed.

Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbmem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 1533d43a0a0c9..8f9aa10453436 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -246,8 +246,11 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 		ret = fb_mode_is_equal(&mode1, &mode2);
 		if (!ret) {
 			ret = fbcon_mode_deleted(info, &mode1);
-			if (!ret)
+			if (!ret) {
+				if (info->mode && fb_mode_is_equal(info->mode, &mode1))
+					info->mode = NULL;
 				fb_delete_videomode(&mode1, &info->modelist);
+			}
 		}
 
 		return ret ? -EINVAL : 0;
-- 
2.53.0



