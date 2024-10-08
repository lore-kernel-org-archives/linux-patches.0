Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB841C9DDF;
	Tue,  8 Oct 2024 13:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393084; cv=none; b=HeFLuWO5vQCimHOkp1QN+qWORPKOw9d+pFQu49CGd74RJyazauqKBvKZt1RoAM21SlXicEsJ1J3xvpgOgvf8hqMayPI5Zxvx99rSfaDnmWs/uoQcfFBQOoLL4ZkIQyUhXqWD0nXEl64u7RGGVkkWkpOrBtMkIxcnjiXDu99l7Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393084; c=relaxed/simple;
	bh=LXibOquvE2NBCpgTG20BcxJ/NanMZeQQPfqqfSIgsUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc5M/M5wD+2rsptVlZbxVoED+SPPoGXAIqE9akzYXdQGlOpxFPtfLqUyXAMlW9tObhZoN7z+3mMLkUAsqMB6BLc7vK/QYVdTifIRzgZhTAKUNDDzKf+q2/um1T6ayBLEpEcFPMza/KzpVL7OGISGM/R3aLdbWrjMVrBymRk7+O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6L/q7dK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6L/q7dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86112C4CEC7;
	Tue,  8 Oct 2024 13:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393084;
	bh=LXibOquvE2NBCpgTG20BcxJ/NanMZeQQPfqqfSIgsUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6L/q7dKiMYxVmJi9KjVGzFsnDUkAE5P5qUKrfE2VokCd2hmCdnEjHzbbIcvbDchE
	 eZX1x/0tC9+KMN/hyQBjEF35637I/HB6PmLKsfjXMMvnOir86MWL2OZynxpAfn1/qp
	 cPwVBcmCgmMjq3pUwjw2VMgweZgQ8GLZz4T72WhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/386] ALSA: mixer_oss: Remove some incorrect kfree_const() usages
Date: Tue,  8 Oct 2024 14:04:52 +0200
Message-ID: <20241008115631.322946400@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 368e4663c557de4a33f321b44e7eeec0a21b2e4e ]

"assigned" and "assigned->name" are allocated in snd_mixer_oss_proc_write()
using kmalloc() and kstrdup(), so there is no point in using kfree_const()
to free these resources.

Switch to the more standard kfree() to free these resources.

This could avoid a memory leak.

Fixes: 454f5ec1d2b7 ("ALSA: mixer: oss: Constify snd_mixer_oss_assign_table definition")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/63ac20f64234b7c9ea87a7fa9baf41e8255852f7.1727374631.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index dae2da3808351..abc99ae333282 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -967,8 +967,8 @@ static void snd_mixer_oss_slot_free(struct snd_mixer_oss_slot *chn)
 	struct slot *p = chn->private_data;
 	if (p) {
 		if (p->allocated && p->assigned) {
-			kfree_const(p->assigned->name);
-			kfree_const(p->assigned);
+			kfree(p->assigned->name);
+			kfree(p->assigned);
 		}
 		kfree(p);
 	}
-- 
2.43.0



