Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061777;
	b=WlbGk5t25j41gQ1tBzdCxigEc5L5UtB1PkO4V869CtATFjxYKAx8MWUXcG1NAhefcFEq
	 9XAM5UWljehHKwRPm/X1ceyOtm/D2QLVvVlliT1t1xbmhvkk2Rsv/vAEfa3FJzSJX6nOK
	 CQt/ix+vu9jhBnXNUoKohHxm0BTHfr4LJ6NSVATMZYuZzJSZqAi8aoWkN+OH6ga40b5HK
	 HiSk/I6pqReuJJNxtP3O59LeCUajN5ljR4siHZfQVSYwLgQo9OUT0WjS9XwzrK6eATdmh
	 XP/FBy+iDni9EXXeoUEhXYgnqd8pwRAJkxPKAJD3lfOcWW0BUjdGDZoncbWLF3kbM6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zV3OJp3Y+Jzlwa7BVm9Uwm3PjJMRmkxKEoXjGH2hGp8=;
	b=yKYq8zjGhfUl28NcviefXNUg8lWnuRQtZYd03s7xq+VrA+nkvNZ/xctRjPlX/bClU6KW
	 xG3A7lIWeoZw1ynTYGxg1FrVixHdLF46FFXUuAUSRCFfBFXrei83WLBe5UTSymykx4uoA
	 fKIGlPdd+km4fjP3VnrrrjyCL9veVQj0L/VPZtZbKo2SN/bnVkRxB62xTFuKxIBpqLB5f
	 77DWqSDZTwj+3F5McfYOL/vbMEP+HIt5SlNBS+Dl+Q2oOvzB39KDRl4z13S4ZdWj2n/JZ
	 W3PqyimtQr8D6+ndYISp0uiPmvhkk8yaCYJ0+Q2J0gJJIuAsDsyM1ZYlewFi/n5jbpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xV7Y3Y4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6C6606A325;
	Thu, 19 Nov 2026 04:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xV7Y3Y4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90871F000C4;
	Thu, 19 Nov 2026 04:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061777;
	bh=zV3OJp3Y+Jzlwa7BVm9Uwm3PjJMRmkxKEoXjGH2hGp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xV7Y3Y4KB57V0VSl8wr5VqHA0aPUgPwqFArpA6ScnkTSzDHaFTngR8Gfuz3kha4O0
	 Mv81lEkoSwdHNlGiF7YmrOxXiWwsculCKat2rpJmO7WbrlaY1B/hMHpK0DPJ9XAavG
	 klBHLDo22mAbOsXRfrZllyesr3EKYg+7KPO1Gx2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1673/1848] ASoC: ops: Fix return value in snd_soc_limit_volume()
Date: Wed, 18 Nov 2026 16:01:51 +0100
Message-ID: <20261118150029.863406630@linuxfoundation.org>
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

From: Amadeusz Sławiński <amade@asmblr.net>

[ Upstream commit 223ec2a93bec6c5ee859094c826fec78516a0bb3 ]

As documented snd_soc_limit_volume() should return 0 on success, however
at some point in time this promise was broken when
snd_soc_clip_to_platform_max() was refactored, refactor it once again
using __free() to automatically free struct snd_ctl_elem_value and
return proper value.

Fixes: 7e10d7242ea8 ("ASoC: ops: dynamically allocate struct snd_ctl_elem_value")
Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
Link: https://patch.msgid.link/20261014200608.118770-3-amade@asmblr.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 91afd73cdd139..72b575f2e7b0a 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -618,7 +618,7 @@ EXPORT_SYMBOL_GPL(snd_soc_get_volsw_range);
 static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 {
 	struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-	struct snd_ctl_elem_value *uctl;
+	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int ret;
 
 	if (!mc->platform_max)
@@ -630,7 +630,7 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 
 	ret = kctl->get(kctl, uctl);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	if (uctl->value.integer.value[0] > mc->platform_max)
 		uctl->value.integer.value[0] = mc->platform_max;
@@ -640,10 +640,10 @@ static int snd_soc_clip_to_platform_max(struct snd_kcontrol *kctl)
 		uctl->value.integer.value[1] = mc->platform_max;
 
 	ret = kctl->put(kctl, uctl);
+	if (ret < 0)
+		return ret;
 
-out:
-	kfree(uctl);
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.53.0



