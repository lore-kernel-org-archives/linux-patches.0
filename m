Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264417B50A;
	Mon,  4 Aug 2025 00:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267464; cv=none; b=Vrb7xsl5fpZnPnDQac4rIj44012g1mDYfxuvxm1ga8qy6kt6yOIOjnE/HUxY8EdeatrSDWeebQAVbaUGTEtBlifm42XWTNC0A+wtPjO31ODRC4uTQArFoy72BBvBCaAocqvXccd5Vqkv1ayP0Po0FPBAiX0NPMFY1Cojy0+9cFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267464; c=relaxed/simple;
	bh=2lH++JfE5hKU4ozqyNDxoFsD43djVWfCuKGiBwIfd48=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ehTZP7uw4hz9YRuey5HL5IhTqCBc29Xgv0tqf9Ao1TR1m1k8IjWSB0T+9sdZMA8ahXCswLmtWGwN4yiKxitz77N9EtYWc1cejmgunMaC5bzCeuwRqr4kCyVMaRYQJgnmXgq/FeYKmF8rIWqbdsBBuF0Wu65iMmo/Qp+7zUDwX9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=swCvVBBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="swCvVBBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CCCC4CEF0;
	Mon,  4 Aug 2025 00:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267463;
	bh=2lH++JfE5hKU4ozqyNDxoFsD43djVWfCuKGiBwIfd48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swCvVBBQ7QDgKsZyuIihwkdJPMsMPJ5K+fxZo3g1i8qEGMcmHVNN5iinsU6oFLtzy
	 CNbb1GEaz/7v0Qv5F4YBUWmoIBV1uPswwrnhOSTixy5UnV9EL4yB1hNc5UMhZ1GCFc
	 RWurpl62AURJja2rbPs8PqhGOw/U/RJMOdCK5lGzUMt/JKU5ZYNFt+2efhuGuXjQYo
	 RH6IbJ3rlgCCLeWg0RKo5DuDiraaFLbM8EN4bnJ4eGcASwmGr8TAYB3C7EnjD/hyQo
	 3Ni7wZGwp0uo/8TbOHl6SJlvTPBIPnjkKouHVj5krVeMcuz7ypXsNjX5PuZrBDGzQq
	 U3UzrdZ8j7zEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lucy Thrun <lucy.thrun@digital-rabbithole.de>,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	rf@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.15 75/80] ALSA: hda/ca0132: Fix buffer overflow in add_tuning_control
Date: Sun,  3 Aug 2025 20:27:42 -0400
Message-Id: <20250804002747.3617039-75-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: Lucy Thrun <lucy.thrun@digital-rabbithole.de>

[ Upstream commit a409c60111e6bb98fcabab2aeaa069daa9434ca0 ]

The 'sprintf' call in 'add_tuning_control' may exceed the 44-byte
buffer if either string argument is too long. This triggers a compiler
warning.
Replaced 'sprintf' with 'snprintf' to limit string lengths to prevent
overflow.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506100642.95jpuMY1-lkp@intel.com/
Signed-off-by: Lucy Thrun <lucy.thrun@digital-rabbithole.de>
Link: https://patch.msgid.link/20250610175012.918-3-lucy.thrun@digital-rabbithole.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real security vulnerability**: The commit fixes a buffer
   overflow vulnerability in the `add_tuning_control` function. The
   sprintf call could overflow the 44-byte `namestr` buffer (defined as
   `char namestr[SNDRV_CTL_ELEM_ID_NAME_MAXLEN]` where
   `SNDRV_CTL_ELEM_ID_NAME_MAXLEN` is 44).

2. **Long-standing bug**: The vulnerable code was introduced in 2012
   (commit 44f0c9782cc6a), meaning this buffer overflow has existed in
   the kernel for over a decade, affecting many stable kernel versions.

3. **Simple and contained fix**: The fix is minimal - it simply replaces
   `sprintf` with `snprintf` on a single line:
  ```c
   - sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
   + snprintf(namestr, sizeof(namestr), "%s %s Volume", name,
dirstr[dir]);
   ```

4. **Low risk of regression**: The change is straightforward and only
   adds bounds checking. It doesn't change any logic or behavior when
   strings fit within the buffer.

5. **Detected by automated testing**: The issue was caught by the kernel
   test robot, indicating it's a real compiler warning that should be
   addressed.

6. **Potential for exploitation**: While the tuning control names like
   "Wedge Angle", "SVM Level", and "EQ Band0-9" are relatively short,
   combined with "Playback" or "Capture" and " Volume", they could
   theoretically overflow the 44-byte buffer. For example: "EQ Band9"
   (8) + " " (1) + "Playback" (8) + " Volume" (7) = 24 bytes, which is
   safe, but the vulnerability exists if longer names were added in the
   future.

7. **Affects user-facing functionality**: This is in the ALSA HD Audio
   driver for Creative CA0132 sound cards, which are used by end users,
   making it important to fix in stable kernels.

The fix follows stable kernel rules perfectly: it's a minimal change
that fixes an important bug without introducing new features or
architectural changes.

 sound/pci/hda/patch_ca0132.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index d40197fb5fbd..f0b612b61ced 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4410,7 +4410,7 @@ static int add_tuning_control(struct hda_codec *codec,
 	}
 	knew.private_value =
 		HDA_COMPOSE_AMP_VAL(nid, 1, 0, type);
-	sprintf(namestr, "%s %s Volume", name, dirstr[dir]);
+	snprintf(namestr, sizeof(namestr), "%s %s Volume", name, dirstr[dir]);
 	return snd_hda_ctl_add(codec, nid, snd_ctl_new1(&knew, codec));
 }
 
-- 
2.39.5

