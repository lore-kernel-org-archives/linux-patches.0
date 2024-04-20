Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8361838C;
	Sat, 20 Apr 2024 00:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713572768; cv=none; b=lUQLNXZogROy1tSwa7Rdtd4plBeDRXIqNFrjJtvZVvAR6+Vg301uCK2ynV4CXBA9IZzIKrazDAVIQdagl9Tf2tZKjFd7JCUZFrI3CkJqHeetYvrsN2sjrPEXmiamqu1akI/ubFWlVNfwziVZnP4m198iIzRCt17170JG8mvYDf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713572768; c=relaxed/simple;
	bh=SNHtumGqvwr1lZZ9ZIBoUzL+sDV4Ix/gONciePeUyFQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=O4S1eNP5RVT+XU6ygexsY+t9DzPSCYvk9T+dz1+G3On9JLB6zfdb7cwZUmGoIc2PL1hAYPT2lAN8MVWLGnAYg3YpKm43iMg6SibQBLWpl5WKJ9JEGzTR4JHEOqMxszeadBVdKjXVJacesQc+9Ss2nH1b0IEwSPMDPkvUB6UPGnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEm/Al3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEm/Al3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EADCC072AA;
	Sat, 20 Apr 2024 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713572768;
	bh=SNHtumGqvwr1lZZ9ZIBoUzL+sDV4Ix/gONciePeUyFQ=;
	h=From:Date:Subject:To:Cc:From;
	b=AEm/Al3Y/lnCA+rSEpzUsw4YwQhg/ziHfeBnNKMZES2l/oTN6jgFoHXoSDtLHENV9
	 JXOQ8fhGhoAuDY9gtQOhywd3/E3ziE+UA8MZf5etYR3i/KR8FTyHA7ksvWGfucF49J
	 dchf5VO1G205lcgriReHdAaQVJcrZPisLHcghAI3ZopYP8zDy0+qIX6cyGZOg5j7Zx
	 SA67BTjIgaYTMycak/czUUoqflfJUo1UsQmRzxJ+gsgd7vjtOK3SI6mQSyNWX60f2n
	 ytTmrrvNTncjjocd5bXRENxtDKcWB5BK2Pgh57eplVylQN6/7f8r3R6eP2m+H4+vK7
	 nnrMP/8tj0C3Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 19 Apr 2024 17:25:59 -0700
Subject: [PATCH] ALSA: scarlett2: Zero initialize ret in
 scarlett2_ag_target_ctl_get()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240419-alsa-scarlett2-fix-wsometimes-uninitialized-v1-1-e2ace8642e08@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJYLI2YC/x2NwQrCMBAFf6Xs2YU2pEr9FfGwNlt9kKaSTVUs/
 XeDx4FhZiPTDDU6NxtlfcGwpArdoaHxIemujFCZXOt867uBJZqwjZKjluJ4wofftsxaMKvxmpB
 QIBFfDRy8n07Hfrj1TqgWn1mr/79drvv+AwrggP19AAAA
To: g@b4.vu, tiwai@suse.com
Cc: alsa-devel@alsa-project.org, linux-sound@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2182; i=nathan@kernel.org;
 h=from:subject:message-id; bh=SNHtumGqvwr1lZZ9ZIBoUzL+sDV4Ix/gONciePeUyFQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnK3PNfz9zypEevTnzlgnVzA4XzFG9yRk6znZqwytkwN
 4cj4sirjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARppsM/0vv6EtNt//fbKsl
 bbKjU+s9c9vhRc9tf5Wf4rYWkKlQaWf4p2QwYUvLteTCux/NXki83FQ47cf3nS7NxZ43xf5xuWq
 VcwIA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR):

  sound/usb/mixer_scarlett2.c:3697:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   3697 |         if (private->autogain_updated) {
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~
  sound/usb/mixer_scarlett2.c:3707:9: note: uninitialized use occurs here
   3707 |         return err;
        |                ^~~
  sound/usb/mixer_scarlett2.c:3697:2: note: remove the 'if' if its condition is always true
   3697 |         if (private->autogain_updated) {
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  sound/usb/mixer_scarlett2.c:3688:9: note: initialize the variable 'err' to silence this warning
   3688 |         int err;
        |                ^
        |                 = 0
  1 error generated.

Initialize ret to zero to ensure ret is initialized in all paths within
scarlett2_ag_target_ctl_get(), which matches the style of other
functions in this driver.

Fixes: e30ea5340c25 ("ALSA: scarlett2: Add autogain target controls")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
FWIW, a lot of the functions that end in just 'mutex_unlock()' before
returning could probably benefit from the cleanup.h infrastructure,
which would help with the scope of err in this particular function, but
I decided to go with the most minimal fix here.
---
 sound/usb/mixer_scarlett2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index a2de31a0371b..b251d25f2a85 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -3685,7 +3685,7 @@ static int scarlett2_ag_target_ctl_get(
 	struct usb_mixer_elem_info *elem = kctl->private_data;
 	struct usb_mixer_interface *mixer = elem->head.mixer;
 	struct scarlett2_data *private = mixer->private_data;
-	int err;
+	int err = 0;
 
 	mutex_lock(&private->data_mutex);
 

---
base-commit: 32cb23a0f911317cdb5030035e49a204aa86fef5
change-id: 20240419-alsa-scarlett2-fix-wsometimes-uninitialized-d44f7659b52a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

