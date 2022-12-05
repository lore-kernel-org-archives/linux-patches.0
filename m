Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8622F15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092C3C433B5;
	Mon,  5 Dec 2022 19:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267983;
	bh=pjV+YzoeVY7nvyOqe8WbShBBG5zI+yI93RPzfb2bX6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iy8T3sgOt8OIPmZUnErW5MxPJTuZ1vUElYXSKgAZkS+RR0n1FbkTr5YPYFUoqzHuz
	 SE4DibkyAw/+uA8MVckCxJh0L0aY6ppIbP4RbGtW/qqhN2WYo/Mpwj1qCOXIDRB9MM
	 A5kkyYhXffXiJk/cvvLrCQNYvlsOIYXKa5KWyKfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aman Dhoot <amandhoot12@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/105] Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode
Date: Mon,  5 Dec 2022 20:09:16 +0100
Message-Id: <20221205190804.629480212@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aman Dhoot <amandhoot12@gmail.com>

[ Upstream commit ac5408991ea6b06e29129b4d4861097c4c3e0d59 ]

The device works fine in native RMI mode, there is no reason to use legacy
PS/2 mode with it.

Signed-off-by: Aman Dhoot <amandhoot12@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index c6d393114502..7dc8ca5fd75f 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -192,6 +192,7 @@ static const char * const smbus_pnp_ids[] = {
 	"SYN3221", /* HP 15-ay000 */
 	"SYN323d", /* HP Spectre X360 13-w013dx */
 	"SYN3257", /* HP Envy 13-ad105ng */
+	"SYN3286", /* HP Laptop 15-da3001TU */
 	NULL
 };
 
-- 
2.35.1



