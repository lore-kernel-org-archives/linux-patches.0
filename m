Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023587;
	b=VgJCjGH9QmOq82G6NuLQ2s2zVB2RJwgI9sNP5Q9b+Dqdk3z9+t3zq5xSlOpqfmSBf+n5
	 N9EKX7kLzyRrgUFxx6zgcXFRAlJidflSaPOyd/WF12PyTwA8BPoF3rntpSEIt4fZn+nil
	 yZFvoQKsnzdr0sEJyiWHy2TizPKvocF9qaempBTjtiqZsBCg5XG2R3GZ/CF0tIwMiQNYL
	 A5703kzq6956aZPcaR0esS98Loh4jDAI96ea0lg7q52MpJbtzFvP8OhyjICLArCZdhUv1
	 0l4C+x32ZmkgaspJybfjSSAZYe7wns3OoUcLnfk6IJlVPOmzJlTLULQ9iq5o7epAuUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWd+Zg0Zo5bg7WnJDsOu0EzPE8El+EBTsjlpozLpeGg=;
	b=F0lGbcIvVWFOaq3X1cGvSbZZzTmpZGMW9ikrfc+it7Qot1PYHejjD0BWHWdOxSAhmp+Q
	 Y3eCuFGnoO3wGx0HqmJNmvFhr5xac3wVY3uRocdQlyHbNkdqmCZrFoiEdT7r/O/kBRPFY
	 dk+dhtZxsw7PR3h9ngj74YnrZEtBCDs+knfZM39C/HDSGiiehZqAZBZhhQi25JFhThLDz
	 bUH7oEPMIiewDCJyfj3HyYoOVRqh/1v0QvMzzzs4OqbgjMYwAj9Cgs1ZXd7nOzxT5KxJE
	 zGbcNS1EEhJQ2IGngnco6lR3l0EHigvF72QdQc2cbKpRTkCNWd6Yr0Wcn23IuAKYlmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgreY6Ij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49497606A325;
	Wed, 18 Nov 2026 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lgreY6Ij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509961F000C4;
	Wed, 18 Nov 2026 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023586;
	bh=EWd+Zg0Zo5bg7WnJDsOu0EzPE8El+EBTsjlpozLpeGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgreY6IjRnhgkmZwdxEFPJZSQI7q5HTygTvX+AD7kKfV+/z7+F3iCCv5BUeIEr94i
	 mbhLwQDqX/zhRT4bh+zm4CiPw5cW5kHBDo+7wlXXkZjPC8uy+q+gweWcCWPsCWjajs
	 DqV5x18jlwNUN5ChuecmsbQ18mi1UcV1NTc6oPbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0421/2151] ALSA: control: Fix virtual master creation reference in kernel-doc
Date: Wed, 18 Nov 2026 15:35:56 +0100
Message-ID: <20261118150137.389947733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a347cc458d97ecd8adb5462b91559682a70aced6 ]

The snd_ctl_add_follower() comment refers to
snd_ctl_create_virtual_master(), but virtual master controls are created
with snd_ctl_make_virtual_master(). Correct the helper name.

Fixes: 79c7cdd5441f ("ALSA: Add kernel-doc comments to vmaster stuff")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912100548.86134-1-kmehltretter@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/control.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index e07f6b960641f..72d401983f53e 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -241,7 +241,7 @@ int _snd_ctl_add_follower(struct snd_kcontrol *master,
  * @follower: follower element to add
  *
  * Add a virtual follower control to the given master element created via
- * snd_ctl_create_virtual_master() beforehand.
+ * snd_ctl_make_virtual_master() beforehand.
  *
  * All followers must be the same type (returning the same information
  * via info callback).  The function doesn't check it, so it's your
-- 
2.53.0



