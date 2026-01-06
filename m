Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3982E542C;
	Tue,  6 Jan 2026 23:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767740908; cv=none; b=BLu6krurSy8F0cvjStQeImXsABYVVg00mjYeTankMNLKJtNL3yk1DAtoARyujzYPkitOPFA3FVhkJ78B1a1kWlGXL5/9mO76Ci4lipXmDB+4I+GL9DUF1EFIaENYTTtlR117c70vyoAysdXtzslkzyg8e6+yjRicDaD9K6Pn4xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767740908; c=relaxed/simple;
	bh=R3l3xQR8S+p5FfGlYDNe7OCmr++dx0zddIaH8n9qDPg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jbsNYfXDNkt49Y9kRKRn4BfiuWEGQ+EapCKKCnXuipM2Ql3mnqF8X16TRP6j1PqRmdgD0i5FEX8qU7bQMRMCo6YZ1bytAmDF4Avf3T9d7OHtn0uD0WIf9ywcOIPYcaZr4aiS4KooDmtJaPFshKZSExlytyu2kcs587itz6wt58E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=txifPGy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txifPGy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7048C116C6;
	Tue,  6 Jan 2026 23:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767740907;
	bh=R3l3xQR8S+p5FfGlYDNe7OCmr++dx0zddIaH8n9qDPg=;
	h=From:Date:Subject:To:Cc:From;
	b=txifPGy6Q4SPHxre+P05qT/izjVZYGN8Aenv5kfhT/ja0W2DuPyxpKdYrCsT2svbI
	 ewNoNpEkNh8A5oXKGAaGdcLzXnl9+LFQHHFihcpuOezuPnmjSNGUsV/EdXkSFKJ6fs
	 wnaYvOZU7Cpsmu2iKAo42T93ryW8CRSsSzicMluDeuWV5WXAieSlALCOKgy36Kkqeq
	 1UiI67G34nqMzroocQzhpehiJBt6ZpweweB/uOwYihb50AZnQy3jVVm5sjjizM7ECH
	 A/mjs50Ms4ppTJbPq6Cts/bcI8WqiUPoeNia1dwALeS4OvwUZ8x1yAHbtHOsT4EC1S
	 yyqmEg5wQazng==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 06 Jan 2026 16:08:18 -0700
Subject: [PATCH] ALSA: pcm: Revert bufs move in
 snd_pcm_xfern_frames_ioctl()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260106-pcm_native-revert-var-move-free-for-old-clang-v1-1-06a03693423d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOGVXWkC/yWNUQrCMBBEr1L224W01Wq9ShFZk61G2qRsYhBK7
 +6qPwMPZuatkFg8JzhXKwgXn3wMCvWuAvugcGf0Thka03SmNh0udr4Gyr4wap8lYyHBOSqPwhp
 RME4O7aRrJOrpuHf9oW1PoJ+L8OjfP99w+XN63Z5s81cC2/YBWH3W/JEAAAA=
X-Change-ID: 20260106-pcm_native-revert-var-move-free-for-old-clang-aa9a74d95338
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 linux-sound@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3042; i=nathan@kernel.org;
 h=from:subject:message-id; bh=R3l3xQR8S+p5FfGlYDNe7OCmr++dx0zddIaH8n9qDPg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJmxU18+Lm9Y0qtx8PoqjdVpwWphvtfXvnCbkpSpFrdxZ
 bpH67f9HaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAizW2MDO2y3Un8eR6q3RKx
 ei//n9so6HYv5bLt3JPn2TtcH7BXajP8zxXknh+q9qvD4Zv+Kbl0u/a7pT6BgbwiQa09gSXcMmv
 YAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with clang older than 17 targeting architectures that use
asm goto for their get_user() and put_user(), such as arm64, after
commit f3d233daf011 ("ALSA: pcm: Relax __free() variable declarations"),
there are bogus errors around skipping over a variable declared with the
cleanup attribute:

  sound/core/pcm_native.c:3308:6: error: cannot jump from this asm goto statement to one of its possible targets
          if (put_user(result, &_xfern->result))
              ^
  ...
  arch/arm64/include/asm/uaccess.h:298:2: note: expanded from macro '__put_mem_asm'
          asm goto(
          ^
  sound/core/pcm_native.c:3295:6: note: possible target of asm goto statement
          if (put_user(0, &_xfern->result))
              ^
  ...
  sound/core/pcm_native.c:3300:8: note: jump exits scope of variable with __attribute__((cleanup))
          void *bufs __free(kfree) =
                ^

clang-17 fixed a bug in clang's jump scope checker [1] where all labels
in a function were checked as valid targets for all asm goto instances
in a function, regardless of whether they were actual targets in a
paricular asm goto's provided list of labels.

To workaround this, revert the change done to
snd_pcm_xfern_frames_ioctl() by commit f3d233daf011 ("ALSA: pcm: Relax
__free() variable declarations") to avoid a variable declared with
cleanup from existing between multiple uses of asm goto. There are no
other uses of cleanup in this function so there should be low risk from
moving this variable back to the top of the function.

Link: https://github.com/ClangBuiltLinux/linux/issues/1886 [1]
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512190802.i4Jzbcsl-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/core/pcm_native.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 4352c0a40f8d..30ace7112c27 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3286,6 +3286,7 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 {
 	struct snd_xfern xfern;
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	void *bufs __free(kfree) = NULL;
 	snd_pcm_sframes_t result;
 
 	if (runtime->state == SNDRV_PCM_STATE_OPEN)
@@ -3297,8 +3298,7 @@ static int snd_pcm_xfern_frames_ioctl(struct snd_pcm_substream *substream,
 	if (copy_from_user(&xfern, _xfern, sizeof(xfern)))
 		return -EFAULT;
 
-	void *bufs __free(kfree) =
-		memdup_array_user(xfern.bufs, runtime->channels, sizeof(void *));
+	bufs = memdup_array_user(xfern.bufs, runtime->channels, sizeof(void *));
 	if (IS_ERR(bufs))
 		return PTR_ERR(bufs);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)

---
base-commit: 94968fc3009d4bd7e7e1300abd7037f3dde585ed
change-id: 20260106-pcm_native-revert-var-move-free-for-old-clang-aa9a74d95338

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

