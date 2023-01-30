Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B886E3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3C0C433D2;
	Mon, 30 Jan 2023 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088362;
	bh=W90CcxRv/GgdKjJd8nx1g0Z2YD6sfIrrwvsaf4h/13Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fL81ys6I76v4bJP2DtkHhUpGBQia7cOgApyDrp3YCRqsiCJTHC1bXFGxsu13VMWB7
	 mIctlZPL9M9U6ZAEaDDyGIP7ElMv/J6w9rLlZlG176r+sKtPobE2xClGpPP0EhM6tC
	 7EMrHTp+wUJVd6bhQMb8LstP+38WDwkVqef7cjp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 197/204] Revert "Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode"
Date: Mon, 30 Jan 2023 14:52:42 +0100
Message-Id: <20230130134325.236709261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 3c44e2b6cde674797b76e76d3a903a63ce8a18bb upstream.

This reverts commit ac5408991ea6b06e29129b4d4861097c4c3e0d59 because
it causes loss of keyboard on HP 15-da1xxx.

Fixes: ac5408991ea6 ("Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/824effa5-8b9a-c28a-82bb-9b0ab24623e1@kernel.org
Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1206358
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/synaptics.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -191,7 +191,6 @@ static const char * const smbus_pnp_ids[
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
-	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 


