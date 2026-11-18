Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014997;
	b=dKx69co/2LKHUHvVWsuNbJbDkWhRmS/lvkAhuNmSoFxVQiRrjh60VZ/P9f/vkuWjDFGk
	 WYYPfLGP5Fd9jW+rV2CGMYsq6E1QG7F7fRnb/FTHz42Z0YwtuYpr2WcVtcW0eKj3lXuvP
	 X5C5hr2JYD9eOa0sMWfD09/YW4viKlIU6nvdByV20HuMaMYB3sNufnkltR140qMBI1VXD
	 A/wlLH0y8MNrO11TnjJHk2NZFfNGogf9Q11viMCzxjB7SO30YMJLI5TDk8G+YnrSdqnqc
	 toKtsteMYvZ9/FStuzcrht2Ibf6bcxEo+7XPA+MtxiuKAl8+THNTdXUPWP22hxblawQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CMA8ZQaE7gavACxP7xNEeWU6XeE3I9O8s7feoBvpA2Q=;
	b=xFZjHItcAYygYD8KP9CYsUnb8TWpbJGWOC4PBbUVZhKDlcXD206oQAslStJsOKnKVqGB
	 BHq4iyOlLuhhUx0bOY77G4f/MI7VE5vxYPgBmRInn2vAttVPFr5ImUsB/V6jvSEmQ2agj
	 qEv7z13yGM77r1xWTYVRYKhieEBtzulo5Fia/TaCUm43/tnfoMKJCYJJ5Ny86+mOTDfvY
	 vVEn5fssgphoPxrD2CED5HiLwSUgYFLIkxDsUwtpxqmDZU1IWWnwwzSCaoJupNKnD2O/5
	 XM4RGBrh6RL0Jt+MU9mnIBKXtvBnEKi/jP8c7v/wEU+nkfPPa6zMLB4XZzt1LgNe/NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQEJH3xF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45446606A320;
	Wed, 18 Nov 2026 15:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQEJH3xF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4351F000C4;
	Wed, 18 Nov 2026 15:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014996;
	bh=CMA8ZQaE7gavACxP7xNEeWU6XeE3I9O8s7feoBvpA2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQEJH3xFW1FBLtJ4rfU10vnFsFid4y6Gy40tPXSPwhKa88WqDyKhIvG5Ucyrs9nle
	 w1VdVemjwWcg1wj9ELeRzK+oQsbwHL5Wm0rqGS0JhCKFXTEeOQQiKXe2j0ZvugpX+p
	 4KqzKpJmXRJr0Npcosl1G0ZMsbdXO0kh0bejh5p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciro Pedrini <ciro.pedrini@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0016/2651] platform/x86: hp-wmi: Add OMEN board 8A17 thermal profile support
Date: Wed, 18 Nov 2026 15:20:56 +0100
Message-ID: <20261118150248.576883803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ciro Pedrini <ciro.pedrini@gmail.com>

[ Upstream commit d35a1ea827a2efaea7fb059ffafefae7c13b9556 ]

The HP OMEN 17-ck1xxx (board 8A17) isn't in omen_thermal_profile_boards,
so hp-wmi uses the generic thermal profile query. The firmware only
stores that value and never acts on it, so the EC stays in its default
mode and the CPU is held at 45 W whatever profile is selected.

The board uses the OMEN interface (mode byte at EC 0x95, thermal policy
v1) and also needs the timed profile quirk: without it, the EC drops
back to the default mode about two minutes after each profile change.

Add 8A17 to omen_thermal_profile_boards and
omen_timed_thermal_profile_boards.

With this, all three profiles work and sustained package power under
load goes from 45 W to 56-79 W.

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Ciro Pedrini <ciro.pedrini@gmail.com>
Link: https://patch.msgid.link/20260925205226.883724-1-ciro.pedrini@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Adjusted board-list context to account for the missing neighboring 8A18 entry. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 8a0fe50ef0c29..022100d9d5503 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -207,7 +207,7 @@ static const char * const omen_thermal_profile_boards[] = {
 	"886B", "886C", "88C8", "88CB", "88D1", "88D2", "88F4", "88F5", "88F6",
 	"88F7", "88FD", "88FE", "88FF",
 	"8900", "8901", "8902", "8912", "8917", "8918", "8949", "894A", "89EB",
-	"8A15", "8A42", "8A43",
+	"8A15", "8A17", "8A42", "8A43",
 	"8BAD",
 	"8C58",
 	"8E41",
@@ -227,7 +227,7 @@ static const char * const omen_thermal_profile_force_v0_boards[] = {
  * "balanced" when reaching zero.
  */
 static const char * const omen_timed_thermal_profile_boards[] = {
-	"8A15", "8A42",
+	"8A15", "8A17", "8A42",
 	"8BAD",
 };
 
-- 
2.53.0



