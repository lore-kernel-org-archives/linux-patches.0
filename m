Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028552;
	b=RXvb4nYREJERzZ+42GQwkswxbXik0LSLOQSd1+f8ALZksiwIdCF6MZ1Va6WPT3eaZbiC
	 Oh/gr8QucML6lLxycUJFTrXOK5rMCASLvDzGsNuWqcJywNa9vmxeRFi7AXwZ3hVxvGeLy
	 M/tvsyP3LA8W57AjUqD5WyViLpyemJAG2OnzFORVIHsSgfJ8tD188r72+ygksi8NcPWgf
	 iR0iZ1QZSfCk4TA7zNcEGmLBNitpX8SM5EhdufFveZXHtvgHEbXxw0qFIgrgNXP/qC+/l
	 EQfL4F1KkCcDvjcyf3k3f+1dXrtWRn6tmqAqcRPpAIcLPWBVVBFkkATp8aBB72jMsnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LMxRLBqMdg+cAoOMjqKixWKi26koeQVnhwh/z05SACA=;
	b=YmLurn19w3ynTd80OdX9cbmE18XSIadAlKMOwlB7i7sb+lbS3n3TFkVpmUi+a3jlOWIo
	 /Iz0V/hQPYwPlML4mce3TW9GHWngaDh9pZSGDK8Agveaj5/Z1iBdUjzUG0akDHA5CfH5R
	 fDmZafcAkVKmBg0tbaOmelDsspFT7Eg1xAFJ4j/fHXUZ/YtsSZaT5ssKUxQuZPkxkXqey
	 Be7a7w11GQoUeJeFuX88ukOXwD2dYlZqF123sEt1UVuVVMaO0zGAgoSuZojdCnT0INTw/
	 QVAxJ8HdGnSG1GnpvkUJ9JXG8H+0GwcRLakUFftEujE8gqmLwEX9xbRpBJGe0GDXc+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxHXylNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BCB606A31C;
	Wed, 18 Nov 2026 19:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GxHXylNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0791F000C4;
	Wed, 18 Nov 2026 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028552;
	bh=LMxRLBqMdg+cAoOMjqKixWKi26koeQVnhwh/z05SACA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxHXylNNdy/2S/8RE1A+k9M1ZePvW490Gqe0nsuprbhbmEMbdt83ctBo7Kud6Q7uJ
	 jjvKAEzT/prG9zaFCtiCdxKDNyOIa8w34PRJwcCSC8jUASK0uWQ7VN71n45eDnB0/S
	 w1A5riBZ6xphnbgls0/8kP5lC61ZVHpYFrPFL2UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciro Pedrini <ciro.pedrini@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0037/1756] platform/x86: hp-wmi: Add OMEN board 8A17 thermal profile support
Date: Wed, 18 Nov 2026 15:36:04 +0100
Message-ID: <20261118150009.321117283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context to match the shorter omen_thermal_profile_boards array. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index d189da2205609..e20f1ba937c09 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -67,7 +67,7 @@ static const char * const omen_thermal_profile_boards[] = {
 	"886B", "886C", "88C8", "88CB", "88D1", "88D2", "88F4", "88F5", "88F6",
 	"88F7", "88FD", "88FE", "88FF",
 	"8900", "8901", "8902", "8912", "8917", "8918", "8949", "894A", "89EB",
-	"8A15", "8A42",
+	"8A15", "8A17", "8A42",
 	"8BAD",
 };
 
@@ -85,7 +85,7 @@ static const char * const omen_thermal_profile_force_v0_boards[] = {
  * "balanced" when reaching zero.
  */
 static const char * const omen_timed_thermal_profile_boards[] = {
-	"8A15", "8A42",
+	"8A15", "8A17", "8A42",
 	"8BAD",
 };
 
-- 
2.53.0



