Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B142E15705A;
	Mon, 29 Jan 2024 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548202; cv=none; b=KZhqPKwTUf4TKtCuWhLppHoT+f7zmb/9s39DhODnIZoYoMycfWpkkE/XuU+rNiGotSGkyhCFU0RvOEeqDJrqcm/osU8YMYKE/AUFfsTiy/Iud0TJ4JD6vCStZPT9AOFBN74YA1vqdEVV6PxHDXLW1c8NCPQBSaxPinxbobNa4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548202; c=relaxed/simple;
	bh=mOrrg5+nIBo9LwECpOxAFYC/wjYbyUPSMt45soM5Uzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlUEWqme/vU63hW2zINz9Yak2A94ldHklAaiTr8+u4AQ0YYaaFzXv3vDVz2jkFTtvV7xE0M9kpiNgIwpNHabBbaxGUailS2bimPeszfHp9oTHw/r+gMD3K//fll72T/MDmGF19/4pp/3zauYTs3PzfWWCv4U8Llw0go2OEcUr8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymE8POeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymE8POeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76648C433F1;
	Mon, 29 Jan 2024 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548202;
	bh=mOrrg5+nIBo9LwECpOxAFYC/wjYbyUPSMt45soM5Uzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymE8POeWVrqUTjQmLJ0T4rsZEiHDjVl34MdJoKcLWCCLyPW7jO+Mw3dTuh5YCJGav
	 a0Sd6wO3Qdy4RuhYqMxbM6iojIwkHd8duDB7WtMfmWen363pWSXZwRjjdtxlPQwqkH
	 oDHvNXWFzpEIDPX899bZ9nq01nYhK1tZsZfwH9NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaak Ristioja <jaak@ristioja.ee>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.7 241/346] Revert "drivers/firmware: Move sysfb_init() from device_initcall to subsys_initcall_sync"
Date: Mon, 29 Jan 2024 09:04:32 -0800
Message-ID: <20240129170023.494105695@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit d1b163aa0749706379055e40a52cf7a851abf9dc upstream.

This reverts commit 60aebc9559492cea6a9625f514a8041717e3a2e4.

Commit 60aebc9559492cea ("drivers/firmware: Move sysfb_init() from
device_initcall to subsys_initcall_sync") messes up initialization order
of the graphics drivers and leads to blank displays on some systems. So
revert the commit.

To make the display drivers fully independent from initialization
order requires to track framebuffer memory by device and independently
from the loaded drivers. The kernel currently lacks the infrastructure
to do so.

Reported-by: Jaak Ristioja <jaak@ristioja.ee>
Closes: https://lore.kernel.org/dri-devel/ZUnNi3q3yB3zZfTl@P70.localdomain/T/#t
Reported-by: Huacai Chen <chenhuacai@loongson.cn>
Closes: https://lore.kernel.org/dri-devel/20231108024613.2898921-1-chenhuacai@loongson.cn/
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10133
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: stable@vger.kernel.org # v6.5+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240123120937.27736-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/sysfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -128,4 +128,4 @@ unlock_mutex:
 }
 
 /* must execute after PCI subsystem for EFI quirks */
-subsys_initcall_sync(sysfb_init);
+device_initcall(sysfb_init);


