Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A45F44AB7B;
	Tue, 21 Jul 2026 22:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671818; cv=none; b=udobs4jY+zkY4ttfKFNLUj0/IB0LGp0FHbvFkvKmOat5NB0G4lH8I/XFPn+d1X+/EWrJ2Pu9L/ccJP2uFDHkWUF9CBPyFoy/p32cjH5d0TOdXRjqJOo2EY6s/X/Cjy7o64P/Rnwu+Uz3iwhhAmKlBs9qlmXhkGJl72JNudCMdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671818; c=relaxed/simple;
	bh=z0b1G8KZrtTgtqcYQtrZK3WYdCFMdUqy9KLmj9l6+zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otTzcnLqfzSZ8/M4r46jKgL78p1yiwhHZyfnrYhHXUsBZE/q3ttwMH3ob5SaDt6YP9JZe3z6hxH0al6ca8vf3RIyCfZqDiTjMedGlUX4eiaQSG6j+GH9leerfM9QnAcxulLkXtD8Z793f77FPkDVw9KTev+P+mU265+O+78F5sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUzlINRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUzlINRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B54B1F000E9;
	Tue, 21 Jul 2026 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671817;
	bh=Y0gm39UAm8VrxJ1VWSdb6C51+I9dlx5obTq5DdnhBMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUzlINRVC7ROiw3F2LMViEZxu4JMIH/nhh+gfqiTk6sg4tmLSFD9BCgVJWIypqYlE
	 8VA+HR4v64bvVQkmMLcjDQeA/TatMcjLbMe6md5V3rP46BrTQ/zdoh36NhE94UO3Sj
	 dFOLbzBfOaKr6d02nyT8/NCSPzC/L4e8TOEJ1J/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/843] HID: logitech-hidpp: remove excess kernel-doc member in hidpp_scroll_counter
Date: Tue, 21 Jul 2026 17:20:24 +0200
Message-ID: <20260721152414.788492582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f22a5db8a7d38152556f230d6d68e59dbc27971b ]

The @dev member described in the kernel-doc does not exist in the
struct. Remove the stale entry.

Fixes: 0610430e3dea ("HID: logitech-hidpp: add input_device ptr to struct hidpp_device")
Assisted-by: opencode:big-pickle

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 812ed660c55575..495d486f540347 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -155,7 +155,6 @@ struct hidpp_battery {
 /**
  * struct hidpp_scroll_counter - Utility class for processing high-resolution
  *                             scroll events.
- * @dev: the input device for which events should be reported.
  * @wheel_multiplier: the scalar multiplier to be applied to each wheel event
  * @remainder: counts the number of high-resolution units moved since the last
  *             low-resolution event (REL_WHEEL or REL_HWHEEL) was sent. Should
-- 
2.53.0



